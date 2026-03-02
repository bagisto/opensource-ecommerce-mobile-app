import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../../category/data/models/product_model.dart';
import '../../../category/data/repository/category_repository.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../bloc/product_detail_bloc.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_attributes_section.dart';
import '../widgets/product_action_bar.dart';
import '../widgets/product_description_section.dart';
import '../widgets/product_more_info_section.dart';
import '../widgets/product_reviews_section.dart';
import '../widgets/product_related_section.dart';
import '../widgets/product_detail_shimmer.dart';
import '../../../../core/widgets/app_back_button.dart';

/// Product Detail Page matching Figma design
/// Light: node 119-5125 | Dark: node 152-3594
///
/// Layout (scrollable):
///  ┌─────────────────────────────┐
///  │  AppBar (back, title, cart) │
///  ├─────────────────────────────┤
///  │  Image Carousel (375×375)   │
///  │  Page indicators            │
///  ├─────────────────────────────┤
///  │  Title, Price, Rating, Stock│
///  ├─────────────────────────────┤
///  │  Size/Color/Text swatches   │
///  │  Quantity picker            │
///  │  Wishlist/Compare/Share     │
///  ├─────────────────────────────┤
///  │  Details (description)      │
///  ├─────────────────────────────┤
///  │  More Informations          │
///  ├─────────────────────────────┤
///  │  Reviews section            │
///  ├─────────────────────────────┤
///  │  Related Products scroll    │
///  └─────────────────────────────┘
///  │ Add to Cart │ Buy Now │  ← sticky bottom
class ProductDetailPage extends StatefulWidget {
  final String urlKey;
  final String? productName;

  const ProductDetailPage({super.key, required this.urlKey, this.productName});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Observe app lifecycle to refresh wishlist on resume
    WidgetsBinding.instance.addObserver(this);
    // Load/refresh wishlist in background when product detail page is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistCubit>().refreshWishlist();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh wishlist when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        context.read<WishlistCubit>().refreshWishlist();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<CategoryRepository>();

    return BlocProvider(
      create: (_) =>
          ProductDetailBloc(repository: repository)
            ..add(LoadProductDetail(urlKey: widget.urlKey)),
      child: _ProductDetailView(productName: widget.productName, urlKey: widget.urlKey),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  final String? productName;
  final String urlKey;

  const _ProductDetailView({this.productName, required this.urlKey});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: Column(
        children: [
          // ── AppBar ──
          _buildAppBar(context, isDark),

          // ── Scrollable Content ──
          Expanded(
            child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                if (state.status == ProductDetailStatus.loading ||
                    state.status == ProductDetailStatus.initial) {
                  return const ProductDetailShimmer();
                }

                if (state.status == ProductDetailStatus.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.neutral400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load product',
                            style: AppTextStyles.text4(context),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage ?? '',
                            style: AppTextStyles.text6(context),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final product = state.product;
                if (product == null) {
                  return const Center(child: Text('Product not found'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductDetailBloc>().add(
                      RefreshProductDetail(urlKey: urlKey),
                    );
                    await context.read<ProductDetailBloc>().stream.firstWhere(
                      (s) => s.status == ProductDetailStatus.loaded || s.status == ProductDetailStatus.error,
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image carousel — show variant image if selected
                        ProductImageCarousel(
                          imageUrls: _getImageUrls(product, state),
                        ),

                        const SizedBox(height: 32),

                        // Product info (name, price, rating, stock)
                        // Price updates when a variant is selected
                        ProductInfoSection(
                          product: product,
                          selectedVariant: state.selectedVariant,
                        ),

                        const SizedBox(height: 32),

                        // Attributes (size, color, text swatches, quantity)
                        ProductAttributesSection(product: product),

                        const SizedBox(height: 32),

                        // Description
                        ProductDescriptionSection(product: product),

                        const SizedBox(height: 32),

                        // More information
                        ProductMoreInfoSection(product: product),

                        const SizedBox(height: 32),

                        // Reviews
                        ProductReviewsSection(product: product),

                        const SizedBox(height: 32),

                        // Related products
                        if (state.relatedProducts.isNotEmpty)
                          ProductRelatedSection(
                            relatedProducts: state.relatedProducts,
                            onProductTap: (relatedProduct) {
                              if (relatedProduct.urlKey != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailPage(
                                      urlKey: relatedProduct.urlKey!,
                                      productName: relatedProduct.name,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Sticky Bottom Action Bar ──
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              if (state.status != ProductDetailStatus.loaded) {
                return const SizedBox.shrink();
              }
              return const ProductActionBar();
            },
          ),
        ],
      ),
    );
  }

  /// Build image URLs list: if a variant is selected, show its image first
  List<String> _getImageUrls(ProductModel product, ProductDetailState state) {
    final productImages = product.allImageUrls;
    final variantImage = state.selectedVariant?.baseImageUrl;

    if (variantImage != null && variantImage.isNotEmpty) {
      // Put variant image first, then product images (without duplicate)
      return [
        variantImage,
        ...productImages.where((url) => url != variantImage),
      ];
    }
    return productImages;
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? AppColors.neutral800 : AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Back button
              const AppBackButton(),

              // Title
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                    builder: (context, state) {
                      final title =
                          state.product?.name ??
                          productName ??
                          'Product Detail';
                      return Text(
                        title,
                        style: AppTextStyles.text4(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ),

              // Search icon
              GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const SearchPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search,
                    size: 24,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  ),
                ),
              ),

              // Cart icon with dynamic badge
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  final count = cartState.itemCount;
                  return GestureDetector(
                    onTap: () {
                      // Pop back to MainShell and switch to Cart tab
                      AppNavigator.navigateToCart(context);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 24,
                            color: isDark
                                ? AppColors.neutral200
                                : AppColors.neutral900,
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary500,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
