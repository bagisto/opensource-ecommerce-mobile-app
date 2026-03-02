import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../../cart/data/models/cart_model.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/checkout_model.dart';
import '../../data/repository/checkout_repository.dart';
import '../bloc/checkout_bloc.dart';
import 'thankyou_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = context.read<CartBloc>().state;
    final authState = context.read<AuthBloc>().state;

    // Check if user is authenticated - check both AuthBloc state and AuthStorage
    // This handles the case when app restarts and AuthBloc hasn't completed AuthCheckStatus yet
    bool isUserLoggedIn(AuthState state) {
      if (state is AuthAuthenticated && state.token.isNotEmpty) {
        return true;
      }
      // Also check if token exists in storage (for app restart case)
      final cartToken = cartState.cartToken;
      if (cartToken != null && cartToken.isNotEmpty && !cartState.isGuest) {
        return true;
      }
      return false;
    }

    final isGuest = !isUserLoggedIn(authState);

    String? getLatestAuthToken() {
      final currentAuthState = context.read<AuthBloc>().state;
      final currentCartState = context.read<CartBloc>().state;
      if (currentAuthState is AuthAuthenticated &&
          currentAuthState.token.isNotEmpty) {
        return currentAuthState.token;
      }
      if (currentCartState.cartToken != null &&
          currentCartState.cartToken!.isNotEmpty) {
        return currentCartState.cartToken;
      }
      return null;
    }

    final latestToken = getLatestAuthToken();
    final repo = CheckoutRepository(
      client: context.read<CartBloc>().repository.client,
      initialToken: latestToken,
    );

    return BlocProvider(
      create: (_) =>
          CheckoutBloc(repository: repo, getLatestAuthToken: getLatestAuthToken)
            ..add(InitCheckout(cart: cartState.cart, isGuest: isGuest)),
      child: const _CheckoutPageView(),
    );
  }
}

class _CheckoutPageView extends StatefulWidget {
  const _CheckoutPageView();

  @override
  State<_CheckoutPageView> createState() => _CheckoutPageViewState();
}

class _CheckoutPageViewState extends State<_CheckoutPageView> {
  final TextEditingController _couponController = TextEditingController();
  bool _useSameAddress = true;

  // Local selection state for immediate UI response
  String? _selectedShippingMethod;
  String? _selectedPaymentMethod;

  // Guest billing address form controllers
  final _billingFormKey = GlobalKey<FormState>();
  final _billingFirstNameCtrl = TextEditingController();
  final _billingLastNameCtrl = TextEditingController();
  final _billingEmailCtrl = TextEditingController();
  final _billingPhoneCtrl = TextEditingController();
  final _billingAddressCtrl = TextEditingController();
  final _billingCityCtrl = TextEditingController();
  final _billingPostcodeCtrl = TextEditingController();
  final _billingCompanyCtrl = TextEditingController();
  String _billingCountry = '';
  String _billingState = '';

  // Display controllers for country/state bottom sheet selection
  final _billingCountryDisplayCtrl = TextEditingController();
  final _billingStateDisplayCtrl = TextEditingController();
  BagistoCountry? _selectedBillingCountry;
  BagistoCountryState? _selectedBillingState;

  // Guest shipping address form controllers (when different from billing)
  final _shippingFormKey = GlobalKey<FormState>();
  final _shippingFirstNameCtrl = TextEditingController();
  final _shippingLastNameCtrl = TextEditingController();
  final _shippingEmailCtrl = TextEditingController();
  final _shippingPhoneCtrl = TextEditingController();
  final _shippingAddressCtrl = TextEditingController();
  final _shippingCityCtrl = TextEditingController();
  final _shippingPostcodeCtrl = TextEditingController();
  final _shippingCompanyCtrl = TextEditingController();
  String _shippingCountry = '';
  String _shippingState = '';

  // Display controllers for shipping country/state bottom sheet selection
  final _shippingCountryDisplayCtrl = TextEditingController();
  final _shippingStateDisplayCtrl = TextEditingController();
  BagistoCountry? _selectedShippingCountry;
  BagistoCountryState? _selectedShippingState;

  // For logged-in address selection
  CheckoutAddress? _selectedBillingAddress;
  CheckoutAddress? _selectedShippingAddress;

