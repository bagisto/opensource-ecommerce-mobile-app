import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/category_model.dart';
import '../../data/repository/category_repository.dart';
import '../pages/category_products_grid_page.dart';

/// Sub-category section with title and wrapped grid of circular chips
/// Figma: Frame 30 / Frame 31 – "Tops", "Bottoms" sections
///
/// Layout:
///  ┌─────────────────────────┐
///  │  Section Title    ▼     │  ← header row with chevron
///  ├─────────────────────────┤
///  │  ○ ○ ○ ○               │
///  │  ○ ○ ○ ○               │  ← 4-per-row wrapped grid of 75px chips
///  └─────────────────────────┘
///
/// Chip size: 75px wide, 64×64 circle image, 7px gap, Text-5 label
/// Row gap: 12px (both horizontal and vertical)
class SubCategorySection extends StatefulWidget {
  final String title;
  final List<CategoryModel> categories;

  const SubCategorySection({
    super.key,
    required this.title,
    required this.categories,
  });

  @override
  State<SubCategorySection> createState() => _SubCategorySectionState();
}

class _SubCategorySectionState extends State<SubCategorySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.text3(context),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Sub-category Grid ──
        AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.categories.map((cat) {
                return _SubCategoryChip(category: cat);
              }).toList(),
            ),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class _SubCategoryChip extends StatelessWidget {
  final CategoryModel category;

  const _SubCategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        final catId = category.numericId;
        debugPrint('[SubCategoryChip] Tapped: ${category.name}, numericId=$catId, id=${category.id}');

        int? resolvedId = catId;
        if (resolvedId == null) {
          // Fallback: try to extract numeric id from the IRI string id
          final match = RegExp(r'/(\d+)$').firstMatch(category.id);
          resolvedId = match != null ? int.tryParse(match.group(1)!) : null;
          debugPrint('[SubCategoryChip] Fallback id=$resolvedId');
        }

        if (resolvedId != null) {
          final repo = context.read<CategoryRepository>();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RepositoryProvider.value(
                value: repo,
                child: CategoryProductsGridPage(
                  categoryId: resolvedId!,
                  categoryName: category.name,
                  categorySlug: category.slug,
                ),
              ),
            ),
          );
        }
      },
      child: SizedBox(
      width: 75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Circle Image ──
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.neutral800 : AppColors.neutral100,
            ),
            clipBehavior: Clip.antiAlias,
            child: category.imageUrl != null && category.imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: category.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      color: isDark
                          ? AppColors.neutral700
                          : AppColors.neutral200,
                    ),
                    errorWidget: (ctx, url, err) => Icon(
                      Icons.category_outlined,
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral500,
                    ),
                  )
                : Icon(
                    Icons.category_outlined,
                    size: 28,
                    color: isDark
                        ? AppColors.neutral400
                        : AppColors.neutral500,
                  ),
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
