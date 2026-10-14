import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/channel_logo.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../data/models/home_models.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../category/presentation/pages/category_products_grid_page.dart';
import '../../../category/data/repository/category_repository.dart';
import '../../../category/presentation/bloc/category_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../bloc/home_bloc.dart';
import '../widgets/category_carousel.dart';
import '../widgets/footer_links_section.dart';
import '../widgets/image_carousel.dart';
import '../widgets/product_card_large.dart';
import '../widgets/product_card_small.dart';
import '../widgets/recently_viewed_products_section.dart';
import '../widgets/section_header.dart';
import '../widgets/services_content_section.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
          productId: product.numericId?.toString() ?? product.id,
          productName: product.name,
          productType: product.type,
        ),
      ),
    );
  }

  /// Open a home category: one with sub-categories opens in the Categories
  /// tab; one without opens its product catalog.
  void _openCategoryProducts(BuildContext context, HomeCategory category) {
    final categoryId = category.numericId ?? 0;
    if (categoryId <= 0) return;
    if (category.hasChildren && AppNavigator.maybeOf(context) != null) {
      context.read<CategoryBloc>().add(ShowCategory(categoryId));
      AppNavigator.goCategories(context);
      return;
    }
    _openCategoryGrid(context, categoryId, category.name, category.slug);
  }

  void _openCategoryGrid(
    BuildContext context,
    int categoryId,
    String name,
    String slug,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: RepositoryProvider.of<CategoryRepository>(context),
          child: CategoryProductsGridPage(
            categoryId: categoryId,
            categoryName: name,
            categorySlug: slug,
          ),
        ),
      ),
    );
  }

  /// Follow an admin-configured home link (banner, collection, button).
  /// The link's last path segment is matched against category slugs; a
  /// top-level category opens in the Categories tab, a sub-category in its
  /// products grid, and anything else is treated as a product URL key.
  Future<void> _openLink(BuildContext context, String link) async {
    final slug = homeLinkSlug(link);
    if (slug == null) return;

    final homeCategory = context
        .read<HomeBloc>()
        .state
        .categories
        .where((c) => c.slug == slug)
        .firstOrNull;
    if (homeCategory != null) {
      _openCategoryProducts(context, homeCategory);
      return;
    }

    final repository = RepositoryProvider.of<CategoryRepository>(context);
    try {
      final categories = await repository.getCategoryTabCategories();
      if (!context.mounted) return;
      for (final top in categories) {
        final topId = top.numericId ?? 0;
        if (top.slug == slug && topId > 0) {
          _openCategoryProducts(
            context,
            HomeCategory(
              id: top.id,
              numericId: topId,
              name: top.name,
              slug: top.slug,
              position: top.position ?? 0,
              hasChildren: top.children.isNotEmpty,
            ),
          );
          return;
        }
        for (final child in top.children) {
          final childId = child.numericId ?? 0;
          if (child.slug == slug && childId > 0) {
            _openCategoryGrid(context, childId, child.name, child.slug);
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('[HomePage] link category lookup failed: $e');
    }
    if (!context.mounted) return;

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ProductDetailPage(urlKey: slug)));
  }

  Future<void> _openFooterLink(HomeFooterLink link) async {
    final uri = Uri.tryParse(link.resolveUrl(bagistoPublicBaseUrl));
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Quick-add a product to cart (for simple products only).
  void _addProductToCart(BuildContext context, HomeProduct product) {
    final l10n = AppLocalizations.of(context)!;
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
        content: Text(l10n.homeAddedToCartMessage(product.name)),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: l10n.homeViewCart,
          textColor: AppColors.white,
          onPressed: () => AppNavigator.goCart(context),
        ),
      ),
    );
  }

  /// Toggle wishlist for a product (add/remove).
  void _toggleWishlist(BuildContext context, HomeProduct product) async {
    final l10n = AppLocalizations.of(context)!;
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
          SnackBar(
            content: Text(l10n.homeLoginToManageWishlist),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result ? l10n.homeAddedToWishlist : l10n.homeRemovedFromWishlist,
          ),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ErrorMapper.getUserMessage(e, context: 'updating wishlist'),
          ),
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
                    // Channel logo from admin, else Bagisto logo + text
                    ChannelLogo(
                      height: 24,
                      fallback: Row(
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
    final l10n = AppLocalizations.of(context)!;
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
            Text(l10n.homeFailedToLoad, style: AppTextStyles.text3(context)),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? l10n.commonUnknownError,
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
              child: Text(l10n.commonRetry),
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
    final l10n = AppLocalizations.of(context)!;
    // ── Build sections dynamically based on sortOrder from API ──
    // The API returns sections in sortOrder, so we render them in that order
    final List<Widget> sections = [];
    final List<Widget> footerSections = [];

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
            sections.add(
              ImageCarousel(
                images: bannerImages,
                onBannerTap: (banner) => _openLink(context, banner.link),
              ),
            );
          }
          break;

        case 'product_carousel':
          final products = state.productSections[tc.id] ?? [];
          if (products.isNotEmpty) {
            final filters = tc.filters;
            final title = tc.title.isNotEmpty
                ? tc.title
                : l10n.homeDefaultProducts;
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
                baseUrl: bagistoPublicBaseUrl,
                onViewAllPressed: () => _openViewAll(context, tc.name),
                onLinkTap: (link) => _openLink(context, link),
              ),
            );
          }
          break;

        case 'services_content':
          final services = HomeService.listFromOptions(tc.options);
          if (services.isNotEmpty) {
            sections.add(ServicesContentSection(services: services));
          }
          break;

        case 'category_carousel':
          final carouselCategories = state.categorySections[tc.id] ?? [];
          if (carouselCategories.isNotEmpty) {
            sections.add(
              CategoryCarousel(
                categories: carouselCategories,
                onCategoryTap: (category) =>
                    _openCategoryProducts(context, category),
              ),
            );
          }
          break;

        case 'footer_links':
          final columns = HomeFooterLink.columnsFromOptions(tc.options);
          if (columns.any((column) => column.isNotEmpty)) {
            footerSections.add(
              FooterLinksSection(
                title: tc.name,
                columns: columns,
                onLinkTap: _openFooterLink,
              ),
            );
          }
          break;
      }
    }

    sections.add(
      RecentlyViewedProductsSection(
        onProductTap: (product) => _openProductDetail(context, product),
      ),
    );

    // Add Back to Top button
    sections.add(_buildBackToTopButton());
    sections.addAll(footerSections);
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
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemBuilder: (context, index) => sections[index],
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
          onSeeAll: () =>
              _openViewAll(context, title, filters: const {'featured': 1}),
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
                      final pid =
                          product.numericId ??
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
                        onWishlistTap: () => _toggleWishlist(context, product),
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
            // 20px padding each side, 12px gaps, two cards plus a peek of
            // the third so the row reads as horizontally scrollable.
            final cardWidth = (screenWidth - 40 - 24) / 2.3;
            // Add a little extra space for price/rating rendering on smaller iOS devices.
            final listHeight = cardWidth + 96;
            return SizedBox(
              height: listHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
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
    final l10n = AppLocalizations.of(context)!;
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
            l10n.homeBackToTop,
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
