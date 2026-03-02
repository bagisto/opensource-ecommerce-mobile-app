import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/queries.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/cart_model.dart';

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
    final prefix = token != null && token.length > 8
        ? token.substring(0, 8)
        : token;
    debugPrint('[CartRepo] token updated: $token (isGuest=$isGuest)');
  }

  /// Whether the current session is a guest.
  bool get isGuest => _isGuest;

  /// The current token value (for reading from the bloc).
  String? get currentToken => _token;

  GraphQLClient get _authedClient {
    if (_token == null || _token!.isEmpty) return client;
    final httpLink = HttpLink(
      bagistoEndpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'X-STOREFRONT-KEY': storefrontKey,
      },
    );
    final authLink = AuthLink(getToken: () async => 'Bearer $_token');
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
    debugPrint('[CartRepo] cart token created: ${response.cartToken}');
    return response;
  }

  /// Add product to cart
  Future<CartModel> addToCart({
    int? cartId,
    required int productId,
    required int quantity,
  }) async {
    debugPrint('[CartRepo] addToCart: productId=$productId, qty=$quantity');
    final Map<String, dynamic> variables = {
      'productId': productId,
      'quantity': quantity,
    };
    if (cartId != null) {
      variables['cartId'] = cartId;
    }

    final result = await _authedClient.mutate(
      MutationOptions(
        document: gql(CartMutations.addProductToCart),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      debugPrint('[CartRepo] addToCart error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data?['createAddProductInCart']?['addProductInCart'];
    if (data == null) {
      throw Exception('Failed to add product to cart');
    }

    debugPrint('[CartRepo] addToCart success: ${data['message']}');
    return CartModel.fromJson(data as Map<String, dynamic>);
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
      final isTimeout =
          result.exception.toString().contains('TimeoutException') ||
          result.exception.toString().contains('No stream event');
      if (isTimeout && attempt < 3) {
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
