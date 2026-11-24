import 'package:flutter/material.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/store_config/store_config.dart';
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
                              errorBuilder: (_, _, _) => _placeholder(),
                              loadingBuilder: (context, child, progress) =>
                                  progress == null ? child : _placeholder(),
                            )
                          : _placeholder(),
                    ),
                  ),
                  // Product Badge: "Sale" (red) or "New" (dark navy) top-left
                  if (product.hasSaleBadge || product.isNew)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: product.hasSaleBadge
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.hasSaleBadge ? 'Sale' : 'New',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  // Wishlist heart icon (top-right)
                  if (StoreConfig.of(context).showWishlist)
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
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 13,
                                  color: isWishlisted
                                      ? Colors.red
                                      : AppColors.neutral800,
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
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (product.priceLabelPrefix != null &&
                        product.priceLabelPrefix!.isNotEmpty) ...[
                      Text(
                        '${product.priceLabelPrefix!} ',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral600,
                        ),
                      ),
                    ],
                    Text(
                      product.displayPriceLabel,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.white : AppColors.neutral900,
                      ),
                    ),
                    if (product.originalPriceLabel != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        product.originalPriceLabel!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.neutral500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
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
    final summaryCount = StoreConfig.of(context).reviewSummaryCount(
      reviewCount: product.reviewCount,
      starCount: product.reviewStarCount,
    );
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
            '$summaryCount',
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

  Widget _placeholder() {
    return Image.asset(AppAssets.largeProductPlaceholder, fit: BoxFit.cover);
  }
}
