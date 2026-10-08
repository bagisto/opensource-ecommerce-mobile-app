import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/graphql/queries.dart';
import '../../../product/domain/models/customizable_file_selection.dart';

import '../models/cart_model.dart';

class AddToCartRequest {
  final String mutation;
  final Map<String, dynamic> variables;

  const AddToCartRequest({required this.mutation, required this.variables});
}

/// Repository for all cart operations via Bagisto GraphQL API.
///
/// TOKEN MANAGEMENT (matching Next.js reference):
///
///  • **Guest user**: Uses a `sessionToken` (UUID) from `createCartToken`.
///    Sent as `Authorization: Bearer <sessionToken>`.
///
///  • **Logged-in user**: Uses the Sanctum `accessToken` from login.
///    Sent as `Authorization: Bearer <accessToken>`.
///
///  • On **login**: Call `mergeCart(cartId)` to merge the guest cart into the
///    user's cart, then switch the Bearer token to the access token.
///
///  • On **logout**: Clear the auth token, create a fresh guest cart session.
class CartRepository {
  final GraphQLClient client;

  /// The Bearer token used for Authorization header.
  /// Guest → sessionToken UUID, Logged-in → Sanctum access token.
  String? _token;

  /// Whether the current token is a guest session token.
  bool _isGuest = true;

  CartRepository({required this.client, String? initialToken}) {
    _token = initialToken;
  }

  /// Set the Bearer token for all subsequent cart API calls.
  void updateToken(String? token, {bool isGuest = true}) {
    _token = token;
    _isGuest = isGuest;
    debugPrint('[CartRepo] token updated (isGuest=$isGuest)');
  }

  /// Whether the current session is a guest.
  bool get isGuest => _isGuest;

  /// The current token value (for reading from the bloc).
  String? get currentToken => _token;

  GraphQLClient get _authedClient =>
      GraphQLClientProvider.buildClient(token: _token);

  /// Whether a guest may check out these products: false when any of them
  /// has guest checkout turned off in admin.
  Future<bool> guestCheckoutAllowed(Iterable<int> productIds) async {
    final results = await Future.wait(
      productIds.toSet().map(
        (id) => client.query(
          QueryOptions(
            document: gql(CartQueries.productGuestCheckout),
            variables: {'id': '/api/shop/products/$id'},
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        ),
      ),
    );
    for (final result in results) {
      if (result.hasException) throw result.exception!;
      if (!allowsGuestCheckout(result.data?['product']?['guestCheckout'])) {
        return false;
      }
    }
    return true;
  }

  /// `guestCheckout` from the API: only an explicit off value (`0`) blocks;
  /// an empty value means the attribute is not set on the product.
  @visibleForTesting
  static bool allowsGuestCheckout(dynamic value) {
    if (value == null || value == true) return true;
    if (value == false) return false;
    final text = value.toString().trim();
    return text.isEmpty || text != '0';
  }

  /// Create a guest cart token
  Future<CartTokenResponse> createCartToken() async {
    debugPrint('[CartRepo] creating cart token...');
    final result = await client.mutate(
      MutationOptions(
        document: gql(CartMutations.createCartToken),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] createCartToken error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createCartToken']?['cartToken'];
    if (data == null) {
      throw Exception('Failed to create cart token');
    }

    final response = CartTokenResponse.fromJson(data as Map<String, dynamic>);
    debugPrint('[CartRepo] cart token created');
    return response;
  }

  /// Add product to cart
  Future<CartModel> addToCart({
    int? cartId,
    required int productId,
    required int quantity,
    List<String>? downloadableLinks,
    List<Map<String, int>>? groupedItems,
    List<Map<String, dynamic>>? bundleOptions,
    Map<String, dynamic>? bookingData,
    int? selectedConfigurableOption,
    List<Map<String, dynamic>>? superAttribute,
    Map<String, dynamic>? customizableOptions,
  }) async {
    debugPrint(
      '[CartRepo] addToCart: productId=$productId, qty=$quantity, '
      'links=$downloadableLinks, groupedItems=$groupedItems, bundleOptions=$bundleOptions, '
      'bookingData=$bookingData, configurableOption=$selectedConfigurableOption, '
      'superAttribute=$superAttribute, customizableOptions=$customizableOptions',
    );

    final request = buildAddToCartRequest(
      cartId: cartId,
      productId: productId,
      quantity: quantity,
      downloadableLinks: downloadableLinks,
      groupedItems: groupedItems,
      bundleOptions: bundleOptions,
      bookingData: bookingData,
      selectedConfigurableOption: selectedConfigurableOption,
      superAttribute: superAttribute,
      customizableOptions: customizableOptions,
    );

    debugPrint('[CartRepo] addToCart mutation: ${request.mutation}');
    debugPrint('[CartRepo] addToCart variables: ${request.variables}');

    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(request.mutation),
        variables: request.variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] addToCart error: ${result.exception}');
      if (result.exception?.graphqlErrors.isNotEmpty == true) {
        for (final error in result.exception!.graphqlErrors) {
          debugPrint('[CartRepo] GraphQL error: ${error.message}');
        }
      }
      if (result.exception?.linkException != null) {
        debugPrint('[CartRepo] Link error: ${result.exception!.linkException}');
      }
      debugPrint('[CartRepo] addToCart raw data on error: ${result.data}');
      throw result.exception!;
    }

    final data = result.data?['createAddProductInCart']?['addProductInCart'];
    debugPrint('[CartRepo] addToCart response: $data');
    return parseAddToCartPayload(data as Map<String, dynamic>?);
  }

