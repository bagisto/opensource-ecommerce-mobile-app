import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../category/data/models/product_model.dart';
import '../bloc/product_detail_bloc.dart';

class ProductGroupedProductsSection extends StatelessWidget {
  final ProductModel product;

  const ProductGroupedProductsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final groupedProducts = List<GroupedProductItem>.from(
      product.groupedProducts,
    )..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));

    if (groupedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      buildWhen: (previous, current) =>
          previous.groupedQuantities != current.groupedQuantities,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedProducts
              .map(
                (groupedProduct) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _GroupedProductItemCard(
                    groupedProduct: groupedProduct,
                    quantity: state.groupedQuantities[groupedProduct.id] ?? 0,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _GroupedProductItemCard extends StatelessWidget {
  final GroupedProductItem groupedProduct;
  final int quantity;

  const _GroupedProductItemCard({
    required this.groupedProduct,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final associated = groupedProduct.associatedProduct;
    if (associated == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = associated.allImageUrls.isNotEmpty
        ? associated.allImageUrls.first
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral50,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GroupedProductImage(imageUrl: imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  associated.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 6),
                _GroupedProductPrice(associatedProduct: associated),
                const SizedBox(height: 10),
                _GroupedQuantityInput(
                  groupedItemId: groupedProduct.id,
                  quantity: quantity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupedProductPrice extends StatelessWidget {
  final ProductModel associatedProduct;

  const _GroupedProductPrice({required this.associatedProduct});

  @override
  Widget build(BuildContext context) {
    final currentPriceLabel = associatedProduct.formattedDisplayPrice;
    final originalPriceLabel = associatedProduct.formattedOriginalPrice;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(
          currentPriceLabel,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary500,
          ),
        ),
        if (originalPriceLabel != null)
          Text(
            originalPriceLabel,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.neutral500 : AppColors.neutral400,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}

class _GroupedQuantityInput extends StatelessWidget {
  final String groupedItemId;
  final int quantity;

  const _GroupedQuantityInput({
    required this.groupedItemId,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _qtyButton(
          context: context,
          icon: Icons.remove,
          onTap: quantity > 0
              ? () {
                  context.read<ProductDetailBloc>().add(
                    UpdateGroupedProductQuantity(
                      groupedItemId: groupedItemId,
                      quantity: quantity - 1,
                    ),
                  );
                }
              : null,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 52,
          height: 36,
          child: TextFormField(
            key: ValueKey('$groupedItemId-$quantity'),
            initialValue: '$quantity',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
            onChanged: (value) {
              final parsed = int.tryParse(value.trim()) ?? 0;
              context.read<ProductDetailBloc>().add(
                UpdateGroupedProductQuantity(
                  groupedItemId: groupedItemId,
                  quantity: parsed,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        _qtyButton(
          context: context,
          icon: Icons.add,
          onTap: () {
            context.read<ProductDetailBloc>().add(
              UpdateGroupedProductQuantity(
                groupedItemId: groupedItemId,
                quantity: quantity + 1,
              ),
            );
          },
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _qtyButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? (isDark ? AppColors.neutral700 : AppColors.neutral300)
              : (isDark ? AppColors.neutral100 : AppColors.neutral900),
        ),
      ),
    );
  }
}

class _GroupedProductImage extends StatelessWidget {
  final String? imageUrl;

  const _GroupedProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 72,
        height: 72,
        color: isDark ? AppColors.neutral700 : AppColors.neutral100,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Image.asset(AppAssets.largeProductPlaceholder, fit: BoxFit.cover)
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, image) => Image.asset(
                  AppAssets.largeProductPlaceholder,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, image, error) => Image.asset(
                  AppAssets.largeProductPlaceholder,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
