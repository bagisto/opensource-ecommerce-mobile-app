import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../data/models/cart_model.dart';
import '../../data/repository/cart_repository.dart';

// ─── Events ────────────────────────────────────────────────────────────────

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

/// Load cart from API (if token exists)
class LoadCart extends CartEvent {}

/// Add a product to cart
class AddToCart extends CartEvent {
  final int productId;
  final int quantity;
  const AddToCart({required this.productId, this.quantity = 1});
  @override
  List<Object?> get props => [productId, quantity];
}

/// Update an item's quantity
class UpdateCartItemQuantity extends CartEvent {
  final int cartItemId;
  final int quantity;
  const UpdateCartItemQuantity({
    required this.cartItemId,
    required this.quantity,
  });
  @override
  List<Object?> get props => [cartItemId, quantity];
}

/// Remove an item from cart
class RemoveFromCart extends CartEvent {
  final int cartItemId;
  const RemoveFromCart({required this.cartItemId});
  @override
  List<Object?> get props => [cartItemId];
}

/// Clear the entire cart (remove all items)
class ClearCart extends CartEvent {}

/// Apply a coupon code
class ApplyCoupon extends CartEvent {
  final String couponCode;
  const ApplyCoupon({required this.couponCode});
  @override
  List<Object?> get props => [couponCode];
}

/// Remove applied coupon
class RemoveCoupon extends CartEvent {}

/// Clear the "just added" success message
class ClearCartMessage extends CartEvent {}

/// Fired when user successfully logs in.
/// Switches the cart token from guest session UUID to the auth access token
/// and optionally merges the guest cart into the user's cart.
class OnUserLoggedIn extends CartEvent {
  final String authToken;
  const OnUserLoggedIn({required this.authToken});
  @override
  List<Object?> get props => [authToken];
}

/// Fired when user logs out.
/// Clears the current cart, resets to guest mode, creates a fresh guest cart.
class OnUserLoggedOut extends CartEvent {
  const OnUserLoggedOut();
}

