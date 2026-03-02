import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/add_review_bloc.dart';

/// Add Review Page — Figma node-id=2157-6741
///
/// Full-screen page for submitting a product review:
///   - AppBar: "Add Review" title (left) + × close button (right)
///   - Product card: image + name on neutral-100 background
///   - Star rating selector (1–5, orange #FE9A00 filled stars)
///   - Nick Name* text field
///   - Summary text field
///   - Review multi-line text field
///   - "Submit Review" orange button (full width)
///
/// Requires [productId], [productName], and optional [productImageUrl]
/// to display the product card and submit the review.
class AddReviewPage extends StatefulWidget {
  /// Numeric product ID for the API mutation
  final int productId;

  /// Product name shown in the card header
  final String productName;

  /// Product image URL (nullable)
  final String? productImageUrl;

  const AddReviewPage({
    super.key,
    required this.productId,
    required this.productName,
    this.productImageUrl,
  });

  /// Navigate to AddReviewPage from any context.
  /// Creates its own [AccountRepository] from the auth token so it works
  /// from product-detail, wishlist, or any other page — not just account.
  /// Returns `true` if a review was successfully submitted.
  static Future<bool?> navigate(
    BuildContext context, {
    required int productId,
    required String productName,
    String? productImageUrl,
  }) {
    // Try to reuse an existing AccountRepository from the widget tree;
    // if not available, create one from the current auth token.
    AccountRepository repository;
    try {
      repository = context.read<AccountRepository>();
    } catch (_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        // Not logged in — show a message and bail out.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to write a review')),
        );
        return Future.value(null);
      }
      final client =
          GraphQLClientProvider.authenticatedClient(authState.token);
      repository = AccountRepository(client: client.value);
    }

    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: repository,
          child: BlocProvider(
            create: (_) => AddReviewBloc(repository: repository),
            child: AddReviewPage(
              productId: productId,
              productName: productName,
              productImageUrl: productImageUrl,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _nickNameController = TextEditingController();
  final _summaryController = TextEditingController();
  final _reviewController = TextEditingController();
  int _selectedRating = 0;

  @override
  void dispose() {
    _nickNameController.dispose();
    _summaryController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please select a rating'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      return;
    }

    context.read<AddReviewBloc>().add(SubmitReview(
          productId: widget.productId,
          title: _summaryController.text.trim(),
          comment: _reviewController.text.trim(),
          rating: _selectedRating,
          name: _nickNameController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Text(
          'Add Review',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
        actions: [
          // × close button — Figma: right side of AppBar
          IconButton(
            icon: Icon(
              Icons.close,
              size: 24,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: BlocConsumer<AddReviewBloc, AddReviewState>(
        listener: (context, state) {
          if (state.status == AddReviewStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage ?? 'Review submitted!'),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            // Pop back with true to signal a review was created
            Navigator.of(context).pop(true);
          }
          if (state.status == AddReviewStatus.error &&
              state.errorMessage != null) {
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
            context
                .read<AddReviewBloc>()
                .add(const ClearAddReviewMessage());
          }
        },
        builder: (context, state) {
          final isSubmitting =
              state.status == AddReviewStatus.submitting;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Scrollable form content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // ── Product Card ──
                        _buildProductCard(context),

                        const SizedBox(height: 20),

                        // ── Rating Section ──
                        _buildRatingSection(context),

                        const SizedBox(height: 20),

                        // ── Nick Name Field ──
                        _buildTextField(
                          context,
                          label: 'Nick Name',
                          isRequired: true,
                          controller: _nickNameController,
                          hintText: 'Enter your name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // ── Summary Field ──
                        _buildTextField(
                          context,
                          label: 'Summary',
                          controller: _summaryController,
                          hintText: 'Brief summary of your review',
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Summary is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // ── Review Field ──
                        _buildTextField(
                          context,
                          label: 'Review',
                          controller: _reviewController,
                          hintText: 'Write your detailed review here',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Review is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ── Submit Button (pinned at bottom) ──
                _buildSubmitButton(context, isSubmitting),
              ],
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Product Card — Figma: rounded-10, bg #F5F5F5
  // ──────────────────────────────────────────────

  Widget _buildProductCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
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
            child: widget.productImageUrl != null &&
                    widget.productImageUrl!.isNotEmpty
                ? Image.network(
                    widget.productImageUrl!,
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

          // Product name — Figma: Medium 16px, #171717
          Expanded(
            child: Text(
              widget.productName,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Rating Section — "Rating" label + 5 stars
  // ──────────────────────────────────────────────

  Widget _buildRatingSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Rating" label
        Text(
          'Rating',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral300 : AppColors.neutral900,
          ),
        ),
        const SizedBox(height: 8),

        // 5 interactive stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= _selectedRating;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = starIndex;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 36,
                  color: isFilled
                      ? const Color(0xFFFE9A00) // status-info/500
                      : (isDark
                          ? AppColors.neutral600
                          : AppColors.neutral300),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Text Field — outlined input matching Figma
  // ──────────────────────────────────────────────

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool isRequired = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label with optional asterisk
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),

        // Text input — Figma: rounded-10, border #E5E5E5
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : AppColors.neutral900,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.neutral400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.primary500,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Submit Button — Figma: orange pill, full width
  // ──────────────────────────────────────────────

  Widget _buildSubmitButton(BuildContext context, bool isSubmitting) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.primary500.withValues(alpha: 0.6),
            disabledForegroundColor: AppColors.white.withValues(alpha: 0.8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(54),
            ),
          ),
          child: isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Text(
                  'Submit Review',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
