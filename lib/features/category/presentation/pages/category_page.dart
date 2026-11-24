import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/category_model.dart';
import '../bloc/category_bloc.dart';
import '../widgets/category_chip_row.dart';
import '../widgets/category_banner.dart';
import '../widgets/sub_category_section.dart';
import '../widgets/product_grid_section.dart';
import '../widgets/category_search_bar.dart';
import '../widgets/category_shimmer.dart';
import '../../../search/presentation/pages/search_page.dart';

/// Category Page – matches Figma "categories-sub"
/// Light: node-id=92-1679 | Dark: node-id=92-1730
///
/// Layout:
///  ┌────────────────────────┐
///  │  Search bar (Women ▼)  │  ← header with category name + search icon
///  ├────────────────────────┤
///  │  ○ Women ○ Men ○ Kids  │  ← horizontal scrollable category chips
///  ├────────────────────────┤
///  │     [ Banner Image ]   │  ← promotional banner
///  ├────────────────────────┤
///  │  Tops          ▼       │  ← sub-category section header
///  │  ○ ○ ○ ○ ○ ○ ○ ○      │  ← sub-category chips (wrap grid)
///  ├────────────────────────┤
///  │  Bottoms        ▼      │
///  │  ○ ○ ○ ○               │
///  ├────────────────────────┤
///  │  Products       ▼      │  ← section header
///  │  ┌──┐ ┌──┐             │
///  │  │  │ │  │             │  ← 2-column product grid
///  │  └──┘ └──┘             │
///  └────────────────────────┘
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.status == CategoryStatus.loading &&
            state.categories.isEmpty) {
          return const CategoryShimmer();
        }

        if (state.status == CategoryStatus.error && state.categories.isEmpty) {
          return _buildError(
            context,
            state.errorMessage ?? l10n.categoryUnknownError,
          );
        }

        if (state.status == CategoryStatus.loaded &&
            state.categories.isEmpty) {
          return _buildNoCategories(context);
        }

        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, CategoryState state) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar ──
            CategorySearchBar(
              categoryName:
                  state.selectedCategory?.name ?? l10n.categoryDefaultName,
              onSearchTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
            ),

            // ── Scrollable Content ──
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary500,
                onRefresh: () => _handleRefresh(context),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter < 200) {
                      context.read<CategoryBloc>().add(LoadMoreProducts());
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // ── Category Chips (horizontal scroll) ──
                        CategoryChipRow(
                          categories: state.categories,
                          selectedCategory: state.selectedCategory,
                          onCategorySelected: (cat) {
                            context.read<CategoryBloc>().add(
                              SelectCategory(cat),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // ── Banner (dynamic from API) ──
                        if (state.selectedCategory?.bannerUrl != null &&
                            state.selectedCategory!.bannerUrl!.isNotEmpty)
                          // Image only: the name is already on the chip above
                          // it, and the storefront prints no text on the
                          // banner.
                          CategoryBanner(
                            bannerUrl: state.selectedCategory?.bannerUrl,
                          ),

                        if (state.selectedCategory?.bannerUrl != null &&
                            state.selectedCategory!.bannerUrl!.isNotEmpty)
                          const SizedBox(height: 32),

                            // ── Description configured in admin ──
                            if (state.selectedCategory?.displayMode != 'products_only' &&
                                (state.selectedCategory?.plainDescription
                                        .isNotEmpty ??
                                    false)) ...[
                              _CategoryDescription(
                                text: state.selectedCategory!.plainDescription,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // ── Sub-category Sections ──
                            ..._buildSubCategorySections(
                                context, state.subCategories),

                        if (state.subCategories.isNotEmpty)
                          const SizedBox(height: 24),

                        // ── Products Grid ──
                        if (state.selectedCategory?.displayMode != 'description_only')
                          ProductGridSection(
                            products: state.products,
                            isLoadingMore: state.isLoadingMore,
                            categoryId: state.selectedCategory?.numericId,
                            categoryName: state.selectedCategory?.name,
                            categorySlug: state.selectedCategory?.slug,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSubCategorySections(
    BuildContext context,
    List<CategoryModel> subCategories,
  ) {
    if (subCategories.isEmpty) return [];

    final l10n = AppLocalizations.of(context)!;

    // Group sub-categories into sections (like "Tops" and "Bottoms" in Figma)
    // If we have grouped children, show them; otherwise show all as one section
    return [
      SubCategorySection(
        title: l10n.categorySubCategories,
        categories: subCategories,
      ),
    ];
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<CategoryBloc>();

    // Subscribe before dispatching so the loaded/error
    // emission is never missed.
    final future = bloc.stream
        .firstWhere(
          (s) =>
              s.status == CategoryStatus.loaded ||
              s.status == CategoryStatus.error,
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => bloc.state,
        );

    bloc.add(const LoadCategories(refresh: true));
    await future;
  }

  Widget _buildNoCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar — kept visible even with no categories, so
            // navigation/search stays available instead of a dead screen ──
            CategorySearchBar(
              categoryName: l10n.categoryDefaultName,
              onSearchTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary500,
                onRefresh: () => _handleRefresh(context),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 48,
                                  color: AppColors.neutral400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.categoryNoCategoriesFound,
                                  style: AppTextStyles.text5(context),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.categorySomethingWentWrong,
              style: AppTextStyles.text3(context),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.text5(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<CategoryBloc>().add(const LoadCategories(refresh: true));
              },
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
}

/// Plain-text category description shown under the chips/banner.
class _CategoryDescription extends StatelessWidget {
  final String text;

  const _CategoryDescription({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      key: const ValueKey('category_description'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          height: 1.5,
          color: isDark ? AppColors.neutral300 : AppColors.neutral700,
        ),
      ),
    );
  }
}