  /// Reads the `addProductInCart` payload. The API can answer
  /// `success: false` with a reason (e.g. requested booking quantity not
  /// available) instead of a GraphQL error; that is thrown as an error
  /// carrying the server message.
  @visibleForTesting
  static CartModel parseAddToCartPayload(Map<String, dynamic>? data) {
    if (data == null) {
      throw Exception('Failed to add product to cart');
    }
    if (data['success'] == false) {
      final message = data['message']?.toString().trim() ?? '';
      throw Exception(
        message.isNotEmpty ? message : 'Failed to add product to cart',
      );
    }
    return CartModel.fromJson(data);
  }

  static AddToCartRequest buildAddToCartRequest({
    int? cartId,
    required int productId,
    required int quantity,
    List<String>? downloadableLinks,
    List<Map<String, int>>? groupedItems,
    List<Map<String, dynamic>>? bundleOptions,
    Map<String, dynamic>? bookingData,
    int? selectedConfigurableOption,
    List<Map<String, dynamic>>? superAttribute,
    Map<String, dynamic>? customizableOptions,
  }) {
    final Map<String, dynamic> variables = {
      'productId': productId,
      'quantity': quantity,
    };

    String mutation;

    if (selectedConfigurableOption != null) {
      mutation = CartMutations.addConfigurableProductToCart;
      variables['selectedConfigurableOption'] = selectedConfigurableOption;
      if (superAttribute != null && superAttribute.isNotEmpty) {
        variables['superAttribute'] = superAttribute;
      }
    } else if (bookingData != null && bookingData.isNotEmpty) {
      mutation = CartMutations.addBookingProductToCart;
      final bookingPayload = _buildBookingPayload(bookingData);
      variables['booking'] = jsonEncode(bookingPayload['booking']);
      final specialNote = bookingPayload['specialNote']?.toString().trim();
      if (specialNote != null && specialNote.isNotEmpty) {
        variables['specialNote'] = specialNote;
      }
    } else if (bundleOptions != null && bundleOptions.isNotEmpty) {
      mutation = CartMutations.addBundleProductToCart;
      final bundlePayload = _buildBundlePayload(bundleOptions);
      variables['bundleOptions'] = jsonEncode(bundlePayload['options']);
      variables['bundleOptionQty'] = jsonEncode(bundlePayload['qty']);
    } else if (groupedItems != null && groupedItems.isNotEmpty) {
      mutation = CartMutations.addGroupedProductToCart;
      variables['groupedQty'] = jsonEncode(
        _buildGroupedQtyPayload(groupedItems),
      );
    } else if (downloadableLinks != null && downloadableLinks.isNotEmpty) {
      mutation = CartMutations.addDownloadableProductToCart;
      variables['links'] = downloadableLinks
          .map((id) => int.tryParse(id))
          .whereType<int>()
          .toList();
    } else {
      mutation = CartMutations.addSimpleProductToCart;
    }

    if (cartId != null) {
      variables['cartId'] = cartId;
    }

    if (customizableOptions != null && customizableOptions.isNotEmpty) {
      variables['customizableOptions'] = serializeCustomizableOptionsForGraphQl(
        customizableOptions,
      );
    }

    return AddToCartRequest(mutation: mutation, variables: variables);
  }

