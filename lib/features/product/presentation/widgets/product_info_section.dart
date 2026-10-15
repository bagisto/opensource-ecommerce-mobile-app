import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../category/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../account/presentation/pages/add_review_page.dart';
import '../bloc/product_detail_bloc.dart';
import 'review_entry.dart';

/// Product info: title, price row, short description, rating badge +
/// review count, stock chip
/// Figma: Frame 1984079200 – below the image carousel
class ProductInfoSection extends StatelessWidget {
  final ProductModel product;
  final ProductVariant? selectedVariant;

  const ProductInfoSection({
    super.key,
    required this.product,
    this.selectedVariant,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Name ──
          Text(
            product.name ?? l10n.productDefaultName,
            style: AppTextStyles.text4(context).copyWith(
              color: isDark ? AppColors.neutral300 : AppColors.neutral800,
            ),
          ),

          const SizedBox(height: 12),

          // ── Price Row ──
          _buildPriceRow(context),

          // ── Short Description (any product type, HTML like the web) ──
          if (_hasText(product.shortDescription))
            Padding(
              key: const ValueKey('product_short_description'),
              padding: const EdgeInsets.only(top: 8),
              child: _buildShortDescription(context, isDark),
            ),

          const SizedBox(height: 12),

          // ── Rating + Stock Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildRatingGroup(context), _buildStockChip(context)],
          ),
        ],
      ),
    );
  }

  /// True when the HTML has visible text (not just empty tags or spaces).
  bool _hasText(String? html) {
    if (html == null) return false;
    return _stripHtml(html).trim().isNotEmpty;
  }

  Widget _buildShortDescription(BuildContext context, bool isDark) {
    final textColor = isDark ? AppColors.neutral400 : AppColors.neutral600;

    return Html(
      data: product.shortDescription,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontFamily: 'Roboto',
          fontSize: FontSize(14),
          lineHeight: LineHeight.number(1.5),
          color: textColor,
        ),
        'p': Style(margin: Margins.zero),
        'ul': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.only(left: 20),
        ),
        'ol': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.only(left: 20),
        ),
        'li': Style(margin: Margins.only(bottom: 4)),
      },
    );
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('\u00A0', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }

  Widget _buildPriceRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayPriceLabel = selectedVariant != null
        ? selectedVariant!.displayPriceLabel
        : product.formattedDisplayPrice;
    final originalPrice = selectedVariant != null
        ? selectedVariant!.originalPrice
        : product.originalPrice;
    final originalPriceLabel = selectedVariant != null
        ? selectedVariant!.originalPriceLabel
        : product.formattedOriginalPrice;
    final displayPrice = selectedVariant != null
        ? selectedVariant!.displayPrice
        : product.displayPrice;

    // Discount percentage
    final discountPercent = (originalPrice != null && originalPrice > 0)
        ? ((originalPrice - displayPrice) / originalPrice * 100).round()
        : product.discountPercent;

    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Current price (Text-1: 24px bold)
        Text(
          displayPriceLabel,
          style: AppTextStyles.text1(context),
        ),

        // Original price strikethrough
        if (originalPrice != null)
          Text(
            originalPriceLabel ?? '',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.17,
              color: AppColors.neutral500,
              decoration: TextDecoration.lineThrough,
            ),
          ),

        // Discount percentage
        if (discountPercent != null && discountPercent > 0)
          Text(
            l10n.productDiscountOff(discountPercent.toString()),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.17,
              color: AppColors.primary500,
            ),
          ),
      ],
    );
  }

  Widget _buildRatingGroup(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rating = product.averageRating;
    final count = product.reviewCount;

    if (count == 0) {
      final reviewEntry = reviewEntryOf(context);
      return Row(
        children: [
          Icon(Icons.star_border, size: 18, color: isDark ? AppColors.neutral400 : AppColors.neutral500),
          const SizedBox(width: 4),
          Text(
            l10n.productNoReviewsYet,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
          if (reviewEntry != ReviewEntry.hidden)
          Row(
            children: [
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () async {
                  final productId = product.numericId;
                  if (productId == null) return;
                  if (openLoginForReview(context, reviewEntry)) return;

                  final submitted = await AddReviewPage.navigate(
                    context,
                    productId: productId,
                    productName: product.name ?? l10n.productDefaultName,
                    productImageUrl: product.baseImageUrl,
                  );

                  if (submitted == true && context.mounted) {
                    final urlKey = product.urlKey;
                    if (urlKey != null) {
                      context.read<ProductDetailBloc>().add(
                            LoadProductDetail(
                              urlKey: urlKey,
                              productType: product.type,
                            ),
                          );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.productReviewSubmitted),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  }
                },
                child: Text(
                  '•  ${l10n.accountAddReview}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary500,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        // ── Green rating badge ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                rating > 0 ? rating.toStringAsFixed(1) : '0.0',
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

        const SizedBox(width: 4),

        // ── Review count ──
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.neutral100 : AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStockChip(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inStock = product.isSaleable ?? true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF008236) // status-success/700
            : const Color(0xFFDCFCE7), // status-success/100
        border: Border.all(
          color: isDark
              ? const Color(0xFF0D542B) // status-success/900
              : const Color(0xFFB9F8CF), // status-success/200
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        inStock ? l10n.productInStock : l10n.productOutOfStock,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark
              ? const Color(0xFFF0FDF4) // status-success/50
              : const Color(0xFF00A63E), // status-success/600
        ),
      ),
    );
  }
}
