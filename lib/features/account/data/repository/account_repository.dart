import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/account_queries.dart';
import '../models/account_models.dart';

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
  Future<({List<ProductReview> reviews, int totalCount})> getProductReviews({
    int first = 10,
    int? status,
  }) async {
    debugPrint('⭐ AccountRepo.getProductReviews');

    final result = await client.query(
      QueryOptions(
        document: gql(AccountQueries.getProductReviews),
        variables: <String, dynamic>{
          'first': first,
          // ignore: use_null_aware_elements
          if (status case final s?) 'status': s,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('⭐ AccountRepo.getProductReviews — error: $message');
      throw AccountException(message);
    }

    final reviewsData = result.data?['customerReviews'];
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
    // required String firstName,
    // required String lastName,
    // required String address,
    // required String city,
    // required String state,
    // required String country,
    // required String postcode,
    // required String phone,
    // String? email,
    bool useForShipping = true,
  }) async {
    debugPrint('📍 AccountRepo.setDefaultAddress (addressId=$addressId)');

    final input = <String, dynamic>{
      'addressId': addressId,
      // 'firstName': firstName,
      // 'lastName': lastName,
      // 'address1': address,
      // 'city': city,
      // 'state': state,
      // 'country': country,
      // 'postcode': postcode,
      // 'phone': phone,
      'defaultAddress': true,
      'useForShipping': useForShipping,
    };
    // if (email != null && email.isNotEmpty) {
    //   input['email'] = email;
    // }

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

    final data = result.data?['createAddUpdateCustomerAddress']?['addUpdateCustomerAddress'];
    if (data == null) {
      throw AccountException('Failed to set default address');
    }

    debugPrint('📍 AccountRepo.setDefaultAddress — success');
    return CustomerAddress.fromJson(data as Map<String, dynamic>);
  }

  /// Delete a customer address
  /// Uses createDeleteCustomerAddress mutation with input type createDeleteCustomerAddressInput.
  Future<void> deleteAddress({required String addressId}) async {
    debugPrint('🗑️ AccountRepo.deleteAddress (id=$addressId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.deleteCustomerAddress),
        variables: {
          'input': {'id': addressId},
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
  ///   country, state, city, postcode, defaultAddress, useForShipping
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
    bool useForShipping = false,
  }) async {
    debugPrint('📍 AccountRepo.createAddress');

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
      'useForShipping': useForShipping,
    };
    if (email != null && email.isNotEmpty) {
      input['email'] = email;
    }
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
    bool useForShipping = false,
  }) async {
    debugPrint('📍 AccountRepo.updateAddress (addressId=$addressId)');

    final input = <String, dynamic>{
      'addressId': addressId,
      'firstName': firstName,
      'lastName': lastName,
      'address1': address,
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'phone': phone,
      'defaultAddress': defaultAddress,
      'useForShipping': useForShipping,
    };
    if (email != null && email.isNotEmpty) {
      input['email'] = email;
    }

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
  /// Returns the created ProductReview.
  Future<ProductReview> createProductReview({
    required int productId,
    required String title,
    required String comment,
    required int rating,
    required String name,
  }) async {
    debugPrint('📝 AccountRepo.createProductReview (product=$productId)');

    final result = await client.mutate(
      MutationOptions(
        document: gql(AccountQueries.createProductReview),
        variables: {
          'input': {
            'productId': productId,
            'title': title,
            'comment': comment,
            'rating': rating,
            'name': name,
          },
        },
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
        variables: {'id': shipmentId},
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
    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.first.message;
    }
    if (exception.linkException != null) {
      final linkEx = exception.linkException;
      debugPrint('🔗 AccountRepo — linkException: ${linkEx.toString()}');
      return 'Network error: ${linkEx.toString()}';
    }
    return 'Something went wrong. Please try again.';
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
      debugPrint('📥 AccountRepo.getCustomerDownloadableProducts — error: $message');
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
        .map((e) => DownloadableProduct.fromJson(e['node'] as Map<String, dynamic>))
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
}

/// Account-specific exception
class AccountException implements Exception {
  final String message;
  const AccountException(this.message);

  @override
  String toString() => 'AccountException: $message';
}
