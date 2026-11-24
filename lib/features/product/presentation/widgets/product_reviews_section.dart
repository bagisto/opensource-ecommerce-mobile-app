import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../account/data/models/review_attachment.dart';
import '../../../account/presentation/widgets/review_attachments_strip.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../account/presentation/bloc/review_bloc.dart';
import '../../../account/presentation/pages/add_review_page.dart';
import '../../../account/presentation/pages/reviews_page.dart';
import '../../../category/data/models/product_model.dart';
import '../../../../core/store_config/store_config.dart';
import 'review_entry.dart';
import '../bloc/product_detail_bloc.dart';

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
    final totalCount = product.totalReviewCount ?? reviews.length;
    final totalStars = reviews.fold<int>(
      0,
      (sum, review) => sum + review.rating.round(),
    );
    final summaryCount = StoreConfig.of(
      context,
    ).reviewSummaryCount(reviewCount: totalCount, starCount: totalStars);

    // Rating distribution for 5 Stars to 1 Stars
    final dist = <String, int>{
      '5 Stars': 0,
      '4 Stars': 0,
      '3 Stars': 0,
      '2 Stars': 0,
      '1 Stars': 0,
    };
    for (final r in reviews) {
      final star = r.rating.round().clamp(1, 5);
      final key = '$star Stars';
      dist[key] = (dist[key] ?? 0) + 1;
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
                        style: const TextStyle(
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var star = 1; star <= 5; star++)
                            Icon(
                              star <= avgRating.floor()
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 14,
                              color: const Color(0xFFFE9A00),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.productRating(summaryCount),
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
                  label: entry.key,
                  fraction: fraction,
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
    required String label,
    required double fraction,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const barColor = Color(0xFFFE9A00);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 48,
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
              height: 6,
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FractionallySizedBox(
                widthFactor: fraction.clamp(0.0, 1.0),
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
        ],
      ),
    );
  }

  /// The product query answers null for a review's `attachments`, so the
  /// media comes from the bloc's side fetch, keyed by review id. Whatever the
  /// review already carries wins, for a server that does fill the field in.
  List<ReviewAttachment> _attachmentsFor(
    BuildContext context,
    ProductReview review,
  ) {
    if (review.attachments.isNotEmpty) return review.attachments;
    final byId = context.read<ProductDetailBloc>().state.reviewAttachments;
    return byId[reviewIdKey(review.id)] ?? const [];
  }

  Widget _buildReviewCard(BuildContext context, ProductReview review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reviewerInitials = (review.name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();

    final reviewerName = review.name != null && review.name!.isNotEmpty
        ? (StoreConfig.of(context).censorReviewerName
            ? censoredReviewerName(review.name!)
            : review.name!)
        : '';

    // Parse date: e.g. "Oct 19, 2026"
    String dateStr = '';
    if (review.createdAt != null && review.createdAt!.isNotEmpty) {
      try {
        final dt = DateTime.parse(review.createdAt!);
        const months = [
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
        dateStr = '${months[dt.month]} ${dt.day}, ${dt.year}';
      } catch (_) {
        dateStr = review.createdAt!;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Avatar (rounded square) + Name + Date + 5 Stars ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 48,
                  height: 48,
                  color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  alignment: Alignment.center,
                  child: review.customerImageUrl != null &&
                          review.customerImageUrl!.isNotEmpty
                      ? Image.network(
                          review.customerImageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Text(
                            reviewerInitials,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.neutral300
                                  : AppColors.neutral700,
                            ),
                          ),
                        )
                      : Text(
                          reviewerInitials,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral700,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (reviewerName.isNotEmpty)
                      Text(
                        reviewerName,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral900,
                        ),
                      ),
                    if (dateStr.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var star = 1; star <= 5; star++)
                          Icon(
                            star <= review.rating.round()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 16,
                            color: const Color(0xFFFE9A00),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Title ──
          if (review.title != null && review.title!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.title!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
          ],

          // ── Comment ──
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.neutral300 : AppColors.neutral700,
              ),
            ),
          ],

          // ── Attachments ──
          if (_attachmentsFor(context, review).isNotEmpty) ...[
            const SizedBox(height: 12),
            ReviewAttachmentsStrip(
              attachments: _attachmentsFor(context, review),
            ),
          ],
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
              style: const TextStyle(
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
