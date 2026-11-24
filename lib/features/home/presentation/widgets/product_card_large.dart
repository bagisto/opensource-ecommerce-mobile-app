import 'package:flutter/material.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/store_config/store_config.dart';
import '../../data/models/home_models.dart';

/// Large product card (Figma node 86:962).
///
/// Fully responsive — accepts an optional [cardWidth]. If not provided,
/// calculates from screen width: `(screenWidth - 40 - 12) / 2` which
/// matches the Figma 375px → 162px formula (20px padding each side + 12px gap).
///
/// Figma spec:
///   • Square rounded-12 image, overlay tint rgba(14,16,25,0.1)
///   • Shopping-bag icon overlay top-right (24×24)
///   • Product name 14px regular #262626, single-line ellipsis
///   • Price: $special 18px semibold #171717 + $original 14px #737373 strikethrough + discount% 14px semibold #FF6900
///   • Rating: green #00A63E rounded-6 pill (star 16px white + rating 14px bold white) + count 14px #171717
class ProductCardLarge extends StatelessWidget {
  final HomeProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;
  final bool isWishlistProcessing;
  final bool showWishlistIcon;

  /// Optional explicit width. If null, calculated from screen width.
  final double? cardWidth;

  const ProductCardLarge({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onWishlistTap,
    this.isWishlisted = false,
    this.isWishlistProcessing = false,
    this.showWishlistIcon = true,
    this.cardWidth,
  });

  double _resolveWidth(BuildContext context) {
    if (cardWidth != null) return cardWidth!;
    final screenWidth = MediaQuery.of(context).size.width;
    // Figma: 20px padding each side + 12px gap between 2 cards
    return (screenWidth - 40 - 12) / 2;
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
              _buildImage(context, w),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.2,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 7),
              _buildPriceRow(context),
              const SizedBox(height: 7),
              _buildRating(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, double size) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: size,
            height: size,
            color: const Color(0x1A0E1019),
            child:
                product.baseImageUrl != null && product.baseImageUrl!.isNotEmpty
                ? Image.network(
                    product.baseImageUrl!,
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : _imagePlaceholder(size),
                    errorBuilder: (context, error, stackTrace) =>
                        _imagePlaceholder(size),
                  )
                : _imagePlaceholder(size),
          ),
        ),
        // Product Badge: "Sale" (red) or "New" (dark navy) top-left
        if (product.hasSaleBadge || product.isNew)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ),
          ),
        if (showWishlistIcon && StoreConfig.of(context).showWishlist)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: isWishlistProcessing ? null : onWishlistTap,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: isWishlistProcessing
                    ? const Padding(
                        padding: EdgeInsets.all(6),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.neutral400,
                        ),
                      )
                    : Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isWishlisted ? Colors.red : AppColors.neutral800,
                      ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefix = product.priceLabelPrefix;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prefix != null && prefix.isNotEmpty) ...[
            Text(
              '$prefix ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.0,
                color: isDark ? AppColors.neutral400 : AppColors.neutral600,
              ),
            ),
          ],
          Text(
            product.displayPriceLabel,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              height: 1.0,
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
                fontSize: 14,
                height: 1.0,
                color: AppColors.neutral500,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Rating badge (Figma: bg #00A63E rounded-6, star + rating bold white, count 14px)
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
          padding: const EdgeInsets.only(left: 2, right: 4, top: 3, bottom: 3),
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
                ratingStr,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
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
              fontSize: 14,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder(double size) {
    return Image.asset(
      AppAssets.largeProductPlaceholder,
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }
}
