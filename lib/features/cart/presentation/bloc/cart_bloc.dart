import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../../checkout/data/models/checkout_model.dart';
import '../../../category/data/models/product_model.dart';
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
  final List<String> downloadableLinks;
  final List<Map<String, int>> groupedItems;
  final List<Map<String, dynamic>> bundleOptions;
  final Map<String, dynamic> bookingData;
  final int? selectedConfigurableOption; // variant ID for configurable
  final List<Map<String, dynamic>> superAttribute; // [{attrId: optionId}, ...]
  final Map<String, dynamic> customizableOptions;

  const AddToCart({
    required this.productId,
    this.quantity = 1,
    this.downloadableLinks = const [],
    this.groupedItems = const [],
    this.bundleOptions = const [],
    this.bookingData = const {},
    this.selectedConfigurableOption,
    this.superAttribute = const [],
    this.customizableOptions = const {},
  });

  @override
  List<Object?> get props => [
    productId,
    quantity,
    downloadableLinks,
    groupedItems,
    bundleOptions,
    bookingData,
    selectedConfigurableOption,
    superAttribute,
    customizableOptions,
  ];
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

/// Estimate shipping and tax for the destination
class EstimateShippingEvent extends CartEvent {
  final String country;
  final String? state;
  final String? postcode;

  const EstimateShippingEvent({
    required this.country,
    this.state,
    this.postcode,
  });

  @override
  List<Object?> get props => [country, state, postcode];
}

/// Select a specific estimated shipping rate
class SelectEstimatedShippingMethodEvent extends CartEvent {
  final String method;
  final String country;
  final String? state;
  final String? postcode;

  const SelectEstimatedShippingMethodEvent({
    required this.method,
    required this.country,
    this.state,
    this.postcode,
  });

  @override
  List<Object?> get props => [method, country, state, postcode];
}

/// Fetch cross-sell products for the current cart
class FetchCartCrossSellProductsEvent extends CartEvent {
  const FetchCartCrossSellProductsEvent();
}

/// Reset estimated shipping state and fields when leaving cart screen
class ResetEstimateShippingEvent extends CartEvent {
  const ResetEstimateShippingEvent();
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
  final List<ShippingRate> estimatedShippingMethods;
  final String? selectedEstimatedShippingRate;
  final bool isEstimatingShipping;
  final String? estimateShippingError;
  final String? estimatedCountry;
  final String? estimatedState;
  final String? estimatedPostcode;
  final List<ProductModel> crossSellProducts;
  final bool isLoadingCrossSells;

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
    this.estimatedShippingMethods = const [],
    this.selectedEstimatedShippingRate,
    this.isEstimatingShipping = false,
    this.estimateShippingError,
    this.estimatedCountry,
    this.estimatedState,
    this.estimatedPostcode,
    this.crossSellProducts = const [],
    this.isLoadingCrossSells = false,
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
    List<ShippingRate>? estimatedShippingMethods,
    String? selectedEstimatedShippingRate,
    bool? isEstimatingShipping,
    String? estimateShippingError,
    String? estimatedCountry,
    String? estimatedState,
    String? estimatedPostcode,
    List<ProductModel>? crossSellProducts,
    bool? isLoadingCrossSells,
    bool clearMessage = false,
    bool clearUpdatingItem = false,
    bool clearError = false,
    bool clearCartId = false,
    bool clearEstimateError = false,
    bool clearEstimatedShipping = false,
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
      estimatedShippingMethods: clearEstimatedShipping
          ? const []
          : (estimatedShippingMethods ?? this.estimatedShippingMethods),
      selectedEstimatedShippingRate: clearEstimatedShipping
          ? null
          : (selectedEstimatedShippingRate ??
                this.selectedEstimatedShippingRate),
      isEstimatingShipping: isEstimatingShipping ?? this.isEstimatingShipping,
      estimateShippingError: (clearEstimateError || clearEstimatedShipping)
          ? null
          : (estimateShippingError ?? this.estimateShippingError),
      estimatedCountry: clearEstimatedShipping
          ? null
          : (estimatedCountry ?? this.estimatedCountry),
      estimatedState: clearEstimatedShipping
          ? null
          : (estimatedState ?? this.estimatedState),
      estimatedPostcode: clearEstimatedShipping
          ? null
          : (estimatedPostcode ?? this.estimatedPostcode),
      crossSellProducts: crossSellProducts ?? this.crossSellProducts,
      isLoadingCrossSells: isLoadingCrossSells ?? this.isLoadingCrossSells,
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
    estimatedShippingMethods,
    selectedEstimatedShippingRate,
    isEstimatingShipping,
    estimateShippingError,
    estimatedCountry,
    estimatedState,
    estimatedPostcode,
    crossSellProducts,
    isLoadingCrossSells,
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
    on<EstimateShippingEvent>(_onEstimateShipping);
    on<SelectEstimatedShippingMethodEvent>(_onSelectEstimatedShippingMethod);
    on<FetchCartCrossSellProductsEvent>(_onFetchCartCrossSellProducts);
    on<ResetEstimateShippingEvent>(_onResetEstimateShipping);
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