  static Map<String, dynamic> serializeCustomizableOptionsForGraphQl(
    Map<String, dynamic> customizableOptions,
  ) {
    return customizableOptions.map(
      (key, value) => MapEntry(key, _serializeCustomizableOptionValue(value)),
    );
  }

  static dynamic _serializeCustomizableOptionValue(dynamic value) {
    if (value is CustomizableFileSelection) return value.name;
    if (value is List) {
      return value.map(_serializeCustomizableOptionValue).toList();
    }
    if (value is Map) {
      return value.map(
        (key, itemValue) => MapEntry(
          key.toString(),
          _serializeCustomizableOptionValue(itemValue),
        ),
      );
    }
    return value;
  }

  static Map<String, Map<String, dynamic>> _buildBundlePayload(
    List<Map<String, dynamic>> bundleOptions,
  ) {
    final Map<String, List<int>> options = {};
    final Map<String, int> qty = {};

    for (final option in bundleOptions) {
      final optionId = int.tryParse('${option['bundleOptionId']}') ?? 0;
      if (optionId <= 0) continue;

      final optionKey = optionId.toString();
      final selectedIds =
          (option['bundleOptionProductId'] as List<dynamic>? ??
                  const <dynamic>[])
              .map((id) => int.tryParse('$id') ?? 0)
              .where((id) => id > 0)
              .toList();

      if (selectedIds.isEmpty) continue;

      final existing = options[optionKey] ?? <int>[];
      for (final id in selectedIds) {
        if (!existing.contains(id)) {
          existing.add(id);
        }
      }
      options[optionKey] = existing;

      final selectedQty = int.tryParse('${option['qty']}') ?? 1;
      qty[optionKey] = selectedQty > 0 ? selectedQty : 1;
    }

    return {'options': options, 'qty': qty};
  }

  static Map<String, dynamic> _buildBookingPayload(
    Map<String, dynamic> bookingData,
  ) {
    final type = bookingData['type']?.toString().toLowerCase().trim() ?? '';
    final Map<String, dynamic> booking = {'type': type};

    switch (type) {
      case 'event':
        booking['qty'] = Map<String, dynamic>.from(
          bookingData['qty'] as Map? ?? const {},
        );
        break;
      case 'rental':
        booking['renting_type'] =
            bookingData['renting_type']?.toString().toLowerCase().trim() ??
            'daily';
        if ((booking['renting_type'] as String) == 'daily') {
          booking['date_from'] = bookingData['date_from'];
          booking['date_to'] = bookingData['date_to'];
        } else {
          booking['date'] = bookingData['date'];
          booking['slot'] = bookingData['slot'];
        }
        break;
      case 'default':
      case 'appointment':
      case 'table':
        booking['date'] = bookingData['date'];
        booking['slot'] = bookingData['slot'];
        break;
    }

    return {'booking': booking, 'specialNote': bookingData['specialNote']};
  }

