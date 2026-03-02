import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';

/// "More Informations" section with key-value pairs
/// Figma: Frame 1984079209 – info rows like Category, Material, etc.
class ProductMoreInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductMoreInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final infoItems = _buildInfoItems();
    if (infoItems.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final isExpanded = state.isMoreInfoExpanded;
        final displayItems =
            isExpanded ? infoItems : infoItems.take(4).toList();
        final needsExpand = infoItems.length > 4;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More Informations',
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
                _buildLoadMoreButton(context),
              ],

              if (isExpanded && needsExpand) ...[
                const SizedBox(height: 8),
                _buildLoadMoreButton(context, isCollapse: true),
              ],
            ],
          ),
        );
      },
    );
  }

  List<(String, String)> _buildInfoItems() {
    final items = <(String, String)>[];

    if (product.sku != null && product.sku!.isNotEmpty) {
      items.add(('SKU', product.sku!));
    }
    if (product.type != null && product.type!.isNotEmpty) {
      items.add(('Type', product.type!));
    }
    if (product.brand != null && product.brand!.isNotEmpty) {
      items.add(('Brand', product.brand!));
    }
    if (product.color != null && product.color!.isNotEmpty) {
      items.add(('Color', product.color!));
    }
    if (product.size != null && product.size!.isNotEmpty) {
      items.add(('Size', product.size!));
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

  Widget _buildLoadMoreButton(BuildContext context,
      {bool isCollapse = false}) {
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
          isCollapse ? 'Show Less' : 'Load More',
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
