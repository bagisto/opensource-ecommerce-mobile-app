import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/checkout_queries.dart';
import '../../../../core/graphql/account_queries.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/checkout_model.dart';

/// Repository for all checkout operations via Bagisto GraphQL API.
///
/// IMPORTANT — Bagisto uses TWO different tokens during checkout:
///
///  1. **Auth token** (`_authToken`) — The Bearer token from login
///     (e.g. `292|63wcgHLYi...`). Sent in the `Authorization` header.
///     For guest users this is the session UUID from `createCartToken`.
///
///  2. **Cart/query token** (`_cartQueryToken`) — Returned as `cartToken`
///     by `createCheckoutAddress`. For logged-in users this equals the
///     numeric **user ID** (e.g. `"19"`). This is passed as the `$token`
///     variable to `collectionShippingRates` and `collectionPaymentMethods`.
///
/// The code MUST keep these separate.
class CheckoutRepository {
  final GraphQLClient client;

  /// Bearer token for the Authorization header.
  String? _authToken;

  /// Token passed as `$token` variable to shipping-rates / payment-methods
  /// queries. Set from the `cartToken` returned by `createCheckoutAddress`.
  String? _cartQueryToken;

  CheckoutRepository({required this.client, String? initialToken}) {
    _authToken = initialToken;
  }

  // ── Token management ────────────────────────────────────────────────────

  /// Set the Bearer auth token (login token or guest session UUID).
  void updateAuthToken(String? token) {
    _authToken = token;
    if (token == null || token.isEmpty) {
      debugPrint('[CheckoutRepo] WARNING authToken set to null/empty');
    } else {
      debugPrint(
        '[CheckoutRepo] authToken updated: ${token.length > 8 ? token.substring(0, 8) : token}…',
      );
    }
  }

  /// Set the cart query token (returned by createCheckoutAddress as `cartToken`).
  void updateCartQueryToken(String? token) {
    _cartQueryToken = token;
    debugPrint('[CheckoutRepo] cartQueryToken updated: $token');
  }

  /// Legacy helper — sets the auth token only.
  void updateToken(String? token) => updateAuthToken(token);

  /// The best cart-query token we have.
  String? get cartQueryToken => _cartQueryToken;

