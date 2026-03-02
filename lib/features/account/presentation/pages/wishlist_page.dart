import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../data/models/account_models.dart';
import '../bloc/wishlist_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';

/// Wishlist page matching Figma node 245:5225
/// Design: Back arrow + "Wishlist" title, item count, list of wishlist items
/// Each item: 93×93 rounded image, product name, price, qty stepper, Add to Cart, Remove
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: AppBackButton(isIosStyle: false),
        leadingWidth: 60,
        title: Text(
          'Wishlist',
          style: AppTextStyles.text4(context).copyWith(
            color: isDark ? AppColors.neutral100 : AppColors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<WishlistBloc, WishlistState>(
        listener: (context, state) {
          // Show snackbar for success/error messages
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.success700,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            // Reload cart when item is added from wishlist
            context.read<WishlistBloc>().add(const ClearWishlistMessage());
            context.read<CartBloc>().add(LoadCart());
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );

            // Navigate to product detail page if it's a configurable product error
            if (state.errorUrlKey != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(
                    urlKey: state.errorUrlKey!,
                    productName: state.errorProductName,
                  ),
                ),
              );
            }

            context.read<WishlistBloc>().add(const ClearWishlistMessage());
          }
        },
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          if (state.status == WishlistStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            );
          }

          if (state.status == WishlistStatus.error && state.items.isEmpty) {
            return _buildErrorState(context, state, isDark);
          }

          if (state.items.isEmpty) {
            return _buildEmptyState(context, isDark);
          }

          return _buildWishlistContent(context, state);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WishlistState state, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.neutral400),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: AppTextStyles.text5(
                context,
              ).copyWith(
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.read<WishlistBloc>().add(const LoadWishlist());
              },
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: isDark ? AppColors.neutral700 : AppColors.neutral300,
            ),
            const SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: AppTextStyles.text4(
                context,
              ).copyWith(
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse products and add them to your wishlist',
              textAlign: TextAlign.center,
              style: AppTextStyles.text5(
                context,
              ).copyWith(color: AppColors.neutral500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context, WishlistState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WishlistList(
      items: state.items,
      totalCount: state.totalCount,
      hasNextPage: state.hasNextPage,
      isLoadingMore: state.isLoadingMore,
      processingIds: state.processingIds,
      isDark: isDark,
    );
  }
}

class _WishlistList extends StatefulWidget {
  final List<WishlistItem> items;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;
  final Set<String> processingIds;
  final bool isDark;

  const _WishlistList({
    required this.items,
    required this.totalCount,
    required this.hasNextPage,
    required this.isLoadingMore,
    required this.processingIds,
    required this.isDark,
  });

  @override
  State<_WishlistList> createState() => _WishlistListState();
}

class _WishlistListState extends State<_WishlistList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasNextPage || widget.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<WishlistBloc>().add(const LoadMoreWishlist());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item count header — "3 Items"
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 0),
            child: Text(
              '${widget.totalCount} ${widget.totalCount == 1 ? 'Item' : 'Items'}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: widget.isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
          // Wishlist items list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 0, bottom: 24),
              itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary500,
                      ),
                    ),
                  );
                }

                final item = widget.items[index];
                final isProcessing = widget.processingIds.contains(
                  item.id ?? '',
                );
                return _WishlistItemCard(
                  item: item,
                  isProcessing: isProcessing,
                  isDark: widget.isDark,
                  onQuantityChanged: (qty) {
                    if (item.id != null) {
                      context.read<WishlistBloc>().add(
                        UpdateWishlistItemQuantity(id: item.id!, quantity: qty),
                      );
                    }
                  },
                  onAddToCart: () {
                    if (item.numericId != null) {
                      context.read<WishlistBloc>().add(
                        MoveWishlistItemToCart(
                          numericId: item.numericId!,
                          quantity: item.quantity,
                        ),
                      );
                    }
                  },
                  onRemove: () {
                    if (item.id != null) {
                      context.read<WishlistBloc>().add(
                        RemoveWishlistItem(id: item.id!),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Single wishlist item card matching Figma design
class _WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final bool isProcessing;
  final bool isDark;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  const _WishlistItemCard({
    required this.item,
    required this.isProcessing,
    required this.isDark,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.neutral800 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Opacity(
        opacity: isProcessing ? 0.5 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image — 93×93 with 12px radius
            GestureDetector(
              onTap: () {
                if (item.urlKey != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(
                        urlKey: item.urlKey!,
                        productName: item.name,
                      ),
                    ),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 93,
                  height: 93,
                  child:
                      item.baseImageUrl != null && item.baseImageUrl!.isNotEmpty
                      ? Image.network(
                          item.baseImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                            child: Icon(
                              Icons.image_outlined,
                              color: isDark ? AppColors.neutral600 : AppColors.neutral400,
                              size: 32,
                            ),
                          ),
                        )
                      : Container(
                          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                          child: Icon(
                            Icons.image_outlined,
                            color: isDark ? AppColors.neutral600 : AppColors.neutral400,
                            size: 32,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name — Roboto Medium 14px, neutral900
                  GestureDetector(
                    onTap: () {
                      if (item.urlKey != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              urlKey: item.urlKey!,
                              productName: item.name,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price — "Starting at $336.00"
                  Text(
                    _buildPriceText(),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity stepper + Add to Cart
                  Row(
                    children: [
                      // Quantity stepper
                      _QuantityStepper(
                        quantity: item.quantity,
                        onChanged: onQuantityChanged,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      // Add to Cart button
                      _AddToCartButton(
                        onPressed: isProcessing ? null : onAddToCart,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Remove link — blue text
                  GestureDetector(
                    onTap: isProcessing ? null : onRemove,
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.process600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildPriceText() {
    if (item.specialPrice != null && item.specialPrice! > 0) {
      return 'Starting at ${item.formattedSpecialPrice}';
    }
    return 'Starting at ${item.formattedPrice}';
  }
}

/// Quantity stepper: [ - ] count [ + ] with bordered container
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final bool isDark;

  const _QuantityStepper({
    required this.quantity,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          GestureDetector(
            onTap: () {
              if (quantity > 1) onChanged(quantity - 1);
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.remove,
                size: 16,
                color: quantity > 1
                    ? (isDark ? AppColors.neutral200 : AppColors.neutral900)
                    : AppColors.neutral400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Quantity display
          SizedBox(
            width: 20,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Plus button
          GestureDetector(
            onTap: () => onChanged(quantity + 1),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.add,
                size: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Add to Cart" outlined button with orange text
class _AddToCartButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDark;

  const _AddToCartButton({
    this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 36,
        width: 108,
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          'Add to Cart',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.primary500,
          ),
        ),
      ),
    );
  }
}
