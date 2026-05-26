import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/graphql/checkout_queries.dart';
import '../../../../core/graphql/account_queries.dart';
import '../models/checkout_model.dart';

List<Map<String, dynamic>> buildCustomerAddressBookInputsFromCheckout(
  Map<String, dynamic> checkoutInput, {
  bool defaultAddress = false,
}) {
  final usesBillingForShipping = checkoutInput['useForShipping'] == true;
  final inputs = <Map<String, dynamic>>[
    _buildCustomerAddressBookInput(
      checkoutInput,
      prefix: 'billing',
      defaultAddress: defaultAddress,
      useForShipping: usesBillingForShipping,
    ),
  ];

  if (!usesBillingForShipping) {
    inputs.add(
      _buildCustomerAddressBookInput(
        checkoutInput,
        prefix: 'shipping',
        defaultAddress: false,
        useForShipping: true,
      ),
    );
  }

  return inputs;
}

Map<String, dynamic> _buildCustomerAddressBookInput(
  Map<String, dynamic> checkoutInput, {
  required String prefix,
  required bool defaultAddress,
  required bool useForShipping,
}) {
  final input = <String, dynamic>{
    'firstName': _checkoutInputValue(checkoutInput, '${prefix}FirstName'),
    'lastName': _checkoutInputValue(checkoutInput, '${prefix}LastName'),
    'address1': _checkoutInputValue(checkoutInput, '${prefix}Address'),
    'city': _checkoutInputValue(checkoutInput, '${prefix}City'),
    'state': _checkoutInputValue(checkoutInput, '${prefix}State'),
    'country': _checkoutInputValue(checkoutInput, '${prefix}Country'),
    'postcode': _checkoutInputValue(checkoutInput, '${prefix}Postcode'),
    'phone': _checkoutInputValue(checkoutInput, '${prefix}PhoneNumber'),
    'defaultAddress': defaultAddress,
    'useForShipping': useForShipping,
  };

  final email = _checkoutInputValue(checkoutInput, '${prefix}Email');
  if (email.isNotEmpty) {
    input['email'] = email;
  }

  return input;
}

String _checkoutInputValue(Map<String, dynamic> checkoutInput, String key) {
  return checkoutInput[key]?.toString() ?? '';
}

bool shouldLogCheckoutOperation(String operation) {
  return operation != 'getCountries';
}