  Future<CartState> _createFreshGuestCartState({String? successMessage}) async {
    repository.updateToken(null, isGuest: true);
    final response = await repository.createCartToken();
    final token = response.sessionToken ?? response.cartToken;
    final cartId = response.id;

    await _saveGuestSession(token, cartId);
    repository.updateToken(token, isGuest: true);

    return CartState(
      status: CartStatus.loaded,
      cartToken: token,
      cartId: cartId,
      isGuest: true,
      cart: CartModel.empty,
      successMessage: successMessage,
    );
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

    // Check if user is already authenticated in AuthStorage
    // If so, fetch the auth token and configure the cart bloc
    final isUserLoggedIn = await AuthStorage.isLoggedIn();
    if (isUserLoggedIn) {
      final authToken = await AuthStorage.getToken();
      if (authToken != null && authToken.isNotEmpty) {
        debugPrint(
          '[CartBloc] _ensureToken: user is logged in, using auth token',
        );
        repository.updateToken(authToken, isGuest: false);
        emit(state.copyWith(cartToken: authToken, isGuest: false));
        return authToken;
      }
      debugPrint(
        '[CartBloc] _ensureToken: user is logged in but no auth token found',
      );
      return null;
    }

    // If state says authenticated but AuthStorage disagrees, don't create guest session
    if (!state.isGuest) {
      debugPrint(
        '[CartBloc] _ensureToken: state says authenticated but no token available',
      );
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
      debugPrint(
        '[CartBloc] LoadCart: user is logged in, loading with auth token',
      );

      // Get the auth token and load cart with it
      final authToken = await AuthStorage.getToken();
      if (authToken != null && authToken.isNotEmpty) {
        // Set the guard flag
        _loginInProgress = true;

        // Switch token to auth access token
        repository.updateToken(authToken, isGuest: false);
        emit(
          state.copyWith(
            cartToken: authToken,
            isGuest: false,
            status: CartStatus.loading,
          ),
        );

        // Load the user's cart
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
          debugPrint('[CartBloc] LoadCart error (logged in user): $e');
          emit(
            state.copyWith(status: CartStatus.loaded, cart: CartModel.empty),
          );
        } finally {
          _loginInProgress = false;
        }
        return;
      }
    }

