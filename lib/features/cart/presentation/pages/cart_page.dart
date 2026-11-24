import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/currency/currency_formatter.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../../../core/store_config/store_config.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/data/models/cart_model.dart';
import '../../../category/data/models/product_model.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../../checkout/presentation/helpers/checkout_access_guard.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../account/presentation/bloc/wishlist_bloc.dart';
import '../../../account/presentation/pages/wishlist_page.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../../checkout/data/models/checkout_model.dart';
import '../../data/repository/cart_repository.dart';
import '../bloc/cart_bloc.dart';
import '../../../home/data/models/home_models.dart';
import '../../../home/presentation/widgets/product_card_large.dart';

/// Cart page matching Figma design node 152-5713
///
/// Layout (from Figma):
///  ┌──────────────────────────────────┐
///  │  ← Cart                    ♡    │  navigation-bar/title
///  ├──────────────────────────────────┤
///  │  N Items in the Cart             │
///  ├──────────────────────────────────┤
///  │  ┌────┐ Name                    │
///  │  │IMG │ $price x N Units  $total│  cart-item
///  │  │    │ [−] qty [+] 🗑️ ♡       │
///  │  └────┘ View More / View Less   │
///  │  (expanded details if bundle)   │
///  ├──────────────────────────────────┤
///  │  [→ Continue Shopping] [🗑 Empty]│
///  ├──────────────────────────────────┤
///  │  Apply Coupon                    │
///  │  [________coupon code____][Apply]│
///  │  ┌ Applied Coupon ────── Remove┐│
///  │  │ DOB2026                     ││
///  │  └─────────────────────────────┘│
///  ├──────────────────────────────────┤
///  │  Price Break                     │
///  │  SubTotal           $13,315.80  │
///  │  Discount               $0.00   │
///  │  Delivery Charges       $0.00   │
///  │  Tax                    $0.00   │
///  │  Grand Total        $13,315.80  │
///  ├──────────────────────────────────┤
///  │  $13,315.80        [  Pay Now  ]│  sticky bottom
///  │  Amount to be Paid              │
///  └──────────────────────────────────┘
class CartPage extends StatefulWidget {
  final bool isActive;
  const CartPage({super.key, this.isActive = true});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _couponController = TextEditingController();
  final FocusNode _couponFocusNode = FocusNode();
  final TextEditingController _estimateStateController =
      TextEditingController();
  final TextEditingController _estimateZipController = TextEditingController();
  final Set<int> _expandedItems = {};
  bool _wasApplyingCoupon = false;
  bool _hadCoupon = false;
  bool _taxBreakdownExpanded = false;
  bool _estimateShippingExpanded = false;
  List<BagistoCountry> _countries = [];
  BagistoCountry? _selectedCountry;
  List<BagistoCountryState> _countryStates = [];
  BagistoCountryState? _selectedState;
  bool _loadingCountries = false;
  bool _loadingStates = false;
  int _lastItemCount = 0;
  CartBloc? _cartBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<CartBloc>().state;
        _lastItemCount = state.cart.items.length;
        if (state.cart.items.isNotEmpty) {
          context.read<CartBloc>().add(const FetchCartCrossSellProductsEvent());
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartBloc = context.read<CartBloc>();
  }

