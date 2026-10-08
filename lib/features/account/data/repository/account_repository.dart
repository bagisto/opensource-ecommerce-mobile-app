import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/graphql/eu_withdrawal_queries.dart';
import '../../../../core/graphql/account_queries.dart';
import '../../../../core/graphql/returns_queries.dart';
import '../models/account_models.dart';
import '../models/returns_models.dart';
import '../utils/review_attachment_encoder.dart';

void _logAccountApiMessage(String message) {
  debugPrint(message);
  // ignore: avoid_print
  print(message);
}

Map<String, dynamic> buildCustomerAddressMutationInput({
  int? addressId,
  required String firstName,
  required String lastName,
  required String address,
  required String city,
  required String state,
  required String country,
  required String postcode,
  required String phone,
  String? email,
  bool defaultAddress = false,
}) {
  final input = <String, dynamic>{
    'firstName': firstName,
    'lastName': lastName,
    'address1': address,
    'city': city,
    'state': state,
    'country': country,
    'postcode': postcode,
    'phone': phone,
    'defaultAddress': defaultAddress,
  };

  if (addressId != null) {
    input['addressId'] = addressId;
  }

  if (email != null && email.isNotEmpty) {
    input['email'] = email;
  }

  return input;
}

Map<String, dynamic> buildSetDefaultCustomerAddressMutationInput({
  required CustomerAddress address,
}) {
  return buildCustomerAddressMutationInput(
    addressId: address.numericId,
    firstName: address.firstName,
    lastName: address.lastName,
    address: address.address,
    city: address.city,
    state: address.state,
    country: address.country,
    postcode: address.zipCode,
    phone: address.phone ?? '',
    email: address.email,
    defaultAddress: true,
  );
}

/// Repository for Account Dashboard API calls via GraphQL.
/// Uses authenticated GraphQL client to fetch:
///   - Customer Profile  (readCustomerProfile)
///   - Customer Addresses (getCustomerAddresses)
///   - Product Reviews    (productReviews)
///
/// Note: Orders and Wishlist queries are NOT available in
/// the Bagisto demo storefront GraphQL schema. Those sections
/// return empty lists gracefully.
class AccountRepository {
  final GraphQLClient client;

  AccountRepository({required this.client});