  static Map<String, int> _buildGroupedQtyPayload(
    List<Map<String, int>> groupedItems,
  ) {
    final Map<String, int> groupedQty = {};

    for (final item in groupedItems) {
      final productId = item['productId'] ?? 0;
      final quantity = item['quantity'] ?? 0;
      if (productId <= 0 || quantity <= 0) continue;

      groupedQty[productId.toString()] = quantity;
    }

    return groupedQty;
  }

  /// Read / fetch the current cart.
  /// Retries once on timeout (cold-start scenario).
  Future<CartModel> getCart({int attempt = 1}) async {
    debugPrint('[CartRepo] getCart... (attempt $attempt)');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CartMutations.getCart),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      if (ErrorMapper.isNetworkError(result.exception!) && attempt < 3) {
        debugPrint(
          '[CartRepo] getCart timeout — retrying (attempt ${attempt + 1})...',
        );
        await Future.delayed(Duration(milliseconds: 500 * attempt));
        return getCart(attempt: attempt + 1);
      }
      debugPrint('[CartRepo] getCart error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createReadCart']?['readCart'];
    if (data == null) {
      debugPrint('[CartRepo] getCart: empty cart');
      return CartModel.empty;
    }

    final cart = CartModel.fromJson(data as Map<String, dynamic>);
    debugPrint(
      '[CartRepo] getCart: ${cart.itemsQty} items, total=${cart.grandTotal}',
    );
    return cart;
  }

  /// Update cart item quantity
  Future<CartModel> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    debugPrint('[CartRepo] updateCartItem: itemId=$cartItemId, qty=$quantity');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CartMutations.updateCartItem),
        variables: {'cartItemId': cartItemId, 'quantity': quantity},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] updateCartItem error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createUpdateCartItem']?['updateCartItem'];
    if (data == null) {
      throw Exception('Failed to update cart item');
    }

    return CartModel.fromJson(data as Map<String, dynamic>);
  }

  /// Remove item from cart
  Future<CartModel> removeCartItem({required int cartItemId}) async {
    debugPrint('[CartRepo] removeCartItem: itemId=$cartItemId');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CartMutations.removeCartItem),
        variables: {'cartItemId': cartItemId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] removeCartItem error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createRemoveCartItem']?['removeCartItem'];
    if (data == null) {
      return CartModel.empty;
    }

    return CartModel.fromJson(data as Map<String, dynamic>);
  }

  /// Apply coupon code to cart
  Future<CartModel> applyCoupon({required String couponCode}) async {
    debugPrint('[CartRepo] applyCoupon: $couponCode');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CartMutations.applyCoupon),
        variables: {'couponCode': couponCode},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] applyCoupon error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createApplyCoupon']?['applyCoupon'];
    if (data == null) {
      throw Exception('Failed to apply coupon');
    }

    debugPrint(
      '[CartRepo] applyCoupon result: couponCode=${data['couponCode']}, discount=${data['discountAmount']}',
    );
    return CartModel.fromJson(data as Map<String, dynamic>);
  }

  /// Remove applied coupon from cart
  Future<CartModel> removeCoupon() async {
    debugPrint('[CartRepo] removeCoupon');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CartMutations.removeCoupon),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] removeCoupon error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createRemoveCoupon']?['removeCoupon'];
    if (data == null) {
      throw Exception('Failed to remove coupon');
    }

    return CartModel.fromJson(data as Map<String, dynamic>);
  }

  /// Merge a guest cart into the logged-in user's cart.
  /// Must be called AFTER switching the token to the auth access token.
  /// Source: nextjs-commerce/src/graphql/cart/mutations/CreateMergeCart.ts
  Future<CartModel> mergeCart({required int cartId}) async {
    debugPrint('[CartRepo] mergeCart: cartId=$cartId');
    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CartMutations.mergeCart),
        variables: {'cartId': cartId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] mergeCart error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createMergeCart']?['mergeCart'];
    if (data == null) {
      throw Exception('Failed to merge cart');
    }

    debugPrint('[CartRepo] mergeCart success: ${data['message']}');
    return CartModel.fromJson(data as Map<String, dynamic>);
  }
}
