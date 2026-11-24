import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';

/// Additional information section with the product's brand.
/// Figma: Frame 1984079209 – info rows like Category, Material, etc.
class ProductMoreInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductMoreInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final infoItems = _buildInfoItems(l10n);
    if (infoItems.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final isExpanded = state.isMoreInfoExpanded;
        final displayItems = isExpanded
            ? infoItems
            : infoItems.take(4).toList();
        final needsExpand = infoItems.length > 4;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.productMoreInformations,
                style: AppTextStyles.text4(context),
              ),
              const SizedBox(height: 16),

              // Info rows
              ...displayItems.map((item) {
                return _buildInfoRow(context, item.$1, item.$2);
              }),

              // Gradient + Load More
              if (needsExpand && !isExpanded) ...[
                const SizedBox(height: 8),
                _buildLoadMoreButton(context, l10n),
              ],

              if (isExpanded && needsExpand) ...[
                const SizedBox(height: 8),
                _buildLoadMoreButton(context, l10n, isCollapse: true),
              ],
            ],
          ),
        );
      },
    );
  }

  List<(String, String)> _buildInfoItems(AppLocalizations l10n) {
    final items = <(String, String)>[];

    final brand = product.brand?.trim();
    if (brand != null && brand.isNotEmpty) {
      items.add((l10n.productBrand, brand));
    }

    return items;
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(
    BuildContext context,
    AppLocalizations l10n, {
    bool isCollapse = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.read<ProductDetailBloc>().add(ToggleMoreInfoExpanded());
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
          isCollapse ? l10n.productShowLess : l10n.productLoadMore,
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
