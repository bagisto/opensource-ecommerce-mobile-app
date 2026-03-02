import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/home_models.dart';

/// Small product card for "Hot Deals" grid (Figma node 86:977).
///
/// Fully responsive — accepts an optional [cardWidth]. If not provided,
/// calculates from screen width: `(screenWidth - 40 - 24) / 3` which
/// matches the Figma 375px → 104px formula (20px padding each side + 2×12px gaps).
///
/// Figma spec:
///   • Square rounded-12 image
///   • Name 12px regular #262626, single-line ellipsis
///   • Price 14px semibold #171717 (range for configurable)
///   • Rating: small green pill bg #00A63E rounded-6 (star 14px + 4.5 12px bold white) + count 12px #171717
class ProductCardSmall extends StatelessWidget {
  final HomeProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;
  final bool isWishlistProcessing;

  /// Optional explicit width. If null, calculated from screen width.
  final double? cardWidth;

  const ProductCardSmall({
    super.key,
    required this.product,
    this.onTap,
    this.onWishlistTap,
    this.isWishlisted = false,
    this.isWishlistProcessing = false,
    this.cardWidth,
  });

  double _resolveWidth(BuildContext context) {
    if (cardWidth != null) return cardWidth!;
    final screenWidth = MediaQuery.of(context).size.width;
    // Figma: 20px padding each side + 2×12px gaps between 3 cards
    return (screenWidth - 40 - 24) / 3;
  }

  @override
  Widget build(BuildContext context) {
    final w = _resolveWidth(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: product.name,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: w,
                      height: w,
                      color: const Color(0x1A0E1019),
                      child:
                          product.baseImageUrl != null &&
                              product.baseImageUrl!.isNotEmpty
                          ? Image.network(
                              product.baseImageUrl!,
                              fit: BoxFit.cover,
                              width: w,
                              height: w,
                            errorBuilder: (_, __, ___) => _placeholder(isDark),
                          )
                        : _placeholder(isDark),
                    ),
                  ),
                  // Wishlist heart icon (top-right)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: isWishlistProcessing ? null : onWishlistTap,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: isWishlistProcessing
                            ? const Padding(
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppColors.neutral400,
                                ),
                              )
                            : Icon(
                                isWishlisted ? Icons.favorite : Icons.favorite_border,
                                size: 13,
                                color: isWishlisted ? Colors.red : AppColors.neutral800,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _priceLabel(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? AppColors.white : AppColors.neutral900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              _buildRating(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Rating badge (Figma: smaller variant — 43px pill, star 14, text 12px)
  Widget _buildRating(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (product.reviewCount == 0) return const SizedBox.shrink();
    final ratingStr = product.averageRating.toStringAsFixed(1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.successGreen,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 14, color: AppColors.white),
              const SizedBox(width: 1),
              Text(
                ratingStr,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            '${product.reviewCount}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _priceLabel() {
    if (product.type == 'configurable' &&
        product.minimumPrice != null &&
        product.minimumPrice! > 0) {
      return '\$${product.minimumPrice!.toStringAsFixed(0)} – \$${product.price.toStringAsFixed(0)}';
    }
    if (product.hasDiscount) {
      return '\$${product.specialPrice!.toStringAsFixed(2)}';
    }
    return '\$${product.price.toStringAsFixed(2)}';
  }

  Widget _placeholder(bool isDark) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 32,
        color: isDark ? AppColors.neutral500 : AppColors.neutral400,
      ),
    );
  }
}