  GraphQLClient get _authedClient {
    if (_authToken == null || _authToken!.isEmpty) {
      debugPrint(
        '[CheckoutRepo] WARNING _authedClient: authToken is null/empty — using unauthenticated client',
      );
      return client;
    }
    final httpLink = HttpLink(
      bagistoEndpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'X-STOREFRONT-KEY': storefrontKey,
      },
    );
    final authLink = AuthLink(getToken: () async => 'Bearer $_authToken');
    final link = authLink.concat(httpLink);
    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        mutate: Policies(fetch: FetchPolicy.noCache),
      ),
    );
  }

  // ─── Queries ─────────────────────────────────────────────────────────────

  /// Fetch all available countries from the Bagisto API.
  /// API: https://api-docs.bagisto.com/api/graphql-api/shop/queries/get-countries.html
  Future<List<BagistoCountry>> getCountries() async {
    debugPrint('[CheckoutRepo] getCountries...');
    final result = await _authedClient.query(
      QueryOptions(
        document: gql(CheckoutQueries.getCountries),
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      debugPrint('[CheckoutRepo] getCountries error: ${result.exception}');
      throw result.exception!;
    }

    final edges = result.data?['countries']?['edges'] as List?;
    if (edges == null) return [];

    return edges
        .map(
          (e) =>
              BagistoCountry.fromJson((e['node'] ?? e) as Map<String, dynamic>),
        )
        .toList();
  }

  /// Fetch states/provinces for a specific country by its numeric ID.
  /// API: https://api-docs.bagisto.com/api/graphql-api/shop/queries/get-country-state.html
  /// Tries with countryId first, then falls back to countryCode if available
  Future<List<BagistoCountryState>> getCountryStates(int countryId, {String? countryCode}) async {
    debugPrint('[CheckoutRepo] getCountryStates countryId=$countryId, countryCode=$countryCode');
    
    // If no valid countryId, try fallback with countryCode
    if (countryId <= 0) {
      if (countryCode != null && countryCode.isNotEmpty) {
        debugPrint('[CheckoutRepo] countryId invalid, falling back to countryCode=$countryCode');
        return _getCountryStatesByCode(countryCode);
      }
      debugPrint('[CheckoutRepo] getCountryStates: invalid countryId=$countryId and no countryCode, returning empty');
      return [];
    }
    
    // Query with countryId (Int! required) — do NOT pass countryCode here
    final Map<String, dynamic> variables = {
      'countryId': countryId,
      'first': 200,
    };
    
    final result = await _authedClient.query(
      QueryOptions(
        document: gql(CheckoutQueries.getCountryStates),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    debugPrint('[CheckoutRepo] getCountryStates raw result: ${result.data}');
    
    if (result.hasException) {
      debugPrint('[CheckoutRepo] getCountryStates error: ${result.exception}');
      // Fallback to countryCode query if available
      if (countryCode != null && countryCode.isNotEmpty) {
        debugPrint('[CheckoutRepo] Retrying with countryCode: $countryCode');
        return _getCountryStatesByCode(countryCode);
      }
      return [];
    }

    final statesData = result.data?['countryStates'];
    if (statesData == null) {
      debugPrint('[CheckoutRepo] getCountryStates: countryStates is null');
      // Try alternative query with countryCode if available
      if (countryCode != null && countryCode.isNotEmpty && countryId <= 0) {
        debugPrint('[CheckoutRepo] Trying alternative query with countryCode: $countryCode');
        return _getCountryStatesByCode(countryCode);
      }
      return [];
    }

    // Handle both direct array and edges/node structures
    List<dynamic> statesList;
    if (statesData is List) {
      // Direct array format: countryStates: [{id, _id, ...}, ...]
      statesList = statesData;
      debugPrint('[CheckoutRepo] getCountryStates: direct array format, ${statesList.length} items');
    } else if (statesData is Map) {
      // Edge/node format: countryStates: {edges: [{node: {...}}, ...]}
      final edges = statesData['edges'] as List?;
      if (edges != null) {
        statesList = edges
            .map((edge) => edge is Map ? edge['node'] : edge)
            .where((node) => node != null)
            .toList();
        debugPrint('[CheckoutRepo] getCountryStates: edge/node format, ${statesList.length} items');
      } else {
        statesList = [];
        debugPrint('[CheckoutRepo] getCountryStates: edges is null');
      }
    } else {
      debugPrint('[CheckoutRepo] getCountryStates: unexpected format: $statesData');
      return [];
    }

    return statesList
        .map(
          (e) => BagistoCountryState.fromJson(
            (e ?? {}) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Alternative: Fetch states using country code
  Future<List<BagistoCountryState>> _getCountryStatesByCode(String countryCode) async {
    debugPrint('[CheckoutRepo] _getCountryStatesByCode countryCode=$countryCode');
    
    final result = await _authedClient.query(
      QueryOptions(
        document: gql(CheckoutQueries.getCountryStatesByCode),
        variables: {'countryCode': countryCode, 'first': 200},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    debugPrint('[CheckoutRepo] _getCountryStatesByCode raw result: ${result.data}');
    
    if (result.hasException) {
      debugPrint('[CheckoutRepo] _getCountryStatesByCode error: ${result.exception}');
      return [];
    }

    final statesData = result.data?['countryStates'];
    if (statesData == null) {
      debugPrint('[CheckoutRepo] _getCountryStatesByCode: countryStates is null');
      return [];
    }

    List<dynamic> statesList;
    if (statesData is List) {
      statesList = statesData;
    } else if (statesData is Map) {
      final edges = statesData['edges'] as List?;
      if (edges != null) {
        statesList = edges
            .map((edge) => edge is Map ? edge['node'] : edge)
            .where((node) => node != null)
            .toList();
      } else {
        statesList = [];
      }
    } else {
      return [];
    }

    return statesList
        .map(
          (e) => BagistoCountryState.fromJson(
            (e ?? {}) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Fetch saved checkout addresses (cursor connection format)
  Future<List<CheckoutAddress>> getCheckoutAddresses() async {
    debugPrint('[CheckoutRepo] getCheckoutAddresses...');
    final result = await _authedClient.query(
      QueryOptions(
        document: gql(CheckoutQueries.getCheckoutAddresses),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      debugPrint(
        '[CheckoutRepo] getCheckoutAddresses error: ${result.exception}',
      );
      throw result.exception!;
    }

    final edges =
        result.data?['collectionGetCheckoutAddresses']?['edges'] as List?;
    if (edges == null) return [];

    return edges
        .map(
          (e) => CheckoutAddress.fromJson(
            (e['node'] ?? e) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Fetch customer saved addresses from account API.
  /// Used as a fallback when checkout addresses are empty for logged-in users.
  Future<List<CheckoutAddress>> getCustomerAddresses() async {
    debugPrint('[CheckoutRepo] getCustomerAddresses (fallback)...');
    final result = await _authedClient.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerAddresses),
        variables: {'first': 100},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      debugPrint(
        '[CheckoutRepo] getCustomerAddresses error: ${result.exception}',
      );
      throw result.exception!;
    }

    final edges =
        result.data?['getCustomerAddresses']?['edges'] as List?;
    if (edges == null) return [];

    return edges.map((e) {
      final node = (e['node'] ?? e) as Map<String, dynamic>;
      // Map account address fields to CheckoutAddress format
      // Account query returns 'address' as an array, handle both formats
      String addressStr = '';
      final rawAddr = node['address'];
      if (rawAddr is List) {
        addressStr = rawAddr.join(', ');
      } else if (rawAddr is String) {
        addressStr = rawAddr;
      } else {
        addressStr = node['address1']?.toString() ?? '';
      }

      return CheckoutAddress(
        id: node['id']?.toString() ?? '',
        addressType: node['addressType']?.toString() ?? '',
        firstName: node['firstName']?.toString() ?? '',
        lastName: node['lastName']?.toString() ?? '',
        companyName: node['companyName']?.toString(),
        address: addressStr,
        city: node['city']?.toString() ?? '',
        state: node['state']?.toString(),
        country: node['country']?.toString(),
        postcode: node['postcode']?.toString(),
        email: node['email']?.toString(),
        phone: node['phone']?.toString(),
        defaultAddress: node['defaultAddress'] == true,
        useForShipping: node['useForShipping'] == true,
      );
    }).toList();
  }

  /// Fetch available shipping rates.
  ///
  /// The `$token` query variable is the **cart query token**:
  /// - Logged-in users: their user ID (e.g. `"19"`).
  /// - Guest users: empty string `""` — the API identifies the cart via
  ///   the Bearer session UUID in the Authorization header.
  Future<List<ShippingRate>> getShippingRates({String? queryToken}) async {
    final qToken = queryToken ?? _cartQueryToken ?? '';
    debugPrint(
      '[CheckoutRepo] getShippingRates queryToken="$qToken" (authToken=${_authToken != null && _authToken!.length > 8 ? _authToken!.substring(0, 8) : _authToken}…)',
    );

    final result = await _authedClient.query(
      QueryOptions(
        document: gql(CheckoutQueries.getShippingRates),
        variables: {'token': qToken},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CheckoutRepo] getShippingRates error: ${result.exception}');
      throw result.exception!;
    }

    final list = result.data?['collectionShippingRates'] as List?;
    if (list == null) return [];

    return list
        .map((e) => ShippingRate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch available payment methods.
  ///
  /// Same as shipping rates — for guests the `$token` variable is `""`,
  /// the API uses the Bearer session token to identify the cart.
  Future<List<PaymentMethod>> getPaymentMethods({String? queryToken}) async {
    final qToken = queryToken ?? _cartQueryToken ?? '';
    debugPrint(
      '[CheckoutRepo] getPaymentMethods queryToken="$qToken" (authToken=${_authToken != null && _authToken!.length > 8 ? _authToken!.substring(0, 8) : _authToken}…)',
    );

    final result = await _authedClient.query(
      QueryOptions(
        document: gql(CheckoutQueries.getPaymentMethods),
        variables: {'token': qToken},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CheckoutRepo] getPaymentMethods error: ${result.exception}');
      throw result.exception!;
    }

    final list = result.data?['collectionPaymentMethods'] as List?;
    if (list == null) return [];

    return list
        .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─── Mutations ───────────────────────────────────────────────────────────

  /// Save checkout address (billing + optional shipping)
  Future<CheckoutAddressResponse> saveCheckoutAddress(
    Map<String, dynamic> input,
  ) async {
    debugPrint('[CheckoutRepo] saveCheckoutAddress input=$input');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CheckoutMutations.createCheckoutAddress),
        variables: {'input': input},
      ),
    );

    if (result.hasException) {
      debugPrint(
        '[CheckoutRepo] saveCheckoutAddress error: ${result.exception}',
      );
      throw result.exception!;
    }

    final data =
        result.data?['createCheckoutAddress']?['checkoutAddress']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to save checkout address – null response');
    }

    return CheckoutAddressResponse.fromJson(data);
  }

  /// Save selected shipping method
  Future<CheckoutShippingMethodResponse> saveShippingMethod(
    String shippingMethod,
  ) async {
    debugPrint('[CheckoutRepo] saveShippingMethod: $shippingMethod (authToken present: ${_authToken != null})');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CheckoutMutations.createCheckoutShippingMethod),
        variables: {
          'input': {'shippingMethod': shippingMethod},
        },
      ),
    );

    if (result.hasException) {
      debugPrint(
        '[CheckoutRepo] saveShippingMethod error: ${result.exception}',
      );
      throw result.exception!;
    }

    final data =
        result.data?['createCheckoutShippingMethod']?['checkoutShippingMethod']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to save shipping method – null response');
    }

    return CheckoutShippingMethodResponse.fromJson(data);
  }

  /// Save selected payment method
  Future<CheckoutPaymentMethodResponse> savePaymentMethod(
    String paymentMethod,
  ) async {
    debugPrint('[CheckoutRepo] savePaymentMethod: $paymentMethod');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CheckoutMutations.createCheckoutPaymentMethod),
        variables: {
          'input': {'paymentMethod': paymentMethod},
        },
      ),
    );

    if (result.hasException) {
      debugPrint('[CheckoutRepo] savePaymentMethod error: ${result.exception}');
      throw result.exception!;
    }

    final data =
        result.data?['createCheckoutPaymentMethod']?['checkoutPaymentMethod']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to save payment method – null response');
    }

    return CheckoutPaymentMethodResponse.fromJson(data);
  }

  /// Place the final order
  Future<CheckoutOrderResponse> placeOrder() async {
    debugPrint('[CheckoutRepo] placeOrder...');
    final result = await _authedClient.mutate(
      MutationOptions(document: gql(CheckoutMutations.createCheckoutOrder)),
    );

    if (result.hasException) {
      debugPrint('[CheckoutRepo] placeOrder error: ${result.exception}');
      throw result.exception!;
    }

    final data =
        result.data?['createCheckoutOrder']?['checkoutOrder']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to place order – null response');
    }

    return CheckoutOrderResponse.fromJson(data);
  }

  /// Apply coupon code
  Future<CouponResponse> applyCoupon(String couponCode) async {
    debugPrint('[CheckoutRepo] applyCoupon: $couponCode');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CheckoutMutations.createApplyCoupon),
        variables: {
          'input': {'couponCode': couponCode},
        },
      ),
    );

    if (result.hasException) {
      debugPrint('[CheckoutRepo] applyCoupon error: ${result.exception}');
      throw result.exception!;
    }

    final data =
        result.data?['createApplyCoupon']?['applyCoupon']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to apply coupon – null response');
    }

    return CouponResponse.fromJson(data);
  }

  /// Remove coupon code
  Future<CouponResponse> removeCoupon() async {
    debugPrint('[CheckoutRepo] removeCoupon...');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CheckoutMutations.createRemoveCoupon),
        variables: {'input': {}},
      ),
    );

    if (result.hasException) {
      debugPrint('[CheckoutRepo] removeCoupon error: ${result.exception}');
      throw result.exception!;
    }

    final data =
        result.data?['createRemoveCoupon']?['removeCoupon']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to remove coupon – null response');
    }

    return CouponResponse.fromJson(data);
  }
}
