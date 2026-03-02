import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../cart/data/models/cart_model.dart';
import '../../data/models/checkout_model.dart';
import '../../data/repository/checkout_repository.dart';

// ─── Events ────────────────────────────────────────────────────────────────

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

/// Initialize checkout with cart data.
/// [isGuest] determines whether we show a blank address form (guest)
/// or fetch saved addresses (logged-in user).
class InitCheckout extends CheckoutEvent {
  final CartModel cart;
  final bool isGuest;
  const InitCheckout({required this.cart, this.isGuest = true});
  @override
  List<Object?> get props => [cart, isGuest];
}

/// Save checkout address (billing + shipping)
class SaveCheckoutAddressEvent extends CheckoutEvent {
  final Map<String, dynamic> input;
  const SaveCheckoutAddressEvent({required this.input});
  @override
  List<Object?> get props => [input];
}

/// Select a saved address for checkout (logged-in user only)
class SelectSavedAddress extends CheckoutEvent {
  final CheckoutAddress address;
  const SelectSavedAddress({required this.address});
  @override
  List<Object?> get props => [address];
}

/// Select and save a shipping method → then fetch payment methods
class SelectShippingMethod extends CheckoutEvent {
  final String shippingMethodCode;
  const SelectShippingMethod({required this.shippingMethodCode});
  @override
  List<Object?> get props => [shippingMethodCode];
}

/// Select a payment method (local UI only, no API call)
class SelectPaymentMethod extends CheckoutEvent {
  final String paymentMethodCode;
  const SelectPaymentMethod({required this.paymentMethodCode});
  @override
  List<Object?> get props => [paymentMethodCode];
}

/// Apply coupon code
class ApplyCheckoutCoupon extends CheckoutEvent {
  final String couponCode;
  const ApplyCheckoutCoupon({required this.couponCode});
  @override
  List<Object?> get props => [couponCode];
}

/// Remove coupon code
class RemoveCheckoutCoupon extends CheckoutEvent {}

/// Toggle use same address for shipping
class ToggleSameAddress extends CheckoutEvent {}

/// Place the order (saves payment first, then creates order)
class PlaceOrder extends CheckoutEvent {}

/// Clear messages
class ClearCheckoutMessage extends CheckoutEvent {}

/// Reset address confirmation so user can change the address
class ResetAddressConfirmation extends CheckoutEvent {}

/// Fetch countries from Bagisto API
class FetchCountries extends CheckoutEvent {}

/// Fetch states for a specific country (by numeric country ID or country code)
class FetchCountryStates extends CheckoutEvent {
  final int countryId;

  /// Country code (e.g., 'IN', 'US') - optional fallback if countryId is 0
  final String? countryCode;

  /// Which form this is for: 'billing' or 'shipping'
  final String formType;
  const FetchCountryStates({
    required this.countryId,
    this.countryCode,
    this.formType = 'billing',
  });
  @override
  List<Object?> get props => [countryId, countryCode, formType];
}

// ─── State ─────────────────────────────────────────────────────────────────

