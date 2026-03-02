import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../data/models/product_model.dart';
import '../../data/models/filter_model.dart';
import '../../data/repository/category_repository.dart';
import '../bloc/product_list_bloc.dart';
import '../widgets/filter_chip_row.dart';
import '../widgets/bottom_sort_filter_bar.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';

/// Category Products Grid Page – Figma node 63:2666
///
/// Layout:
///  ┌──────────────────────────────┐
///  │ ← │  "Top"  search box  │ 🔍 🛒│  nav bar
///  ├──────────────────────────────┤
///  │ [Ratings] [Price▼] [Size]...│  filter chips
///  ├──────────────────────────────┤
///  │  5 Items Found      ⊞ ☰    │  count + view toggle
///  ├──────────────────────────────┤
///  │  ┌──────┐  ┌──────┐        │
///  │  │ img  │  │ img  │        │  2-col product grid
///  │  │ name │  │ name │        │
///  │  │ $50  │  │ $50  │        │
///  │  └──────┘  └──────┘        │
///  ├──────────────────────────────┤
///  │  Sort ↕  │  Filter ⊕  │ ⊞  │  bottom bar
///  └──────────────────────────────┘
class CategoryProductsGridPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  /// Category slug for fetching dynamic filter attributes.
  /// If empty, generic filters are fetched.
  final String categorySlug;

  /// Optional initial filter JSON string from themeCustomization.
  /// e.g. '{"new":1}' or '{"featured":1}' or null for all products.
  /// This filter is passed to the ProductListBloc as a base filter that
  /// persists even when the user applies additional sort/filter options.
  final String? initialFilter;

  const CategoryProductsGridPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.categorySlug = '',
    this.initialFilter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = context.read<CategoryRepository>();
        return ProductListBloc(repository: repository)..add(
          LoadProductList(
            categoryId: categoryId,
            categoryName: categoryName,
            categorySlug: categorySlug,
            initialFilter: initialFilter,
          ),
        );
      },
      child: const _CategoryProductsGridView(),
    );
  }
}

class _CategoryProductsGridView extends StatefulWidget {
  const _CategoryProductsGridView();

  @override
  State<_CategoryProductsGridView> createState() =>
      _CategoryProductsGridViewState();
}

