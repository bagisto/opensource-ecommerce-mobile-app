import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../data/models/product_model.dart';
import '../../data/repository/category_repository.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../pages/category_products_grid_page.dart';

/// Products grid section
/// Figma: Frame 21 – "Products" header + 2-column grid
///
/// Product card (162px wide):
///  ┌────────────┐
///  │  [Image]   │  162×162, rounded 12px, with heart icon top-right
///  ├────────────┤
///  │  Title     │  Text-5, max 2 lines
///  │  $50  $100 │  Price row: bold current + strikethrough + discount%
///  │  ★4.5 1254 │  Rating badge (green) + review count
///  └────────────┘
class ProductGridSection extends StatelessWidget {
  final List<ProductModel> products;
  final bool isLoadingMore;
  final int? categoryId;
  final String? categoryName;
  final String? categorySlug;

  const ProductGridSection({
    super.key,
    required this.products,
    this.isLoadingMore = false,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ──
          GestureDetector(
            onTap: () {
              if (categoryId != null) {
                final repo = context.read<CategoryRepository>();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RepositoryProvider.value(
                      value: repo,
                      child: CategoryProductsGridPage(
                        categoryId: categoryId!,
                        categoryName: categoryName ?? 'Products',
                        categorySlug: categorySlug ?? '',
                      ),
                    ),
                  ),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Products', style: AppTextStyles.text3(context)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    categoryId != null
                        ? Icons.arrow_forward_ios
                        : Icons.keyboard_arrow_down,
                    size: categoryId != null ? 16 : 24,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Product Grid ──
          if (products.isEmpty && !isLoadingMore)
            _buildEmptyState(context)
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: products.map((product) {
                return _ProductCard(product: product);
              }).toList(),
            ),

          // ── Loading indicator ──
          if (isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary500,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 12),
            Text('No products found', style: AppTextStyles.text5(context)),
          ],
        ),
      ),
    );
  }
}

/// Individual product card matching Figma "product-image/light" component
class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 20 * 2 - 12) / 2; // 2 columns

    return GestureDetector(
      onTap: () {
        // Navigate to search page with product name as search query
        if (product.name != null && product.name!.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SearchPage(
                initialQuery: product.name,
              ),
            ),
          );
        }
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ──
            Stack(
              children: [
                Container(
                  width: cardWidth,
                  height: cardWidth, // Square image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark
                        ? AppColors.neutral800
                        : const Color(0xFFF5F5F5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: product.baseImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: product.baseImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => Container(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral200,
                          ),
                          errorWidget: (ctx, url, err) => Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: AppColors.neutral400,
                          ),
                        )
                      : Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: AppColors.neutral400,
                        ),
                ),

                // ── Heart Icon (top-right) ──
                BlocBuilder<WishlistCubit, WishlistCubitState>(
                  builder: (context, wishlistState) {
                    final pid =
                        product.numericId ??
                        int.tryParse(product.id.split('/').last) ??
                        0;
                    final isWishlisted =
                        pid > 0 && wishlistState.isWishlisted(pid);
                    final isProcessing =
                        pid > 0 && wishlistState.isProcessing(pid);
                    return Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: isProcessing
                            ? null
                            : () => _toggleWishlist(context, product),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(200),
                            shape: BoxShape.circle,
                          ),
                          child: isProcessing
                              ? const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.neutral200,
                                  ),
                                )
                              : Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: isWishlisted
                                      ? Colors.red
                                      : AppColors.neutral800,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Product Info ──
            // Title
            Text(
              product.name ?? 'Product',
              style: AppTextStyles.text5(context).copyWith(
                color: isDark ? AppColors.neutral300 : AppColors.neutral800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 7),

            // ── Price Row ──
            _buildPriceRow(context),

            const SizedBox(height: 7),

            // ── Rating Row ──
            _buildRatingRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Wrap(
      spacing: 3,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Current price
        Text(
          '\$${product.displayPrice.toStringAsFixed(2)}',
          style: AppTextStyles.priceText(context),
        ),

        // Original price (strikethrough)
        if (product.originalPrice != null)
          Text(
            '\$${product.originalPrice!.toStringAsFixed(2)}',
            style: AppTextStyles.originalPriceText(context),
          ),

        // Discount percentage
        if (product.discountPercent != null)
          Text(
            '${product.discountPercent}% off',
            style: AppTextStyles.discountText(context),
          ),
      ],
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rating = product.averageRating;
    final reviewCount = product.reviews.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Rating Badge ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.successGreen,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: AppColors.white),
              const SizedBox(width: 1),
              Text(
                rating > 0 ? rating.toStringAsFixed(1) : '0.0',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 3),

        // ── Review Count ──
        Flexible(
          child: Text(
            reviewCount > 0 ? '$reviewCount' : '0',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _toggleWishlist(BuildContext context, ProductModel product) async {
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
          const SnackBar(
            content: Text('Please login to manage wishlist'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Added to wishlist' : 'Removed from wishlist'),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update wishlist: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
