import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';

/// Description section with "Load More" toggle
/// Figma: "Details" section with text and "Load More" link
class ProductDescriptionSection extends StatelessWidget {
  final ProductModel product;

  const ProductDescriptionSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final description = product.description ?? product.shortDescription ?? '';
    if (description.isEmpty) return const SizedBox.shrink();

    // Strip HTML tags for display
    final cleanText = _stripHtml(description);

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final isExpanded = state.isDescriptionExpanded;
        final maxChars = 200;
        final needsTruncation = cleanText.length > maxChars;
        final displayText = (!isExpanded && needsTruncation)
            ? '${cleanText.substring(0, maxChars)}...'
            : cleanText;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details',
                style: AppTextStyles.text4(context),
              ),
              const SizedBox(height: 16),
              Text(
                displayText,
                style: AppTextStyles.bodyText(context),
              ),
              if (needsTruncation) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ProductDetailBloc>()
                        .add(ToggleDescriptionExpanded());
                  },
                  child: Text(
                    isExpanded ? 'Show Less' : 'Load More',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }
}