    // If user is authenticated but has no token, don't fall back to guest
    // This prevents the guest session from being loaded when user is logged in
    if (!state.isGuest &&
        (state.cartToken == null || state.cartToken!.isEmpty)) {
      debugPrint(
        '[CartBloc] LoadCart: authenticated user but no token, waiting for login to complete',
      );
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
          emit(await _createFreshGuestCartState());
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
        downloadableLinks: event.downloadableLinks,
        groupedItems: event.groupedItems,
        bundleOptions: event.bundleOptions,
        bookingData: event.bookingData,
        selectedConfigurableOption: event.selectedConfigurableOption,
        superAttribute: event.superAttribute,
        customizableOptions: event.customizableOptions,
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
      final errorMsg = ErrorMapper.getUserMessage(
        e,
        context: 'adding the product to cart',
      );
      emit(state.copyWith(isAddingToCart: false, errorMessage: errorMsg));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(updatingItemId: event.cartItemId));
    try {
      _syncRepoToken();
      await repository.updateCartItem(
        cartItemId: event.cartItemId,
        quantity: event.quantity,
      );
      final freshCart = await repository.getCart();
      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: freshCart,
          cartId: freshCart.id > 0 ? freshCart.id : state.cartId,
          clearUpdatingItem: true,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] UpdateCartItem error: $e');
      emit(
        state.copyWith(
          clearUpdatingItem: true,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'updating quantity',
          ),
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
      final updatedCart = await repository.removeCartItem(
        cartItemId: event.cartItemId,
      );

      if (updatedCart.itemsQty == 0 || updatedCart.items.isEmpty) {
        if (state.isGuest) {
          await _clearGuestSession();
          try {
            emit(
              await _createFreshGuestCartState(
                successMessage: 'Item removed from cart',
              ),
            );
          } catch (sessionError) {
            debugPrint(
              '[CartBloc] Failed to recreate guest session after last-item removal: $sessionError',
            );
            emit(
              const CartState(
                status: CartStatus.loaded,
                isGuest: true,
                cart: CartModel.empty,
                successMessage: 'Item removed from cart',
              ),
            );
          }
          return;
        }

        emit(
          state.copyWith(
            status: CartStatus.loaded,
            cart: CartModel.empty,
            clearCartId: true,
            clearUpdatingItem: true,
            successMessage: 'Item removed from cart',
            clearError: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: updatedCart,
          cartId: updatedCart.id > 0 ? updatedCart.id : state.cartId,
          clearUpdatingItem: true,
          successMessage: 'Item removed from cart',
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] RemoveFromCart error: $e');

      if (e.toString().contains('Cart not found')) {
        if (state.isGuest) {
          await _clearGuestSession();
          try {
            emit(
              await _createFreshGuestCartState(
                successMessage: 'Item removed from cart',
              ),
            );
          } catch (sessionError) {
            debugPrint(
              '[CartBloc] Failed to recreate guest session after stale-cart removal: $sessionError',
            );
            emit(
              const CartState(
                status: CartStatus.loaded,
                isGuest: true,
                cart: CartModel.empty,
                successMessage: 'Item removed from cart',
              ),
            );
          }
          return;
        }

        emit(
          state.copyWith(
            status: CartStatus.loaded,
            cart: CartModel.empty,
            clearCartId: true,
            clearUpdatingItem: true,
            successMessage: 'Item removed from cart',
            clearError: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          clearUpdatingItem: true,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'removing item from cart',
          ),
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
  ///  1. Reset local cart state
  ///  2. Create a fresh guest session
  ///  3. Load the (empty) guest cart
  Future<void> _onUserLoggedOut(
    OnUserLoggedOut event,
    Emitter<CartState> emit,
  ) async {
    debugPrint('[CartBloc] OnUserLoggedOut — switching to guest mode');

    // Clear the guard flag — we're going back to guest mode
    _loginInProgress = false;

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
            errorMessage: ErrorMapper.couponFailureMessage(
              'Invalid coupon code',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('[CartBloc] ApplyCoupon error: $e');
      emit(
        state.copyWith(
          isApplyingCoupon: false,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'applying coupon',
          ),
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
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'removing coupon',
          ),
        ),
      );
    }
  }

  void _onClearCartMessage(ClearCartMessage event, Emitter<CartState> emit) {
    emit(state.copyWith(clearMessage: true, clearError: true));
  }

  Future<void> _onEstimateShipping(
    EstimateShippingEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isEstimatingShipping: true, clearEstimateError: true));
    try {
      _syncRepoToken();
      final result = await repository.estimateShipping(
        country: event.country,
        state: event.state,
        postcode: event.postcode,
      );
      emit(
        state.copyWith(
          isEstimatingShipping: false,
          cart: result.cart,
          estimatedShippingMethods: result.shippingMethods,
          selectedEstimatedShippingRate: result.selectedShippingRate,
          estimatedCountry: event.country,
          estimatedState: event.state,
          estimatedPostcode: event.postcode,
          clearEstimateError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] EstimateShipping error: $e');
      emit(
        state.copyWith(
          isEstimatingShipping: false,
          estimateShippingError: ErrorMapper.getUserMessage(
            e,
            context: 'estimating shipping',
          ),
        ),
      );
    }
  }

  Future<void> _onSelectEstimatedShippingMethod(
    SelectEstimatedShippingMethodEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isEstimatingShipping: true, clearEstimateError: true));
    try {
      _syncRepoToken();
      final result = await repository.estimateShipping(
        country: event.country,
        state: event.state,
        postcode: event.postcode,
        shippingMethod: event.method,
      );
      emit(
        state.copyWith(
          isEstimatingShipping: false,
          cart: result.cart,
          estimatedShippingMethods: result.shippingMethods.isNotEmpty
              ? result.shippingMethods
              : state.estimatedShippingMethods,
          selectedEstimatedShippingRate:
              result.selectedShippingRate ?? event.method,
          estimatedCountry: event.country,
          estimatedState: event.state,
          estimatedPostcode: event.postcode,
          clearEstimateError: true,
        ),
      );
    } catch (e) {
      debugPrint('[CartBloc] SelectEstimatedShippingMethod error: $e');
      emit(
        state.copyWith(
          isEstimatingShipping: false,
          estimateShippingError: ErrorMapper.getUserMessage(
            e,
            context: 'selecting shipping method',
          ),
        ),
      );
    }
  }

  Future<void> _onFetchCartCrossSellProducts(
    FetchCartCrossSellProductsEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state.cart.items.isEmpty) {
      emit(state.copyWith(crossSellProducts: const []));
      return;
    }
    emit(state.copyWith(isLoadingCrossSells: true));
    try {
      _syncRepoToken();
      final products = await repository.getCartCrossSellProducts();
      emit(
        state.copyWith(crossSellProducts: products, isLoadingCrossSells: false),
      );
    } catch (e) {
      debugPrint('[CartBloc] _onFetchCartCrossSellProducts error: $e');
      emit(state.copyWith(isLoadingCrossSells: false));
    }
  }

  void _onResetEstimateShipping(
    ResetEstimateShippingEvent event,
    Emitter<CartState> emit,
  ) {
    emit(
      state.copyWith(clearEstimatedShipping: true, isEstimatingShipping: false),
    );
  }
}
