import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../../cart/data/models/cart_model.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../account/presentation/bloc/wishlist_bloc.dart';
import '../../../account/presentation/pages/wishlist_page.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../bloc/cart_bloc.dart';
import '../../../../core/widgets/app_back_button.dart';

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
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _couponController = TextEditingController();
  final FocusNode _couponFocusNode = FocusNode();

  @override
  void dispose() {
    _couponController.dispose();
    _couponFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          _showToast(context, state.successMessage!, isError: false);
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
                'Cart',
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
          GestureDetector(
            onTap: () async {
              final accessToken = await AuthStorage.getToken();
              if (accessToken == null || accessToken.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please login to view wishlist'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
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
                        create: (_) =>
                            WishlistBloc(
                              repository: repository,
                              wishlistCubit: wishlistCubit,
                            )
                              ..add(const LoadWishlist()),
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
            const SizedBox(height: 8),

            // ── "N Items in the Cart" ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${state.cart.itemsQty} ${state.cart.itemsQty == 1 ? 'Item' : 'Items'} in the Cart',
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

  /// Empty cart state
  Widget _buildEmptyCart(BuildContext context, bool isDark) {
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
          Text('Your cart is empty', style: AppTextStyles.text4(context)),
          const SizedBox(height: 8),
          Text(
            'Add products to your cart to see them here',
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
              child: const Text(
                'Continue Shopping',
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
                            productName: item.name,
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
                            placeholder: (_, __) => Container(
                              color: isDark
                                  ? AppColors.neutral700
                                  : AppColors.neutral200,
                            ),
                            errorWidget: (_, __, ___) => Icon(
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
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)} x ${item.quantity} ${item.quantity == 1 ? 'Unit' : 'Units'}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.neutral300
                                  : AppColors.neutral900,
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.neutral200
                                  : AppColors.neutral900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Quantity controls + Delete + Wishlist
                      Row(
                        children: [
                          // Quantity stepper (Figma: swatch with border)
                          Container(
                            height: 36,
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
                                // Decrement
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
                                // Quantity
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    '${item.quantity}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: isDark
                                          ? AppColors.neutral200
                                          : AppColors.neutral900,
                                    ),
                                  ),
                                ),
                                // Increment
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
                          // Wishlist
                          GestureDetector(
                            onTap: () async {
                              final accessToken = await AuthStorage.getToken();
                              if (accessToken == null || accessToken.isEmpty) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please login to add to wishlist',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                                return;
                              }
                              try {
                                final client =
                                    GraphQLClientProvider.authenticatedClient(
                                      accessToken,
                                    ).value;
                                final accountRepo = AccountRepository(
                                  client: client,
                                );
                                // Add to wishlist
                                await accountRepo.addToWishlist(
                                  productId: item.productId,
                                );
                                // Remove from cart (move to wishlist flow)
                                if (context.mounted) {
                                  context.read<CartBloc>().add(
                                    RemoveFromCart(cartItemId: item.id),
                                  );
                                }
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Moved to wishlist'),
                                      backgroundColor: AppColors.successGreen,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to move to wishlist: $e',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Icon(
                              Icons.favorite_border,
                              size: 24,
                              color: isDark
                                  ? AppColors.neutral400
                                  : AppColors.neutral600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          width: 24,
          height: 24,
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
                      'Continue Shopping',
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
                      'Empty Cart',
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
            'Apply Coupon',
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
                      labelText: 'Coupon Code',
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
                      : const Text(
                          'Apply',
                          style: TextStyle(
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
                        'Applied Coupon',
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
                    child: const Text(
                      'Remove',
                      style: TextStyle(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Break',
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
            'SubTotal',
            '\$${_formatPrice(cart.subtotal)}',
            isDark,
          ),
          const SizedBox(height: 8),

          // Discount
          _buildPriceRow(
            context,
            'Discount',
            cart.discountAmount > 0
                ? '-\$${_formatPrice(cart.discountAmount)}'
                : '\$0.00',
            isDark,
            valueColor: cart.discountAmount > 0 ? AppColors.success700 : null,
          ),
          const SizedBox(height: 8),

          // Delivery Charges
          _buildPriceRow(
            context,
            'Delivery Charges',
            cart.shippingAmount > 0
                ? '\$${_formatPrice(cart.shippingAmount)}'
                : '\$0.00',
            isDark,
          ),
          const SizedBox(height: 8),

          // Tax
          _buildPriceRow(
            context,
            'Tax',
            cart.taxAmount > 0 ? '\$${_formatPrice(cart.taxAmount)}' : '\$0.00',
            isDark,
          ),
          const SizedBox(height: 8),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
              ),
              Text(
                '\$${_formatPrice(cart.grandTotal)}',
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
  }) {
    return Row(
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
    );
  }

  /// Figma: navigation-bar/add-to-cart (sticky bottom)
  Widget _buildBottomBar(BuildContext context, CartState state, bool isDark) {
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
        child: Row(
          children: [
            // Price + "Amount to be Paid"
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${_formatPrice(state.cart.grandTotal)}',
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
                    'Amount to be Paid',
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
              onTap: () {
                final cartBloc = context.read<CartBloc>();
                final authBloc = context.read<AuthBloc>();
                Navigator.of(context).push(
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
              },
              child: Container(
                width: 131,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.circular(54),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
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
        title: Text('Remove Item', style: AppTextStyles.text4(context)),
        content: Text(
          'Are you sure you want to remove "${item.name}" from your cart?',
          style: AppTextStyles.text5(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
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
            child: const Text(
              'Remove',
              style: TextStyle(color: AppColors.primary500),
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
        title: Text('Empty Cart', style: AppTextStyles.text4(context)),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: AppTextStyles.text5(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
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
            child: const Text(
              'Empty Cart',
              style: TextStyle(color: AppColors.primary500),
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

  /// Format price with commas
  String _formatPrice(double price) {
    if (price >= 1000) {
      final parts = price.toStringAsFixed(2).split('.');
      final intPart = parts[0];
      final decPart = parts[1];
      final buffer = StringBuffer();
      for (int i = 0; i < intPart.length; i++) {
        if (i > 0 && (intPart.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(intPart[i]);
      }
      return '$buffer.$decPart';
    }
    return price.toStringAsFixed(2);
  }
}
