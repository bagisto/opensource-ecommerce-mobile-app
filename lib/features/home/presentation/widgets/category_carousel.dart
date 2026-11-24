import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/category_circular_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/home_models.dart';

/// Horizontal scrollable category carousel with circular images and labels.
///
/// Matches Figma design: 64×64 circular category image + 14px medium label below.
class CategoryCarousel extends StatelessWidget {
  final List<HomeCategory> categories;
  final ValueChanged<HomeCategory>? onCategoryTap;

  const CategoryCarousel({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryItem(
            key: ValueKey('cat_${category.id}'),
            category: category,
            onTap: onCategoryTap != null
                ? () => onCategoryTap!(category)
                : null,
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final HomeCategory category;
  final VoidCallback? onTap;

  const _CategoryItem({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: l10n.homeCategorySemanticLabel(category.name),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 66,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 64×64 circular category image with web placeholder fallback
              CategoryCircularImage(
                imageUrl: category.logoUrl,
                size: 64,
              ),
              const SizedBox(height: 7),
              // Category name
              Text(
                category.name,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
