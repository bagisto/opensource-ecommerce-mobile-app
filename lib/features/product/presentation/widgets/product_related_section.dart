import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../category/data/models/product_model.dart';
import '../../../home/data/models/home_models.dart';
import '../../../home/presentation/widgets/product_card_large.dart';

/// Product recommendation row styled with the same large cards as Home.
class ProductRecommendationSection extends StatelessWidget {
  const ProductRecommendationSection({
    super.key,
    required this.title,
    required this.products,
    this.onProductTap,
  });

  final String title;
  final List<ProductModel> products;
  final void Function(ProductModel)? onProductTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(title, style: AppTextStyles.text4(context)),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth > 0
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            final cardWidth = (width - 40 - 12) / 2;
            return SizedBox(
              height: cardWidth + 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final homeProduct = _asHomeProduct(product);
                  final productId =
                      product.numericId ??
                      int.tryParse(product.id.split('/').last) ??
                      0;
                  return BlocBuilder<WishlistCubit, WishlistCubitState>(
                    builder: (context, wishlistState) => ProductCardLarge(
                      key: ValueKey('recommendation_${product.id}'),
                      product: homeProduct,
                      cardWidth: cardWidth,
                      onTap: onProductTap == null
                          ? null
                          : () => onProductTap!(product),
                      isWishlisted:
                          productId > 0 &&
                          wishlistState.isWishlisted(productId),
                      isWishlistProcessing:
                          productId > 0 &&
                          wishlistState.isProcessing(productId),
                      onWishlistTap: productId <= 0
                          ? null
                          : () => _toggleWishlist(context, productId),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  HomeProduct _asHomeProduct(ProductModel product) => HomeProduct(
    id: product.id,
    numericId: product.numericId,
    sku: product.sku ?? '',
    type: product.type ?? 'simple',
    bookingType: product.bookingType,
    name: product.name ?? '',
    urlKey: product.urlKey ?? '',
    baseImageUrl: product.baseImageUrl,
    price: product.price ?? product.minimumPrice ?? 0,
    minimumPrice: product.minimumPrice,
    specialPrice: product.specialPrice,
    formattedPrice: product.formattedPrice,
    formattedMinimumPrice: product.formattedMinimumPrice,
    formattedSpecialPrice: product.formattedSpecialPrice,
    maximumPrice: product.maximumPrice,
    formattedMaximumPrice: product.formattedMaximumPrice,
    regularMinimumPrice: product.regularMinimumPrice,
    formattedRegularMinimumPrice: product.formattedRegularMinimumPrice,
    regularMaximumPrice: product.regularMaximumPrice,
    formattedRegularMaximumPrice: product.formattedRegularMaximumPrice,
    isSaleable: product.isSaleable ?? false,
    isNew: product.isNew ?? false,
    isFeatured: product.isFeatured ?? false,
    averageRating: product.averageRating,
    reviewCount: product.totalReviewCount ?? product.reviewCount,
    reviewStarCount: product.reviewStarCount,
  );

  Future<void> _toggleWishlist(BuildContext context, int productId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await context.read<WishlistCubit>().toggleWishlist(
        productId: productId,
      );
      if (!context.mounted || result != null) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.homeLoginToManageWishlist)));
    } on Object catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ErrorMapper.getUserMessage(error, context: 'updating wishlist'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