  @override
  void dispose() {
    _couponController.dispose();
    _billingFirstNameCtrl.dispose();
    _billingLastNameCtrl.dispose();
    _billingEmailCtrl.dispose();
    _billingPhoneCtrl.dispose();
    _billingAddressCtrl.dispose();
    _billingCityCtrl.dispose();
    _billingPostcodeCtrl.dispose();
    _billingCompanyCtrl.dispose();
    _billingCountryDisplayCtrl.dispose();
    _billingStateDisplayCtrl.dispose();
    _shippingFirstNameCtrl.dispose();
    _shippingLastNameCtrl.dispose();
    _shippingEmailCtrl.dispose();
    _shippingPhoneCtrl.dispose();
    _shippingAddressCtrl.dispose();
    _shippingCityCtrl.dispose();
    _shippingPostcodeCtrl.dispose();
    _shippingCompanyCtrl.dispose();
    _shippingCountryDisplayCtrl.dispose();
    _shippingStateDisplayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<CheckoutBloc>().add(ClearCheckoutMessage());
        }
        if (state.successMessage != null &&
            state.status == CheckoutStatus.orderPlaced) {
          // Reload cart after successful order
          context.read<CartBloc>().add(LoadCart());
          // Navigate to Thank You page (replaces checkout in the stack)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ThankyouPage(
                orderId: state.orderResponse?.orderId,
                orderIncrementId: state.orderResponse?.orderIncrementId,
              ),
            ),
          );
        }
        // Sync local address selections with bloc state
        if (state.selectedAddress != null && _selectedBillingAddress == null) {
          _selectedBillingAddress = state.selectedAddress;
        }
        // Reset local selections when bloc resets downstream state
        if (!state.addressConfirmed) {
          _selectedShippingMethod = null;
          _selectedPaymentMethod = null;
        }
        // Sync local shipping method selection with bloc state (for auto-select)
        if (state.selectedShippingMethod != null &&
            _selectedShippingMethod == null) {
          _selectedShippingMethod = state.selectedShippingMethod;
        }
        // Sync local payment method selection with bloc state
        if (state.selectedPaymentMethod != null &&
            _selectedPaymentMethod == null) {
          _selectedPaymentMethod = state.selectedPaymentMethod;
        }
        if (state.selectedShippingMethod == null) {
          _selectedShippingMethod = null;
        }
        if (state.selectedPaymentMethod == null) {
          _selectedPaymentMethod = null;
        }
      },
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cart = state.cart;
        return Scaffold(
          backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Billing Address
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildBillingSection(context, state),
                        ),
                        const SizedBox(height: 16),
                        // Shipping Address (only when NOT using same address)
                        if (!_useSameAddress) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildShippingAddressSection(context, state),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Cart Items
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildCartItemsSection(context, cart),
                        ),
                        const SizedBox(height: 16),
                        // Shipping Method
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildShippingMethodSection(context, state),
                        ),
                        const SizedBox(height: 8),
                        // Payment Method
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildPaymentMethodSection(context, state),
                        ),
                        const SizedBox(height: 32),
                        // Coupon
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildCouponSection(context, state),
                        ),
                        const SizedBox(height: 32),
                        // Price Break
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildPriceBreakSection(context, cart),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(context, cart, state),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================================
  // APP BAR
  // =====================================================================

  Widget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.neutral900 : AppColors.white,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? AppColors.neutral100 : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // BILLING SECTION  (Figma node 204:6679)
  // =====================================================================

  Widget _buildBillingSection(BuildContext context, CheckoutState state) {
    // Loading
    if (state.isLoading && state.status == CheckoutStatus.loading) {
      return _buildLoadingCard();
    }

    // Address confirmed → Figma-exact card
    if (state.addressConfirmed && state.selectedAddress != null) {
      return _buildAddressCard(
        context: context,
        state: state,
        label: 'Billing to',
        address: state.selectedAddress!,
        onChangePressed: () =>
            _showChangeAddressFlow(context, state, isBilling: true),
        showSameAddressCheckbox: true,
      );
    }

    // Guest → form
    if (state.isGuest) {
      return _buildGuestBillingForm(context, state);
    }

    // Logged-in with saved addresses (not yet confirmed)
    if (state.addresses.isNotEmpty) {
      final displayAddr = _selectedBillingAddress ?? state.selectedAddress;
      if (displayAddr != null) {
        return _buildAddressCardWithConfirm(
          context: context,
          state: state,
          label: 'Billing to',
          address: displayAddr,
          onChangePressed: () =>
              _showAddressSelectionSheet(context, state, isBilling: true),
          showSameAddressCheckbox: true,
        );
      }
      return _buildSelectAddressPrompt(
        context,
        state,
        label: 'Select Billing Address',
        onTap: () =>
            _showAddressSelectionSheet(context, state, isBilling: true),
      );
    }

    // Logged-in but no saved addresses
    return _buildGuestBillingForm(context, state);
  }

  // =====================================================================
  // SHIPPING ADDRESS SECTION  (Figma node 204:6694)
  // =====================================================================

  Widget _buildShippingAddressSection(
    BuildContext context,
    CheckoutState state,
  ) {
    if (state.isGuest) {
      return _buildGuestShippingForm(context, state);
    }
    if (state.addresses.isNotEmpty) {
      final displayAddr =
          _selectedShippingAddress ??
          (state.addresses.length > 1
              ? state.addresses[1]
              : state.addresses.first);
      return _buildAddressCard(
        context: context,
        state: state,
        label: 'Delivered to',
        address: displayAddr,
        onChangePressed: () =>
            _showAddressSelectionSheet(context, state, isBilling: false),
        showSameAddressCheckbox: false,
      );
    }
    return _buildGuestShippingForm(context, state);
  }

  // =====================================================================
  // FIGMA-EXACT ADDRESS CARD
  // =====================================================================

  Widget _buildAddressCard({
    required BuildContext context,
    required CheckoutState state,
    required String label,
    required CheckoutAddress address,
    required VoidCallback onChangePressed,
    required bool showSameAddressCheckbox,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressTitleRow(label, address, onChangePressed, isDark),
          const SizedBox(height: 6),
          Text(
            address.displayName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            address.fullAddress,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
          ),
          if (showSameAddressCheckbox) ...[
            const SizedBox(height: 10),
            Container(height: 1, color: isDark ? AppColors.neutral700 : AppColors.white),
            const SizedBox(height: 10),
            _buildSameAddressCheckbox(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressCardWithConfirm({
    required BuildContext context,
    required CheckoutState state,
    required String label,
    required CheckoutAddress address,
    required VoidCallback onChangePressed,
    required bool showSameAddressCheckbox,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressTitleRow(label, address, onChangePressed, isDark),
          const SizedBox(height: 6),
          Text(
            address.displayName,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            address.fullAddress,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
          ),
          if (address.phone != null && address.phone!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Phone: ${address.phone}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                color: isDark ? AppColors.neutral400 : AppColors.neutral800,
              ),
            ),
          ],
          if (showSameAddressCheckbox) ...[
            const SizedBox(height: 10),
            Container(height: 1, color: isDark ? AppColors.neutral700 : AppColors.white),
            const SizedBox(height: 10),
            _buildSameAddressCheckbox(context),
          ],
          const SizedBox(height: 16),
          _buildSaveAddressButton(context, state),
        ],
      ),
    );
  }

  /// Title row: label + green chip + "Change"
  Widget _buildAddressTitleRow(
    String label,
    CheckoutAddress address,
    VoidCallback onChangePressed,
    bool isDark,
  ) {
    final chipText = _getAddressTypeChip(address);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral300 : AppColors.neutral900,
              ),
            ),
            if (chipText.isNotEmpty) ...[
              const SizedBox(width: 4),
              _buildGreenChip(chipText),
            ],
          ],
        ),
        GestureDetector(
          onTap: onChangePressed,
          child: const Text(
            'Change',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF155DFC),
            ),
          ),
        ),
      ],
    );
  }

  /// Green badge chip (Figma node 233:5469)
  Widget _buildGreenChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        border: Border.all(color: const Color(0xFFB9F8CF)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: Color(0xFF00A63E),
        ),
      ),
    );
  }

  String _getAddressTypeChip(CheckoutAddress address) {
    final type = address.addressType.toLowerCase();
    if (type.contains('office') || type.contains('work')) return 'Office';
    if (type.contains('home')) return 'Home';
    if (type.contains('billing') || type.contains('cart_billing')) {
      return 'Billing';
    }
    if (type.contains('shipping') || type.contains('cart_shipping')) {
      return 'Shipping';
    }
    if (address.defaultAddress) return 'Default';
    if (address.companyName != null && address.companyName!.isNotEmpty) {
      return 'Office';
    }
    return 'Home';
  }

  Widget _buildSelectAddressPrompt(
    BuildContext context,
    CheckoutState state, {
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: isDark ? AppColors.neutral500 : AppColors.neutral400,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: isDark ? AppColors.neutral500 : AppColors.neutral400),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // ADDRESS SELECTION BOTTOM SHEET (logged-in users)
  // =====================================================================

  void _showAddressSelectionSheet(
    BuildContext context,
    CheckoutState state, {
    required bool isBilling,
  }) {
    final addresses = state.addresses;
    if (addresses.isEmpty) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bloc = context.read<CheckoutBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.neutral700 : AppColors.neutral300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    isBilling
                        ? 'Select Billing Address'
                        : 'Select Shipping Address',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: addresses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) {
                        final addr = addresses[index];
                        final isSelected = isBilling
                            ? _selectedBillingAddress?.id == addr.id
                            : _selectedShippingAddress?.id == addr.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isBilling) {
                                _selectedBillingAddress = addr;
                                bloc.add(SelectSavedAddress(address: addr));
                              } else {
                                _selectedShippingAddress = addr;
                              }
                            });
                            Navigator.pop(ctx);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary500.withValues(alpha: 0.05)
                                  : (isDark ? AppColors.neutral800 : AppColors.neutral100),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary500
                                    : (isDark ? AppColors.neutral700 : AppColors.neutral200),
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        addr.displayName,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: isSelected
                                              ? AppColors.primary500
                                              : (isDark ? AppColors.neutral100 : AppColors.neutral900),
                                        ),
                                      ),
                                    ),
                                    _buildGreenChip(_getAddressTypeChip(addr)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  addr.fullAddress,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 13,
                                    color: isDark ? AppColors.neutral400 : AppColors.neutral800,
                                  ),
                                ),
                                if (addr.phone != null &&
                                    addr.phone!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'Phone: ${addr.phone}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      color: isDark ? AppColors.neutral500 : AppColors.neutral500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangeAddressFlow(
    BuildContext context,
    CheckoutState state, {
    required bool isBilling,
  }) {
    if (state.isGuest || state.addresses.isEmpty) {
      // Guest or logged-in with no saved addresses: reset to form
      context.read<CheckoutBloc>().add(ResetAddressConfirmation());
    } else {
      _showAddressSelectionSheet(context, state, isBilling: isBilling);
    }
  }

  // =====================================================================
  // GUEST BILLING FORM
  // =====================================================================

  Widget _buildGuestBillingForm(BuildContext context, CheckoutState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _billingFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.isGuest ? 'Billing Address' : 'Enter Address',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _billingFirstNameCtrl,
                    'First Name',
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _billingLastNameCtrl,
                    'Last Name',
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _billingEmailCtrl,
              'Email',
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _billingPhoneCtrl,
              'Phone',
              keyboardType: TextInputType.phone,
              required: true,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _billingAddressCtrl,
              'Street Address',
              required: true,
            ),
            const SizedBox(height: 12),
            // Country dropdown (searchable bottom sheet)
            _buildCountrySelector(
              displayCtrl: _billingCountryDisplayCtrl,
              selectedCountry: _selectedBillingCountry,
              countries: state.countries,
              isLoading: state.countries.isEmpty,
              onSelected: (country) {
                setState(() {
                  _selectedBillingCountry = country;
                  _billingCountryDisplayCtrl.text = country.name;
                  _billingCountry = country.code;
                  _billingState = '';
                  _selectedBillingState = null;
                  _billingStateDisplayCtrl.clear();
                });
                if (country.numericId > 0 || country.code.isNotEmpty) {
                  context.read<CheckoutBloc>().add(
                    FetchCountryStates(
                      countryId: country.numericId,
                      countryCode: country.code,
                      formType: 'billing',
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            // State dropdown (searchable bottom sheet, dynamic based on country)
            _buildStateSelector(
              displayCtrl: _billingStateDisplayCtrl,
              selectedState: _selectedBillingState,
              states: state.billingStates,
              hasCountry: _selectedBillingCountry != null,
              isLoading: state.billingStatesLoading,
              onSelected: (stateObj) {
                setState(() {
                  _selectedBillingState = stateObj;
                  _billingStateDisplayCtrl.text = stateObj.defaultName;
                  _billingState = stateObj.code ?? stateObj.defaultName;
                });
              },
              onManualChanged: (text) {
                _selectedBillingState = null;
                _billingState = text;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _billingCityCtrl,
                    'City',
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _billingPostcodeCtrl,
                    'Postcode',
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(_billingCompanyCtrl, 'Company (Optional)'),
            const SizedBox(height: 12),
            _buildSameAddressCheckbox(context),
            const SizedBox(height: 16),
            _buildSaveAddressButton(context, state),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // GUEST SHIPPING FORM
  // =====================================================================

  Widget _buildGuestShippingForm(BuildContext context, CheckoutState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _shippingFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Delivered to',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral900,
                  ),
                ),
                const SizedBox(width: 4),
                _buildGreenChip('Shipping'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _shippingFirstNameCtrl,
                    'First Name',
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _shippingLastNameCtrl,
                    'Last Name',
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _shippingEmailCtrl,
              'Email',
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _shippingPhoneCtrl,
              'Phone',
              keyboardType: TextInputType.phone,
              required: true,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _shippingAddressCtrl,
              'Street Address',
              required: true,
            ),
            const SizedBox(height: 12),
            // Country dropdown (searchable bottom sheet)
            _buildCountrySelector(
              displayCtrl: _shippingCountryDisplayCtrl,
              selectedCountry: _selectedShippingCountry,
              countries: state.countries,
              isLoading: state.countries.isEmpty,
              onSelected: (country) {
                setState(() {
                  _selectedShippingCountry = country;
                  _shippingCountryDisplayCtrl.text = country.name;
                  _shippingCountry = country.code;
                  _shippingState = '';
                  _selectedShippingState = null;
                  _shippingStateDisplayCtrl.clear();
                });
                if (country.numericId > 0 || country.code.isNotEmpty) {
                  context.read<CheckoutBloc>().add(
                    FetchCountryStates(
                      countryId: country.numericId,
                      countryCode: country.code,
                      formType: 'shipping',
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            // State dropdown (searchable bottom sheet, dynamic based on country)
            _buildStateSelector(
              displayCtrl: _shippingStateDisplayCtrl,
              selectedState: _selectedShippingState,
              states: state.shippingStates,
              hasCountry: _selectedShippingCountry != null,
              isLoading: state.shippingStatesLoading,
              onSelected: (stateObj) {
                setState(() {
                  _selectedShippingState = stateObj;
                  _shippingStateDisplayCtrl.text = stateObj.defaultName;
                  _shippingState = stateObj.code ?? stateObj.defaultName;
                });
              },
              onManualChanged: (text) {
                _selectedShippingState = null;
                _shippingState = text;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _shippingCityCtrl,
                    'City',
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _shippingPostcodeCtrl,
                    'Postcode',
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(_shippingCompanyCtrl, 'Company (Optional)'),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // FORM WIDGETS
  // =====================================================================

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: isDark ? AppColors.neutral500 : AppColors.neutral400,
        ),
        filled: true,
        fillColor: isDark ? AppColors.neutral800 : AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary500),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        isDense: true,
      ),
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: isDark ? AppColors.neutral100 : AppColors.neutral900,
      ),
    );
  }

  Widget _buildCountrySelector({
    required TextEditingController displayCtrl,
    required BagistoCountry? selectedCountry,
    required List<BagistoCountry> countries,
    required bool isLoading,
    required void Function(BagistoCountry) onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: isLoading || countries.isEmpty
          ? null
          : () async {
              final selected = await SelectionSheet.show<BagistoCountry>(
                context: context,
                title: 'Select Country',
                items: countries,
                selectedItem: selectedCountry,
                itemLabel: (c) => c.name,
              );
              if (!mounted || selected == null) return;
              // Wait for bottom sheet dismiss animation
              await WidgetsBinding.instance.endOfFrame;
              await WidgetsBinding.instance.endOfFrame;
              if (!mounted) return;
              onSelected(selected);
            },
      child: AbsorbPointer(
        child: TextFormField(
          controller: displayCtrl,
          readOnly: true,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Country is required' : null,
          decoration: InputDecoration(
            labelText: 'Country',
            labelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: isDark ? AppColors.neutral500 : AppColors.neutral400,
            ),
            filled: true,
            fillColor: isDark ? AppColors.neutral800 : AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.neutral700 : AppColors.neutral200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.neutral700 : AppColors.neutral200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary500),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            isDense: true,
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? AppColors.neutral500 : AppColors.neutral800,
                  ),
          ),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: isDark ? AppColors.neutral100 : AppColors.neutral900,
          ),
        ),
      ),
    );
  }

  Widget _buildStateSelector({
    required TextEditingController displayCtrl,
    required BagistoCountryState? selectedState,
    required List<BagistoCountryState> states,
    required bool hasCountry,
    required bool isLoading,
    required void Function(BagistoCountryState) onSelected,
    required void Function(String) onManualChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasStates = states.isNotEmpty;

    if (!hasStates) {
      return TextFormField(
        controller: displayCtrl,
        readOnly: !hasCountry || isLoading,
        enabled: hasCountry,
        onChanged: onManualChanged,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'State is required' : null,
        decoration: InputDecoration(
          labelText: 'State',
          labelStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: isDark ? AppColors.neutral500 : AppColors.neutral400,
          ),
          hintText: !hasCountry ? 'Select country first' : null,
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: isDark ? AppColors.neutral500 : AppColors.neutral400,
          ),
          filled: true,
          fillColor: isDark ? AppColors.neutral800 : AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary500),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
          suffixIcon: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary500,
                    ),
                  ),
                )
              : null,
        ),
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: isDark ? AppColors.neutral100 : AppColors.neutral900,
        ),
      );
    }

    return GestureDetector(
      onTap: (!hasCountry || isLoading)
          ? null
          : () async {
              final selected = await SelectionSheet.show<BagistoCountryState>(
                context: context,
                title: 'Select State',
                items: states,
                selectedItem: selectedState,
                itemLabel: (s) => s.defaultName,
              );
              if (!mounted || selected == null) return;
              // Wait for bottom sheet dismiss animation
              await WidgetsBinding.instance.endOfFrame;
              await WidgetsBinding.instance.endOfFrame;
              if (!mounted) return;
              onSelected(selected);
            },
      child: AbsorbPointer(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              controller: displayCtrl,
              readOnly: true,
              enabled: hasCountry && !isLoading,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'State is required' : null,
              decoration: InputDecoration(
                labelText: 'State',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                ),
                hintText: !hasCountry ? 'Select country first' : null,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                ),
                filled: true,
                fillColor: isDark ? AppColors.neutral800 : AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary500),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                isDense: true,
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary500,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.keyboard_arrow_down,
                        color: isDark ? AppColors.neutral500 : AppColors.neutral800,
                      ),
              ),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Checkbox: "Use same address for shipping?"  (Figma node 204:6691)
  Widget _buildSameAddressCheckbox(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() => _useSameAddress = !_useSameAddress);
        context.read<CheckoutBloc>().add(ToggleSameAddress());
      },
      child: SizedBox(
        height: 24,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: _useSameAddress
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 18,
                        color: AppColors.white,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
            ),
            const SizedBox(width: 4),
            Text(
              ' Use same address for shipping? ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveAddressButton(BuildContext context, CheckoutState state) {
    return GestureDetector(
      onTap: state.isLoading ? null : () => _onSaveAddress(context, state),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: state.isLoading ? AppColors.neutral400 : AppColors.primary500,
          borderRadius: BorderRadius.circular(54),
        ),
        child: Center(
          child: state.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Text(
                  'Save & Continue',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }

  void _onSaveAddress(BuildContext context, CheckoutState state) {
    Map<String, dynamic> input;

    if (state.isGuest || state.selectedAddress == null) {
      if (_billingFormKey.currentState == null ||
          !_billingFormKey.currentState!.validate())
        return;

      input = {
        'billingFirstName': _billingFirstNameCtrl.text.trim(),
        'billingLastName': _billingLastNameCtrl.text.trim(),
        'billingEmail': _billingEmailCtrl.text.trim(),
        'billingCompanyName': _billingCompanyCtrl.text.trim(),
        'billingAddress': _billingAddressCtrl.text.trim(),
        'billingCity': _billingCityCtrl.text.trim(),
        'billingCountry': _billingCountry,
        'billingState': _billingState,
        'billingPostcode': _billingPostcodeCtrl.text.trim(),
        'billingPhoneNumber': _billingPhoneCtrl.text.trim(),
        'useForShipping': _useSameAddress,
      };

      if (!_useSameAddress) {
        if (_shippingFormKey.currentState == null ||
            !_shippingFormKey.currentState!.validate())
          return;
        input.addAll({
          'shippingFirstName': _shippingFirstNameCtrl.text.trim(),
          'shippingLastName': _shippingLastNameCtrl.text.trim(),
          'shippingEmail': _shippingEmailCtrl.text.trim(),
          'shippingCompanyName': _shippingCompanyCtrl.text.trim(),
          'shippingAddress': _shippingAddressCtrl.text.trim(),
          'shippingCity': _shippingCityCtrl.text.trim(),
          'shippingCountry': _shippingCountry,
          'shippingState': _shippingState,
          'shippingPostcode': _shippingPostcodeCtrl.text.trim(),
          'shippingPhoneNumber': _shippingPhoneCtrl.text.trim(),
        });
      }

      // Build address from form for display
      final formAddr = CheckoutAddress(
        id: '',
        firstName: _billingFirstNameCtrl.text.trim(),
        lastName: _billingLastNameCtrl.text.trim(),
        companyName: _billingCompanyCtrl.text.trim(),
        address: _billingAddressCtrl.text.trim(),
        city: _billingCityCtrl.text.trim(),
        state: _billingState,
        country: _billingCountry,
        postcode: _billingPostcodeCtrl.text.trim(),
        phone: _billingPhoneCtrl.text.trim(),
        email: _billingEmailCtrl.text.trim(),
      );
      context.read<CheckoutBloc>().add(SelectSavedAddress(address: formAddr));
    } else {
      input = state.selectedAddress!.toBillingInput(
        useForShipping: _useSameAddress,
      );

      if (!_useSameAddress && _selectedShippingAddress != null) {
        final sa = _selectedShippingAddress!;
        input.addAll({
          'shippingFirstName': sa.firstName,
          'shippingLastName': sa.lastName,
          'shippingEmail': sa.email ?? '',
          'shippingCompanyName': sa.companyName ?? '',
          'shippingAddress': sa.address,
          'shippingCity': sa.city,
          'shippingCountry': sa.country ?? '',
          'shippingState': sa.state ?? '',
          'shippingPostcode': sa.postcode ?? '',
          'shippingPhoneNumber': sa.phone ?? '',
        });
      }
    }

    context.read<CheckoutBloc>().add(SaveCheckoutAddressEvent(input: input));
  }

  // =====================================================================
  // CART ITEMS
  // =====================================================================

  Widget _buildCartItemsSection(BuildContext context, CartModel cart) {
    final items = cart.items;
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text(
            'Your cart is empty',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: AppColors.neutral400,
            ),
          ),
        ),
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${items.length} Item${items.length > 1 ? 's' : ''} in the Cart',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : Colors.black,
          ),
        ),
        ...items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return _buildCartItemWidget(
            imageUrl: item.imageUrl,
            name: item.name,
            pricePerUnit: '\$${item.price.toStringAsFixed(2)}',
            quantity: item.quantity,
            totalPrice: '\$${item.totalPrice.toStringAsFixed(2)}',
            showBorder: idx < items.length - 1,
          );
        }),
      ],
    );
  }

  Widget _buildCartItemWidget({
    String? imageUrl,
    required String name,
    required String pricePerUnit,
    required int quantity,
    required String totalPrice,
    required bool showBorder,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(color: isDark ? AppColors.neutral700 : AppColors.neutral200, width: 1),
              )
            : null,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 62,
              height: 62,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
                      errorWidget: (_, __, ___) => Container(
                        color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                        child: Icon(
                          Icons.image,
                          color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                        ),
                      ),
                    )
                  : Container(
                      color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                      child: Icon(
                        Icons.image,
                        color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                        size: 30,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$pricePerUnit x $quantity Units',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: isDark ? AppColors.neutral300 : AppColors.neutral900,
                      ),
                    ),
                    Text(
                      totalPrice,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // SHIPPING METHOD  (Figma node 204:6800)
  // =====================================================================

  Widget _buildShippingMethodSection(
    BuildContext context,
    CheckoutState state,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!state.addressConfirmed) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Method',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral900 : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
  child: Text(
    'Save your address to see shipping options',
    style: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 13,
      color: isDark ? AppColors.neutral500 : AppColors.neutral400,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
  ),
),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final rates = state.shippingRates;
    if (rates.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Method',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Method',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
              const SizedBox(),
            ],
          ),
          const SizedBox(height: 6),
          ...rates.asMap().entries.map((entry) {
            final rate = entry.value;
            final isSelected =
                (_selectedShippingMethod ?? rates.first.code) == rate.code;
            return _buildRadioOption(
              isSelected: isSelected,
              title: rate.displayPrice,
              subtitle: rate.displayLabel,
              onTap: () {
                setState(() => _selectedShippingMethod = rate.code);
                context.read<CheckoutBloc>().add(
                  SelectShippingMethod(shippingMethodCode: rate.method),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // =====================================================================
  // PAYMENT METHOD  (Figma node 204:6819)
  // =====================================================================

  Widget _buildPaymentMethodSection(BuildContext context, CheckoutState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (state.selectedShippingMethod == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral900 : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Select a shipping method first',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final methods = state.paymentMethods;
    if (methods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method ',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
              const SizedBox(),
            ],
          ),
          const SizedBox(height: 6),
          ...methods.map((method) {
            final isSelected = (_selectedPaymentMethod ?? '') == method.method;
            return _buildPaymentOptionRow(
              isSelected: isSelected,
              title: method.title,
              subtitle: method.description ?? '',
              paymentCode: method.method,
              onTap: () {
                setState(() => _selectedPaymentMethod = method.method);
                context.read<CheckoutBloc>().add(
                  SelectPaymentMethod(paymentMethodCode: method.method),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // =====================================================================
  // PAYMENT ICON HELPER
  // =====================================================================

  Widget _getPaymentIcon(String code) {
    IconData iconData;
    Color bgColor;
    Color iconColor;

    switch (code) {
      case 'paypal_smart_button':
        iconData = Icons.paypal_outlined;
        bgColor = const Color(0xFFE8F0FE);
        iconColor = const Color(0xFF003087);
        break;
      case 'cashondelivery':
        iconData = Icons.local_atm;
        bgColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF2E7D32);
        break;
      case 'moneytransfer':
        iconData = Icons.account_balance;
        bgColor = const Color(0xFFE3F2FD);
        iconColor = const Color(0xFF1565C0);
        break;
      case 'paypal_standard':
        iconData = Icons.paypal;
        bgColor = const Color(0xFFFFF3E0);
        iconColor = const Color(0xFF003087);
        break;
      default:
        iconData = Icons.payment;
        bgColor = AppColors.white;
        iconColor = AppColors.neutral800;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(iconData, size: 22, color: iconColor),
    );
  }

  Widget _buildPaymentOptionRow({
    required bool isSelected,
    required String title,
    required String subtitle,
    required String paymentCode,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: isSelected
                      ? _buildFilledRadio()
                      : _buildEmptyRadio(isDark: isDark),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral300
                              : AppColors.neutral900,
                        ),
                      ),
                    ],
                  ),
                ),
                _getPaymentIcon(paymentCode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // RADIO BUTTONS
  // =====================================================================

  Widget _buildRadioOption({
    required bool isSelected,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: isSelected
                      ? _buildFilledRadio()
                      : _buildEmptyRadio(isDark: isDark),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral300
                              : AppColors.neutral900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilledRadio() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary500, width: 2),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyRadio({bool isDark = false}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isDark ? AppColors.neutral600 : AppColors.neutral400, width: 2),
      ),
    );
  }

  // =====================================================================
  // COUPON  (Figma node 204:6832)
  // =====================================================================

  Widget _buildCouponSection(BuildContext context, CheckoutState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apply Coupon',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral100 : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.neutral800 : AppColors.white,
                      border: Border.all(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              hintText: 'Enter your coupon code',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        if (_couponController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _couponController.clear();
                              if (state.couponCode != null &&
                                  state.couponCode!.isNotEmpty) {
                                context.read<CheckoutBloc>().add(
                                  RemoveCheckoutCoupon(),
                                );
                              }
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: isDark ? AppColors.neutral300 : AppColors.neutral900,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 9,
                    top: -10,
                    child: Container(
                      color: isDark ? AppColors.neutral900 : AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        'Coupon Code',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: isDark ? AppColors.neutral400 : AppColors.neutral800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                final code = _couponController.text.trim();
                if (code.isNotEmpty) {
                  context.read<CheckoutBloc>().add(
                    ApplyCheckoutCoupon(couponCode: code),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.circular(54),
                ),
                child: const Text(
                  'Apply Coupon',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =====================================================================
  // PRICE BREAK  (Figma node 204:6838)
  // =====================================================================

  Widget _buildPriceBreakSection(BuildContext context, CartModel cart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtotal = cart.subtotal > 0
        ? '\$${_formatPrice(cart.subtotal)}'
        : '\$0.00';
    final discount = cart.discountAmount > 0
        ? '-\$${_formatPrice(cart.discountAmount)}'
        : '\$0.00';
    final shipping = cart.shippingAmount > 0
        ? '\$${_formatPrice(cart.shippingAmount)}'
        : '\$0.00';
    final tax = cart.taxAmount > 0
        ? '\$${_formatPrice(cart.taxAmount)}'
        : '\$0.00';
    final grandTotal = cart.grandTotal > 0
        ? '\$${_formatPrice(cart.grandTotal)}'
        : '\$0.00';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Break',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral100 : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildPriceRow('SubTotal', subtotal, isDark: isDark),
        const SizedBox(height: 8),
        _buildPriceRow('Discount (Coupon)', discount, isDark: isDark),
        const SizedBox(height: 8),
        _buildPriceRow('Delivery Charges', shipping, isDark: isDark),
        const SizedBox(height: 8),
        _buildPriceRow('Tax', tax, isDark: isDark),
        const SizedBox(height: 8),
        _buildPriceRow('Grand Total', grandTotal, isDark: isDark, isBold: true),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDark = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral300 : AppColors.neutral800,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral100 : AppColors.neutral800,
          ),
        ),
      ],
    );
  }

  // =====================================================================
  // BOTTOM BAR  (Figma node 204:6857)
  // =====================================================================

  Widget _buildBottomBar(
    BuildContext context,
    CartModel cart,
    CheckoutState state,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grandTotal = cart.grandTotal > 0
        ? '\$${_formatPrice(cart.grandTotal)}'
        : '\$0.00';
    final canPlace = state.canPlaceOrder;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral900 : AppColors.neutral50,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grandTotal,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? AppColors.neutral100 : AppColors.neutral800,
                    ),
                  ),
                  Text(
                    'Amount to be Paid',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark ? AppColors.neutral400 : AppColors.neutral800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: (!canPlace || state.isPlacingOrder)
                  ? null
                  : () => context.read<CheckoutBloc>().add(PlaceOrder()),
              child: Container(
                width: 131,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: canPlace ? AppColors.primary500 : AppColors.neutral400,
                  borderRadius: BorderRadius.circular(54),
                ),
                child: Center(
                  child: state.isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Text(
                          'Place Order',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // HELPERS
  // =====================================================================

  Widget _buildLoadingCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      final parts = price.toStringAsFixed(2).split('.');
      final intPart = parts[0];
      final decPart = parts[1];
      final buffer = StringBuffer();
      int count = 0;
      for (int i = intPart.length - 1; i >= 0; i--) {
        buffer.write(intPart[i]);
        count++;
        if (count % 3 == 0 && i > 0) {
          buffer.write(',');
        }
      }
      return '${buffer.toString().split('').reversed.join('')}.$decPart';
    }
    return price.toStringAsFixed(2);
  }

  // _showOrderSuccessDialog removed — navigation to ThankyouPage is
  // handled directly in the BlocConsumer listener above.
}