  @override
  void didUpdateWidget(CartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive && !widget.isActive) {
      _resetEstimateShippingFields();
    }
  }

  void _resetEstimateShippingFields() {
    _estimateStateController.clear();
    _estimateZipController.clear();
    _selectedCountry = null;
    _selectedState = null;
    _countryStates = [];
    _estimateShippingExpanded = false;
    _taxBreakdownExpanded = false;
    _cartBloc?.add(const ResetEstimateShippingEvent());
  }

  @override
  void dispose() {
    _resetEstimateShippingFields();
    _couponController.dispose();
    _couponFocusNode.dispose();
    _estimateStateController.dispose();
    _estimateZipController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    if (_countries.isNotEmpty || _loadingCountries) return;
    setState(() => _loadingCountries = true);
    try {
      final repo = context.read<CartRepository>();
      final list = await repo.getCountries();
      if (mounted) {
        setState(() {
          _countries = list;
          _loadingCountries = false;
          if (_selectedCountry == null && list.isNotEmpty) {
            _selectedCountry = list.first;
            _loadStatesForCountry(_selectedCountry!);
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingCountries = false);
    }
  }

  Future<void> _loadStatesForCountry(BagistoCountry country) async {
    setState(() {
      _loadingStates = true;
      _countryStates = [];
      _selectedState = null;
      _estimateStateController.clear();
    });
    try {
      final repo = context.read<CartRepository>();
      final states = await repo.getCountryStates(country.numericId);
      if (mounted) {
        setState(() {
          _countryStates = states;
          _loadingStates = false;
          if (states.isNotEmpty) {
            _selectedState = states.first;
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingStates = false);
    }
  }

  /// "N Units in the Cart" or "N Items in the Cart", per the admin
  /// cart summary setting.
  String _cartSummaryText(BuildContext context, CartModel cart) {
    final l10n = AppLocalizations.of(context)!;
    final config = StoreConfig.of(context);
    final count = config.cartCount(
      itemsCount: cart.itemsCount,
      itemsQty: cart.itemsQty,
    );
    final String unit;
    if (config.cartSummaryShowsItemCount) {
      unit = count == 1 ? l10n.accountItemSingular : l10n.accountItemPlural;
    } else {
      unit = count == 1 ? l10n.cartUnit : l10n.cartUnits;
    }
    return l10n.cartItemsInCart(count, unit);
  }

  /// Minimum order message from the API, or the app text with the amount.
  String _minimumOrderMessage(BuildContext context, StoreConfig config) {
    return config.minimumOrderMessage ??
        'Minimum order amount is ${CurrencyFormatter.formatAmount(config.minimumOrderAmount)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        // Clear the coupon input only when an apply attempt ends without a
        // coupon (invalid code) or an applied coupon goes away. Keep the
        // typed code visible while it is being applied.
        final applyFailed =
            _wasApplyingCoupon &&
            !state.isApplyingCoupon &&
            !state.cart.hasCoupon;
        final couponRemoved = _hadCoupon && !state.cart.hasCoupon;
        _wasApplyingCoupon = state.isApplyingCoupon;
        _hadCoupon = state.cart.hasCoupon;
        if (applyFailed || couponRemoved) {
          _couponController.clear();
        }
        if (state.cart.items.length != _lastItemCount) {
          _lastItemCount = state.cart.items.length;
          if (state.cart.items.isNotEmpty) {
            context.read<CartBloc>().add(
              const FetchCartCrossSellProductsEvent(),
            );
          }
        }
        if (state.successMessage != null) {
          _showToast(
            context,
            _localizedCartMessage(context, state.successMessage!),
            isError: false,
          );
          context.read<CartBloc>().add(ClearCartMessage());
        }
        if (state.errorMessage != null) {
          _showToast(context, state.errorMessage!, isError: true);
          context.read<CartBloc>().add(ClearCartMessage());
        }
      },
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                // ── Navigation Bar / Title ──
                _buildNavigationBar(context, isDark),

                // ── Content ──
                Expanded(child: _buildBody(context, state, isDark)),

                // ── Sticky Bottom Bar ──
                if (state.cart.items.isNotEmpty)
                  _buildBottomBar(context, state, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Figma: navigation-bar/title
  Widget _buildNavigationBar(BuildContext context, bool isDark) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral900 : AppColors.white,
      ),
      child: Row(
        children: [
          // Back arrow
          AppBackButton(
            onTap: () {
              _resetEstimateShippingFields();
              // Cart is inside MainShell's IndexedStack, not pushed on
              // the nav stack. Use AppNavigator to go to previous tab.
              final nav = AppNavigator.maybeOf(context);
              if (nav != null) {
                AppNavigator.goCategories(context);
              } else if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          // Title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                AppLocalizations.of(context)!.cart,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.neutral200 : AppColors.black,
                ),
              ),
            ),
          ),
          // Wishlist icon
          if (StoreConfig.of(context).showWishlist)
            GestureDetector(
              onTap: () async {
                final accessToken = await AuthStorage.getToken();
                if (accessToken == null || accessToken.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.cartPleaseLoginWishlist,
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  return;
                }
                final client = GraphQLClientProvider.authenticatedClient(
                  accessToken,
                ).value;
                final repository = AccountRepository(client: client);
                if (context.mounted) {
                  final wishlistCubit = context.read<WishlistCubit>();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RepositoryProvider.value(
                        value: repository,
                        child: BlocProvider(
                          create: (_) => WishlistBloc(
                            repository: repository,
                            wishlistCubit: wishlistCubit,
                          )..add(const LoadWishlist()),
                          child: const WishlistPage(),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.favorite_border,
                  size: 24,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CartState state, bool isDark) {
    if (state.status == CartStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary500),
      );
    }

    if (state.cart.isEmpty) {
      return _buildEmptyCart(context, isDark);
    }

    return RefreshIndicator(
      color: AppColors.primary500,
      onRefresh: () async {
        context.read<CartBloc>().add(LoadCart());
        // Wait for the state to transition back to loaded
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOfferInfo(context, isDark),
            const SizedBox(height: 8),

            // ── "N Items in the Cart" ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _cartSummaryText(context, state.cart),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.neutral200 : AppColors.black,
                ),
              ),
            ),

            // ── Cart Items ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ...state.cart.items.map(
                    (item) => _buildCartItem(context, item, state, isDark),
                  ),
                ],
              ),
            ),

            // ── Continue Shopping / Empty Cart ──
            _buildActionButtons(context, isDark),

            const SizedBox(height: 32),

            // ── More Choices (Cross-sell Products) ──
            if (StoreConfig.of(context).showCartCrossSell &&
                state.crossSellProducts.isNotEmpty) ...[
              _buildCrossSellSection(context, state, isDark),
              const SizedBox(height: 32),
            ],

            // ── Estimate Shipping and Tax Section ──
            if (StoreConfig.of(context).showEstimateShipping &&
                state.cart.hasStockableItems) ...[
              _buildEstimateShippingSection(context, state, isDark),
              const SizedBox(height: 32),
            ],

            // ── Apply Coupon Section ──
            _buildCouponSection(context, state, isDark),

            const SizedBox(height: 32),

            // ── Price Break Section ──
            _buildPriceBreak(context, state.cart, isDark),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Admin "Mini Cart Offer Information" text, shown on the full and the
  /// empty cart like the storefront mini cart.
  Widget _buildOfferInfo(BuildContext context, bool isDark) {
    final offer = StoreConfig.of(context).cartOfferInfo;
    if (offer == null) return const SizedBox.shrink();
    return Container(
      key: const ValueKey('cart_offer_info'),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        offer,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.neutral200 : AppColors.neutral900,
        ),
      ),
    );
  }

  /// Empty cart state
  Widget _buildEmptyCart(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildOfferInfo(context, isDark),
        Expanded(child: _buildEmptyCartMessage(context, isDark)),
      ],
    );
  }

  Widget _buildEmptyCartMessage(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.cartYourCartEmpty,
            style: AppTextStyles.text4(context),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.cartAddProductsHere,
            style: AppTextStyles.text6(
              context,
            ).copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Continue Shopping button
          GestureDetector(
            onTap: () {
              // Switch to Categories tab via AppNavigator
              AppNavigator.goCategories(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(54),
              ),
              child: Text(
                AppLocalizations.of(context)!.cartContinueShopping,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Figma: cart-item component
  Widget _buildCartItem(
    BuildContext context,
    CartItemModel item,
    CartState state,
    bool isDark,
  ) {
    final isUpdating = state.updatingItemId == item.id;
    final isExpanded = _expandedItems.contains(item.id);
    final hasOptions = item.options.isNotEmpty;
    final config = StoreConfig.of(context);
    final l10n = AppLocalizations.of(context)!;
    final unitPrice = item.formattedUnitPrice(config);
    final lineTotal = item.formattedLineTotal(config);
    final lineTotalSubValue = item.formattedLineTotalSubValue(
      config,
      (amount) => l10n.cartExclTax(amount),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Opacity(
        opacity: isUpdating ? 0.5 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: Image + Details ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image (93x93, rounded 12)
                GestureDetector(
                  onTap: () {
                    if (item.productUrlKey != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(
                            urlKey: item.productUrlKey!,
                            productId: item.productId.toString(),
                            productName: item.name,
                            productType: item.type,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 93,
                    height: 93,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDark
                          ? AppColors.neutral700
                          : AppColors.neutral100,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: item.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: item.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: isDark
                                  ? AppColors.neutral700
                                  : AppColors.neutral200,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: isDark
                                  ? AppColors.neutral600
                                  : AppColors.neutral400,
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: AppColors.neutral400,
                          ),
                  ),
                ),

                const SizedBox(width: 10),

                // Details column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        item.name,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Price row: "$price x N Units" and "$total"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$unitPrice x ${item.quantity} ${item.quantity == 1 ? l10n.cartUnit : l10n.cartUnits}',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? AppColors.neutral300
                                        : AppColors.neutral900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                lineTotal,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.neutral200
                                      : AppColors.neutral900,
                                ),
                              ),
                              if (lineTotalSubValue != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    lineTotalSubValue,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.neutral400
                                          : AppColors.neutral500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Quantity controls + Delete + Wishlist
                      Row(
                        children: [
                          Container(
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark
                                    ? AppColors.neutral700
                                    : AppColors.neutral200,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildStepperButton(
                                  context,
                                  icon: Icons.remove,
                                  isDark: isDark,
                                  enabled: item.quantity > 1 && !isUpdating,
                                  onTap: () {
                                    context.read<CartBloc>().add(
                                      UpdateCartItemQuantity(
                                        cartItemId: item.id,
                                        quantity: item.quantity - 1,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: item.quantity >= 100 ? 42 : 34,
                                  child: Text(
                                    '${item.quantity}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.neutral200
                                          : AppColors.neutral900,
                                    ),
                                  ),
                                ),
                                _buildStepperButton(
                                  context,
                                  icon: Icons.add,
                                  isDark: isDark,
                                  enabled: !isUpdating,
                                  onTap: () {
                                    context.read<CartBloc>().add(
                                      UpdateCartItemQuantity(
                                        cartItemId: item.id,
                                        quantity: item.quantity + 1,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Delete
                          GestureDetector(
                            onTap: isUpdating
                                ? null
                                : () => _showDeleteConfirmation(
                                    context,
                                    item,
                                    isDark,
                                  ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 24,
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          BlocBuilder<WishlistCubit, WishlistCubitState>(
                            builder: (context, wishlistState) {
                              final isWishlisted =
                                  item.productId > 0 &&
                                  wishlistState.isWishlisted(item.productId);
                              final isWishlistProcessing =
                                  item.productId > 0 &&
                                  wishlistState.isProcessing(item.productId);

                              return GestureDetector(
                                onTap: isUpdating || isWishlistProcessing
                                    ? null
                                    : () => _handleWishlistAction(
                                        context,
                                        item,
                                        isWishlisted: isWishlisted,
                                      ),
                                child: isWishlistProcessing
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary500,
                                        ),
                                      )
                                    : Icon(
                                        isWishlisted
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 24,
                                        color: isWishlisted
                                            ? Colors.red
                                            : (isDark
                                                  ? AppColors.neutral400
                                                  : AppColors.neutral600),
                                      ),
                              );
                            },
                          ),
                        ],
                      ),

                      // ── View More / View Less toggle ──
                      if (hasOptions) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedItems.remove(item.id);
                              } else {
                                _expandedItems.add(item.id);
                              }
                            });
                          },
                          child: Text(
                            isExpanded
                                ? AppLocalizations.of(context)!.cartViewLess
                                : AppLocalizations.of(context)!.cartViewMore,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.process600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // ── Expanded options (below the image row, full width) ──
            if (hasOptions && isExpanded) ...[
              const SizedBox(height: 16),
              ...item.options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleWishlistAction(
    BuildContext context,
    CartItemModel item, {
    required bool isWishlisted,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final wishlistCubit = context.read<WishlistCubit>();
    final cartBloc = context.read<CartBloc>();
    final accessToken = await AuthStorage.getToken();

    if (accessToken == null || accessToken.isEmpty) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.cartPleaseLoginWishlistAdd),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      final result = await wishlistCubit.toggleWishlist(
        productId: item.productId,
      );

      if (result == null) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.cartPleaseLoginWishlistAdd),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      if (isWishlisted) {
        if (!mounted || result != false) return;

        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.homeRemovedFromWishlist),
            backgroundColor: AppColors.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      if (result != true) {
        return;
      }

      if (!mounted) return;

      cartBloc.add(RemoveFromCart(cartItemId: item.id));
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.cartMovedToWishlist),
          backgroundColor: AppColors.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.cartFailedMoveWishlist(
              ErrorMapper.getUserMessage(e, context: 'moving item to wishlist'),
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Stepper button for quantity control
  Widget _buildStepperButton(
    BuildContext context, {
    required IconData icon,
    required bool isDark,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SizedBox(
          width: 22,
          height: 22,
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? (isDark ? AppColors.neutral200 : AppColors.neutral900)
                : (isDark ? AppColors.neutral700 : AppColors.neutral300),
          ),
        ),
      ),
    );
  }

  /// Figma: Continue Shopping + Empty Cart row
  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Continue Shopping
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _resetEstimateShippingFields();
                  // Switch to Categories tab via AppNavigator
                  AppNavigator.goCategories(context);
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.cartContinueShopping,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Empty Cart
            GestureDetector(
              onTap: () => _showEmptyCartConfirmation(context, isDark),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 24,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.cartEmptyCartAction,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Figma / Web: Estimate Shipping and Tax section
  Widget _buildEstimateShippingSection(
    BuildContext context,
    CartState state,
    bool isDark,
  ) {
    if (!StoreConfig.of(context).showEstimateShipping) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final borderColor = isDark ? AppColors.neutral700 : AppColors.neutral300;
    final fillColor = isDark ? AppColors.neutral800 : AppColors.neutral50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral900 : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accordion Header
            InkWell(
              onTap: () {
                setState(() {
                  _estimateShippingExpanded = !_estimateShippingExpanded;
                });
                if (_estimateShippingExpanded) {
                  _loadCountries();
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.neutral300
                              : AppColors.neutral800,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.cartEstimateShippingAndTax,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.neutral200
                                : AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _estimateShippingExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral600,
                    ),
                  ],
                ),
              ),
            ),

            if (_estimateShippingExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cartEstimateShippingPrompt,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Country Selection
                    Text(
                      '${l10n.cartEstimateCountry} *',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _loadingCountries
                          ? null
                          : () async {
                              if (_countries.isEmpty) await _loadCountries();
                              if (!context.mounted || _countries.isEmpty) {
                                return;
                              }
                              final picked =
                                  await SelectionSheet.show<BagistoCountry>(
                                    context: context,
                                    title: l10n.cartEstimateSelectCountry,
                                    items: _countries,
                                    selectedItem: _selectedCountry,
                                    itemLabel: (c) => c.name,
                                    isDark: isDark,
                                  );
                              if (picked != null &&
                                  picked != _selectedCountry) {
                                setState(() {
                                  _selectedCountry = picked;
                                });
                                _loadStatesForCountry(picked);
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _loadingCountries
                                    ? 'Loading countries...'
                                    : (_selectedCountry?.name ??
                                          l10n.cartEstimateSelectCountry),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  color: _selectedCountry != null
                                      ? (isDark
                                            ? AppColors.neutral200
                                            : AppColors.neutral900)
                                      : (isDark
                                            ? AppColors.neutral500
                                            : AppColors.neutral400),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // State Selection / Input
                    Text(
                      '${l10n.cartEstimateState} *',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_loadingStates)
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.cartEstimateSelectState,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.neutral500
                                    : AppColors.neutral400,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark
                                      ? AppColors.neutral400
                                      : AppColors.neutral600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_countryStates.isNotEmpty)
                      InkWell(
                        onTap: () async {
                          final picked =
                              await SelectionSheet.show<BagistoCountryState>(
                                context: context,
                                title: l10n.cartEstimateSelectState,
                                items: _countryStates,
                                selectedItem: _selectedState,
                                itemLabel: (s) => s.defaultName,
                                isDark: isDark,
                              );
                          if (picked != null) {
                            setState(() {
                              _selectedState = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedState?.defaultName ??
                                      l10n.cartEstimateSelectState,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: _selectedState != null
                                        ? (isDark
                                              ? AppColors.neutral200
                                              : AppColors.neutral900)
                                        : (isDark
                                              ? AppColors.neutral500
                                              : AppColors.neutral400),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: isDark
                                    ? AppColors.neutral400
                                    : AppColors.neutral600,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      TextField(
                        controller: _estimateStateController,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.cartEstimateState,
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: isDark
                                ? AppColors.neutral500
                                : AppColors.neutral400,
                          ),
                          filled: true,
                          fillColor: fillColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: AppColors.primary500),
                          ),
                        ),
                      ),
                    const SizedBox(height: 14),

                    // Zip / Postcode
                    Text(
                      '${l10n.cartEstimateZip} *',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _estimateZipController,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.cartEstimateZip,
                        hintStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral500
                              : AppColors.neutral400,
                        ),
                        filled: true,
                        fillColor: fillColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: AppColors.primary500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Calculate / Estimate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isEstimatingShipping
                            ? null
                            : () {
                                final countryCode = _selectedCountry?.code;
                                if (countryCode == null ||
                                    countryCode.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.cartEstimateSelectCountry,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final stateVal = _countryStates.isNotEmpty
                                    ? (_selectedState?.code ??
                                          _selectedState?.defaultName ??
                                          '')
                                    : _estimateStateController.text.trim();
                                final zipVal = _estimateZipController.text
                                    .trim();

                                context.read<CartBloc>().add(
                                  EstimateShippingEvent(
                                    country: countryCode,
                                    state: stateVal,
                                    postcode: zipVal,
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state.isEstimatingShipping
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                l10n.cartEstimateButton,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // Error Message
                    if (state.estimateShippingError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.estimateShippingError!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          color: AppColors.process700,
                        ),
                      ),
                    ],

                    // Shipping Methods List
                    if (state.estimatedShippingMethods.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        l10n.checkoutShippingMethod,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral900
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral300,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              for (
                                var i = 0;
                                i < state.estimatedShippingMethods.length;
                                i++
                              ) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: isDark
                                        ? AppColors.neutral800
                                        : AppColors.neutral200,
                                  ),
                                () {
                                  final rate =
                                      state.estimatedShippingMethods[i];
                                  final isSelected =
                                      state.selectedEstimatedShippingRate ==
                                      rate.method;
                                  final carrier =
                                      rate.carrierTitle ?? rate.label;
                                  final desc =
                                      (rate.description != null &&
                                          rate.description!.isNotEmpty)
                                      ? rate.description!
                                      : (rate.methodTitle != null &&
                                                rate.methodTitle != carrier
                                            ? rate.methodTitle!
                                            : '');
                                  final subtitle = desc.isNotEmpty
                                      ? '$carrier - $desc'
                                      : carrier;

                                  return InkWell(
                                    onTap: state.isEstimatingShipping
                                        ? null
                                        : () {
                                            final countryCode =
                                                _selectedCountry?.code ?? '';
                                            final stateVal =
                                                _countryStates.isNotEmpty
                                                ? (_selectedState?.code ??
                                                      _selectedState
                                                          ?.defaultName ??
                                                      '')
                                                : _estimateStateController.text
                                                      .trim();
                                            final zipVal =
                                                _estimateZipController.text
                                                    .trim();

                                            context.read<CartBloc>().add(
                                              SelectEstimatedShippingMethodEvent(
                                                method: rate.method,
                                                country: countryCode,
                                                state: stateVal,
                                                postcode: zipVal,
                                              ),
                                            );
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          isSelected
                                              ? _buildFilledRadio()
                                              : _buildEmptyRadio(
                                                  isDark: isDark,
                                                ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  rate.displayPrice,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: isDark
                                                        ? AppColors.neutral100
                                                        : AppColors.neutral900,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  subtitle,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: isDark
                                                        ? AppColors.neutral400
                                                        : AppColors.neutral600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }(),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Figma: Apply Coupon section
  Widget _buildCouponSection(
    BuildContext context,
    CartState state,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            AppLocalizations.of(context)!.cartApplyCoupon,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.neutral200 : AppColors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Input + Apply button row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Coupon input field (Figma: input-field with floating label)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _couponController,
                    focusNode: _couponFocusNode,
                    enabled: !state.isApplyingCoupon && !state.cart.hasCoupon,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.cartCouponCode,
                      labelStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral800,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.neutral700
                              : AppColors.neutral200,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.neutral700
                              : AppColors.neutral200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primary500,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.neutral700
                              : AppColors.neutral200,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Apply button
              GestureDetector(
                onTap: (state.isApplyingCoupon || state.cart.hasCoupon)
                    ? null
                    : () {
                        final code = _couponController.text.trim();
                        if (code.isNotEmpty) {
                          _couponFocusNode.unfocus();
                          context.read<CartBloc>().add(
                            ApplyCoupon(couponCode: code),
                          );
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: (state.isApplyingCoupon || state.cart.hasCoupon)
                        ? (isDark ? AppColors.neutral600 : AppColors.neutral400)
                        : AppColors.primary500,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: state.isApplyingCoupon
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.cartApply,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),

          // Applied coupon banner (Figma: success/50 bg, success/500 border)
          if (state.cart.hasCoupon) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.success700.withValues(alpha: 0.15)
                    : AppColors.success50,
                border: Border.all(color: AppColors.success500),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.cartAppliedCoupon,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.cart.couponCode!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success700,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _couponController.clear();
                      context.read<CartBloc>().add(RemoveCoupon());
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cartRemove,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.process700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Figma: Price Break section
  Widget _buildPriceBreak(BuildContext context, CartModel cart, bool isDark) {
    final config = StoreConfig.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Subtotal
    final hasSubtotalTaxDiff =
        cart.subTotalInclTax > 0 &&
        (cart.subTotalInclTax - cart.subtotal).abs() > 0.001;
    final String subtotal;
    final String? subtotalSubValue;

    if (config.showSubtotalBoth && hasSubtotalTaxDiff) {
      subtotal =
          cart.formattedSubTotalInclTax ??
          CurrencyFormatter.formatAmount(cart.subTotalInclTax);
      final exclFormatted =
          cart.formattedSubtotal ??
          CurrencyFormatter.formatAmount(cart.subtotal);
      subtotalSubValue = l10n.cartExclTax(exclFormatted);
    } else if (config.showSubtotalInclTax && hasSubtotalTaxDiff) {
      subtotal =
          cart.formattedSubTotalInclTax ??
          CurrencyFormatter.formatAmount(cart.subTotalInclTax);
      subtotalSubValue = null;
    } else {
      subtotal = cart.subtotal > 0
          ? (cart.formattedSubtotal ??
                CurrencyFormatter.formatAmount(cart.subtotal))
          : CurrencyFormatter.formatAmount(0);
      subtotalSubValue = null;
    }

    // Discount
    final discount = cart.discountAmount > 0
        ? '-${cart.formattedDiscountAmount ?? CurrencyFormatter.formatAmount(cart.discountAmount)}'
        : CurrencyFormatter.formatAmount(0);

    // Delivery Charges
    final hasShippingTaxDiff =
        cart.shippingAmountInclTax > 0 &&
        (cart.shippingAmountInclTax - cart.shippingAmount).abs() > 0.001;
    final String shipping;
    final String? shippingSubValue;

    if (config.showShippingBoth) {
      if (cart.shippingAmount > 0) {
        shipping =
            cart.formattedShippingAmountInclTax ??
            CurrencyFormatter.formatAmount(
              cart.shippingAmountInclTax > 0
                  ? cart.shippingAmountInclTax
                  : cart.shippingAmount,
            );
        final exclShippingFormatted =
            cart.formattedShippingAmount ??
            CurrencyFormatter.formatAmount(cart.shippingAmount);
        shippingSubValue = l10n.cartExclTax(exclShippingFormatted);
      } else {
        shipping = CurrencyFormatter.formatAmount(0);
        shippingSubValue = l10n.cartExclTax(CurrencyFormatter.formatAmount(0));
      }
    } else if (config.showShippingInclTax && hasShippingTaxDiff) {
      shipping =
          cart.formattedShippingAmountInclTax ??
          CurrencyFormatter.formatAmount(cart.shippingAmountInclTax);
      shippingSubValue = null;
    } else {
      shipping = cart.shippingAmount > 0
          ? (cart.formattedShippingAmount ??
                CurrencyFormatter.formatAmount(cart.shippingAmount))
          : CurrencyFormatter.formatAmount(0);
      shippingSubValue = null;
    }

    // Tax
    final taxAmountStr = cart.taxAmount > 0
        ? (cart.formattedTaxAmount ??
              CurrencyFormatter.formatAmount(cart.taxAmount))
        : CurrencyFormatter.formatAmount(0);
    final tax = (cart.hasTaxIncluded && cart.taxAmount > 0)
        ? '$taxAmountStr ${l10n.cartTaxIncluded}'
        : taxAmountStr;
    final canShowBreakdown =
        config.showTaxBreakdown && cart.hasAppliedTaxes && cart.taxAmount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cartPriceBreak,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.neutral200 : AppColors.black,
            ),
          ),
          const SizedBox(height: 16),

          // SubTotal
          _buildPriceRow(
            context,
            l10n.cartSubTotal,
            subtotal,
            isDark,
            subValue: subtotalSubValue,
          ),
          const SizedBox(height: 8),

          // Discount
          _buildPriceRow(
            context,
            l10n.cartDiscount,
            discount,
            isDark,
            valueColor: cart.discountAmount > 0 ? AppColors.success700 : null,
          ),
          const SizedBox(height: 8),

          // Delivery Charges
          _buildPriceRow(
            context,
            l10n.cartDeliveryCharges,
            shipping,
            isDark,
            subValue: shippingSubValue,
          ),
          const SizedBox(height: 8),

          // Tax
          GestureDetector(
            onTap: canShowBreakdown
                ? () {
                    setState(() {
                      _taxBreakdownExpanded = !_taxBreakdownExpanded;
                    });
                  }
                : null,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.cartTax,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral800,
                      ),
                    ),
                    if (canShowBreakdown) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _taxBreakdownExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral600,
                      ),
                    ],
                  ],
                ),
                Text(
                  tax,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                  ),
                ),
              ],
            ),
          ),
          if (canShowBreakdown && _taxBreakdownExpanded) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cart.taxBreakdownLines.map((taxLine) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              taxLine.rateName,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.neutral300
                                    : AppColors.neutral700,
                              ),
                            ),
                            if (taxLine.items.isEmpty)
                              Text(
                                taxLine.rateTotal,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.neutral300
                                      : AppColors.neutral700,
                                ),
                              ),
                          ],
                        ),
                        for (final item in taxLine.items)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.neutral400
                                          : AppColors.neutral600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${item.taxAmount} ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? AppColors.neutral300
                                              : AppColors.neutral700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '(${item.taxableAmount})',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                          color: isDark
                                              ? AppColors.neutral400
                                              : AppColors.neutral500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          const SizedBox(height: 8),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.cartGrandTotal,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
              ),
              Text(
                cart.formattedGrandTotal ??
                    CurrencyFormatter.formatAmount(cart.grandTotal),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    String? subValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.neutral400 : AppColors.neutral800,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color:
                    valueColor ??
                    (isDark ? AppColors.neutral200 : AppColors.neutral800),
              ),
            ),
          ],
        ),
        if (subValue != null && subValue.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                subValue,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Figma: navigation-bar/add-to-cart (sticky bottom)
  Widget _buildBottomBar(BuildContext context, CartState state, bool isDark) {
    final config = StoreConfig.of(context);
    final meetsMinimumOrder = config.meetsMinimumOrder(
      subtotal: state.cart.subtotal,
      discount: state.cart.discountAmount,
      tax: state.cart.taxAmount,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral50,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!meetsMinimumOrder)
              Padding(
                key: const ValueKey('cart_minimum_order_message'),
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _minimumOrderMessage(context, config),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.errorRed,
                  ),
                ),
              ),
            Row(
              children: [
                // Price + "Amount to be Paid"
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.cart.formattedGrandTotal ??
                            CurrencyFormatter.formatAmount(
                              state.cart.grandTotal,
                            ),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral800,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.cartAmountToBePaid,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral800,
                        ),
                      ),
                    ],
                  ),
                ),

                // Pay Now button (Figma: 131px wide, rounded 54)
                GestureDetector(
                  onTap: () async {
                    if (!meetsMinimumOrder) return;
                    final cartBloc = context.read<CartBloc>();
                    final authBloc = context.read<AuthBloc>();
                    if (authBloc.state is! AuthAuthenticated &&
                        !await CheckoutAccessGuard.ensureGuestCheckoutAllowed(
                          context,
                          cartBloc,
                        )) {
                      return;
                    }
                    if (!context.mounted) return;
                    _resetEstimateShippingFields();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: cartBloc),
                            BlocProvider.value(value: authBloc),
                          ],
                          child: const CheckoutPage(),
                        ),
                      ),
                    );
                    if (!mounted) return;
                    cartBloc.add(LoadCart());
                  },
                  child: Container(
                    width: 131,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: meetsMinimumOrder
                          ? AppColors.primary500
                          : AppColors.neutral400,
                      borderRadius: BorderRadius.circular(54),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.cartPayNow,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Delete confirmation dialog
  void _showDeleteConfirmation(
    BuildContext context,
    CartItemModel item,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(context)!.cartRemoveItem,
          style: AppTextStyles.text4(context),
        ),
        content: Text(
          AppLocalizations.of(context)!.cartRemoveItemConfirm(item.name),
          style: AppTextStyles.text5(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              AppLocalizations.of(context)!.cartCancel,
              style: TextStyle(
                color: isDark ? AppColors.neutral300 : AppColors.neutral500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CartBloc>().add(RemoveFromCart(cartItemId: item.id));
            },
            child: Text(
              AppLocalizations.of(context)!.cartRemove,
              style: const TextStyle(color: AppColors.primary500),
            ),
          ),
        ],
      ),
    );
  }

  /// Empty cart confirmation dialog
  void _showEmptyCartConfirmation(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(context)!.cartEmptyCartTitle,
          style: AppTextStyles.text4(context),
        ),
        content: Text(
          AppLocalizations.of(context)!.cartEmptyCartConfirm,
          style: AppTextStyles.text5(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              AppLocalizations.of(context)!.cartCancel,
              style: TextStyle(
                color: isDark ? AppColors.neutral300 : AppColors.neutral500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CartBloc>().add(ClearCart());
            },
            child: Text(
              AppLocalizations.of(context)!.cartEmptyCartAction,
              style: const TextStyle(color: AppColors.primary500),
            ),
          ),
        ],
      ),
    );
  }

  /// Figma: toster/success style notification
  void _showToast(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isError ? Colors.red.shade700 : AppColors.successGreen,
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _localizedCartMessage(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    switch (message) {
      case 'Product added to cart successfully':
        return l10n.cartAddedToCartSuccess;
      default:
        return message;
    }
  }

  Widget _buildFilledRadio() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary500, width: 2),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
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
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? AppColors.neutral600 : AppColors.neutral400,
          width: 2,
        ),
      ),
    );
  }

  HomeProduct _toHomeProduct(ProductModel p) {
    final parsedId = p.numericId ?? int.tryParse(p.id.split('/').last) ?? 0;
    final firstBooking = p.bookingProducts.isNotEmpty
        ? p.bookingProducts.first
        : null;
    return HomeProduct(
      id: p.id,
      numericId: parsedId > 0 ? parsedId : null,
      sku: p.sku ?? '',
      type: p.type ?? 'simple',
      bookingType: p.bookingType,
      name: p.name ?? '',
      urlKey: p.urlKey ?? '',
      baseImageUrl: p.baseImageUrl,
      price: p.price ?? 0.0,
      minimumPrice: p.minimumPrice,
      specialPrice: p.specialPrice,
      formattedPrice: p.formattedPrice,
      formattedMinimumPrice: p.formattedMinimumPrice,
      formattedSpecialPrice: p.formattedSpecialPrice,
      maximumPrice: p.maximumPrice,
      formattedMaximumPrice: p.formattedMaximumPrice,
      regularMinimumPrice: p.regularMinimumPrice,
      formattedRegularMinimumPrice: p.formattedRegularMinimumPrice,
      regularMaximumPrice: p.regularMaximumPrice,
      formattedRegularMaximumPrice: p.formattedRegularMaximumPrice,
      startingPrice: firstBooking?.startingPrice,
      formattedStartingPrice: firstBooking?.formattedStartingPrice,
      startingRegularPrice: firstBooking?.startingRegularPrice,
      formattedStartingRegularPrice:
          firstBooking?.formattedStartingRegularPrice,
      isSaleable: p.isSaleable ?? true,
      isNew: p.isNew ?? false,
      isFeatured: p.isFeatured ?? false,
      averageRating: p.averageRating,
      reviewCount: p.totalReviewCount ?? p.reviewCount,
      reviewStarCount: p.reviewStarCount,
    );
  }

  void _toggleCrossSellWishlist(
    BuildContext context,
    HomeProduct product,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final productId =
        product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;
    if (productId <= 0) return;

    try {
      final result = await context.read<WishlistCubit>().toggleWishlist(
        productId: productId,
      );
      if (!context.mounted) return;

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.homeLoginToManageWishlist),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Figma / Web: "More Choices" cross-sell products section
  Widget _buildCrossSellSection(
    BuildContext context,
    CartState state,
    bool isDark,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final storeConfig = StoreConfig.of(context);
    final products = storeConfig.limitProducts(
      state.crossSellProducts,
      storeConfig.crossSellProductsLimit,
    );
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.cartMoreChoices,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth > 0
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            final cardWidth = (screenWidth - 40 - 24) / 2.3;
            final listHeight = cardWidth + 96;

            return SizedBox(
              height: listHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final homeProduct = _toHomeProduct(product);
                  final pid = homeProduct.numericId ?? 0;

                  return BlocBuilder<WishlistCubit, WishlistCubitState>(
                    builder: (context, wishlistState) {
                      return ProductCardLarge(
                        key: ValueKey('cross_sell_${product.id}'),
                        product: homeProduct,
                        cardWidth: cardWidth,
                        isWishlisted:
                            pid > 0 && wishlistState.isWishlisted(pid),
                        isWishlistProcessing:
                            pid > 0 && wishlistState.isProcessing(pid),
                        onWishlistTap: () =>
                            _toggleCrossSellWishlist(context, homeProduct),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                urlKey: product.urlKey ?? '',
                                productId: (product.numericId ?? product.id)
                                    .toString(),
                                productName: product.name,
                                productType: product.type,
                              ),
                            ),
                          );
                        },
                        onAddToCart: () {
                          final pType = (product.type ?? 'simple')
                              .toLowerCase();
                          if (pType == 'simple' &&
                              (product.isSaleable ?? true)) {
                            final pidInt =
                                product.numericId ??
                                int.tryParse(product.id.split('/').last) ??
                                0;
                            if (pidInt > 0) {
                              context.read<CartBloc>().add(
                                AddToCart(productId: pidInt, quantity: 1),
                              );
                              return;
                            }
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                urlKey: product.urlKey ?? '',
                                productId: (product.numericId ?? product.id)
                                    .toString(),
                                productName: product.name,
                                productType: product.type,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