enum CheckoutStatus {
  initial,
  loading,
  addressesFetched,
  addressSaved,
  shippingRatesFetched,
  shippingSaved,
  paymentMethodsFetched,
  paymentSaved,
  orderPlaced,
  error,
}

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final CartModel cart;
  final String? cartToken;

  /// Whether the current checkout is for a guest (no account).
  final bool isGuest;

  /// Whether the address has been saved to the API for this checkout session.
  final bool addressConfirmed;

  // Addresses fetched from API (only for logged-in users)
  final List<CheckoutAddress> addresses;
  final CheckoutAddress? selectedAddress;
  final bool useSameAddressForShipping;

  // Shipping rates (fetched after address saved)
  final List<ShippingRate> shippingRates;
  final String? selectedShippingMethod;

  // Payment methods (fetched after shipping saved)
  final List<PaymentMethod> paymentMethods;
  final String? selectedPaymentMethod;

  final String? couponCode;
  final String? errorMessage;
  final String? successMessage;
  final bool isLoading;
  final bool isPlacingOrder;
  final CheckoutOrderResponse? orderResponse;

  // Countries & states from Bagisto API
  final List<BagistoCountry> countries;
  final List<BagistoCountryState> billingStates;
  final List<BagistoCountryState> shippingStates;
  final bool billingStatesLoading;
  final bool shippingStatesLoading;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.cart = CartModel.empty,
    this.cartToken,
    this.isGuest = true,
    this.addressConfirmed = false,
    this.addresses = const [],
    this.selectedAddress,
    this.useSameAddressForShipping = true,
    this.shippingRates = const [],
    this.selectedShippingMethod,
    this.paymentMethods = const [],
    this.selectedPaymentMethod,
    this.couponCode,
    this.errorMessage,
    this.successMessage,
    this.isLoading = false,
    this.isPlacingOrder = false,
    this.orderResponse,
    this.countries = const [],
    this.billingStates = const [],
    this.shippingStates = const [],
    this.billingStatesLoading = false,
    this.shippingStatesLoading = false,
  });

  /// Whether all required steps are complete for placing an order.
  bool get canPlaceOrder =>
      addressConfirmed &&
      selectedShippingMethod != null &&
      selectedPaymentMethod != null &&
      !isPlacingOrder;

  CheckoutState copyWith({
    CheckoutStatus? status,
    CartModel? cart,
    String? cartToken,
    bool? isGuest,
    bool? addressConfirmed,
    List<CheckoutAddress>? addresses,
    CheckoutAddress? selectedAddress,
    bool? useSameAddressForShipping,
    List<ShippingRate>? shippingRates,
    String? selectedShippingMethod,
    List<PaymentMethod>? paymentMethods,
    String? selectedPaymentMethod,
    String? couponCode,
    String? errorMessage,
    String? successMessage,
    bool? isLoading,
    bool? isPlacingOrder,
    CheckoutOrderResponse? orderResponse,
    List<BagistoCountry>? countries,
    List<BagistoCountryState>? billingStates,
    List<BagistoCountryState>? shippingStates,
    bool? billingStatesLoading,
    bool? shippingStatesLoading,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearSelectedAddress = false,
    bool clearSelectedShippingMethod = false,
    bool clearSelectedPaymentMethod = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      cartToken: cartToken ?? this.cartToken,
      isGuest: isGuest ?? this.isGuest,
      addressConfirmed: addressConfirmed ?? this.addressConfirmed,
      addresses: addresses ?? this.addresses,
      selectedAddress: clearSelectedAddress
          ? null
          : (selectedAddress ?? this.selectedAddress),
      useSameAddressForShipping:
          useSameAddressForShipping ?? this.useSameAddressForShipping,
      shippingRates: shippingRates ?? this.shippingRates,
      selectedShippingMethod: clearSelectedShippingMethod
          ? null
          : (selectedShippingMethod ?? this.selectedShippingMethod),
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod: clearSelectedPaymentMethod
          ? null
          : (selectedPaymentMethod ?? this.selectedPaymentMethod),
      couponCode: couponCode ?? this.couponCode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      isLoading: isLoading ?? this.isLoading,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      orderResponse: orderResponse ?? this.orderResponse,
      countries: countries ?? this.countries,
      billingStates: billingStates ?? this.billingStates,
      shippingStates: shippingStates ?? this.shippingStates,
      billingStatesLoading: billingStatesLoading ?? this.billingStatesLoading,
      shippingStatesLoading:
          shippingStatesLoading ?? this.shippingStatesLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cart,
    cartToken,
    isGuest,
    addressConfirmed,
    addresses,
    selectedAddress,
    useSameAddressForShipping,
    shippingRates,
    selectedShippingMethod,
    paymentMethods,
    selectedPaymentMethod,
    couponCode,
    errorMessage,
    successMessage,
    isLoading,
    isPlacingOrder,
    orderResponse,
    countries,
    billingStates,
    shippingStates,
    billingStatesLoading,
    shippingStatesLoading,
  ];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository repository;

  /// Returns the latest Bearer auth token (login token or guest session UUID).
  final String? Function()? getLatestAuthToken;

  CheckoutBloc({required this.repository, this.getLatestAuthToken})
    : super(const CheckoutState()) {
    on<InitCheckout>(_onInitCheckout);
    on<SaveCheckoutAddressEvent>(_onSaveCheckoutAddress);
    on<SelectSavedAddress>(_onSelectSavedAddress);
    on<SelectShippingMethod>(_onSelectShippingMethod);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<ApplyCheckoutCoupon>(_onApplyCoupon);
    on<RemoveCheckoutCoupon>(_onRemoveCoupon);
    on<ToggleSameAddress>(_onToggleSameAddress);
    on<PlaceOrder>(_onPlaceOrder);
    on<ClearCheckoutMessage>(_onClearMessage);
    on<ResetAddressConfirmation>(_onResetAddressConfirmation);
    on<FetchCountries>(_onFetchCountries);
    on<FetchCountryStates>(_onFetchCountryStates);
  }

  /// Refresh the repo's Bearer auth token from the latest source.
  void _refreshAuthToken() {
    String? token = getLatestAuthToken?.call();
    if (token != null && token.isNotEmpty) {
      repository.updateAuthToken(token);
    } else {
      debugPrint(
        '[CheckoutBloc] WARNING _refreshAuthToken: no valid auth token available',
      );
    }
  }

  /// 1) Store cart, determine guest/logged-in, fetch addresses only for logged-in
  Future<void> _onInitCheckout(
    InitCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    final token = event.cart.cartToken;
    emit(
      state.copyWith(
        cart: event.cart,
        cartToken: token,
        isGuest: event.isGuest,
        isLoading: true,
        status: CheckoutStatus.loading,
      ),
    );
    _refreshAuthToken();

    if (event.isGuest) {
      // Guest checkout: no saved addresses, user must fill in the form
      debugPrint('[CheckoutBloc] Guest checkout — skipping address fetch');
      emit(
        state.copyWith(
          status: CheckoutStatus.addressesFetched,
          isLoading: false,
          addresses: const [],
        ),
      );
      // Fetch countries for the address form dropdowns
      add(FetchCountries());
      return;
    }

    // Logged-in user: fetch saved addresses
    try {
      final addresses = await repository.getCheckoutAddresses();
      debugPrint('[CheckoutBloc] fetched ${addresses.length} addresses');

      // Filter to only show addresses that belong to this user's cart
      // or customer addresses (not cart_billing/cart_shipping from other carts)
      final customerAddresses = addresses
          .where(
            (a) =>
                a.addressType != 'cart_billing' &&
                a.addressType != 'cart_shipping',
          )
          .toList();

      // Also check for existing cart billing/shipping addresses
      final cartBilling = addresses.firstWhere(
        (a) => a.addressType == 'cart_billing',
        orElse: () => const CheckoutAddress(id: ''),
      );
      final hasCartAddress = cartBilling.id.isNotEmpty;

      CheckoutAddress? defaultAddr;
      if (hasCartAddress) {
        // Cart already has an address set — use it
        defaultAddr = cartBilling;
      } else if (customerAddresses.isNotEmpty) {
        defaultAddr = customerAddresses.firstWhere(
          (a) => a.defaultAddress,
          orElse: () => customerAddresses.first,
        );
      }

      // ── Auto-save: if we have a default address from checkout, save it automatically ──
      if (defaultAddr != null) {
        if (hasCartAddress) {
          // Cart already has address saved — just mark confirmed and fetch shipping/payment
          debugPrint('[CheckoutBloc] Cart already has address — auto-proceeding');
          emit(
            state.copyWith(
              addresses: customerAddresses.isNotEmpty ? customerAddresses : addresses,
              selectedAddress: defaultAddr,
              status: CheckoutStatus.addressSaved,
              addressConfirmed: true,
              isLoading: false,
            ),
          );
          add(FetchCountries());

          try {
            final rates = await repository.getShippingRates();
            debugPrint('[CheckoutBloc] Auto-fetched ${rates.length} shipping rates');

            if (rates.isNotEmpty) {
              final firstRate = rates.first;
              final shipResp = await repository.saveShippingMethod(firstRate.method);
              debugPrint('[CheckoutBloc] Auto-saved shipping: ${firstRate.code}, success=${shipResp.success}');

              if (shipResp.success) {
                final methods = await repository.getPaymentMethods();
                debugPrint('[CheckoutBloc] Auto-fetched ${methods.length} payment methods');
                emit(
                  state.copyWith(
                    shippingRates: rates,
                    selectedShippingMethod: firstRate.code,
                    status: CheckoutStatus.paymentMethodsFetched,
                    paymentMethods: methods,
                  ),
                );
              } else {
                emit(state.copyWith(shippingRates: rates, status: CheckoutStatus.shippingRatesFetched));
              }
            } else {
              emit(state.copyWith(shippingRates: rates, status: CheckoutStatus.shippingRatesFetched));
            }
          } catch (e) {
            debugPrint('[CheckoutBloc] Auto-fetch shipping rates error: $e');
          }
          return;
        }

        // No cart address yet — save the default/selected address
        debugPrint('[CheckoutBloc] Auto-saving default checkout address: ${defaultAddr.fullName}');
        try {
          final saveInput = defaultAddr.toBillingInput(useForShipping: true);
          final saveResponse = await repository.saveCheckoutAddress(saveInput);
          debugPrint('[CheckoutBloc] Auto-saved checkout address — success=${saveResponse.success}, cartToken=${saveResponse.cartToken}');

          if (saveResponse.success) {
            // Update cart query token
            final rawCartToken = saveResponse.cartToken;
            final queryToken = (rawCartToken != null && rawCartToken.isNotEmpty)
                ? rawCartToken
                : (saveResponse.id != null && saveResponse.id!.isNotEmpty)
                ? saveResponse.id!
                : '';
            repository.updateCartQueryToken(queryToken);

            emit(
              state.copyWith(
                addresses: customerAddresses.isNotEmpty ? customerAddresses : addresses,
                selectedAddress: defaultAddr,
                status: CheckoutStatus.addressSaved,
                addressConfirmed: true,
                cartToken: queryToken,
                isLoading: false,
              ),
            );
            add(FetchCountries());

            // Fetch shipping rates, auto-select first, then payment methods
            try {
              final rates = await repository.getShippingRates(queryToken: queryToken);
              debugPrint('[CheckoutBloc] Auto-fetched ${rates.length} shipping rates');

              if (rates.isNotEmpty) {
                final firstRate = rates.first;
                final shipResp = await repository.saveShippingMethod(firstRate.method);
                debugPrint('[CheckoutBloc] Auto-saved shipping method: ${firstRate.code}, success=${shipResp.success}');

                if (shipResp.success) {
                  final methods = await repository.getPaymentMethods();
                  debugPrint('[CheckoutBloc] Auto-fetched ${methods.length} payment methods');
                  emit(
                    state.copyWith(
                      shippingRates: rates,
                      selectedShippingMethod: firstRate.code,
                      status: CheckoutStatus.paymentMethodsFetched,
                      paymentMethods: methods,
                    ),
                  );
                } else {
                  emit(
                    state.copyWith(
                      shippingRates: rates,
                      status: CheckoutStatus.shippingRatesFetched,
                    ),
                  );
                }
              } else {
                emit(state.copyWith(shippingRates: rates, status: CheckoutStatus.shippingRatesFetched));
              }
            } catch (e) {
              debugPrint('[CheckoutBloc] Auto-fetch shipping rates error: $e');
            }
            return;
          }
        } catch (e) {
          debugPrint('[CheckoutBloc] Auto-save checkout address error: $e — falling through to manual');
        }
      }

      // ── Fallback: if no checkout addresses, fetch from account/customer addresses ──
      if (customerAddresses.isEmpty && !hasCartAddress) {
        debugPrint('[CheckoutBloc] No checkout addresses found — fetching customer addresses as fallback');
        try {
          final accountAddresses = await repository.getCustomerAddresses();
          debugPrint('[CheckoutBloc] fetched ${accountAddresses.length} customer addresses');

          if (accountAddresses.isNotEmpty) {
            // Find the default address, or use the first one
            final fallbackAddr = accountAddresses.firstWhere(
              (a) => a.defaultAddress,
              orElse: () => accountAddresses.first,
            );

            debugPrint('[CheckoutBloc] Using customer address as default: ${fallbackAddr.fullName}');

            // Auto-save this address as the checkout billing address
            try {
              final saveInput = fallbackAddr.toBillingInput(useForShipping: true);
              debugPrint('[CheckoutBloc] Auto-saving customer default address to checkout: $saveInput');
              final saveResponse = await repository.saveCheckoutAddress(saveInput);
              debugPrint('[CheckoutBloc] Auto-saved address — success=${saveResponse.success}, cartToken=${saveResponse.cartToken}');

              // Update cart query token if returned
              if (saveResponse.cartToken != null && saveResponse.cartToken!.isNotEmpty) {
                repository.updateCartQueryToken(saveResponse.cartToken);
              }
              final fallbackQueryToken = saveResponse.cartToken ?? '';

              emit(
                state.copyWith(
                  addresses: accountAddresses,
                  selectedAddress: fallbackAddr,
                  status: CheckoutStatus.addressSaved,
                  addressConfirmed: true,
                  cartToken: fallbackQueryToken,
                  isLoading: false,
                ),
              );

              // Now fetch shipping rates since address is saved
              add(FetchCountries());
              try {
                final rates = await repository.getShippingRates(queryToken: fallbackQueryToken);
                debugPrint('[CheckoutBloc] Auto-fetched ${rates.length} shipping rates');

                if (rates.isNotEmpty) {
                  final firstRate = rates.first;
                  final shipResp = await repository.saveShippingMethod(firstRate.method);
                  debugPrint('[CheckoutBloc] Auto-saved shipping: ${firstRate.code}, success=${shipResp.success}');

                  if (shipResp.success) {
                    final methods = await repository.getPaymentMethods();
                    debugPrint('[CheckoutBloc] Auto-fetched ${methods.length} payment methods');
                    emit(
                      state.copyWith(
                        shippingRates: rates,
                        selectedShippingMethod: firstRate.code,
                        status: CheckoutStatus.paymentMethodsFetched,
                        paymentMethods: methods,
                      ),
                    );
                  } else {
                    emit(
                      state.copyWith(
                        shippingRates: rates,
                        status: CheckoutStatus.shippingRatesFetched,
                      ),
                    );
                  }
                } else {
                  emit(state.copyWith(shippingRates: rates, status: CheckoutStatus.shippingRatesFetched));
                }
              } catch (e) {
                debugPrint('[CheckoutBloc] Auto-fetch shipping rates error: $e');
              }
              return;
            } catch (e) {
              debugPrint('[CheckoutBloc] Auto-save address error: $e');
              // Fall through to show customer addresses for manual selection
            }

            // If auto-save failed, still show the customer addresses for selection
            emit(
              state.copyWith(
                addresses: accountAddresses,
                selectedAddress: fallbackAddr,
                status: CheckoutStatus.addressesFetched,
                isLoading: false,
              ),
            );
            add(FetchCountries());
            return;
          }
        } catch (e) {
          debugPrint('[CheckoutBloc] getCustomerAddresses fallback error: $e');
        }
      }

      emit(
        state.copyWith(
          addresses: customerAddresses.isNotEmpty
              ? customerAddresses
              : addresses,
          selectedAddress: defaultAddr,
          status: CheckoutStatus.addressesFetched,
          isLoading: false,
        ),
      );
      // Fetch countries for the address form dropdowns
      add(FetchCountries());
    } catch (e) {
      debugPrint('[CheckoutBloc] getCheckoutAddresses error: $e');
      emit(
        state.copyWith(
          status: CheckoutStatus.addressesFetched,
          isLoading: false,
        ),
      );
    }
  }

  /// Select a saved address (for logged-in users switching between addresses)
  /// Automatically saves the address and fetches shipping rates + payment methods.
  Future<void> _onSelectSavedAddress(
    SelectSavedAddress event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedAddress: event.address,
        // Reset downstream steps since address changed
        addressConfirmed: false,
        shippingRates: const [],
        clearSelectedShippingMethod: true,
        paymentMethods: const [],
        clearSelectedPaymentMethod: true,
        isLoading: true,
      ),
    );

    _refreshAuthToken();

    // Auto-save the newly selected address
    try {
      final saveInput = event.address.toBillingInput(useForShipping: true);
      debugPrint('[CheckoutBloc] Auto-saving selected address: ${event.address.fullName}');
      final saveResponse = await repository.saveCheckoutAddress(saveInput);
      debugPrint('[CheckoutBloc] Auto-saved address — success=${saveResponse.success}, cartToken=${saveResponse.cartToken}');

      if (!saveResponse.success) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: saveResponse.message ?? 'Failed to save address',
          ),
        );
        return;
      }

      final rawCartToken = saveResponse.cartToken;
      final queryToken = (rawCartToken != null && rawCartToken.isNotEmpty)
          ? rawCartToken
          : (saveResponse.id != null && saveResponse.id!.isNotEmpty)
          ? saveResponse.id!
          : '';
      repository.updateCartQueryToken(queryToken);

      emit(
        state.copyWith(
          status: CheckoutStatus.addressSaved,
          cartToken: queryToken,
          addressConfirmed: true,
        ),
      );

      // Fetch shipping rates, auto-select first, then payment methods
      try {
        final rates = await repository.getShippingRates(queryToken: queryToken);
        debugPrint('[CheckoutBloc] Auto-fetched ${rates.length} shipping rates after address change');

        if (rates.isNotEmpty) {
          final firstRate = rates.first;
          final shipResp = await repository.saveShippingMethod(firstRate.method);
          debugPrint('[CheckoutBloc] Auto-saved shipping: ${firstRate.code}, success=${shipResp.success}');

          if (shipResp.success) {
            final methods = await repository.getPaymentMethods();
            debugPrint('[CheckoutBloc] Auto-fetched ${methods.length} payment methods');
            emit(
              state.copyWith(
                shippingRates: rates,
                selectedShippingMethod: firstRate.code,
                status: CheckoutStatus.paymentMethodsFetched,
                paymentMethods: methods,
                isLoading: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                shippingRates: rates,
                status: CheckoutStatus.shippingRatesFetched,
                isLoading: false,
              ),
            );
          }
        } else {
          emit(state.copyWith(shippingRates: rates, status: CheckoutStatus.shippingRatesFetched, isLoading: false));
        }
      } catch (e) {
        debugPrint('[CheckoutBloc] Auto-fetch shipping rates error: $e');
        emit(state.copyWith(isLoading: false, errorMessage: 'Address saved but failed to load shipping rates'));
      }
    } catch (e) {
      debugPrint('[CheckoutBloc] Auto-save address on selection error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save address: $e',
        ),
      );
    }
  }

  /// 2) Save address → on success fetch shipping rates.
  ///
  /// For **logged-in users** the `cartToken` returned by
  /// `createCheckoutAddress` is the user ID (e.g. `"19"`) which is used as
  /// the `$token` variable for `collectionShippingRates` /
  /// `collectionPaymentMethods`.
  ///
  /// For **guest users** the API returns `cartToken: ""`. The Bagisto API
  /// identifies the guest cart via the session UUID in the Bearer
  /// `Authorization` header, so the `$token` variable can be an empty string.
  Future<void> _onSaveCheckoutAddress(
    SaveCheckoutAddressEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    _refreshAuthToken();
    try {
      final response = await repository.saveCheckoutAddress(event.input);
      debugPrint(
        '[CheckoutBloc] saveAddress success=${response.success}, cartToken="${response.cartToken}", id="${response.id}"',
      );
      if (!response.success) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response.message ?? 'Failed to save address',
          ),
        );
        return;
      }

      // Determine the query token for shipping-rates / payment-methods.
      // Logged-in users: cartToken is their user ID (e.g. "19").
      // Guests: cartToken is "" — the API uses the Bearer session token
      // in the header to identify the cart, so "" is valid.
      final rawCartToken = response.cartToken;
      final queryToken = (rawCartToken != null && rawCartToken.isNotEmpty)
          ? rawCartToken
          : (response.id != null && response.id!.isNotEmpty)
          ? response.id!
          : ''; // empty string is valid for guests

      repository.updateCartQueryToken(queryToken);

      emit(
        state.copyWith(
          status: CheckoutStatus.addressSaved,
          cartToken: queryToken,
          addressConfirmed: true,
          successMessage: response.message,
        ),
      );

      // Now fetch shipping rates
      try {
        final rates = await repository.getShippingRates(queryToken: queryToken);
        debugPrint('[CheckoutBloc] fetched ${rates.length} shipping rates');

        // Auto-select first shipping method if available
        if (rates.isNotEmpty) {
          final firstRate = rates.first;
          debugPrint('[CheckoutBloc] auto-selecting first shipping method: ${firstRate.code}');

          // Save the first shipping method
          final shipResp = await repository.saveShippingMethod(firstRate.method);
          debugPrint('[CheckoutBloc] saveShipping success=${shipResp.success}');

          if (shipResp.success) {
            // Fetch payment methods
            final methods = await repository.getPaymentMethods();
            debugPrint('[CheckoutBloc] fetched ${methods.length} payment methods');

            emit(
              state.copyWith(
                shippingRates: rates,
                selectedShippingMethod: firstRate.code,
                status: CheckoutStatus.paymentMethodsFetched,
                paymentMethods: methods,
                isLoading: false,
              ),
            );
          } else {
            // Shipping method save failed, but we have rates
            emit(
              state.copyWith(
                shippingRates: rates,
                status: CheckoutStatus.shippingRatesFetched,
                isLoading: false,
              ),
            );
          }
        } else {
          // No shipping rates available
          emit(
            state.copyWith(
              shippingRates: rates,
              status: CheckoutStatus.shippingRatesFetched,
              isLoading: false,
            ),
          );
        }
      } catch (e) {
        debugPrint('[CheckoutBloc] getShippingRates error: $e');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Address saved but failed to load shipping rates: $e',
          ),
        );
      }
    } catch (e) {
      debugPrint('[CheckoutBloc] saveCheckoutAddress error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save address: $e',
        ),
      );
    }
  }

  /// 3) Save shipping method → on success fetch payment methods.
  ///    The Bearer auth token is refreshed from `getLatestAuthToken`.
  ///    The `$token` for `collectionPaymentMethods` comes from
  ///    `repository.cartQueryToken` (set during address save).
  Future<void> _onSelectShippingMethod(
    SelectShippingMethod event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedShippingMethod: event.shippingMethodCode,
        isLoading: true,
        clearError: true,
      ),
    );
    _refreshAuthToken();

    print("rshtjyjgjhgj");

    try {
      final response = await repository.saveShippingMethod(
        event.shippingMethodCode,
      );
      debugPrint('[CheckoutBloc] saveShipping success=${response.success}');
      if (!response.success) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response.message ?? 'Failed to save shipping method',
          ),
        );
        return;
      }
      emit(state.copyWith(status: CheckoutStatus.shippingSaved));

      // Fetch payment methods using the stored cart query token
      try {
        final methods = await repository.getPaymentMethods();
        debugPrint('[CheckoutBloc] fetched ${methods.length} payment methods');
        emit(
          state.copyWith(
            paymentMethods: methods,
            status: CheckoutStatus.paymentMethodsFetched,
            isLoading: false,
          ),
        );
      } catch (e) {
        debugPrint('[CheckoutBloc] getPaymentMethods error: $e');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                'Shipping saved but failed to load payment methods: $e',
          ),
        );
      }
    } catch (e) {
      debugPrint('[CheckoutBloc] saveShippingMethod error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save shipping method: $e',
        ),
      );
    }
  }

  /// 4) Local payment selection (no API call until PlaceOrder)
  void _onSelectPaymentMethod(
    SelectPaymentMethod event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(selectedPaymentMethod: event.paymentMethodCode));
  }

  /// 5) Place order: save payment method → create order.
  ///    Only the Bearer auth token is needed (no `$token` variable).
  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    // Validate all steps are complete
    if (!state.addressConfirmed) {
      emit(state.copyWith(errorMessage: 'Please save your address first'));
      return;
    }
    if (state.selectedShippingMethod == null) {
      emit(state.copyWith(errorMessage: 'Please select a shipping method'));
      return;
    }
    if (state.selectedPaymentMethod == null) {
      emit(state.copyWith(errorMessage: 'Please select a payment method'));
      return;
    }

    emit(state.copyWith(isPlacingOrder: true, clearError: true));
    _refreshAuthToken();

    try {
      // Save payment method first
      if (state.selectedPaymentMethod != null &&
          state.selectedPaymentMethod!.isNotEmpty) {
        final payResp = await repository.savePaymentMethod(
          state.selectedPaymentMethod!,
        );
        debugPrint('[CheckoutBloc] savePayment success=${payResp.success}');
        if (!payResp.success) {
          emit(
            state.copyWith(
              isPlacingOrder: false,
              errorMessage: payResp.message ?? 'Failed to save payment method',
            ),
          );
          return;
        }
      }
      // Place the order
      final response = await repository.placeOrder();
      debugPrint('[CheckoutBloc] placeOrder orderId=${response.orderId}');
      if (response.success) {
        emit(
          state.copyWith(
            status: CheckoutStatus.orderPlaced,
            isPlacingOrder: false,
            orderResponse: response,
            successMessage: response.message ?? 'Order placed successfully!',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isPlacingOrder: false,
            errorMessage: response.message ?? 'Failed to place order',
          ),
        );
      }
    } catch (e) {
      debugPrint('[CheckoutBloc] placeOrder error: $e');
      emit(
        state.copyWith(
          isPlacingOrder: false,
          errorMessage: 'Failed to place order: $e',
        ),
      );
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCheckoutCoupon event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final response = await repository.applyCoupon(event.couponCode);
      if (response.success) {
        emit(
          state.copyWith(
            isLoading: false,
            couponCode: event.couponCode,
            successMessage: response.message ?? 'Coupon applied',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response.message ?? 'Invalid coupon code',
          ),
        );
      }
    } catch (e) {
      debugPrint('[CheckoutBloc] applyCoupon error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to apply coupon: $e',
        ),
      );
    }
  }

  Future<void> _onRemoveCoupon(
    RemoveCheckoutCoupon event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final response = await repository.removeCoupon();
      if (response.success) {
        emit(
          state.copyWith(
            isLoading: false,
            couponCode: '',
            successMessage: response.message ?? 'Coupon removed',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response.message ?? 'Failed to remove coupon',
          ),
        );
      }
    } catch (e) {
      debugPrint('[CheckoutBloc] removeCoupon error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to remove coupon: $e',
        ),
      );
    }
  }

  void _onToggleSameAddress(
    ToggleSameAddress event,
    Emitter<CheckoutState> emit,
  ) {
    emit(
      state.copyWith(
        useSameAddressForShipping: !state.useSameAddressForShipping,
      ),
    );
  }

  void _onResetAddressConfirmation(
    ResetAddressConfirmation event,
    Emitter<CheckoutState> emit,
  ) {
    emit(
      state.copyWith(
        addressConfirmed: false,
        shippingRates: const [],
        clearSelectedShippingMethod: true,
        paymentMethods: const [],
        clearSelectedPaymentMethod: true,
      ),
    );
  }

  void _onClearMessage(
    ClearCheckoutMessage event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  /// Fetch all countries from the Bagisto API
  Future<void> _onFetchCountries(
    FetchCountries event,
    Emitter<CheckoutState> emit,
  ) async {
    // Don't re-fetch if already loaded
    if (state.countries.isNotEmpty) return;

    try {
      final countries = await repository.getCountries();
      debugPrint('[CheckoutBloc] fetched ${countries.length} countries');
      // Sort alphabetically by name for better UX
      countries.sort((a, b) => a.name.compareTo(b.name));
      emit(state.copyWith(countries: countries));
    } catch (e) {
      debugPrint('[CheckoutBloc] fetchCountries error: $e');
      // Non-fatal: don't set error message, just log
    }
  }

  /// Fetch states/provinces for a specific country
  Future<void> _onFetchCountryStates(
    FetchCountryStates event,
    Emitter<CheckoutState> emit,
  ) async {
    debugPrint('[CheckoutBloc] FetchCountryStates: countryId=${event.countryId}, countryCode=${event.countryCode}, formType=${event.formType}');
    if (event.formType == 'shipping') {
      emit(
        state.copyWith(
          shippingStatesLoading: true,
          shippingStates: const [],
        ),
      );
    } else {
      emit(
        state.copyWith(
          billingStatesLoading: true,
          billingStates: const [],
        ),
      );
    }

    try {
      final states = await repository.getCountryStates(event.countryId, countryCode: event.countryCode);
      debugPrint(
        '[CheckoutBloc] fetched ${states.length} states for countryId=${event.countryId}',
      );
      // Sort alphabetically by name
      states.sort((a, b) => a.defaultName.compareTo(b.defaultName));

      if (event.formType == 'shipping') {
        emit(
          state.copyWith(
            shippingStates: states,
            shippingStatesLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            billingStates: states,
            billingStatesLoading: false,
          ),
        );
      }
    } catch (e) {
      debugPrint('[CheckoutBloc] fetchCountryStates error: $e');
      // Non-fatal: set empty states list
      if (event.formType == 'shipping') {
        emit(
          state.copyWith(
            shippingStates: const [],
            shippingStatesLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            billingStates: const [],
            billingStatesLoading: false,
          ),
        );
      }
    }
  }
}
