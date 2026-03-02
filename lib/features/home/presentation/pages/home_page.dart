import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../data/models/home_models.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../category/presentation/pages/category_products_grid_page.dart';
import '../../../category/data/repository/category_repository.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../bloc/home_bloc.dart';
import '../widgets/category_carousel.dart';
import '../widgets/image_carousel.dart';
import '../widgets/product_card_large.dart';
import '../widgets/product_card_small.dart';
import '../widgets/section_header.dart';
import '../widgets/static_content_widget.dart';

/// The main Home page of the Bagisto Flutter app.
///
/// Layout (matching Figma node 86:930):
///   1. App bar with Bagisto logo, search icon, notification bell
///   2. Scrollable body driven by `themeCustomizations`:
///      • category_carousel → horizontal category circles
///      • image_carousel → auto-scrolling banner
///      • product_carousel → product sections (Featured, Hot Deals, New, etc.)
///   3. "Back to Top" pill button at the bottom
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Observe app lifecycle to refresh wishlist on resume
    WidgetsBinding.instance.addObserver(this);
    // Load/refresh wishlist in background when home page is shown
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
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Navigate to the Search page.
  void _openSearchPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SearchPage()));
  }

  /// Navigate to the Product Detail page for a given [HomeProduct].
  void _openProductDetail(BuildContext context, HomeProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          urlKey: product.urlKey,
          productName: product.name,
        ),
      ),
    );
  }

  /// Navigate to Category Products grid for a given [HomeCategory].
  void _openCategoryProducts(BuildContext context, HomeCategory category) {
    final categoryId = category.numericId ?? 0;
    if (categoryId <= 0) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: RepositoryProvider.of<CategoryRepository>(context),
          child: CategoryProductsGridPage(
            categoryId: categoryId,
            categoryName: category.name,
            categorySlug: category.slug,
          ),
        ),
      ),
    );
  }

  /// Quick-add a product to cart (for simple products only).
  void _addProductToCart(BuildContext context, HomeProduct product) {
    final productId = int.tryParse(product.id) ?? 0;
    if (productId <= 0) return;

    // For configurable products, navigate to detail page instead
    if (product.type == 'configurable') {
      _openProductDetail(context, product);
      return;
    }

    context.read<CartBloc>().add(AddToCart(productId: productId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: AppColors.white,
          onPressed: () => AppNavigator.goCart(context),
        ),
      ),
    );
  }

  /// Toggle wishlist for a product (add/remove).
  void _toggleWishlist(BuildContext context, HomeProduct product) async {
    final productId =
        product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;
    if (productId <= 0) return;

    try {
      final result = await context.read<WishlistCubit>().toggleWishlist(
        productId: productId,
      );
      if (!context.mounted) return;

      if (result == null) {
        // Not authenticated
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to manage wishlist'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Added to wishlist' : 'Removed from wishlist'),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update wishlist: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Navigate to catalog page showing all products with sort/filter.
  /// [title] is used as the page header (e.g. "Featured Products").
  /// [filters] is the raw filter map from themeCustomization options
  /// (e.g. {"new": 1, "sort": "created_at-desc", "limit": 10}).
  /// We extract the product-level filters (new, featured, category_id, etc.)
  /// and pass them to the catalog page as the initial filter JSON.
  void _openViewAll(
    BuildContext context,
    String title, {
    Map<String, dynamic> filters = const {},
  }) {
    // Build the API filter JSON from themeCustomization filters,
    // excluding UI-only keys like "sort" and "limit".
    // API requires all values to be strings.
    final apiFilter = <String, String>{};
    for (final entry in filters.entries) {
      if (entry.key == 'sort' || entry.key == 'limit') continue;
      if (entry.value != null) {
        apiFilter[entry.key] = entry.value.toString();
      }
    }

    final initialFilter = apiFilter.isNotEmpty ? json.encode(apiFilter) : null;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: RepositoryProvider.of<CategoryRepository>(context),
          child: CategoryProductsGridPage(
            categoryId: 0,
            categoryName: title,
            initialFilter: initialFilter,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            _buildTopBar(context),

            // ── Scrollable content ──
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                // Skip rebuilds when state changes to 'refreshing' — the old
                // data is still valid and the RefreshIndicator already shows
                // its own spinner. Rebuild only when data actually changes.
                buildWhen: (previous, current) {
                  if (current.status == HomeStatus.refreshing) return false;
                  return true;
                },
                builder: (context, state) {
                  // Show full-screen loader only on first load (no data yet).
                  if (state.status == HomeStatus.loading &&
                      state.customizations.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary500,
                      ),
                    );
                  }

                  if (state.status == HomeStatus.error &&
                      state.customizations.isEmpty) {
                    return _buildError(context, state);
                  }

                  // Show content for loaded/initial states, or when
                  // data exists even during a background refresh.
                  if (state.customizations.isNotEmpty) {
                    return _buildContent(context, state);
                  }

                  // Fallback: initial state with no data yet.
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary500,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // TOP BAR — Logo + Search + Notification
  // ──────────────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.neutral900 : AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      child: Row(
        children: [
          // Logo + "bagisto" text inside search-style container
          Expanded(
            child: GestureDetector(
              onTap: () => _openSearchPage(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.neutral800 : AppColors.white,
                  border: Border.all(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bagisto logo + text
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/bagisto_logo.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'bagisto',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isDark
                                ? AppColors.neutral100
                                : AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    // Search icon
                    GestureDetector(
                      onTap: () => _openSearchPage(context),
                      child: Icon(
                        Icons.search,
                        size: 24,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Notification bell
          // Container(
          //   width: 44,
          //   height: 46,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: AppColors.neutral200),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: const Icon(
          //     Icons.notifications_outlined,
          //     size: 24,
          //     color: AppColors.neutral800,
          //   ),
          // ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // ERROR STATE
  // ──────────────────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context, HomeState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: isDark ? AppColors.neutral500 : AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load homepage',
              style: AppTextStyles.text3(context),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Unknown error',
              style: AppTextStyles.text5(context),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<HomeBloc>().add(const LoadHome()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // MAIN CONTENT — Fixed Figma order (node 86:930)
  //
  //  1. Category carousel
  //  2. Banner carousel (first set)
  //  3. "Featured Products" — horizontal large cards
  //  4. 3-image editorial grid
  //  5. "Hot Deals" — 3×2 small card grid
  //  6. Banner carousel (second set / reuse first)
  //  7. "New Products" — 2×2 large card grid
  //  8. 2-image editorial row
  //  9. "Recently Viewed Products" — horizontal large cards
  // 10. "Back to Top" pill button
  // ──────────────────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, HomeState state) {
    // ── Build sections dynamically based on sortOrder from API ──
    // The API returns sections in sortOrder, so we render them in that order
    final List<Widget> sections = [];

    // Add category carousel first (always at top)
    if (state.categories.isNotEmpty) {
      sections.add(
        CategoryCarousel(
          categories: state.categories,
          onCategoryTap: (category) => _openCategoryProducts(context, category),
        ),
      );
    }

    // Add Featured Products section with 6-product grid (randomized)
    final allFeaturedProducts = <HomeProduct>[];
    for (final entry in state.productSections.entries) {
      final tc = state.customizations.where((c) => c.id == entry.key).firstOrNull;
      if (tc != null && tc.name.toLowerCase().contains('featured')) {
        allFeaturedProducts.addAll(entry.value);
      }
    }
    if (allFeaturedProducts.isNotEmpty) {
      sections.add(
        _buildFeaturedProductsGridSection(
          context: context,
          title: 'Featured Products',
          products: allFeaturedProducts,
        ),
      );
    }

    // Process each customization in sortOrder
    for (final tc in state.customizations) {
      switch (tc.type) {
        case 'image_carousel':
          final imagesRaw = tc.options['images'] as List? ?? [];
          final bannerImages = imagesRaw
              .map(
                (e) => BannerImage.fromJson(
                  e is Map<String, dynamic> ? e : <String, dynamic>{},
                ),
              )
              .where((b) => b.imageUrl.isNotEmpty)
              .toList();
          if (bannerImages.isNotEmpty) {
            sections.add(ImageCarousel(images: bannerImages));
          }
          break;

        case 'product_carousel':
          final products = state.productSections[tc.id] ?? [];
          if (products.isNotEmpty) {
            final filters =
                tc.options['filters'] as Map<String, dynamic>? ?? {};
            final title = tc.name.isNotEmpty ? tc.name : 'Products';
            sections.add(
              _buildHorizontalProductSection(
                title: title,
                products: products,
                filters: filters,
              ),
            );
          }
          break;

        case 'static_content':
          final htmlRaw = tc.options['html'] as String? ?? '';
          final cssRaw = tc.options['css'] as String?;
          if (htmlRaw.isNotEmpty) {
            sections.add(
              StaticContentWidget(
                html: htmlRaw,
                css: cssRaw,
                baseUrl: 'https://api-demo.bagisto.com',
                onViewAllPressed: () => _openViewAll(context, tc.name),
              ),
            );
          }
          break;

        case 'category_carousel':
          // Category carousel is handled separately at the top
          break;
      }
    }

    // Add Back to Top button
    sections.add(_buildBackToTopButton());
    sections.add(const SizedBox(height: 16));

    return RefreshIndicator(
      color: AppColors.primary500,
      onRefresh: () async {
        final bloc = context.read<HomeBloc>();

        // Subscribe BEFORE dispatching to avoid missing the loaded emission
        final future = bloc.stream
            .firstWhere(
              (s) =>
                  s.status == HomeStatus.loaded || s.status == HomeStatus.error,
            )
            .timeout(
              const Duration(seconds: 15),
              onTimeout: () => bloc.state, // fallback to current state
            );

        bloc.add(const RefreshHome());
        await future;
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 32),
        itemBuilder: (_, index) => sections[index],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // SECTION BUILDERS
  // ──────────────────────────────────────────────────────────────────────

  /// Featured Products grid section with 6 products in random order.
  /// Uses Wrap instead of GridView to avoid fixed-height overflow.
  /// Matches Figma node 86:976 flex-wrap layout.
  Widget _buildFeaturedProductsGridSection({
    required BuildContext context,
    required String title,
    required List<HomeProduct> products,
  }) {
    // Shuffle products randomly
    final random = Random();
    final shuffledProducts = List<HomeProduct>.from(products)..shuffle(random);

    // Take first 6 products (or less if not enough)
    final displayProducts = shuffledProducts.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: () => _openViewAll(
            context,
            title,
            filters: const {'featured': 1},
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth > 0
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            // 3 columns: 20px padding each side + 2×12px gaps → available / 3
            final cardWidth = (screenWidth - 40 - 24) / 3;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12, // horizontal gap between cards (Figma 12px)
                runSpacing: 18, // vertical gap between rows (Figma 18px)
                children: displayProducts.map((product) {
                  return BlocBuilder<WishlistCubit, WishlistCubitState>(
                    builder: (context, wishlistState) {
                      final pid = product.numericId ??
                          int.tryParse(product.id.split('/').last) ??
                          0;
                      return ProductCardSmall(
                        key: ValueKey('featured_${product.id}'),
                        product: product,
                        cardWidth: cardWidth,
                        onTap: () => _openProductDetail(context, product),
                        isWishlisted:
                            pid > 0 && wishlistState.isWishlisted(pid),
                        isWishlistProcessing:
                            pid > 0 && wishlistState.isProcessing(pid),
                        onWishlistTap: () =>
                            _toggleWishlist(context, product),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Horizontal scrolling product section (Featured Products, Recently Viewed).
  Widget _buildHorizontalProductSection({
    required String title,
    required List<HomeProduct> products,
    Map<String, dynamic> filters = const {},
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: () => _openViewAll(context, title, filters: filters),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth > 0
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            // Figma: 20px padding each side, 12px gap, 2 visible cards + peek
            // Card width = (screenWidth - 40 - 12) / 2
            final cardWidth = (screenWidth - 40 - 12) / 2;
            // Height = image (square) + spacing + name + price + rating
            // image + 10 + ~17 (name 14×1.2) + 7 + 18 (price) + 7 + ~22 (rating) = cardWidth + 81
            // Add 7px safety margin for font rendering = 88
            final listHeight = cardWidth + 88;
            return SizedBox(
              height: listHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return BlocBuilder<WishlistCubit, WishlistCubitState>(
                    builder: (context, wishlistState) {
                      final pid =
                          product.numericId ??
                          int.tryParse(product.id.split('/').last) ??
                          0;
                      return ProductCardLarge(
                        key: ValueKey('prod_large_${product.id}'),
                        product: product,
                        cardWidth: cardWidth,
                        onTap: () => _openProductDetail(context, product),
                        onAddToCart: () => _addProductToCart(context, product),
                        isWishlisted:
                            pid > 0 && wishlistState.isWishlisted(pid),
                        isWishlistProcessing:
                            pid > 0 && wishlistState.isProcessing(pid),
                        onWishlistTap: () => _toggleWishlist(context, product),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// "Back to Top" pill button.
  Widget _buildBackToTopButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: GestureDetector(
        onTap: _scrollToTop,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Back to Top',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),
        ),
      ),
    );
  }
}