// ─── State ─────────────────────────────────────────────────────────────────

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  final CartStatus status;
  final CartModel cart;

  /// The Bearer token currently in use.
  /// Guest → sessionToken UUID, logged-in → Sanctum access token.
  final String? cartToken;

  /// Whether the current cart session is a guest session.
  final bool isGuest;

  /// The numeric cart ID (used for mergeCart on login).
  final int? cartId;

  final String? errorMessage;
  final String? successMessage;
  final bool isAddingToCart;
  final int? updatingItemId;
  final bool isApplyingCoupon;

  const CartState({
    this.status = CartStatus.initial,
    this.cart = CartModel.empty,
    this.cartToken,
    this.isGuest = true,
    this.cartId,
    this.errorMessage,
    this.successMessage,
    this.isAddingToCart = false,
    this.updatingItemId,
    this.isApplyingCoupon = false,
  });

  int get itemCount => cart.itemsQty;

  CartState copyWith({
    CartStatus? status,
    CartModel? cart,
    String? cartToken,
    bool? isGuest,
    int? cartId,
    String? errorMessage,
    String? successMessage,
    bool? isAddingToCart,
    int? updatingItemId,
    bool? isApplyingCoupon,
    bool clearMessage = false,
    bool clearUpdatingItem = false,
    bool clearError = false,
    bool clearCartId = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      cartToken: cartToken ?? this.cartToken,
      isGuest: isGuest ?? this.isGuest,
      cartId: clearCartId ? null : (cartId ?? this.cartId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessage
          ? null
          : (successMessage ?? this.successMessage),
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      updatingItemId: clearUpdatingItem
          ? null
          : (updatingItemId ?? this.updatingItemId),
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cart,
    cartToken,
    isGuest,
    cartId,
    errorMessage,
    successMessage,
    isAddingToCart,
    updatingItemId,
    isApplyingCoupon,
  ];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  /// SharedPreferences keys
  static const _guestCartTokenKey = 'bagisto_guest_cart_token';
  static const _guestCartIdKey = 'bagisto_guest_cart_id';

  /// Guard flag: when true, _onLoadCart will skip because
  /// _onUserLoggedIn is actively handling the cart.
  bool _loginInProgress = false;

  CartBloc({required this.repository}) : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
    on<ClearCartMessage>(_onClearCartMessage);
    on<OnUserLoggedIn>(_onUserLoggedIn);
    on<OnUserLoggedOut>(_onUserLoggedOut);
  }

  // ─── Token persistence helpers ───────────────────────────────────────

  Future<void> _saveGuestSession(String token, int? cartId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_guestCartTokenKey, token);
      if (cartId != null) {
        await prefs.setInt(_guestCartIdKey, cartId);
      }
      debugPrint(
        '[CartBloc] saved guest session: ${token.length > 8 ? token.substring(0, 8) : token}…, cartId=$cartId',
      );
    } catch (e) {
      debugPrint('[CartBloc] Failed to save guest session: $e');
    }
  }

  Future<({String? token, int? cartId})> _loadGuestSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_guestCartTokenKey);
      final cartId = prefs.getInt(_guestCartIdKey);
      final prefix = token != null && token.length > 8
          ? token.substring(0, 8)
          : token;
      debugPrint('[CartBloc] loaded guest session: $prefix…, cartId=$cartId');
      return (token: token, cartId: cartId);
    } catch (e) {
      debugPrint('[CartBloc] Failed to load guest session: $e');
      return (token: null, cartId: null);
    }
  }

  Future<void> _clearGuestSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_guestCartTokenKey);
      await prefs.remove(_guestCartIdKey);
      debugPrint('[CartBloc] cleared guest session');
    } catch (e) {
      debugPrint('[CartBloc] Failed to clear guest session: $e');
    }
  }

  // ─── Token resolution ───────────────────────────────────────────────

  /// Ensure we have a valid token. For guests, creates a cart token if needed.
  /// For logged-in users, the auth token should already be set via OnUserLoggedIn.
  ///
  /// Returns null only if no token could be obtained.
  Future<String?> _ensureToken(Emitter<CartState> emit) async {
    // Already have a token in state (auth or guest)
    if (state.cartToken != null && state.cartToken!.isNotEmpty) {
      // If we have an auth token, make sure the repo is updated
      if (!state.isGuest) {
        repository.updateToken(state.cartToken, isGuest: false);
      }
      return state.cartToken!;
    }

    // CRITICAL: Check if user is already authenticated in AuthStorage
    // This prevents creating a guest session when user is logged in
    final isUserLoggedIn = await AuthStorage.isLoggedIn();
    if (isUserLoggedIn) {
      debugPrint('[CartBloc] _ensureToken: user is logged in, not creating guest session');
      return null;
    }

    // If user is authenticated but has no token in state, something is wrong
    // Don't load guest session - let the caller handle this
    if (!state.isGuest) {
      debugPrint('[CartBloc] _ensureToken: authenticated but no token in state');
      return null;
    }

    // Try loading saved guest session
    final saved = await _loadGuestSession();
    if (saved.token != null && saved.token!.isNotEmpty) {
      repository.updateToken(saved.token, isGuest: true);
      emit(
        state.copyWith(
          cartToken: saved.token,
          cartId: saved.cartId,
          isGuest: true,
        ),
      );
      return saved.token!;
    }

    // Create a new guest cart token
    try {
      final response = await repository.createCartToken();
      final token = response.sessionToken ?? response.cartToken;
      final cartId = response.id;

      await _saveGuestSession(token, cartId);
      repository.updateToken(token, isGuest: true);
      emit(state.copyWith(cartToken: token, cartId: cartId, isGuest: true));
      return token;
    } catch (e) {
      debugPrint('[CartBloc] _ensureToken: failed to create guest token: $e');
      return null;
    }
  }

  /// Sync repo token from current state.
  void _syncRepoToken() {
    repository.updateToken(state.cartToken, isGuest: state.isGuest);
  }

  // ─── Event handlers ──────────────────────────────────────────────────

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    // If OnUserLoggedIn is in progress, skip — it will load the cart itself.
    if (_loginInProgress) {
      debugPrint('[CartBloc] LoadCart: login in progress, skipping');
      return;
    }

    // CRITICAL: Check if user is already authenticated in AuthStorage
    // This prevents creating a guest session when user is logged in
    final isUserLoggedIn = await AuthStorage.isLoggedIn();
    if (isUserLoggedIn) {
      debugPrint('[CartBloc] LoadCart: user is logged in, loading with auth token');
      
      // Get the auth token and load cart with it
      final authToken = await AuthStorage.getToken();
      if (authToken != null && authToken.isNotEmpty) {
        // Set the guard flag
        _loginInProgress = true;
        
        // Switch token to auth access token
        repository.updateToken(authToken, isGuest: false);
        emit(state.copyWith(
          cartToken: authToken,
          isGuest: false,
          status: CartStatus.loading,
        ));

        // Load the user's cart
        try {
          _syncRepoToken();
          final cart = await repository.getCart();
          emit(state.copyWith(
            status: CartStatus.loaded,
            cart: cart,
            cartId: cart.id > 0 ? cart.id : null,
            clearError: true,
          ));
        } catch (e) {
          debugPrint('[CartBloc] LoadCart error (logged in user): $e');
          emit(state.copyWith(status: CartStatus.loaded, cart: CartModel.empty));
        } finally {
          _loginInProgress = false;
        }
        return;
      }
    }

    // If user is authenticated but has no token, don't fall back to guest
    // This prevents the guest session from being loaded when user is logged in
    if (!state.isGuest && (state.cartToken == null || state.cartToken!.isEmpty)) {
      debugPrint('[CartBloc] LoadCart: authenticated user but no token, waiting for login to complete');
      return;
    }

    emit(state.copyWith(status: CartStatus.loading));
    try {
      final token = await _ensureToken(emit);
      if (token == null) {
        // No token available — emit loaded with empty cart
        debugPrint('[CartBloc] LoadCart: no token, emitting empty');
        emit(
          state.copyWith(
            status: CartStatus.loaded,
            cart: CartModel.empty,
            clearError: true,
          ),
        );
        return;
      }

      _syncRepoToken();
      final cart = await repository.getCart();

      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          cartId: cart.id > 0 ? cart.id : state.cartId,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] LoadCart error: $e');

      // If guest cart is stale ("Cart not found"), clear and create a fresh one
      if (state.isGuest && e.toString().contains('Cart not found')) {
        debugPrint('[CartBloc] Stale guest cart — creating fresh session');
        await _clearGuestSession();
        try {
          repository.updateToken(null, isGuest: true);
          final response = await repository.createCartToken();
          final newToken = response.sessionToken ?? response.cartToken;
          final newCartId = response.id;
          await _saveGuestSession(newToken, newCartId);
          repository.updateToken(newToken, isGuest: true);
          emit(
            CartState(
              status: CartStatus.loaded,
              cartToken: newToken,
              cartId: newCartId,
              isGuest: true,
              cart: CartModel.empty,
            ),
          );
          return;
        } catch (e2) {
          debugPrint('[CartBloc] Failed to create fresh guest session: $e2');
        }
      }

      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: CartModel.empty,
          clearError: true,
        ),
      );
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(isAddingToCart: true, clearMessage: true));
    try {
      final token = await _ensureToken(emit);
      if (token == null) {
        emit(
          state.copyWith(
            isAddingToCart: false,
            errorMessage: 'Please wait, loading session...',
          ),
        );
        return;
      }
      _syncRepoToken();

      final cart = await repository.addToCart(
        productId: event.productId,
        quantity: event.quantity,
      );

      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          cartId: cart.id > 0 ? cart.id : state.cartId,
          isAddingToCart: false,
          successMessage: 'Product added to cart successfully',
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] AddToCart error: $e');
      final errorMsg = _extractErrorMessage(e);
      emit(
        state.copyWith(
          isAddingToCart: false,
          errorMessage: errorMsg,
        ),
      );
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(updatingItemId: event.cartItemId));
    try {
      _syncRepoToken();
      final cart = await repository.updateCartItem(
        cartItemId: event.cartItemId,
        quantity: event.quantity,
      );
      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          clearUpdatingItem: true,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] UpdateCartItem error: $e');
      emit(
        state.copyWith(
          clearUpdatingItem: true,
          errorMessage: 'Failed to update quantity',
        ),
      );
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(updatingItemId: event.cartItemId));
    try {
      _syncRepoToken();
      final cart = await repository.removeCartItem(
        cartItemId: event.cartItemId,
      );

      // If cart is now empty and we're a guest, reset the guest session
      if (cart.itemsQty == 0 && state.isGuest) {
        await _clearGuestSession();
        emit(
          const CartState(
            status: CartStatus.loaded,
            isGuest: true,
            cart: CartModel.empty,
            successMessage: 'Item removed from cart',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          clearUpdatingItem: true,
          successMessage: 'Item removed from cart',
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] RemoveFromCart error: $e');
      emit(
        state.copyWith(
          clearUpdatingItem: true,
          errorMessage: 'Failed to remove item',
        ),
      );
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final items = List<CartItemModel>.from(state.cart.items);
    for (final item in items) {
      try {
        _syncRepoToken();
        await repository.removeCartItem(cartItemId: item.id);
      } catch (_) {}
    }

    await _clearGuestSession();
    emit(
      const CartState(
        status: CartStatus.loaded,
        successMessage: 'Cart cleared successfully',
      ),
    );
  }

  /// CRITICAL: Called when user logs in.
  ///
  /// Flow (matching Next.js reference — useMergeCart + useGuestCartToken):
  ///  1. Take the guest cart ID (if any)
  ///  2. Switch the Bearer token to the auth access token
  ///  3. Call mergeCart(cartId) to merge the guest cart into user's cart
  ///  4. Load the merged cart
  ///  5. Clear the saved guest session
  Future<void> _onUserLoggedIn(
    OnUserLoggedIn event,
    Emitter<CartState> emit,
  ) async {
    debugPrint('[CartBloc] OnUserLoggedIn — switching to auth token');

    // Set the guard flag so any queued LoadCart events skip
    _loginInProgress = true;

    final guestCartId = state.cartId ?? state.cart.id;
    final hadGuestItems = state.cart.itemsQty > 0;

    // Switch token to auth access token
    repository.updateToken(event.authToken, isGuest: false);
    emit(
      state.copyWith(
        cartToken: event.authToken,
        isGuest: false,
        status: CartStatus.loading,
      ),
    );

    // Merge guest cart if it had items
    if (hadGuestItems && guestCartId > 0) {
      try {
        debugPrint(
          '[CartBloc] Merging guest cart (id=$guestCartId) into user cart',
        );
        final mergedCart = await repository.mergeCart(cartId: guestCartId);
        debugPrint(
          '[CartBloc] mergeCart success: ${mergedCart.itemsQty} items',
        );
        emit(
          state.copyWith(
            cart: mergedCart,
            cartId: mergedCart.id > 0 ? mergedCart.id : null,
            status: CartStatus.loaded,
            clearError: true,
          ),
        );
      } catch (e) {
        debugPrint(
          '[CartBloc] mergeCart failed (loading user cart instead): $e',
        );
      }
    }

    // Clear guest session from disk
    await _clearGuestSession();

    // Load the user's cart (covers both merge success and failure)
    try {
      _syncRepoToken();
      final cart = await repository.getCart();
      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          cartId: cart.id > 0 ? cart.id : null,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] LoadCart after login error: $e');
      emit(state.copyWith(status: CartStatus.loaded, cart: CartModel.empty));
    } finally {
      // Always clear the login-in-progress flag so future LoadCart events work
      _loginInProgress = false;
    }
  }

  /// CRITICAL: Called when user logs out.
  ///
  /// Flow (matching Next.js reference):
  ///  1. Clear the logged-in cart state
  ///  2. Create a fresh guest session
  ///  3. Load the (empty) guest cart
  Future<void> _onUserLoggedOut(
    OnUserLoggedOut event,
    Emitter<CartState> emit,
  ) async {
    debugPrint('[CartBloc] OnUserLoggedOut — switching to guest mode');

    // Clear the guard flag — we're going back to guest mode
    _loginInProgress = false;

    // Best-effort: clear server-side cart items for logged-in session
    // before switching to guest mode.
    final itemsToRemove = List<CartItemModel>.from(state.cart.items);
    if (!state.isGuest && itemsToRemove.isNotEmpty) {
      for (final item in itemsToRemove) {
        try {
          _syncRepoToken();
          await repository.removeCartItem(cartItemId: item.id);
        } catch (e) {
          debugPrint('[CartBloc] OnUserLoggedOut remove item failed: $e');
        }
      }
    }

    await _clearGuestSession();

    // Reset state completely
    emit(const CartState(status: CartStatus.loading, isGuest: true));

    // Create fresh guest session
    try {
      repository.updateToken(null, isGuest: true);
      final response = await repository.createCartToken();
      final token = response.sessionToken ?? response.cartToken;
      final cartId = response.id;

      await _saveGuestSession(token, cartId);
      repository.updateToken(token, isGuest: true);

      emit(
        CartState(
          status: CartStatus.loaded,
          cartToken: token,
          cartId: cartId,
          isGuest: true,
          cart: CartModel.empty,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] Failed to create guest session after logout: $e');
      emit(
        const CartState(
          status: CartStatus.loaded,
          isGuest: true,
          cart: CartModel.empty,
        ),
      );
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isApplyingCoupon: true, clearMessage: true));
    try {
      _syncRepoToken();
      final cart = await repository.applyCoupon(couponCode: event.couponCode);

      if (cart.hasCoupon) {
        emit(
          state.copyWith(
            cart: cart,
            isApplyingCoupon: false,
            successMessage: 'Coupon applied successfully',
            clearError: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            cart: cart,
            isApplyingCoupon: false,
            errorMessage: 'Invalid coupon code',
          ),
        );
      }
    } catch (e) {
      debugPrint('[CartBloc] ApplyCoupon error: $e');
      emit(
        state.copyWith(
          isApplyingCoupon: false,
          errorMessage: 'Failed to apply coupon',
        ),
      );
    }
  }

  Future<void> _onRemoveCoupon(
    RemoveCoupon event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isApplyingCoupon: true));
    try {
      _syncRepoToken();
      final cart = await repository.removeCoupon();

      emit(
        state.copyWith(
          cart: cart,
          isApplyingCoupon: false,
          successMessage: 'Coupon removed',
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] RemoveCoupon error: $e');
      emit(
        state.copyWith(
          isApplyingCoupon: false,
          errorMessage: 'Failed to remove coupon',
        ),
      );
    }
  }

  void _onClearCartMessage(ClearCartMessage event, Emitter<CartState> emit) {
    emit(state.copyWith(clearMessage: true, clearError: true));
  }

  /// Extract readable error message from exceptions
  String _extractErrorMessage(Object exception) {
    if (exception is OperationException) {
      if (exception.graphqlErrors.isNotEmpty) {
        return exception.graphqlErrors.first.message;
      }
      if (exception.linkException != null) {
        return 'Network error. Please check your connection.';
      }
    }
    return 'Failed to add product to cart. Please try again.';
  }
}