class _CategoryProductsGridViewState extends State<_CategoryProductsGridView>
    with WidgetsBindingObserver {
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    // Observe app lifecycle to refresh wishlist on resume
    WidgetsBinding.instance.addObserver(this);
    // Load/refresh wishlist in background when category page is shown
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
  // Widget build(BuildContext context) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //   return BlocBuilder<ProductListBloc, ProductListState>(
  //     builder: (context, state) {
  //       debugPrint(
  //         '[GridPage] BlocBuilder rebuild: status=${state.status}, products=${state.products.length}',
  //       );
  //       return Scaffold(
  //         backgroundColor: isDark ? AppColors.neutral900 : AppColors.neutral50,
  //         body: SafeArea(
  //           bottom: false,
  //           child: NotificationListener<ScrollNotification>(
  //             onNotification: (notification) {
  //               if (notification is ScrollEndNotification &&
  //                   notification.metrics.extentAfter < 200) {
  //                 context.read<ProductListBloc>().add(LoadMoreProductList());
  //               }
  //               return false;
  //             },
  //             child: CustomScrollView(
  //               slivers: [
  //                 // ── Navigation Bar ──
  //                 SliverToBoxAdapter(child: _buildNavBar(context, state)),
  //                 // ── Filter Chips ──
  //                 if (state.filterAttributes.isNotEmpty)
  //                   SliverToBoxAdapter(
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(bottom: 8),
  //                       child: FilterChipRow(
  //                         filterAttributes: state.filterAttributes,
  //                         activeFilters: state.activeFilters,
  //                         selectedPriceMin: state.selectedPriceMin,
  //                         selectedPriceMax: state.selectedPriceMax,
  //                         priceRangeMin: state.priceRangeMin,
  //                         priceRangeMax: state.priceRangeMax,
  //                         onChipTap: (attr) =>
  //                             _showFilterForAttribute(context, state, attr),
  //                       ),
  //                     ),
  //                   ),
  //                 // ── Items Count + View Toggle ──
  //                 SliverToBoxAdapter(child: _buildCountRow(context, state)),
  //                 // ── Product Content ──
  //                 _buildSliverProductContent(context, state),
  //                 // Bottom padding for footer
  //                 const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
  //               ],
  //             ),
  //           ),
  //         ),
  //         // ── Bottom Sort/Filter Bar ──
  //         bottomNavigationBar: BottomSortFilterBar(
  //           sortBadge: state.isSortActive ? 1 : 0,
  //           filterBadge: state.totalActiveFilterCount,
  //           isGridView: _isGridView,
  //           onSortTap: () => _showSortSheet(context, state),
  //           onFilterTap: () => _showFilterSheet(context, state),
  //           onViewToggle: () => setState(() => _isGridView = !_isGridView),
  //         ),
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        debugPrint(
          '[GridPage] BlocBuilder rebuild: status=${state.status}, products=${state.products.length}',
        );

        return Scaffold(
          backgroundColor: isDark ? AppColors.neutral900 : AppColors.neutral50,

          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ─────────────────────────────
                // 🔒 STICKY TOP SECTION
                // ─────────────────────────────
                _buildNavBar(context, state),

                if (state.filterAttributes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FilterChipRow(
                      filterAttributes: state.filterAttributes,
                      activeFilters: state.activeFilters,
                      selectedPriceMin: state.selectedPriceMin,
                      selectedPriceMax: state.selectedPriceMax,
                      priceRangeMin: state.priceRangeMin,
                      priceRangeMax: state.priceRangeMax,
                      onChipTap: (attr) =>
                          _showFilterForAttribute(context, state, attr),
                    ),
                  ),

                _buildCountRow(context, state),

                // ─────────────────────────────
                // 📦 SCROLLABLE PRODUCT SECTION
                // ─────────────────────────────
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.extentAfter < 200) {
                        context.read<ProductListBloc>().add(
                          LoadMoreProductList(),
                        );
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      slivers: [
                        _buildSliverProductContent(context, state),

                        const SliverPadding(
                          padding: EdgeInsets.only(bottom: 80),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─────────────────────────────
          // ⬇ Bottom Sort/Filter Bar
          // ─────────────────────────────
          bottomNavigationBar: BottomSortFilterBar(
            sortBadge: state.isSortActive ? 1 : 0,
            filterBadge: state.totalActiveFilterCount,
            isGridView: _isGridView,
            onSortTap: () => _showSortSheet(context, state),
            onFilterTap: () => _showFilterSheet(context, state),
            onViewToggle: () => setState(() => _isGridView = !_isGridView),
          ),
        );
      },
    );
  }

  Widget _buildSliverProductContent(
    BuildContext context,
    ProductListState state,
  ) {
    // Show loader only when:
    // 1. Status is 'loading' (first load, no cached data)
    // 2. AND there are no products yet
    //
    // Don't show loader when:
    // - Status is 'refreshing' (showing cached data, refreshing in background)
    // - Products exist (can show cached data while refreshing)
    // - Status is 'initial' (just started, waiting for first data)

    // Check if we should show loader - only when loading AND no products at all
    final bool shouldShowLoader =
        (state.status == ProductListStatus.loading ||
            state.status == ProductListStatus.initial) &&
        state.products.isEmpty;

    if (shouldShowLoader) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary500,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (state.status == ProductListStatus.error) {
      return SliverFillRemaining(
        child: _buildErrorState(context, state.errorMessage),
      );
    }

    if (state.products.isEmpty && state.status == ProductListStatus.loaded) {
      return SliverFillRemaining(child: _buildEmptyState(context));
    }

    return _isGridView
        ? _buildSliverGridView(context, state)
        : _buildSliverListView(context, state);
  }

  /// Calculate responsive grid columns based on available width.
  int _gridCrossAxisCount(double width) {
    if (width >= 900) return 4; // Large tablets / landscape
    if (width >= 600) return 3; // Small tablets
    return 2; // Phones
  }

  Widget _buildSliverGridView(BuildContext context, ProductListState state) {
    final itemCount = state.products.length + (state.isLoadingMore ? 1 : 0);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _gridCrossAxisCount(screenWidth);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          // Use 0.56 to give more vertical space for text content.
          // This prevents overflow with long names, discounted prices,
          // and rating rows on all screen sizes.
          childAspectRatio: 0.56,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= state.products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(
                  color: AppColors.primary500,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          final product = state.products[index];
          return _ProductCardGrid(product: product, cardWidth: double.infinity);
        }, childCount: itemCount),
      ),
    );
  }

  Widget _buildSliverListView(BuildContext context, ProductListState state) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final productIndex = index ~/ 2;
            if (index.isOdd) {
              return const SizedBox(height: 16);
            }
            if (productIndex >= state.products.length) {
              if (state.isLoadingMore) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(
                      color: AppColors.primary500,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              return null;
            }
            return _ProductCardList(product: state.products[productIndex]);
          },
          childCount:
              (state.products.length * 2 - 1) + (state.isLoadingMore ? 2 : 0),
        ),
      ),
    );
  }

  /// Navigation bar: back + search-style box with category name + search + cart
  /// Figma: px-16 row, bordered search box (border #E5E5E5, rounded 10, padding 12)
  Widget _buildNavBar(BuildContext context, ProductListState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // ── Back Button ──
          AppBackButton(
            key: const ValueKey('catalog_back'),
            onTap: () => Navigator.of(context).pop(),
            isIosStyle: false, // Matches Icons.arrow_back
          ),

          const SizedBox(width: 4),

          // ── Search-style box with category name ──
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to search page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SearchPage(),
                  ),
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.neutral800 : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.categoryName,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.search,
                      size: 24,
                      color: isDark ? AppColors.neutral300 : AppColors.neutral800,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // ── Cart Icon with Badge ──
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final count = cartState.itemCount;
              return GestureDetector(
                onTap: () {
                  AppNavigator.navigateToCart(context);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
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
    );
  }

  /// Count row: "X Items Found" + grid/list toggle icons
  /// Figma: px-20, "5 Items Found" 12px Medium #171717 + toggle icons
  Widget _buildCountRow(BuildContext context, ProductListState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show loading placeholder when fetching and no products yet
    final bool isLoading =
        state.status == ProductListStatus.loading ||
        (state.status == ProductListStatus.refreshing &&
            state.products.isEmpty);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Show placeholder text while loading, otherwise show actual count
          isLoading
              ? Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              : Text(
                  '${state.totalProducts} Items Found',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral900,
                  ),
                ),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isGridView = true),
                child: Icon(
                  Icons.grid_view,
                  size: 20,
                  color: _isGridView
                      ? AppColors.primary500
                      : (isDark ? AppColors.neutral500 : AppColors.neutral400),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                // onTap: () => setState(() => _isGridView = false),
                child: Icon(
                  Icons.view_list,
                  size: 20,
                  color: !_isGridView
                      ? AppColors.primary500
                      : (isDark ? AppColors.neutral500 : AppColors.neutral400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.neutral300 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search criteria',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? errorMessage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.neutral300 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            if (errorMessage != null)
              Text(
                errorMessage,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: AppColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final bloc = context.read<ProductListBloc>();
                bloc.add(
                  LoadProductList(
                    categoryId: bloc.state.categoryId,
                    categoryName: bloc.state.categoryName,
                    categorySlug: bloc.state.categorySlug,
                    initialFilter: bloc.state.initialFilter,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context, ProductListState state) {
    SortBottomSheet.show(
      context,
      currentSort: state.currentSort,
      onSortSelected: (sort) {
        context.read<ProductListBloc>().add(ApplySort(sort));
      },
    );
  }

  void _showFilterSheet(BuildContext context, ProductListState state, {int? initialSelectedIndex}) {
    FilterBottomSheet.show(
      context,
      filterAttributes: state.filterAttributes,
      activeFilters: state.activeFilters,
      priceRangeMin: state.priceRangeMin,
      priceRangeMax: state.priceRangeMax,
      selectedPriceMin: state.selectedPriceMin,
      selectedPriceMax: state.selectedPriceMax,
      initialSelectedIndex: initialSelectedIndex,
      onToggle: (code, id) {
        context.read<ProductListBloc>().add(
          ToggleFilter(attributeCode: code, optionId: id),
        );
      },
      onPriceRangeChanged: (min, max) {
        context.read<ProductListBloc>().add(
          UpdatePriceRange(min: min, max: max),
        );
      },
      onClearAll: () {
        context.read<ProductListBloc>().add(ClearAllFilters());
      },
      onApply: () {
        context.read<ProductListBloc>().add(ApplyFilters());
      },
    );
  }

  void _showFilterForAttribute(
    BuildContext context,
    ProductListState state,
    FilterAttribute attribute,
  ) {
    // Find the index of the clicked attribute in the filter attributes list
    final index = state.filterAttributes.indexWhere((attr) => attr.code == attribute.code);
    // Show the full filter sheet with the relevant attribute tab selected
    _showFilterSheet(context, state, initialSelectedIndex: index >= 0 ? index : null);
  }
}

// ─── Product Card (Grid) ───────────────────────────────────────────────────

/// Product card for grid view – matching Figma 63:2666 specs
///
/// 162×162 image (rounded 12, dark overlay), heart icon top-right 24×24,
/// name (14px Regular #262626 single-line ellipsis),
/// price row (gap-3: $50.00 18px SemiBold #171717 + $100.00 14px #737373
///   strikethrough + 50% off 14px SemiBold #FF6900),
/// rating (green pill star + 4.5 bold white + count)
class _ProductCardGrid extends StatelessWidget {
  final ProductModel product;
  final double cardWidth;

  const _ProductCardGrid({required this.product, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image (square) ──
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDark
                          ? AppColors.neutral800
                          : AppColors.neutral50,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (product.baseImageUrl != null)
                          CachedNetworkImage(
                            imageUrl: product.baseImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: isDark
                                  ? AppColors.neutral700
                                  : AppColors.neutral200,
                            ),
                            errorWidget: (_, __, ___) => Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: AppColors.neutral400,
                            ),
                          )
                        else
                          Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: AppColors.neutral400,
                          ),
                        // Dark overlay
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0x1A0E1019),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<WishlistCubit, WishlistCubitState>(
                    builder: (context, wishlistState) {
                      final pid =
                          product.numericId ??
                          int.tryParse(product.id.split('/').last) ??
                          0;
                      final isWishlisted =
                          pid > 0 && wishlistState.isWishlisted(pid);
                      final isProcessing =
                          pid > 0 && wishlistState.isProcessing(pid);
                      return GestureDetector(
                        onTap: isProcessing
                            ? null
                            : () => _toggleWishlist(context, product),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(200),
                            shape: BoxShape.circle,
                          ),
                          child: isProcessing
                              ? const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.neutral400,
                                  ),
                                )
                              : Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: isWishlisted
                                      ? Colors.red
                                      : AppColors.neutral800,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Text content (takes remaining space, prevents overflow) ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Name ──
                  Flexible(
                    flex: 2,
                    child: Text(
                      product.name ?? 'Product',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── Price Row ──
                  _buildPriceRow(context),

                  const SizedBox(height: 4),

                  // ── Rating Row ──
                  _buildRatingRow(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          // Current price
          Text(
            '\$${product.displayPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: isDark ? AppColors.white : AppColors.neutral900,
            ),
          ),

          if (product.originalPrice != null) ...[
            const SizedBox(width: 3),
            Text(
              '\$${product.originalPrice!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.0,
                color: AppColors.neutral500,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],

          if (product.discountPercent != null) ...[
            const SizedBox(width: 3),
            Text(
              '${product.discountPercent}% off',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: AppColors.primary500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rating = product.averageRating;
    final reviewCount = product.reviews.length;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          // Rating badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.successGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 12, color: AppColors.white),
                const SizedBox(width: 2),
                Text(
                  rating > 0 ? rating.toStringAsFixed(1) : '0.0',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
          Text(
            reviewCount > 0 ? '$reviewCount' : '0',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    if (product.urlKey != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(
            urlKey: product.urlKey!,
            productName: product.name,
          ),
        ),
      );
    }
  }

  void _toggleWishlist(BuildContext context, ProductModel product) async {
    final productId =
        product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;
    if (productId <= 0) return;

    try {
      final result = await context.read<WishlistCubit>().toggleWishlist(
        productId: productId,
      );
      if (!context.mounted) return;

      if (result == null) {
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
}

// ─── Product Card (List) ───────────────────────────────────────────────────

/// Product card for list view – horizontal layout
class _ProductCardList extends StatelessWidget {
  final ProductModel product;

  const _ProductCardList({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (product.urlKey != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                urlKey: product.urlKey!,
                productName: product.name,
              ),
            ),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image (responsive size based on screen width) ──
          Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              final imageSize = screenWidth >= 600 ? 140.0 : 120.0;
              return Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDark
                      ? AppColors.neutral800
                      : const Color(0xFFF5F5F5),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (product.baseImageUrl != null)
                      CachedNetworkImage(
                        imageUrl: product.baseImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: isDark
                              ? AppColors.neutral700
                              : AppColors.neutral200,
                        ),
                        errorWidget: (_, __, ___) => Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: AppColors.neutral400,
                        ),
                      )
                    else
                      Icon(
                        Icons.image_outlined,
                        size: 32,
                        color: AppColors.neutral400,
                      ),
                    Container(color: const Color(0x1A0E1019)),
                  ],
                ),
              );
            },
          ),

          const SizedBox(width: 12),

          // ── Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Product',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Price
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        '\$${product.displayPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.white
                              : AppColors.neutral900,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '\$${product.originalPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: AppColors.neutral500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      if (product.discountPercent != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${product.discountPercent}% off',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 1),
                          Text(
                            product.averageRating > 0
                                ? product.averageRating.toStringAsFixed(1)
                                : '0.0',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${product.reviews.length}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Heart icon ──
          BlocBuilder<WishlistCubit, WishlistCubitState>(
            builder: (context, wishlistState) {
              final pid =
                  product.numericId ??
                  int.tryParse(product.id.split('/').last) ??
                  0;
              final isWishlisted = pid > 0 && wishlistState.isWishlisted(pid);
              final isProcessing = pid > 0 && wishlistState.isProcessing(pid);
              return GestureDetector(
                onTap: isProcessing ? null : () => _toggleWishlist(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.neutral400,
                            ),
                          ),
                        )
                      : Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 24,
                          color: isWishlisted
                              ? Colors.red
                              : AppColors.neutral400,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _toggleWishlist(BuildContext context) async {
    final productId =
        product.numericId ?? int.tryParse(product.id.split('/').last) ?? 0;
    if (productId <= 0) return;

    try {
      final result = await context.read<WishlistCubit>().toggleWishlist(
        productId: productId,
      );
      if (!context.mounted) return;

      if (result == null) {
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
}
