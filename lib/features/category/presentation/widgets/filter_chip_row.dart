import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/filter_model.dart';

/// Horizontal scrollable filter chips – Figma 63:2666
///
/// Dynamically renders chips for each filter attribute returned
/// by the `categoryAttributeFilters` API. Shows count badges
/// when filters are active.
///
/// Figma specs:
///  - Row: horizontal scroll, gap 8px, px 16, pb 8
///  - Normal chip: bg #F5F5F5, rounded 20, pl 10 pr 4 py 4,
///    text 14px Medium #262626 + dropdown chevron 24×24
///  - Active chip: bg white, border 1px #FF6900,
///    text 14px Medium #FF6900 + orange chevron
class FilterChipRow extends StatelessWidget {
  final List<FilterAttribute> filterAttributes;
  final Map<String, Set<String>> activeFilters;

  /// Price filter state (for badge display)
  final double? selectedPriceMin;
  final double? selectedPriceMax;
  final double? priceRangeMin;
  final double? priceRangeMax;

  final void Function(FilterAttribute attribute) onChipTap;

  const FilterChipRow({
    super.key,
    required this.filterAttributes,
    required this.activeFilters,
    this.selectedPriceMin,
    this.selectedPriceMax,
    this.priceRangeMin,
    this.priceRangeMax,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    if (filterAttributes.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filterAttributes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final attr = filterAttributes[index];
          final int count;
          final bool isActive;

          if (attr.isPriceFilter) {
            // Price filter active if user has changed from default range
            final hasMinChange = priceRangeMin != null &&
                selectedPriceMin != null &&
                selectedPriceMin! > priceRangeMin!;
            final hasMaxChange = priceRangeMax != null &&
                selectedPriceMax != null &&
                selectedPriceMax! < priceRangeMax!;
            isActive = hasMinChange || hasMaxChange;
            count = isActive ? 1 : 0;
          } else {
            final selectedValues = activeFilters[attr.code] ?? {};
            isActive = selectedValues.isNotEmpty;
            count = selectedValues.length;
          }

          return _FilterChip(
            label: attr.displayName,
            isActive: isActive,
            count: count,
            onTap: () => onChipTap(attr),
          );
        },
      ),
    );
  }
}

/// Individual filter chip matching Figma specs
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final int count;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark
                  ? AppColors.primary500.withValues(alpha: 0.1)
                  : AppColors.white)
              : (isDark ? AppColors.neutral700 : AppColors.neutral100),
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? Border.all(color: AppColors.primary500, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? AppColors.primary500
                    : (isDark ? AppColors.neutral200 : AppColors.neutral800),
              ),
            ),
            if (isActive && count > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
            Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: isActive
                  ? AppColors.primary500
                  : (isDark ? AppColors.neutral400 : AppColors.neutral800),
            ),
          ],
        ),
      ),
    );
  }
}
