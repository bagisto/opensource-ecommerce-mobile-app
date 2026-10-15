import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../account/presentation/bloc/review_bloc.dart';
import '../../../account/presentation/pages/add_review_page.dart';
import '../../../account/presentation/pages/reviews_page.dart';
import '../../../account/presentation/widgets/review_attachments_strip.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';
import '../../../../core/store_config/store_config.dart';
import 'review_entry.dart';

/// Reviews section with rating summary, bars, and individual review cards
/// Figma: Frame 1984079219 – Reviews with rating breakdown and review list
class ProductReviewsSection extends StatelessWidget {
  final ProductModel product;

  const ProductReviewsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reviews = product.reviews;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header + Write a Review button ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.productReviews, style: AppTextStyles.text4(context)),
              _buildWriteReviewButton(context),
            ],
          ),

          const SizedBox(height: 16),

          // ── Rating Summary + Breakdown ──
          if (reviews.isNotEmpty) _buildRatingSummary(context, reviews, l10n),

          if (reviews.isNotEmpty) const SizedBox(height: 16),

          // ── Review Cards ──
          if (reviews.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                l10n.productNoReviewsYet,
                style: AppTextStyles.text5(context),
              ),
            )
          else
            ...reviews.take(5).map((review) {
              return _buildReviewCard(context, review);
            }),

          // ── Load More Reviews ──
          if (reviews.length > 4) ...[
            const SizedBox(height: 8),
            _buildLoadMoreButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingSummary(
    BuildContext context,
    List<ProductReview> reviews,
    AppLocalizations l10n,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avgRating = product.averageRating;
    final totalCount = reviews.length;

    // Rating distribution
    final dist = <String, int>{
      l10n.productVeryGood: 0,
      l10n.productGood: 0,
      l10n.productAverage: 0,
      l10n.productBad: 0,
      l10n.productVeryBad: 0,
    };
    for (final r in reviews) {
      if (r.rating >= 4.5) {
        dist[l10n.productVeryGood] = (dist[l10n.productVeryGood] ?? 0) + 1;
      } else if (r.rating >= 3.5) {
        dist[l10n.productGood] = (dist[l10n.productGood] ?? 0) + 1;
      } else if (r.rating >= 2.5) {
        dist[l10n.productAverage] = (dist[l10n.productAverage] ?? 0) + 1;
      } else if (r.rating >= 1.5) {
        dist[l10n.productBad] = (dist[l10n.productBad] ?? 0) + 1;
      } else {
        dist[l10n.productVeryBad] = (dist[l10n.productVeryBad] ?? 0) + 1;
      }
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: Big rating ──
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? AppColors.neutral700 : AppColors.neutral300,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 26, color: AppColors.white),
                      const SizedBox(width: 6),
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 1.3,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        l10n.productRating(totalCount),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral700,
                        ),
                      ),
                      Text(
                        l10n.productReviewsCount(totalCount),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ── Right: Bar chart ──
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dist.entries.map((entry) {
                final count = entry.value;
                final fraction = totalCount > 0 ? count / totalCount : 0.0;
                return _buildRatingBar(
                  context,
                  l10n: l10n,
                  label: entry.key,
                  fraction: fraction,
                  count: count,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(
    BuildContext context, {
    required AppLocalizations l10n,
    required String label,
    required double fraction,
    required int count,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color barColor;
    switch (label) {
      case 'Very Good':
        barColor = AppColors.successGreen;
        break;
      case 'Good':
        barColor = const Color(0xFF7CCF00); // lime/500
        break;
      case 'Average':
        barColor = const Color(0xFFFE9A00); // status-info/500
        break;
      case 'Bad':
        barColor = const Color(0xFFFE9A00);
        break;
      case 'Very Bad':
        barColor = const Color(0xFFFB2C36); // status-error/500
        break;
      default:
        barColor = AppColors.neutral400;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: isDark ? AppColors.neutral400 : AppColors.neutral700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FractionallySizedBox(
                widthFactor: fraction,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: isDark ? AppColors.neutral400 : AppColors.neutral700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, ProductReview review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color ratingBgColor;
    final rating = review.rating;
    if (rating >= 4.5) {
      ratingBgColor = AppColors.successGreen;
    } else if (rating >= 3.5) {
      ratingBgColor = const Color(0xFF7CCF00);
    } else if (rating >= 2.5) {
      ratingBgColor = const Color(0xFFFE9A00);
    } else if (rating >= 1.5) {
      ratingBgColor = AppColors.primary500;
    } else {
      ratingBgColor = const Color(0xFFFB2C36);
    }

    // Parse date
    String dateStr = '';
    if (review.createdAt != null) {
      try {
        final dt = DateTime.parse(review.createdAt!);
        final months = [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        dateStr = 'Posted on ${dt.day} ${months[dt.month]} ${dt.year}';
      } catch (_) {
        dateStr = '';
      }
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: rating badge + label + date ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ratingBgColor,
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
                          const SizedBox(width: 1),
                          Text(
                            rating.toStringAsFixed(1),
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
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        review.ratingLabel,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (dateStr.isNotEmpty)
                Flexible(
                  child: Text(
                    dateStr,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutral500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Title ──
          if (review.title != null && review.title!.isNotEmpty)
            Text(
              review.title!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),

          if (review.title != null && review.title!.isNotEmpty)
            const SizedBox(height: 8),

          // ── Comment ──
          if (review.comment != null && review.comment!.isNotEmpty)
            Text(
              review.comment!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.neutral300 : AppColors.neutral800,
              ),
            ),

          if (review.attachments.isNotEmpty) ...[
            const SizedBox(height: 12),
            ReviewAttachmentsStrip(attachments: review.attachments),
          ],

          const SizedBox(height: 12),

          // ── Author ──
          if (review.name != null && review.name!.isNotEmpty)
            Text(
              // Admin "Censoring Reviewer Name" hides who wrote it.
              '— ${StoreConfig.of(context).censorReviewerName ? censoredReviewerName(review.name!) : review.name!}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.neutral300 : AppColors.neutral800,
              ),
            ),
        ],
      ),
    );
  }

  /// "Write a Review" button
  Widget _buildWriteReviewButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final entry = reviewEntryFor(
          StoreConfig.of(context),
          isLoggedIn: authState is AuthAuthenticated,
        );
        if (entry == ReviewEntry.hidden) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () async {
            final productId = product.numericId;
            if (productId == null) return;
            if (openLoginForReview(context, entry)) return;

            final submitted = await AddReviewPage.navigate(
              context,
              productId: productId,
              productName:
                  product.name ??
                  AppLocalizations.of(context)!.productDefaultName,
              productImageUrl: product.baseImageUrl,
            );

            // Refresh product page after successful review submission
            if (submitted == true && context.mounted) {
              final urlKey = product.urlKey;
              if (urlKey != null) {
                context.read<ProductDetailBloc>().add(
                  LoadProductDetail(urlKey: urlKey, productType: product.type),
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.productReviewSubmitted,
                  ),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary500,
              borderRadius: BorderRadius.circular(54),
            ),
            child: Text(
              AppLocalizations.of(context)!.productWriteReview,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        // Navigate to full reviews list page with ReviewBloc
        final accessToken = await AuthStorage.getToken();
        if (!context.mounted) return;
        if (accessToken == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.productPleaseLoginForReviews,
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        final client = GraphQLClientProvider.authenticatedClient(
          accessToken,
        ).value;
        final repository = AccountRepository(client: client);
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
              value: repository,
              child: BlocProvider(
                create: (_) => ReviewBloc(repository: repository)
                  ..add(
                    LoadReviews(
                      mode: ReviewMode.product,
                      productId: product.numericId,
                    ),
                  ),
                child: ReviewsPage(productId: product.numericId),
              ),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
          borderRadius: BorderRadius.circular(54),
        ),
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context)!.productLoadMoreReviews,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.primary500,
          ),
        ),
      ),
    );
  }
}
