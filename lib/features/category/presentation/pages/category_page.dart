import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
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
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.status == CategoryStatus.loading &&
            state.categories.isEmpty) {
          return const CategoryShimmer();
        }

        if (state.status == CategoryStatus.error &&
            state.categories.isEmpty) {
          return _buildError(context, state.errorMessage ?? 'Unknown error');
        }

        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, CategoryState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar ──
            CategorySearchBar(
              categoryName: state.selectedCategory?.name ?? 'Categories',
              onSearchTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
            ),

            // ── Scrollable Content ──
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.extentAfter < 200) {
                    context.read<CategoryBloc>().add(LoadMoreProducts());
                  }
                  return false;
                },
                child: SingleChildScrollView(
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
                          context
                              .read<CategoryBloc>()
                              .add(SelectCategory(cat));
                        },
                      ),

                      const SizedBox(height: 16),

                      // ── Banner (dynamic from API) ──
                      if (state.selectedCategory?.bannerUrl != null &&
                          state.selectedCategory!.bannerUrl!.isNotEmpty)
                        CategoryBanner(
                          bannerUrl: state.selectedCategory?.bannerUrl,
                          title: state.selectedCategory?.name,
                        ),

                      if (state.selectedCategory?.bannerUrl != null &&
                          state.selectedCategory!.bannerUrl!.isNotEmpty)
                        const SizedBox(height: 32),

                      // ── Sub-category Sections ──
                      ..._buildSubCategorySections(state.subCategories),

                      if (state.subCategories.isNotEmpty)
                        const SizedBox(height: 24),

                      // ── Products Grid ──
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
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSubCategorySections(List<CategoryModel> subCategories) {
    if (subCategories.isEmpty) return [];

    // Group sub-categories into sections (like "Tops" and "Bottoms" in Figma)
    // If we have grouped children, show them; otherwise show all as one section
    return [
      SubCategorySection(
        title: 'Sub Categories',
        categories: subCategories,
      ),
    ];
  }

  Widget _buildError(BuildContext context, String message) {
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
              'Something went wrong',
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
                context.read<CategoryBloc>().add(LoadCategories());
              },
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
}
