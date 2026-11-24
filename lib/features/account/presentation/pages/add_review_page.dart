import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/add_review_bloc.dart';
import '../widgets/review_video_thumbnail.dart';
import 'review_video_player_page.dart';

/// A photo or video picked for attachment to a review, pending submission.
class _ReviewAttachment {
  final XFile file;
  final bool isVideo;

  const _ReviewAttachment({required this.file, required this.isVideo});
}

/// Add Review Page — Figma node-id=2157-6741
///
/// Full-screen page for submitting a product review:
///   - AppBar: "Add Review" title (left) + × close button (right)
///   - Product card: image + name on neutral-100 background
///   - Star rating selector (1–5, orange #FE9A00 filled stars)
///   - Name* text field
///   - Title text field
///   - Comment multi-line text field
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

  /// Whether this submission is from a guest (no signed-in customer).
  /// Guests get an extra required Name field since there's no profile to
  /// pull a name from. Defaults to false — logged-in behaviour, untouched.
  final bool isGuest;

  const AddReviewPage({
    super.key,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    this.isGuest = false,
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
    bool isGuest = false;
    try {
      repository = context.read<AccountRepository>();
    } catch (_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final client = GraphQLClientProvider.authenticatedClient(
          authState.token,
        );
        repository = AccountRepository(client: client.value);
      } else {
        // Guest — no token to attach. The button that leads here is only
        // shown when Admin's "Allow Guest Review" config is on.
        isGuest = true;
        repository = AccountRepository(
          client: GraphQLClientProvider.client.value,
        );
      }
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
              isGuest: isGuest,
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
  static const int _maxAttachments = 5;
  // Backend rejects anything over 5MB (confirmed for both image and video
  // attachments — "Image size must not exceed 5MB"), so match it here to
  // fail fast client-side instead of a backend 500/validation error.
  static const int _maxAttachmentSizeBytes = 5 * 1024 * 1024; // 5 MB

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _summaryController = TextEditingController();
  final _reviewController = TextEditingController();
  final _imagePicker = ImagePicker();
  int _selectedRating = 0;
  String? _ratingErrorText;
  final List<_ReviewAttachment> _attachments = [];

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _addAttachment(XFile? picked, {required bool isVideo}) async {
    if (picked == null) return;

    final l10n = AppLocalizations.of(context)!;
    final size = await picked.length();
    if (size > _maxAttachmentSizeBytes) {
      if (!mounted) return;
      _showAttachmentMessage(l10n.accountReviewAttachmentTooLarge);
      return;
    }

    if (!mounted) return;
    setState(() {
      _attachments.add(_ReviewAttachment(file: picked, isVideo: isVideo));
    });
  }

  Future<void> _pickPhoto(ImageSource source) async {
    Navigator.of(context).pop();
    final file = await _imagePicker.pickImage(source: source, imageQuality: 85);
    await _addAttachment(file, isVideo: false);
  }

  Future<void> _pickVideo() async {
    Navigator.of(context).pop();
    final file = await _imagePicker.pickVideo(source: ImageSource.gallery);
    await _addAttachment(file, isVideo: true);
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _showAttachmentMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  void _showAttachmentPicker() {
    final l10n = AppLocalizations.of(context)!;

    if (_attachments.length >= _maxAttachments) {
      _showAttachmentMessage(l10n.accountReviewAttachmentLimitReached);
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.accountReviewTakePhoto),
                onTap: () => _pickPhoto(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.accountReviewChooseFromGallery),
                onTap: () => _pickPhoto(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: Text(l10n.accountReviewChooseVideo),
                onTap: _pickVideo,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;

    final isFormValid = _formKey.currentState!.validate();
    final ratingError = _selectedRating == 0
        ? l10n.accountPleaseSelectRating
        : null;

    setState(() {
      _ratingErrorText = ratingError;
    });

    if (!isFormValid || ratingError != null) {
      return;
    }

    context.read<AddReviewBloc>().add(
      SubmitReview(
        productId: widget.productId,
        title: _summaryController.text.trim(),
        comment: _reviewController.text.trim(),
        rating: _selectedRating,
        guestName: widget.isGuest ? _nameController.text.trim() : null,
        attachmentPaths: _attachments.isEmpty
            ? null
            : _attachments.map((a) => a.file.path).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Text(
          l10n.accountAddReview,
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<AddReviewBloc, AddReviewState>(
          listener: (context, state) {
            if (state.status == AddReviewStatus.success) {
              // No SnackBar here — this page closes immediately and the
              // caller (product page) shows its own success message once the
              // product data has actually refreshed. Showing one here too
              // just doubled up the toast.
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
              context.read<AddReviewBloc>().add(const ClearAddReviewMessage());
            }
          },
          builder: (context, state) {
            final isSubmitting = state.status == AddReviewStatus.submitting;

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

                          // ── Name Field — guest reviewers only. Logged-in
                          // users keep the existing profile-name lookup. ──
                          if (widget.isGuest) ...[
                            _buildTextField(
                              context,
                              label: l10n.accountName,
                              isRequired: true,
                              controller: _nameController,
                              hintText: l10n.accountName,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.accountNameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ── Title Field ──
                          _buildTextField(
                            context,
                            label: l10n.accountSummary,
                            isRequired: true,
                            controller: _summaryController,
                            hintText: l10n.accountReviewSummaryHint,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.accountSummaryRequired;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // ── Comment Field ──
                          _buildTextField(
                            context,
                            label: l10n.accountReview,
                            isRequired: true,
                            controller: _reviewController,
                            hintText: l10n.accountDetailedReviewHint,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.accountReviewRequired;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // ── Attachments Section (photo/video) ──
                          _buildAttachmentsSection(context),

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
            child:
                widget.productImageUrl != null &&
                    widget.productImageUrl!.isNotEmpty
                ? Image.network(
                    widget.productImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Rating" label
        _buildFieldLabel(context, label: l10n.accountRating, isRequired: true),
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
                  _ratingErrorText = null;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 36,
                  color: isFilled
                      ? const Color(0xFFFE9A00) // status-info/500
                      : (isDark ? AppColors.neutral600 : AppColors.neutral300),
                ),
              ),
            );
          }),
        ),
        if (_ratingErrorText != null) ...[
          const SizedBox(height: 8),
          Text(
            _ratingErrorText!,
            style: TextStyle(fontSize: 12, color: Colors.red.shade400),
          ),
        ],
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Attachments Section — optional photo/video tiles + add button
  // ──────────────────────────────────────────────

  Widget _buildAttachmentsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(context, label: l10n.accountReviewAttachmentsLabel),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < _attachments.length; i++)
              _buildAttachmentTile(context, index: i),
            if (_attachments.length < _maxAttachments)
              _buildAddAttachmentTile(context),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentTile(BuildContext context, {required int index}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attachment = _attachments[index];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          ),
          clipBehavior: Clip.antiAlias,
          child: attachment.isVideo
              // A picked video gets the same real thumbnail and play
              // affordance as one already posted, and opens on tap.
              ? GestureDetector(
                  key: ValueKey('add_review_media_open_$index'),
                  onTap: () => ReviewVideoPlayerPage.navigateFile(
                    context,
                    File(attachment.file.path),
                  ),
                  child: ReviewVideoThumbnail(
                    file: File(attachment.file.path),
                    iconSize: 32,
                  ),
                )
              : Image.file(
                  File(attachment.file.path),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 28,
                      color: AppColors.neutral400,
                    ),
                  ),
                ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () => _removeAttachment(index),
            child: Semantics(
              button: true,
              label: AppLocalizations.of(
                context,
              )!.accountReviewRemoveAttachment,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddAttachmentTile(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _showAttachmentPicker,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 24,
          color: isDark ? AppColors.neutral400 : AppColors.neutral500,
        ),
      ),
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
        _buildFieldLabel(context, label: label, isRequired: isRequired),
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
              borderSide: BorderSide(color: AppColors.primary500, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(
    BuildContext context, {
    required String label,
    bool isRequired = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RichText(
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
    );
  }

  // ──────────────────────────────────────────────
  // Submit Button — Figma: orange pill, full width
  // ──────────────────────────────────────────────

  Widget _buildSubmitButton(BuildContext context, bool isSubmitting) {
    final l10n = AppLocalizations.of(context)!;

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
            disabledBackgroundColor: AppColors.primary500.withValues(
              alpha: 0.6,
            ),
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
              : Text(
                  l10n.accountSubmitReview,
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
