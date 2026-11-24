import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/filter_model.dart';
import '../../../../l10n/app_localizations.dart';

/// Sort bottom sheet matching Figma design
/// Shows a list of sort options with a radio-style selection
class SortBottomSheet extends StatelessWidget {
  final SortOption currentSort;
  final ValueChanged<SortOption> onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  static void show(
    BuildContext context, {
    required SortOption currentSort,
    required ValueChanged<SortOption> onSortSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SortBottomSheet(
        currentSort: currentSort,
        onSortSelected: onSortSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ──
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Title ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.categorySortByTitle,
                  style: AppTextStyles.text3(context),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral800,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Sort Options ──
          ...sortByFields.map((option) {
            final isSelected = option.key == currentSort.key;

            return InkWell(
              onTap: () {
                onSortSelected(option);
                Navigator.pop(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _titleFor(option, l10n),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary500
                              : (isDark
                                  ? AppColors.neutral200
                                  : AppColors.neutral800),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check,
                        size: 20,
                        color: AppColors.primary500,
                      ),
                  ],
                ),
              ),
            );
          }),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  String _titleFor(SortOption option, AppLocalizations l10n) {
    switch (option.key) {
      case 'name-asc':
        return l10n.categorySortAZ;
      case 'name-desc':
        return l10n.categorySortZA;
      case 'newest':
      case 'created_at-desc':
        return l10n.categorySortNewest;
      case 'oldest':
      case 'created_at-asc':
        return l10n.categorySortOldest;
      case 'price-asc':
        return l10n.categorySortCheapest;
      case 'price-desc':
        return l10n.categorySortExpensive;
      default:
        return l10n.categorySort;
    }
  }
}
