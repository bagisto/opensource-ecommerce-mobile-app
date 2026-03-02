import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/account_models.dart';
import 'section_header.dart';

/// Product Reviews section
/// Figma: node-id=220-7367
class ProductReviewsSection extends StatelessWidget {
  final List<ProductReview> reviews;
  final int totalCount;
  final VoidCallback? onViewAll;

  const ProductReviewsSection({
    super.key,
    required this.reviews,
    required this.totalCount,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Product Reviews',
              onViewAll: reviews.isNotEmpty
                  ? onViewAll
                  : null,
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
                    .map((review) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildReviewCard(context, review),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            'No product reviews yet',
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
          // Product info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 62,
                  height: 62,
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  child: review.productImageUrl != null
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
                          errorWidget: (_, _, _) => Icon(
                            Icons.star_outline,
                            color: isDark
                                ? AppColors.neutral500
                                : AppColors.neutral400,
                          ),
                        )
                      : Icon(
                          Icons.star_outline,
                          color: isDark
                              ? AppColors.neutral500
                              : AppColors.neutral400,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              // Product name
              Expanded(
                child: Text(
                  review.productName ?? 'Product',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: isDark
                        ? AppColors.neutral200
                        : AppColors.neutral900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Status + Rating row + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge + rating badge row
              Row(
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: review.isApproved
                          ? const Color(0xFFD4EDDA)
                          : const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: review.isApproved
                            ? const Color(0xFFC3E6CB)
                            : const Color(0xFFFFECB5),
                      ),
                    ),
                    child: Text(
                      review.statusLabel,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: review.isApproved
                            ? const Color(0xFF155724)
                            : const Color(0xFF856404),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildRatingBadge(review.rating),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      review.ratingLabel,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                    ),
                  ),
                ],
              ),
              // Date text below badges
              if (review.formattedDate.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Posted on ${review.formattedDate}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Review title
          Text(
            review.title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 8),
          // Review comment
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

  Widget _buildRatingBadge(int rating) {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 6, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFE9A00),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 16,
            color: AppColors.white,
          ),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
