import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../data/models/account_models.dart';
import '../bloc/review_bloc.dart';

/// Reviews Page — Figma node-id=245-5802
///
/// Displays a list of the customer's product reviews:
///   - AppBar: back arrow + "Reviews" title
///   - Count header: "N Reviews" + sort icon
///   - Review cards with product image, name, rating badge, date, title, comment
///
/// Architecture:
///   BlocProvider<ReviewBloc> → ReviewsPage → Repository → GraphQL
class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mode = context.read<ReviewBloc>().state.mode;
    final pageTitle =
        mode == ReviewMode.product ? 'Product Reviews' : 'My Reviews';

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: AppBackButton(),
        leadingWidth: 60,
        titleSpacing: 0,
        title: Text(
          pageTitle,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != ReviewStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            context.read<ReviewBloc>().add(const ClearReviewMessage());
          }
        },
        builder: (context, state) {
          if (state.status == ReviewStatus.loading &&
              state.reviews.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ReviewStatus.error &&
              state.reviews.isEmpty) {
            return _buildErrorState(context, state.errorMessage);
          }

          if (state.reviews.isEmpty) {
            return _buildEmptyState(context);
          }

          return _ReviewList(
            reviews: state.reviews,
            totalCount: state.totalCount,
            hasNextPage: state.hasNextPage,
            isLoadingMore: state.isLoadingMore,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Reviews Yet',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your product reviews will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context
                  .read<ReviewBloc>()
                  .add(const LoadReviews()),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Review List — scrollable list with count header
// ──────────────────────────────────────────────

class _ReviewList extends StatefulWidget {
  final List<ProductReview> reviews;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;

  const _ReviewList({
    required this.reviews,
    required this.totalCount,
    required this.hasNextPage,
    required this.isLoadingMore,
  });

  @override
  State<_ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<_ReviewList> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Update scroll arrow visibility
    final hasScrollableContent =
        _scrollController.position.maxScrollExtent > 0;
    final atTop = _scrollController.position.pixels <= 0;
    final atBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10;

    setState(() {
      _canScrollUp = hasScrollableContent && !atTop;
      _canScrollDown = hasScrollableContent && !atBottom;
    });

    // Load more reviews when reaching near the bottom
    if (!widget.hasNextPage || widget.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<ReviewBloc>().add(const LoadMoreReviews());
    }
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Scroll navigation arrows
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              // Previous arrow
              Opacity(
                opacity: _canScrollUp ? 1.0 : 0.3,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _canScrollUp ? _scrollUp : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral200,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Next arrow
              Opacity(
                opacity: _canScrollDown ? 1.0 : 0.3,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _canScrollDown ? _scrollDown : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral800
                              : AppColors.neutral100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.neutral700
                                : AppColors.neutral200,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),

        // Reviews list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // +1 for header, +1 for loading indicator if loading more
            itemCount:
                widget.reviews.length + 1 + (widget.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // First item: count header row
              if (index == 0) {
                return _CountHeader(totalCount: widget.totalCount);
              }

              // Loading more indicator at the bottom
              if (index == widget.reviews.length + 1) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              // Review card
              final review = widget.reviews[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ReviewCard(review: review),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Count Header: "N Reviews" + sort icon
// Figma node-id=245-5806
// ──────────────────────────────────────────────

class _CountHeader extends StatelessWidget {
  final int totalCount;
  const _CountHeader({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "N Reviews" — Figma node: 245:5807
          Text(
            '$totalCount Review${totalCount == 1 ? '' : 's'}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),

          // Sort/filter icon — Figma node: 245:5808
          Icon(
            Icons.swap_vert_rounded,
            size: 20,
            color: isDark ? AppColors.neutral400 : AppColors.neutral700,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Review Card — Figma node: cart-item/light
// Background: #F5F5F5, border: 1px #E5E5E5, rounded-10, p-12
// ──────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  final ProductReview review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product header: image + name ──
          _buildProductHeader(context),

          const SizedBox(height: 8),

          // ── Rating row + date ──
          _buildRatingRow(context),

          const SizedBox(height: 12),

          // ── Review title ──
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

          // ── Review comment ──
          Text(
            review.comment,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral300 : AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }

  /// Product header: 62×62 rounded-8 image + product name
  /// Figma node: 245:6082
  Widget _buildProductHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image — 62×62, rounded-8
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDark ? AppColors.neutral700 : const Color(0x1A0E1019),
          ),
          clipBehavior: Clip.antiAlias,
          child: review.productImageUrl != null &&
                  review.productImageUrl!.isNotEmpty
              ? Image.network(
                  review.productImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 28,
                      color: AppColors.neutral400,
                    ),
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 28,
                    color: AppColors.neutral400,
                  ),
                ),
        ),

        const SizedBox(width: 10),

        // Product name — Figma node: 245:6085
        Expanded(
          child: Text(
            review.productName ?? review.name,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
        ),
      ],
    );
  }

  /// Rating badge row: [⭐ 4.5] Average, [Approved] ... Posted on 25 Nov 2024
  /// Figma node: 152:4078
  Widget _buildRatingRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges row: status badge + rating badge + label
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
            // Orange rating badge — Figma: bg #FE9A00, rounded-6
            Container(
              padding: const EdgeInsets.only(
                left: 4,
                right: 6,
                top: 4,
                bottom: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFE9A00),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.white),
                  const SizedBox(width: 1),
                  Text(
                    review.rating > 0
                        ? review.rating.toStringAsFixed(1)
                        : '0.0',
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
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                review.ratingLabel,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
            ),
          ],
        ),

        // Date row below badges
        if (review.formattedDate.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Posted on ${review.formattedDate}',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: AppColors.neutral500,
            ),
          ),
        ],
      ],
    );
  }
}
