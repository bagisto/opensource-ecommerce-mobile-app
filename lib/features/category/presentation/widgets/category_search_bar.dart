import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Search bar at top of category page
/// Figma: Frame 1 with category name + search icon
/// Light: white bg, neutral/200 border, 10px radius
/// Dark: neutral/800 bg, neutral/900 border, 10px radius
class CategorySearchBar extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onSearchTap;

  const CategorySearchBar({
    super.key,
    required this.categoryName,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onSearchTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral800 : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.neutral900 : AppColors.neutral200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: AppTextStyles.text3(context).copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              Icon(
                Icons.search,
                size: 24,
                color: isDark ? AppColors.white : AppColors.neutral800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