  Future<List<ShopLocale>> getLocales() async {
    _logAccountApiMessage('🌐 AccountRepo.getLocales called');
    _logAccountApiMessage('📝 Query Name: getLocales');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getLocales),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      _logAccountApiMessage('❌ AccountRepo.getLocales error: $message');
      throw AccountException(message);
    }

    final edges = result.data?['locales']?['edges'] as List<dynamic>? ?? [];
    final locales = edges
        .map((edge) => ShopLocale.fromJson(edge['node'] as Map<String, dynamic>))
        .toList();

    _logAccountApiMessage(
      '✅ AccountRepo.getLocales success: ${locales.length} locales',
    );
    return locales;
  }

  Future<List<ShopCurrency>> getCurrencies() async {
    _logAccountApiMessage('🌐 AccountRepo.getCurrencies called');
    _logAccountApiMessage('📝 Query Name: allCurrency');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCurrencies),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      _logAccountApiMessage('❌ AccountRepo.getCurrencies error: $message');
      throw AccountException(message);
    }

    final edges = result.data?['currencies']?['edges'] as List<dynamic>? ?? [];
    final currencies = edges
        .map(
          (edge) => ShopCurrency.fromJson(edge['node'] as Map<String, dynamic>),
        )
        .toList();

    _logAccountApiMessage(
      '✅ AccountRepo.getCurrencies success: ${currencies.length} currencies',
    );
    return currencies;
  }

  /// Fetch customer profile via readCustomerProfile query.
  /// The API uses the auth token to identify the user (id is empty string).
  Future<CustomerProfile> getCustomerProfile() async {
    debugPrint('👤 AccountRepo.getCustomerProfile');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerProfile),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('👤 AccountRepo.getCustomerProfile — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['readCustomerProfile'];
    if (data == null) {
      throw AccountException('No profile data returned');
    }

    debugPrint('👤 AccountRepo.getCustomerProfile — success');
    return CustomerProfile.fromJson(data);
  }

  /// Fetch customer addresses via getCustomerAddresses query
  Future<List<CustomerAddress>> getCustomerAddresses({int first = 10}) async {
    debugPrint('📍 AccountRepo.getCustomerAddresses');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerAddresses),
        variables: {'first': first},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📍 AccountRepo.getCustomerAddresses — error: $message');
      throw AccountException(message);
    }

    final edges = result.data?['getCustomerAddresses']?['edges'] as List? ?? [];
    final addresses = edges.map<CustomerAddress>((edge) {
      final node = edge['node'] ?? edge;
      return CustomerAddress.fromJson(node);
    }).toList();

    debugPrint(
      '📍 AccountRepo.getCustomerAddresses — got ${addresses.length} addresses',
    );
    return addresses;
  }

  Future<List<RecentOrder>> getRecentOrders({int first = 5}) async {
    debugPrint('📦 AccountRepo.getRecentOrders');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerOrders),
        variables: {'first': first},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📦 AccountRepo.getRecentOrders — error: $message');
      throw AccountException(message);
    }

    final edges = result.data?['customerOrders']?['edges'] as List? ?? [];
    final orders = edges.map<RecentOrder>((edge) {
      final node = edge['node'] ?? edge;
      return RecentOrder.fromJson(node);
    }).toList();

    debugPrint('📦 AccountRepo.getRecentOrders — got ${orders.length} orders');
    return orders;
  }

  /// Fetch wishlists (cursor-paginated).
  /// Uses the authenticated wishlists query.
  Future<
    ({
      List<WishlistItem> items,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getWishlist({int first = 20, String? after}) async {
    debugPrint('❤️ AccountRepo.getWishlist');

    final variables = <String, dynamic>{'first': first};
    if (after != null) variables['after'] = after;

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getWishlists),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('❤️ AccountRepo.getWishlist — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['wishlists'];
    if (data == null) {
      return (
        items: const <WishlistItem>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }

    final edges = data['edges'] as List<dynamic>? ?? [];
    final items = edges
        .map((e) => WishlistItem.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
    final totalCount = data['totalCount'] as int? ?? items.length;

    final pageInfo = data['pageInfo'] as Map<String, dynamic>?;
    final hasNextPage = pageInfo?['hasNextPage'] as bool? ?? false;
    final endCursor = pageInfo?['endCursor']?.toString();

    debugPrint(
      '❤️ AccountRepo.getWishlist — ${items.length} items (total: $totalCount, hasNext: $hasNextPage)',
    );
    return (
      items: items,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
      endCursor: endCursor,
    );
  }

  /// Delete a wishlist item by IRI id.
  Future<void> deleteWishlistItem({required String id}) async {
    debugPrint('🗑️ AccountRepo.deleteWishlistItem (id=$id)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.deleteWishlist),
        variables: {
          'input': {'id': id},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🗑️ AccountRepo.deleteWishlistItem — error: $message');
      throw AccountException(message);
    }

    debugPrint('🗑️ AccountRepo.deleteWishlistItem — success');
  }

  /// Move a wishlist item to cart.
  /// [wishlistItemId] is the numeric _id (not IRI).
  Future<String> moveWishlistToCart({
    required int wishlistItemId,
    int quantity = 1,
  }) async {
    debugPrint(
      '🛒 AccountRepo.moveWishlistToCart (itemId=$wishlistItemId, qty=$quantity)',
    );

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.moveWishlistToCart),
        variables: {
          'input': {'wishlistItemId': wishlistItemId, 'quantity': quantity},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🛒 AccountRepo.moveWishlistToCart — error: $message');
      throw AccountException(message);
    }

    final msg =
        result.data?['moveWishlistToCart']?['wishlistToCart']?['message']
            ?.toString() ??
        'Item moved to cart';
    debugPrint('🛒 AccountRepo.moveWishlistToCart — success: $msg');
    return msg;
  }

  /// Fetch product reviews via productReviews query
  /// [productId] — optional product ID to filter reviews for a specific product
  Future<({List<ProductReview> reviews, int totalCount})> getProductReviews({
    int first = 10,
    int? status,
    int? productId,
  }) async {
    debugPrint('⭐ AccountRepo.getProductReviews (productId=$productId)');

    final variables = <String, dynamic>{'first': first};
    if (status != null) variables['status'] = status;
    if (productId != null) variables['productId'] = productId;

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getProductReviews),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('⭐ AccountRepo.getProductReviews — error: $message');
      throw AccountException(message);
    }

    final reviewsData = result.data?['productReviews'];
    if (reviewsData == null) {
      return (reviews: const <ProductReview>[], totalCount: 0);
    }

    final edges = reviewsData['edges'] as List? ?? [];
    final totalCount = reviewsData['totalCount'] as int? ?? edges.length;

    final reviews = edges.map<ProductReview>((edge) {
      final node = edge['node'] ?? edge;
      return ProductReview.fromJson(node);
    }).toList();

    debugPrint(
      '⭐ AccountRepo.getProductReviews — got ${reviews.length} reviews, total: $totalCount',
    );
    return (reviews: reviews, totalCount: totalCount);
  }

  /// Fetch customer reviews via customerReviews query (cursor-paginated).
  /// Returns review list with nested product data (name, images).
  /// Falls back to productReviews if customerReviews is unavailable.
  Future<
    ({
      List<ProductReview> reviews,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerReviews({int first = 10, String? after}) async {
    debugPrint('⭐ AccountRepo.getCustomerReviews');

    final variables = <String, dynamic>{'first': first};
    if (after != null) variables['after'] = after;

    // Try customerReviews first
    var result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerReviews),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    // Determine which response key to use
    String responseKey = 'customerReviews';

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('⭐ CustomerReviews failed: $message');
      // Fallback: try productReviews if customerReviews not available
      debugPrint('⭐ Falling back to productReviews');
      result = await client.query(
        QueryOptions(
          document: gql(AccountQueries.getCustomerReviews),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      responseKey = 'productReviews';

      if (result.hasException) {
        final message = _extractErrorMessage(result.exception!);
        debugPrint('⭐ AccountRepo.getCustomerReviews — error: $message');
        throw AccountException(message);
      }
    }

    final data = result.data?[responseKey];
    if (data == null) {
      return (
        reviews: const <ProductReview>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }

    final edges = data['edges'] as List<dynamic>? ?? [];
    final reviews = edges
        .map((e) => ProductReview.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
    final totalCount = data['totalCount'] as int? ?? reviews.length;
    final pageInfo = data['pageInfo'] as Map<String, dynamic>?;
    final hasNextPage = pageInfo?['hasNextPage'] as bool? ?? false;
    final endCursor = pageInfo?['endCursor']?.toString();

    debugPrint(
      '⭐ AccountRepo.getCustomerReviews — ${reviews.length} reviews (total: $totalCount, hasNext: $hasNextPage)',
    );
    return (
      reviews: reviews,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
      endCursor: endCursor,
    );
  }

  /// Set an address as the default address.
  /// Uses createAddUpdateCustomerAddress mutation with addressId and defaultAddress: true.
  /// Requires the full address data to be passed.
  Future<CustomerAddress> setDefaultAddress({
    required int addressId,
    required String firstName,
    required String lastName,
    required String address,
    required String city,
    required String state,
    required String country,
    required String postcode,
    required String phone,
    String? email,
  }) async {
    debugPrint('📍 AccountRepo.setDefaultAddress (addressId=$addressId)');

    final input = buildCustomerAddressMutationInput(
      addressId: addressId,
      firstName: firstName,
      lastName: lastName,
      address: address,
      city: city,
      state: state,
      country: country,
      postcode: postcode,
      phone: phone,
      email: email,
      defaultAddress: true,
    );

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.setDefaultAddress),
        variables: {'input': input},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📍 AccountRepo.setDefaultAddress — error: $message');
      throw AccountException(message);
    }

    final data = result
        .data?['createAddUpdateCustomerAddress']?['addUpdateCustomerAddress'];
    if (data == null) {
      throw AccountException('Failed to set default address');
    }

    debugPrint('📍 AccountRepo.setDefaultAddress — success');
    return CustomerAddress.fromJson(data as Map<String, dynamic>);
  }

  /// Delete a customer address
  /// Uses createDeleteCustomerAddress mutation with input type createDeleteCustomerAddressInput.
  Future<void> deleteAddress({required int addressId}) async {
    debugPrint('🗑️ AccountRepo.deleteAddress (id=$addressId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.deleteCustomerAddress),
        variables: {
          'input': {'addressId': addressId},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🗑️ AccountRepo.deleteAddress — error: $message');
      throw AccountException(message);
    }

    debugPrint('🗑️ AccountRepo.deleteAddress — success');
  }

  /// Add a new customer address via createAddUpdateCustomerAddress mutation.
  /// Schema introspection: createAddUpdateCustomerAddressInput fields:
  ///   firstName, lastName, email, phone, address1, address2,
  ///   country, state, city, postcode, defaultAddress
  Future<CustomerAddress> createAddress({
    required String firstName,
    required String lastName,
    required String address,
    required String city,
    required String state,
    required String country,
    required String postcode,
    required String phone,
    String? email,
    String? companyName,
    String? vatId,
    bool defaultAddress = false,
  }) async {
    debugPrint('📍 AccountRepo.createAddress');

    final input = buildCustomerAddressMutationInput(
      firstName: firstName,
      lastName: lastName,
      address: address,
      city: city,
      state: state,
      country: country,
      postcode: postcode,
      phone: phone,
      email: email,
      defaultAddress: defaultAddress,
    );
    // Note: companyName and vatId are NOT supported by
    // createAddUpdateCustomerAddressInput on this server.

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.createAddUpdateCustomerAddress),
        variables: {'input': input},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📍 AccountRepo.createAddress — error: $message');
      throw AccountException(message);
    }

    final data = result
        .data?['createAddUpdateCustomerAddress']?['addUpdateCustomerAddress'];
    if (data == null) {
      throw AccountException('Failed to create address');
    }

    debugPrint('📍 AccountRepo.createAddress — success');
    return CustomerAddress.fromJson(data as Map<String, dynamic>);
  }

  /// Update an existing customer address via createAddUpdateCustomerAddress mutation.
  /// The `addressId` (Int) tells the API which address to update.
  /// API: https://api-docs.bagisto.com/api/graphql-api/shop/mutations/update-customer-address.html
  Future<CustomerAddress> updateAddress({
    required int addressId,
    required String firstName,
    required String lastName,
    required String address,
    required String city,
    required String state,
    required String country,
    required String postcode,
    required String phone,
    String? email,
    String? companyName,
    String? vatId,
    bool defaultAddress = false,
  }) async {
    debugPrint('📍 AccountRepo.updateAddress (addressId=$addressId)');

    final input = buildCustomerAddressMutationInput(
      addressId: addressId,
      firstName: firstName,
      lastName: lastName,
      address: address,
      city: city,
      state: state,
      country: country,
      postcode: postcode,
      phone: phone,
      email: email,
      defaultAddress: defaultAddress,
    );

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.createAddUpdateCustomerAddress),
        variables: {'input': input},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📍 AccountRepo.updateAddress — error: $message');
      throw AccountException(message);
    }

    final data = result
        .data?['createAddUpdateCustomerAddress']?['addUpdateCustomerAddress'];
    if (data == null) {
      throw AccountException('Failed to update address');
    }

    debugPrint('📍 AccountRepo.updateAddress — success');
    return CustomerAddress.fromJson(data as Map<String, dynamic>);
  }

  /// Update customer profile via updateCustomerProfile mutation.
  /// Fields: firstName, lastName, phone, gender, dateOfBirth, subscribedToNewsLetter
  Future<CustomerProfile> updateCustomerProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? gender,
    String? dateOfBirth,
    bool? subscribedToNewsLetter,
  }) async {
    debugPrint('👤 AccountRepo.updateCustomerProfile');

    final input = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
    };
    if (phone != null) input['phone'] = phone;
    if (gender != null) input['gender'] = gender;
    if (dateOfBirth != null) input['dateOfBirth'] = dateOfBirth;
    if (subscribedToNewsLetter != null) {
      input['subscribedToNewsLetter'] = subscribedToNewsLetter;
    }

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.updateCustomerProfile),
        variables: {'input': input},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('👤 AccountRepo.updateCustomerProfile — error: $message');
      throw AccountException(message);
    }

    final payload =
        result.data?['createCustomerProfileUpdate']?['customerProfileUpdate'];
    if (payload == null) {
      throw AccountException('Failed to update profile');
    }

    // Re-fetch the full profile since the mutation only returns id
    debugPrint(
      '👤 AccountRepo.updateCustomerProfile — mutation success, re-fetching profile',
    );
    return getCustomerProfile();
  }

  /// Change customer email — requires current password for verification
  Future<CustomerProfile> changeEmail({
    required String email,
    required String currentPassword,
  }) async {
    debugPrint('📧 AccountRepo.changeEmail');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.changeCustomerEmail),
        variables: {
          'input': {'email': email, 'currentPassword': currentPassword},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📧 AccountRepo.changeEmail — error: $message');
      throw AccountException(message);
    }

    final payload =
        result.data?['createCustomerProfileUpdate']?['customerProfileUpdate'];
    if (payload == null) {
      throw AccountException('Failed to change email');
    }

    // Re-fetch the full profile since the mutation only returns id
    debugPrint(
      '📧 AccountRepo.changeEmail — mutation success, re-fetching profile',
    );
    return getCustomerProfile();
  }

  /// Change customer password — requires current + new password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    debugPrint('🔑 AccountRepo.changePassword');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.changeCustomerPassword),
        variables: {
          'input': {
            'currentPassword': currentPassword,
            'newPassword': newPassword,
            'confirmPassword': confirmPassword,
          },
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🔑 AccountRepo.changePassword — error: $message');
      throw AccountException(message);
    }

    debugPrint('🔑 AccountRepo.changePassword — success');
  }

  /// Delete customer account — requires current password
  Future<void> deleteCustomerAccount({required String password}) async {
    debugPrint('🗑️ AccountRepo.deleteCustomerAccount');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.deleteCustomerAccount),
        variables: {
          'input': {'password': password},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🗑️ AccountRepo.deleteCustomerAccount — error: $message');
      throw AccountException(message);
    }

    debugPrint('🗑️ AccountRepo.deleteCustomerAccount — success');
  }

  /// Fetch list of available countries (cursor-paginated).
  /// Uses FetchPolicy.cacheFirst — countries rarely change.
  Future<List<Country>> getCountries() async {
    debugPrint('🌍 AccountRepo.getCountries');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCountries),
        variables: const {'first': 260},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🌍 AccountRepo.getCountries — error: $message');
      throw AccountException(message);
    }

    // Cursor-paginated: countries → edges → [ { node: { ... } } ]
    final edges = result.data?['countries']?['edges'] as List<dynamic>? ?? [];
    final countries = edges.map<Country>((edge) {
      final node = (edge as Map<String, dynamic>)['node'] ?? edge;
      return Country.fromJson(node as Map<String, dynamic>);
    }).toList();
    countries.sort((a, b) => a.name.compareTo(b.name));

    debugPrint('🌍 AccountRepo.getCountries — got ${countries.length}');
    return countries;
  }

  /// Fetch states/provinces for a given country using its numeric _id.
  /// Uses FetchPolicy.cacheFirst — states rarely change.
  Future<List<CountryState>> getCountryStates({required int countryId}) async {
    debugPrint('🏛️ AccountRepo.getCountryStates (countryId=$countryId)');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCountryStates),
        variables: {'countryId': countryId, 'first': 200},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🏛️ AccountRepo.getCountryStates — error: $message');
      throw AccountException(message);
    }

    // Cursor-paginated: countryStates → edges → [ { node: { ... } } ]
    final edges =
        result.data?['countryStates']?['edges'] as List<dynamic>? ?? [];
    final states = edges.map<CountryState>((edge) {
      final node = (edge as Map<String, dynamic>)['node'] ?? edge;
      return CountryState.fromJson(node as Map<String, dynamic>);
    }).toList();
    states.sort((a, b) => a.name.compareTo(b.name));

    debugPrint('🏛️ AccountRepo.getCountryStates — got ${states.length}');
    return states;
  }

  // ──────────────────────────────────────────────
  // Compare Items
  // ──────────────────────────────────────────────

  /// Fetch compare items (cursor-paginated).
  Future<({List<CompareItem> items, int totalCount})> getCompareItems({
    int first = 20,
    String? after,
  }) async {
    debugPrint('🔀 AccountRepo.getCompareItems');

    final variables = <String, dynamic>{'first': first};
    if (after != null) variables['after'] = after;

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCompareItems),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🔀 AccountRepo.getCompareItems — error: $message');
      throw AccountException(message);
    }

    final connection = result.data?['compareItems'];
    if (connection == null) {
      return (items: <CompareItem>[], totalCount: 0);
    }

    final edges = connection['edges'] as List<dynamic>? ?? [];
    final totalCount = connection['totalCount'] as int? ?? edges.length;

    final items = edges.map<CompareItem>((edge) {
      final node = (edge as Map<String, dynamic>)['node'] ?? edge;
      return CompareItem.fromJson(node as Map<String, dynamic>);
    }).toList();

    debugPrint(
      '🔀 AccountRepo.getCompareItems — got ${items.length} of $totalCount',
    );
    return (items: items, totalCount: totalCount);
  }

  /// Delete a single compare item by IRI id.
  Future<void> deleteCompareItem(String id) async {
    debugPrint('🔀 AccountRepo.deleteCompareItem($id)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.deleteCompareItem),
        variables: {'id': id},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🔀 AccountRepo.deleteCompareItem — error: $message');
      throw AccountException(message);
    }

    debugPrint('🔀 AccountRepo.deleteCompareItem — success');
  }

  /// Delete all compare items at once.
  Future<void> deleteAllCompareItems() async {
    debugPrint('🔀 AccountRepo.deleteAllCompareItems');

    final result = await client.mutate(
      MutationOptions(document: gql(AccountQueries.deleteAllCompareItems)),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🔀 AccountRepo.deleteAllCompareItems — error: $message');
      throw AccountException(message);
    }

    debugPrint('🔀 AccountRepo.deleteAllCompareItems — success');
  }

  /// Add product to wishlist.
  /// [productId] is the numeric product ID.
  /// Add product to wishlist.
  /// [productId] is the numeric product ID.
  /// Returns the wishlist item IRI id (e.g. "/api/shop/wishlists/69").
  Future<String?> addToWishlist({required int productId}) async {
    debugPrint('❤️ AccountRepo.addToWishlist (productId=$productId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.createWishlist),
        variables: {
          'input': {'productId': productId},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('❤️ AccountRepo.addToWishlist — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['createWishlist']?['wishlist'];
    final iri = data?['id']?.toString();
    debugPrint('❤️ AccountRepo.addToWishlist — success (iri=$iri)');
    return iri;
  }

  /// Add product to compare list.
  /// [productId] is the numeric product ID.
  Future<void> addToCompare({required int productId}) async {
    debugPrint('🔀 AccountRepo.addToCompare (productId=$productId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.createCompareItem),
        variables: {
          'input': {'productId': productId},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🔀 AccountRepo.addToCompare — error: $message');
      throw AccountException(message);
    }

    debugPrint('🔀 AccountRepo.addToCompare — success');
  }

  /// Create a product review.
  /// [productId] — numeric product _id (Int).
  /// [title] — review headline.
  /// [comment] — full review text.
  /// [rating] — 1 to 5 star rating.
  /// [name] — reviewer's display name.
  /// [attachments] — optional images/videos, sent as a JSON string of
  /// Base64 data URIs. The key is omitted when the list is empty.
  /// Returns the created ProductReview.
  Future<ProductReview> createProductReview({
    required int productId,
    required String title,
    required String comment,
    required int rating,
    required String name,
    List<File> attachments = const [],
  }) async {
    debugPrint(
      '📝 AccountRepo.createProductReview '
      '(product=$productId, attachments=${attachments.length})',
    );

    final input = <String, dynamic>{
      'productId': productId,
      'title': title,
      'comment': comment,
      'rating': rating,
      'name': name,
    };
    if (attachments.isNotEmpty) {
      input['attachments'] = await ReviewAttachmentEncoder.encode(attachments);
    }

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.createProductReview),
        variables: {'input': input},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📝 AccountRepo.createProductReview — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['createProductReview']?['productReview'];
    if (data == null) {
      throw AccountException('Failed to create review');
    }

    debugPrint('📝 AccountRepo.createProductReview — success');
    return ProductReview.fromJson(data as Map<String, dynamic>);
  }

  /// Fetch customer orders with cursor-based pagination.
  /// Supports optional [status] filter and cursor [after] for pagination.
  Future<
    ({
      List<CustomerOrder> orders,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerOrders({int first = 20, String? after, String? status}) async {
    debugPrint(
      '📦 AccountRepo.getCustomerOrders (first=$first, status=$status)',
    );

    final variables = <String, dynamic>{'first': first};
    if (after != null) variables['after'] = after;
    if (status != null) variables['status'] = status;

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerOrders),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📦 AccountRepo.getCustomerOrders — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerOrders'];
    if (data == null) {
      return (
        orders: const <CustomerOrder>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }

    final edges = data['edges'] as List<dynamic>? ?? [];
    final orders = edges
        .map((e) => CustomerOrder.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
    final totalCount = data['totalCount'] as int? ?? orders.length;
    final pageInfo = data['pageInfo'] as Map<String, dynamic>?;
    final hasNextPage = pageInfo?['hasNextPage'] as bool? ?? false;
    final endCursor = pageInfo?['endCursor']?.toString();

    debugPrint(
      '📦 AccountRepo.getCustomerOrders — ${orders.length} orders (total: $totalCount, hasNext: $hasNextPage)',
    );
    return (
      orders: orders,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
      endCursor: endCursor,
    );
  }

  /// Fetch a single customer order detail by numeric ID.
  /// The Bagisto API expects an IRI ID for the `customerOrder(id: ID!)` query.
  /// We construct it as: `/api/shop/customer-orders/{numericId}`
  Future<OrderDetail> getCustomerOrder(int orderId) async {
    debugPrint('📦 AccountRepo.getCustomerOrder (id=$orderId)');

    final iriId = '/api/shop/customer-orders/$orderId';

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerOrder),
        variables: {'id': iriId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📦 AccountRepo.getCustomerOrder — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerOrder'];
    if (data == null) {
      throw const AccountException('Order not found');
    }

    debugPrint('📦 AccountRepo.getCustomerOrder — success');
    return OrderDetail.fromJson(data as Map<String, dynamic>);
  }

  /// `allowCancellation` of a booking product; null when unknown.
  Future<bool?> getBookingAllowsCancellation(int productId) async {
    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getBookingCancellation),
        variables: {'id': '/api/shop/products/$productId'},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📦 AccountRepo.getBookingAllowsCancellation — error: $message');
      throw AccountException(message);
    }

    final edges =
        result.data?['product']?['bookingProducts']?['edges'] as List? ?? [];
    final value = edges.isEmpty
        ? null
        : (edges.first as Map)['node']?['allowCancellation'];
    if (value == null) return null;
    return value == true || value.toString() == '1' || value == 1;
  }

  // ──────────────────────────────────────────────
  // EU contract withdrawal
  // ──────────────────────────────────────────────

  /// Whether EU withdrawal is enabled for the channel (admin setting).
  Future<bool> isEuWithdrawalEnabled() async {
    final result = await client.query(
      QueryOptions(
        document: gql(EuWithdrawalQueries.getStatus),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw AccountException(_extractErrorMessage(result.exception!));
    }
    return result.data?['euWithdrawalStatus']?['enabled'] == true;
  }

  /// The customer's withdrawal request for [orderId], if any.
  Future<EuWithdrawal?> getEuWithdrawalForOrder(int orderId) async {
    String? after;
    do {
      final result = await client.query(
        QueryOptions(
          document: gql(EuWithdrawalQueries.getWithdrawals),
          variables: {'first': 50, 'after': ?after},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        throw AccountException(_extractErrorMessage(result.exception!));
      }
      final connection = result.data?['euWithdrawals'] as Map<String, dynamic>?;
      final edges = connection?['edges'] as List<dynamic>? ?? [];
      for (final edge in edges) {
        final node = (edge as Map)['node'];
        if (node is Map<String, dynamic> &&
            _parseIntValue(node['orderId']) == orderId) {
          return EuWithdrawal.fromJson(node);
        }
      }
      final pageInfo = connection?['pageInfo'] as Map<String, dynamic>?;
      after = pageInfo?['hasNextPage'] == true
          ? pageInfo!['endCursor'] as String?
          : null;
    } while (after != null);
    return null;
  }

  /// Withdraw from the contract of the customer's order [orderId].
  Future<EuWithdrawal> createEuWithdrawal({
    required int orderId,
    String? reasonText,
  }) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(EuWithdrawalQueries.createWithdrawal),
        variables: {
          'input': {
            'orderId': orderId,
            if (reasonText != null && reasonText.isNotEmpty)
              'reasonText': reasonText,
          },
        },
      ),
    );
    if (result.hasException) {
      throw AccountException(_extractErrorMessage(result.exception!));
    }
    final data = result.data?['createEuWithdrawal']?['euWithdrawal'];
    if (data is! Map<String, dynamic>) {
      throw const AccountException('Failed to submit the withdrawal request');
    }
    return EuWithdrawal.fromJson(data);
  }

  /// Guest withdrawal for order [orderIncrementId] placed with [email].
  Future<EuWithdrawal> createGuestEuWithdrawal({
    required String orderIncrementId,
    required String email,
    String? reasonText,
  }) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(EuWithdrawalQueries.createGuestWithdrawal),
        variables: {
          'input': {
            'orderIncrementId': orderIncrementId,
            'email': email,
            if (reasonText != null && reasonText.isNotEmpty)
              'reasonText': reasonText,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (result.hasException) {
      throw AccountException(_extractErrorMessage(result.exception!));
    }
    final data = result.data?['createGuestEuWithdrawal']?['guestEuWithdrawal'];
    if (data is! Map<String, dynamic>) {
      throw const AccountException('Failed to submit the withdrawal request');
    }
    return EuWithdrawal.fromJson(data);
  }

  static int? _parseIntValue(dynamic value) =>
      value is int ? value : int.tryParse('$value');

  /// Fetch customer invoices with cursor-based pagination.
  /// Supports optional [orderId] and [state] filters.
  Future<
    ({
      List<OrderInvoice> invoices,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerInvoices({
    int first = 20,
    String? after,
    int? orderId,
    String? state,
  }) async {
    debugPrint(
      '🧾 AccountRepo.getCustomerInvoices (first=$first, orderId=$orderId, state=$state)',
    );

    final variables = <String, dynamic>{'first': first};
    if (after != null) variables['after'] = after;
    if (orderId != null) variables['orderId'] = orderId;
    if (state != null) variables['state'] = state;

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerInvoices),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🧾 AccountRepo.getCustomerInvoices — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerInvoices'];
    if (data == null) {
      return (
        invoices: const <OrderInvoice>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }

    final edges = data['edges'] as List<dynamic>? ?? [];
    final invoices = edges
        .map((e) => OrderInvoice.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
    final totalCount = data['totalCount'] as int? ?? invoices.length;
    final pageInfo = data['pageInfo'] as Map<String, dynamic>?;
    final hasNextPage = pageInfo?['hasNextPage'] as bool? ?? false;
    final endCursor = pageInfo?['endCursor']?.toString();

    debugPrint(
      '🧾 AccountRepo.getCustomerInvoices — ${invoices.length} invoices (total: $totalCount, hasNext: $hasNextPage)',
    );
    return (
      invoices: invoices,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
      endCursor: endCursor,
    );
  }

  /// Fetch a single customer invoice detail by numeric ID.
  /// The Bagisto API expects an IRI ID for the `customerInvoice(id: ID!)` query.
  /// We construct it as: `/api/shop/customer-invoices/{numericId}`
  Future<OrderInvoice> getCustomerInvoice(int invoiceId) async {
    debugPrint('🧾 AccountRepo.getCustomerInvoice (id=$invoiceId)');

    final iriId = '/api/shop/customer-invoices/$invoiceId';

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerInvoice),
        variables: {'id': iriId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🧾 AccountRepo.getCustomerInvoice — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerInvoice'];
    if (data == null) {
      throw const AccountException('Invoice not found');
    }

    debugPrint('🧾 AccountRepo.getCustomerInvoice — success');
    return OrderInvoice.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────────
  // Customer Shipments
  // ──────────────────────────────────────────────

  /// Fetch customer order shipments for a given order.
  Future<({List<OrderShipment> shipments, int totalCount})>
  getCustomerOrderShipments({required int orderId}) async {
    debugPrint('📦 AccountRepo.getCustomerOrderShipments (orderId=$orderId)');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerOrderShipments),
        variables: {'orderId': orderId},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📦 AccountRepo.getCustomerOrderShipments — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerOrderShipments'];
    if (data == null) {
      return (shipments: const <OrderShipment>[], totalCount: 0);
    }

    final edges = data['edges'] as List<dynamic>? ?? [];
    final shipments = edges
        .map((e) => OrderShipment.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
    final totalCount = data['totalCount'] as int? ?? shipments.length;

    debugPrint(
      '📦 AccountRepo.getCustomerOrderShipments — ${shipments.length} shipments (total: $totalCount)',
    );
    return (shipments: shipments, totalCount: totalCount);
  }

  /// Fetch a single customer order shipment detail by numeric ID.
  Future<OrderShipment> getCustomerOrderShipment(int shipmentId) async {
    debugPrint('📦 AccountRepo.getCustomerOrderShipment (id=$shipmentId)');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerOrderShipment),
        variables: {'id': '/api/shop/customer-order-shipments/$shipmentId'},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📦 AccountRepo.getCustomerOrderShipment — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerOrderShipment'];
    if (data == null) {
      throw const AccountException('Shipment not found');
    }

    debugPrint('📦 AccountRepo.getCustomerOrderShipment — success');
    return OrderShipment.fromJson(data as Map<String, dynamic>);
  }

  /// Extract error message from GraphQL exception
  String _extractErrorMessage(OperationException exception) {
    return ErrorMapper.getUserMessage(exception);
  }

  /// Reorder an existing order.
  /// [orderId] is the numeric order ID.
  /// Returns a tuple with success status, message, orderId, and itemsAddedCount.
  Future<({bool success, String message, int orderId, int itemsAddedCount})>
  reorderOrder({required int orderId}) async {
    debugPrint('🔄 AccountRepo.reorderOrder (orderId=$orderId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.reorderOrder),
        variables: {
          'input': {'orderId': orderId},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🔄 AccountRepo.reorderOrder — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['createReorderOrder']?['reorderOrder'];
    if (data == null) {
      throw AccountException('Failed to reorder');
    }

    final success = data['success'] as bool? ?? false;
    final message = data['message'] as String? ?? '';
    final reorderedOrderId = data['orderId'] as int? ?? orderId;
    final itemsAddedCount = data['itemsAddedCount'] as int? ?? 0;

    debugPrint(
      '🔄 AccountRepo.reorderOrder — success: $success, message: $message, itemsAddedCount: $itemsAddedCount',
    );
    return (
      success: success,
      message: message,
      orderId: reorderedOrderId,
      itemsAddedCount: itemsAddedCount,
    );
  }

  /// Cancel an existing order.
  /// [orderId] is the numeric order ID.
  /// Returns a record with success status, message, orderId, and new status.
  Future<({bool success, String message, int orderId, String status})>
  cancelOrder({required int orderId}) async {
    debugPrint('🚫 AccountRepo.cancelOrder (orderId=$orderId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.cancelOrder),
        variables: {
          'input': {'orderId': orderId},
        },
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🚫 AccountRepo.cancelOrder — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['createCancelOrder']?['cancelOrder'];
    if (data == null) {
      throw const AccountException('Failed to cancel order');
    }

    final success = data['success'] as bool? ?? false;
    final message = data['message'] as String? ?? '';
    final canceledOrderId = data['orderId'] as int? ?? orderId;
    final status = data['status']?.toString() ?? '';

    debugPrint(
      '🚫 AccountRepo.cancelOrder — success: $success, message: $message, status: $status',
    );
    return (
      success: success,
      message: message,
      orderId: canceledOrderId,
      status: status,
    );
  }

  /// Fetch customer downloadable products (cursor-paginated)
  /// Returns downloadable products associated with customer's orders
  Future<
    ({
      List<DownloadableProduct> products,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerDownloadableProducts({int first = 10, String? after}) async {
    debugPrint('📥 AccountRepo.getCustomerDownloadableProducts');

    final variables = <String, dynamic>{'first': first};
    if (after != null) variables['after'] = after;

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getCustomerDownloadableProducts),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint(
        '📥 AccountRepo.getCustomerDownloadableProducts — error: $message',
      );
      throw AccountException(message);
    }

    final data = result.data?['customerDownloadableProducts'];
    if (data == null) {
      return (
        products: const <DownloadableProduct>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }

    final edges = data['edges'] as List<dynamic>? ?? [];
    final products = edges
        .map(
          (e) =>
              DownloadableProduct.fromJson(e['node'] as Map<String, dynamic>),
        )
        .toList();
    final totalCount = data['totalCount'] as int? ?? products.length;
    final pageInfo = data['pageInfo'] as Map<String, dynamic>?;
    final hasNextPage = pageInfo?['hasNextPage'] as bool? ?? false;
    final endCursor = pageInfo?['endCursor']?.toString();

    debugPrint(
      '📥 AccountRepo.getCustomerDownloadableProducts — ${products.length} products (total: $totalCount, hasNext: $hasNextPage)',
    );
    return (
      products: products,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
      endCursor: endCursor,
    );
  }

  // ─── Returns (RMA) ───

  /// Fetch customer return requests with cursor-based pagination.
  Future<
    ({
      List<CustomerReturn> returns,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerReturns({int first = 20, String? after, int? status}) async {
    debugPrint('↩️ AccountRepo.getCustomerReturns (first=$first, status=$status)');

    final variables = <String, dynamic>{'first': first};
    if (after != null) variables['after'] = after;
    if (status != null) variables['status'] = status;

    final result = await client.query(
      QueryOptions(
        document: gql(ReturnsQueries.getCustomerReturns),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.getCustomerReturns — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerReturns'];
    if (data == null) {
      return (
        returns: const <CustomerReturn>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }

    final edges = data['edges'] as List<dynamic>? ?? [];
    final returns = edges
        .map((e) => CustomerReturn.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
    final totalCount = data['totalCount'] as int? ?? returns.length;
    final pageInfo = data['pageInfo'] as Map<String, dynamic>?;
    final hasNextPage = pageInfo?['hasNextPage'] as bool? ?? false;
    final endCursor = pageInfo?['endCursor']?.toString();

    debugPrint(
      '↩️ AccountRepo.getCustomerReturns — ${returns.length} returns (total: $totalCount, hasNext: $hasNextPage)',
    );
    return (
      returns: returns,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
      endCursor: endCursor,
    );
  }

  /// Fetch a single return detail by numeric ID.
  /// The Bagisto API expects an IRI ID: `/api/shop/returns/{numericId}`
  Future<CustomerReturn> getCustomerReturn(int returnId) async {
    debugPrint('↩️ AccountRepo.getCustomerReturn (id=$returnId)');

    final iriId = '/api/shop/returns/$returnId';

    final result = await client.query(
      QueryOptions(
        document: gql(ReturnsQueries.getCustomerReturn),
        variables: {'id': iriId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.getCustomerReturn — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerReturn'];
    if (data == null) {
      throw const AccountException('Return not found');
    }

    debugPrint('↩️ AccountRepo.getCustomerReturn — success');
    return CustomerReturn.fromJson(data as Map<String, dynamic>);
  }

  /// Fetch order items still eligible for return/cancellation.
  /// Orders the customer can still raise a return for (returnable quantity
  /// above zero). Pass [incrementId] to check a single order.
  Future<List<CustomerOrder>> getReturnableOrders({String? incrementId}) async {
    debugPrint('↩️ AccountRepo.getReturnableOrders (incrementId=$incrementId)');

    final result = await client.query(
      QueryOptions(
        document: gql(ReturnsQueries.getReturnableOrders),
        variables: {'incrementId': ?incrementId},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.getReturnableOrders — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['returnableOrders'] as List<dynamic>? ?? [];
    final orders = data
        .whereType<Map<String, dynamic>>()
        .where((json) => (int.tryParse('${json['returnableQty']}') ?? 0) > 0)
        .map(CustomerOrder.fromJson)
        .toList();

    debugPrint('↩️ AccountRepo.getReturnableOrders — ${orders.length} orders');
    return orders;
  }

  Future<List<ReturnableItem>> getReturnableItems(int orderId) async {
    debugPrint('↩️ AccountRepo.getReturnableItems (orderId=$orderId)');

    final result = await client.query(
      QueryOptions(
        document: gql(ReturnsQueries.getReturnableItems),
        variables: {'orderId': orderId},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.getReturnableItems — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['returnableItems'] as List<dynamic>? ?? [];
    final items = data
        .map((e) => ReturnableItem.fromJson(e as Map<String, dynamic>))
        .toList();

    debugPrint('↩️ AccountRepo.getReturnableItems — ${items.length} items');
    return items;
  }

  /// Fetch active return reasons for a resolution type
  /// ("return" or "cancel_items"), sorted by position.
  Future<List<ReturnReason>> getReturnReasons(String resolutionType) async {
    debugPrint('↩️ AccountRepo.getReturnReasons (type=$resolutionType)');

    final result = await client.query(
      QueryOptions(
        document: gql(ReturnsQueries.getReturnReasons),
        variables: {'resolutionType': resolutionType},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.getReturnReasons — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['returnReasons'] as List<dynamic>? ?? [];
    final reasons = data
        .map((e) => ReturnReason.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    debugPrint('↩️ AccountRepo.getReturnReasons — ${reasons.length} reasons');
    return reasons;
  }

  /// Fetch the conversation thread for a return, oldest first.
  Future<List<ReturnMessage>> getReturnMessages(int returnId) async {
    debugPrint('↩️ AccountRepo.getReturnMessages (returnId=$returnId)');

    final result = await client.query(
      QueryOptions(
        document: gql(ReturnsQueries.getReturnMessages),
        variables: {'returnId': returnId},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.getReturnMessages — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['customerReturnMessages'] as List<dynamic>? ?? [];
    final messages = data
        .map((e) => ReturnMessage.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));

    debugPrint('↩️ AccountRepo.getReturnMessages — ${messages.length} messages');
    return messages;
  }

  /// Create a return request for one order item.
  /// [resolutionType] is "return" or "cancel_items".
  Future<CustomerReturn> createReturn({
    required int orderId,
    required int orderItemId,
    required int rmaQty,
    required String resolutionType,
    required int rmaReasonId,
    String? information,
    String? packageCondition,
  }) async {
    debugPrint(
      '↩️ AccountRepo.createReturn (orderId=$orderId, item=$orderItemId, qty=$rmaQty, type=$resolutionType)',
    );

    final input = <String, dynamic>{
      'orderId': orderId,
      'orderItemId': orderItemId,
      'rmaQty': rmaQty,
      'resolutionType': resolutionType,
      'rmaReasonId': rmaReasonId,
      'agreement': true,
    };
    if (information != null && information.isNotEmpty) {
      input['information'] = information;
    }
    if (packageCondition != null && packageCondition.isNotEmpty) {
      input['packageCondition'] = packageCondition;
    }

    final result = await client.mutate(
      MutationOptions(
        document: gql(ReturnsQueries.createCustomerReturn),
        variables: {'input': input},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.createReturn — error: $message');
      throw AccountException(message);
    }

    final data = result.data?['createCustomerReturn']?['customerReturn'];
    if (data == null) {
      throw const AccountException('Failed to create return request');
    }

    debugPrint('↩️ AccountRepo.createReturn — success');
    return CustomerReturn.fromJson(data as Map<String, dynamic>);
  }

  /// Cancel / close / reopen share the same IRI-id mutation shape.
  Future<CustomerReturn> _mutateReturn({
    required String document,
    required String rootField,
    required int returnId,
    required String action,
  }) async {
    debugPrint('↩️ AccountRepo.$action (id=$returnId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(document),
        variables: {'id': '/api/shop/returns/$returnId'},
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.$action — error: $message');
      throw AccountException(message);
    }

    final data = result.data?[rootField]?['customerReturn'];
    if (data == null) {
      throw AccountException('Failed to $action return');
    }

    debugPrint('↩️ AccountRepo.$action — success');
    return CustomerReturn.fromJson(data as Map<String, dynamic>);
  }

  /// Cancel the customer's own return request.
  Future<CustomerReturn> cancelReturn(int returnId) => _mutateReturn(
    document: ReturnsQueries.cancelCustomerReturn,
    rootField: 'cancelCustomerReturn',
    returnId: returnId,
    action: 'cancelReturn',
  );

  /// Mark a return as solved (requires `canClose`).
  Future<CustomerReturn> closeReturn(int returnId) => _mutateReturn(
    document: ReturnsQueries.closeCustomerReturn,
    rootField: 'closeCustomerReturn',
    returnId: returnId,
    action: 'closeReturn',
  );

  /// Reopen a canceled/declined return (requires `canReopen`).
  Future<CustomerReturn> reopenReturn(int returnId) => _mutateReturn(
    document: ReturnsQueries.reopenCustomerReturn,
    rootField: 'reopenCustomerReturn',
    returnId: returnId,
    action: 'reopenReturn',
  );

  /// Add a customer message to the return conversation thread.
  Future<ReturnMessage> sendReturnMessage({
    required int returnId,
    required String message,
  }) async {
    debugPrint('↩️ AccountRepo.sendReturnMessage (returnId=$returnId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(ReturnsQueries.createCustomerReturnMessage),
        variables: {'returnId': returnId, 'message': message},
      ),
    );

    if (result.hasException) {
      final errorMessage = _extractErrorMessage(result.exception!);
      debugPrint('↩️ AccountRepo.sendReturnMessage — error: $errorMessage');
      throw AccountException(errorMessage);
    }

    final data =
        result.data?['createCustomerReturnMessage']?['customerReturnMessage'];
    if (data == null) {
      throw const AccountException('Failed to send message');
    }

    debugPrint('↩️ AccountRepo.sendReturnMessage — success');
    return ReturnMessage.fromJson(data as Map<String, dynamic>);
  }
}

/// Account-specific exception
class AccountException implements Exception {
  final String message;
  const AccountException(this.message);

  @override
  String toString() => 'AccountException: $message';
}
