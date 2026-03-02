import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../category/data/models/product_model.dart';

/// Related Products horizontal scroll section
/// Figma: "Related Product" header + horizontal card list (142×142 image)
class ProductRelatedSection extends StatelessWidget {
  final List<ProductModel> relatedProducts;
  final void Function(ProductModel)? onProductTap;

  const ProductRelatedSection({
    super.key,
    required this.relatedProducts,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (relatedProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Related Product', style: AppTextStyles.text4(context)),
        ),

        const SizedBox(height: 16),

        // ── Horizontal scroll ──
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: relatedProducts.length,
            separatorBuilder: (context, i) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _RelatedProductCard(
                product: relatedProducts[index],
                onTap: onProductTap != null
                    ? () => onProductTap!(relatedProducts[index])
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const _RelatedProductCard({required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const cardWidth = 142.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            Stack(
              children: [
                Container(
                  width: cardWidth,
                  height: cardWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                            size: 28,
                            color: AppColors.neutral400,
                          ),
                        )
                      : Icon(
                          Icons.image_outlined,
                          size: 28,
                          color: AppColors.neutral400,
                        ),
                ),

                // ── Heart ──
                Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Title ──
            Text(
              product.name ?? 'Product',
              style: AppTextStyles.text5(context).copyWith(
                color: isDark ? AppColors.neutral300 : AppColors.neutral800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // ── Price Row ──
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${product.displayPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.priceText(context),
                  ),
                  if (product.originalPrice != null) ...[
                    const SizedBox(width: 3),
                    Text(
                      '\$${product.originalPrice!.toStringAsFixed(2)}',
                      style: AppTextStyles.originalPriceText(context),
                    ),
                  ],
                  if (product.discountPercent != null) ...[
                    const SizedBox(width: 3),
                    Text(
                      '${product.discountPercent}% off',
                      style: AppTextStyles.discountText(context),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ── Rating Row ──
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: AppColors.white),
                      const SizedBox(width: 1),
                      Text(
                        product.averageRating > 0
                            ? product.averageRating.toStringAsFixed(1)
                            : '0.0',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    '${product.reviews.length}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color:
                          isDark ? AppColors.neutral100 : AppColors.neutral900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
