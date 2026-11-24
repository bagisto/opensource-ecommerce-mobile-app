import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/category_circular_image.dart';
import '../../data/models/category_model.dart';

/// Horizontal scrollable category chip row
/// Figma: Frame 9 – row of circular category icons
///
/// Layout per chip (width: 66, column):
///  ┌──────┐
///  │  ○   │  64×64 circle with image
///  │ Name │  Text-5, centered
///  └──────┘
///
/// Selected: primary/600 bottom border (3px)
/// Gap between chips: 20px
/// Horizontal padding: 16px
class CategoryChipRow extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel> onCategorySelected;

  const CategoryChipRow({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context2, index2) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory?.id == cat.id;
          return _CategoryChip(
            category: cat,
            isSelected: isSelected,
            onTap: () => onCategorySelected(cat),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 66,
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.primary600,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Circle Image ──
            CategoryCircularImage(
              imageUrl: category.imageUrl,
              size: 64,
            ),
            const SizedBox(height: 7),
            // ── Name ──
            Text(
              category.name,
              style: AppTextStyles.text5Category(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
