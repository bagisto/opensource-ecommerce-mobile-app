import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../data/models/account_models.dart';
import 'section_header.dart';

/// Opens the product a customer review belongs to.
void openReviewedProduct(BuildContext context, ProductReview review) {
  final productId = review.productId;
  if (productId == null || productId <= 0) return;
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ProductDetailPage(
        productId: productId.toString(),
        productName: review.productName,
      ),
    ),
  );
}

/// Product Reviews section
/// Figma: node-id=220-7367
class ProductReviewsSection extends StatelessWidget {
  final List<ProductReview> reviews;
  final int totalCount;
  final VoidCallback? onViewAll;

  /// Called when a review card is tapped (e.g. to open its product).
  final ValueChanged<ProductReview>? onReviewTap;

  const ProductReviewsSection({
    super.key,
    required this.reviews,
    required this.totalCount,
    this.onViewAll,
    this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: l10n.accountProductReviews,
              onViewAll: reviews.isNotEmpty ? onViewAll : null,
            ),
          ),
          const SizedBox(height: 2),
          if (reviews.isEmpty)
            _buildEmptyState(context)
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: reviews
                    .take(3)
                    .map(
                      (review) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onReviewTap == null || review.productId == null
                              ? null
                              : () => onReviewTap!(review),
                          child: _buildReviewCard(context, review),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        child: Center(
          child: Text(
            l10n.accountNoProductReviewsYet,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, ProductReview review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 62,
                  height: 62,
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  child: review.productImageUrl != null &&
                          review.productImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: review.productImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary500,
                              ),
                            ),
                          ),
                          errorWidget: (_, _, _) => Image.asset(
                            AppAssets.productPlaceholder,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          AppAssets.productPlaceholder,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.title,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                    ),
                    if (review.formattedDateTime.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        review.formattedDateTime,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 18,
                          color: index < review.rating
                              ? const Color(0xFFFF9800)
                              : AppColors.neutral500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral300 : AppColors.neutral700,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
