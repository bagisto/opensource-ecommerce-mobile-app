import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
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
              _buildImage(w, isDark),
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

  Widget _buildImage(double size, bool isDark) {
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
                    errorBuilder: (_, __, ___) => _imagePlaceholder(isDark),
                  )
                : _imagePlaceholder(isDark),
          ),
        ),
        // Wishlist heart icon (top-right 24×24)
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
    if (product.hasDiscount) {
      // Figma: flex row (not wrap) with gap-3, items centered vertically
      // Use FittedBox to scale down when content exceeds card width
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\$${product.specialPrice!.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 1.0,
                color: isDark ? AppColors.white : AppColors.neutral900,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.0,
                color: AppColors.neutral500,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              '${product.discountPercent}% off',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.0,
                color: AppColors.primary500,
              ),
            ),
          ],
        ),
      );
    }

    final displayPrice =
        product.type == 'configurable' &&
            product.minimumPrice != null &&
            product.minimumPrice! > 0
        ? '\$${product.minimumPrice!.toStringAsFixed(2)}'
        : '\$${product.price.toStringAsFixed(2)}';

    return Text(
      displayPrice,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 1.0,
        color: isDark ? AppColors.white : AppColors.neutral900,
      ),
    );
  }

  /// Rating badge (Figma: bg #00A63E rounded-6, star + rating bold white, count 14px)
  Widget _buildRating(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (product.reviewCount == 0) return const SizedBox.shrink();
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
            '${product.reviewCount}',
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

  Widget _imagePlaceholder(bool isDark) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 40,
        color: isDark ? AppColors.neutral500 : AppColors.neutral400,
      ),
    );
  }
}
