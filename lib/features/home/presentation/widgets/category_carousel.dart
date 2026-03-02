import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
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
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryItem(
            key: ValueKey('cat_${category.id}'),
            category: category,
            onTap: onCategoryTap != null ? () => onCategoryTap!(category) : null,
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final HomeCategory category;
  final VoidCallback? onTap;

  const _CategoryItem({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: '${category.name} category',
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 66,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 64×64 circular category image
              ClipOval(
                child: category.logoUrl != null && category.logoUrl!.isNotEmpty
                    ? Image.network(
                        category.logoUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(context),
                      )
                    : _placeholder(context),
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

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.category_outlined,
        color: isDark ? AppColors.neutral500 : AppColors.neutral500,
      ),
    );
  }
}