void _logCheckoutApiDetails(
  String operation, {
  Map<String, dynamic>? variables,
  Object? responseData,
}) {
  if (!kDebugMode || !shouldLogCheckoutOperation(operation)) return;

  final encoder = const JsonEncoder.withIndent('  ');
  debugPrint('━━━━━━━━━━━━━━━━ Checkout API ━━━━━━━━━━━━━━━━');
  debugPrint('[CheckoutRepo][$operation]');
  if (variables != null) {
    debugPrint('variables=');
    debugPrint(encoder.convert(variables));
  }
  if (responseData != null) {
    debugPrint('response=');
    debugPrint(encoder.convert(responseData));
  }
  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}

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

  GraphQLClient get _authedClient =>
      GraphQLClientProvider.buildClient(token: _authToken);

  // ─── Queries ─────────────────────────────────────────────────────────────

  /// Fetch all available countries from the Bagisto API.
  /// API: https://api-docs.bagisto.com/api/graphql-api/shop/queries/get-countries.html
  Future<List<BagistoCountry>> getCountries() async {
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

    _logCheckoutApiDetails('getCountries', responseData: result.data);

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
  Future<List<BagistoCountryState>> getCountryStates(
    int countryId, {
    String? countryCode,
  }) async {
    debugPrint(
      '[CheckoutRepo] getCountryStates countryId=$countryId, countryCode=$countryCode',
    );

    // If no valid countryId, try fallback with countryCode
    if (countryId <= 0) {
      if (countryCode != null && countryCode.isNotEmpty) {
        debugPrint(
          '[CheckoutRepo] countryId invalid, falling back to countryCode=$countryCode',
        );
        return _getCountryStatesByCode(countryCode);
      }
      debugPrint(
        '[CheckoutRepo] getCountryStates: invalid countryId=$countryId and no countryCode, returning empty',
      );
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

    _logCheckoutApiDetails(
      'getCountryStates',
      variables: variables,
      responseData: result.data,
    );

    final statesData = result.data?['countryStates'];
    if (statesData == null) {
      debugPrint('[CheckoutRepo] getCountryStates: countryStates is null');
      // Try alternative query with countryCode if available
      if (countryCode != null && countryCode.isNotEmpty && countryId <= 0) {
        debugPrint(
          '[CheckoutRepo] Trying alternative query with countryCode: $countryCode',
        );
        return _getCountryStatesByCode(countryCode);
      }
      return [];
    }

    // Handle both direct array and edges/node structures
    List<dynamic> statesList;
    if (statesData is List) {
      // Direct array format: countryStates: [{id, _id, ...}, ...]
      statesList = statesData;
      debugPrint(
        '[CheckoutRepo] getCountryStates: direct array format, ${statesList.length} items',
      );
    } else if (statesData is Map) {
      // Edge/node format: countryStates: {edges: [{node: {...}}, ...]}
      final edges = statesData['edges'] as List?;
      if (edges != null) {
        statesList = edges
            .map((edge) => edge is Map ? edge['node'] : edge)
            .where((node) => node != null)
            .toList();
        debugPrint(
          '[CheckoutRepo] getCountryStates: edge/node format, ${statesList.length} items',
        );
      } else {
        statesList = [];
        debugPrint('[CheckoutRepo] getCountryStates: edges is null');
      }
    } else {
      debugPrint(
        '[CheckoutRepo] getCountryStates: unexpected format: $statesData',
      );
      return [];
    }

    return statesList
        .map(
          (e) =>
              BagistoCountryState.fromJson((e ?? {}) as Map<String, dynamic>),
        )
        .toList();
  }

  /// Alternative: Fetch states using country code
  Future<List<BagistoCountryState>> _getCountryStatesByCode(
    String countryCode,
  ) async {
    debugPrint(
      '[CheckoutRepo] _getCountryStatesByCode countryCode=$countryCode',
    );

    final result = await _authedClient.query(
      QueryOptions(
        document: gql(CheckoutQueries.getCountryStatesByCode),
        variables: {'countryCode': countryCode, 'first': 200},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    debugPrint(
      '[CheckoutRepo] _getCountryStatesByCode raw result: ${result.data}',
    );

    if (result.hasException) {
      debugPrint(
        '[CheckoutRepo] _getCountryStatesByCode error: ${result.exception}',
      );
      return [];
    }

    _logCheckoutApiDetails(
      'getCountryStatesByCode',
      variables: {'countryCode': countryCode, 'first': 200},
      responseData: result.data,
    );

    final statesData = result.data?['countryStates'];
    if (statesData == null) {
      debugPrint(
        '[CheckoutRepo] _getCountryStatesByCode: countryStates is null',
      );
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
          (e) =>
              BagistoCountryState.fromJson((e ?? {}) as Map<String, dynamic>),
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

    _logCheckoutApiDetails('getCheckoutAddresses', responseData: result.data);

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

    _logCheckoutApiDetails(
      'getCustomerAddresses',
      variables: {'first': 100},
      responseData: result.data,
    );

    final edges = result.data?['getCustomerAddresses']?['edges'] as List?;
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

    _logCheckoutApiDetails(
      'getShippingRates',
      variables: {'token': qToken},
      responseData: result.data,
    );

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

    _logCheckoutApiDetails(
      'getPaymentMethods',
      variables: {'token': qToken},
      responseData: result.data,
    );

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

    _logCheckoutApiDetails(
      'saveCheckoutAddress',
      variables: {'input': input},
      responseData: result.data,
    );

    final data =
        result.data?['createCheckoutAddress']?['checkoutAddress']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to save checkout address – null response');
    }

    return CheckoutAddressResponse.fromJson(data);
  }

  /// Save the checkout billing address into the customer's address book.
  ///
  /// This is used for the first logged-in checkout when the customer has no
  /// saved addresses yet and opts into saving the entered billing address.
  Future<void> saveCustomerAddressFromCheckout(
    Map<String, dynamic> checkoutInput, {
    bool defaultAddress = false,
  }) async {
    final inputs = buildCustomerAddressBookInputsFromCheckout(
      checkoutInput,
      defaultAddress: defaultAddress,
    );

    for (final input in inputs) {
      debugPrint('[CheckoutRepo] saveCustomerAddressFromCheckout input=$input');

      final result = await _authedClient.mutate(
        MutationOptions(
          document: gql(AccountQueries.createAddUpdateCustomerAddress),
          variables: {'input': input},
        ),
      );

      if (result.hasException) {
        debugPrint(
          '[CheckoutRepo] saveCustomerAddressFromCheckout error: ${result.exception}',
        );
        throw result.exception!;
      }

      _logCheckoutApiDetails(
        'saveCustomerAddressFromCheckout',
        variables: {'input': input},
        responseData: result.data,
      );

      final data =
          result.data?['createAddUpdateCustomerAddress']?['addUpdateCustomerAddress']
              as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Failed to save address to address book');
      }
    }
  }

  /// Save selected shipping method
  Future<CheckoutShippingMethodResponse> saveShippingMethod(
    String shippingMethod,
  ) async {
    debugPrint(
      '[CheckoutRepo] saveShippingMethod: $shippingMethod (authToken present: ${_authToken != null})',
    );
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

    _logCheckoutApiDetails(
      'saveShippingMethod',
      variables: {
        'input': {'shippingMethod': shippingMethod},
      },
      responseData: result.data,
    );

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

    _logCheckoutApiDetails(
      'savePaymentMethod',
      variables: {
        'input': {'paymentMethod': paymentMethod},
      },
      responseData: result.data,
    );

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

    _logCheckoutApiDetails('placeOrder', responseData: result.data);

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

    _logCheckoutApiDetails(
      'applyCoupon',
      variables: {
        'input': {'couponCode': couponCode},
      },
      responseData: result.data,
    );

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

    _logCheckoutApiDetails(
      'removeCoupon',
      variables: {'input': {}},
      responseData: result.data,
    );

    final data =
        result.data?['createRemoveCoupon']?['removeCoupon']
            as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to remove coupon – null response');
    }

    return CouponResponse.fromJson(data);
  }
}
