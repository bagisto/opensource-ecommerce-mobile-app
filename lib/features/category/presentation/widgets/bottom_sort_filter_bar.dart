import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Bottom Sort/Filter bar matching Figma 63:2666
///
/// Figma specs:
///  - bg: neutral50 (#FAFAFA), border-top: neutral300 (#D4D4D4)
///  - px 16, py 8
///  - Three sections:
///    1. Sort: icon 20×20 + "Sort" 14px #262626 + orange badge "2"
///    2. Filter: icon 20×20 + "Filter" 14px #262626 + orange badge "3"
///    3. Grid-toggle icon 24×24
// class BottomSortFilterBar extends StatelessWidget {
//   final int sortBadge;
//   final int filterBadge;
//   final bool isGridView;
//   final VoidCallback onSortTap;
//   final VoidCallback onFilterTap;
//   final VoidCallback onViewToggle;

//   const BottomSortFilterBar({
//     super.key,
//     this.sortBadge = 0,
//     this.filterBadge = 0,
//     this.isGridView = true,
//     required this.onSortTap,
//     required this.onFilterTap,
//     required this.onViewToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Material(
//       color: isDark ? AppColors.neutral800 : AppColors.neutral50,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: isDark ? AppColors.neutral700 : AppColors.neutral300,
//               width: 1,
//             ),
//           ),
//         ),
//         child: SafeArea(
//           child: SizedBox(
//             height: 50,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   // ── Sort Button ──
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: onSortTap,
//                       behavior: HitTestBehavior.opaque,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.swap_vert,
//                             size: 20,
//                             color: isDark
//                                 ? AppColors.neutral200
//                                 : AppColors.neutral800,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             'Sort',
//                             style: TextStyle(
//                               fontFamily: 'Roboto',
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: isDark
//                                   ? AppColors.neutral200
//                                   : AppColors.neutral800,
//                             ),
//                           ),
//                           if (sortBadge > 0) ...[
//                             const SizedBox(width: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 5,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary500,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 '$sortBadge',
//                                 style: const TextStyle(
//                                   fontFamily: 'Roboto',
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),

//                   // ── Divider ──
//                   Container(
//                     width: 1,
//                     height: 24,
//                     color: isDark ? AppColors.neutral700 : AppColors.neutral300,
//                   ),

//                   // ── Filter Button ──
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: onFilterTap,
//                       behavior: HitTestBehavior.opaque,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.tune,
//                             size: 20,
//                             color: isDark
//                                 ? AppColors.neutral200
//                                 : AppColors.neutral800,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             'Filter',
//                             style: TextStyle(
//                               fontFamily: 'Roboto',
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: isDark
//                                   ? AppColors.neutral200
//                                   : AppColors.neutral800,
//                             ),
//                           ),
//                           if (filterBadge > 0) ...[
//                             const SizedBox(width: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 5,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary500,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 '$filterBadge',
//                                 style: const TextStyle(
//                                   fontFamily: 'Roboto',
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),

//                   // ── Divider ──
//                   Container(
//                     width: 1,
//                     height: 24,
//                     color: isDark ? AppColors.neutral700 : AppColors.neutral300,
//                   ),

//                   // ── View Toggle ──
//                   SizedBox(
//                     width: 56,
//                     child: GestureDetector(
//                       onTap: onViewToggle,
//                       behavior: HitTestBehavior.opaque,
//                       child: Center(
//                         child: Icon(
//                           isGridView ? Icons.grid_view : Icons.view_list,
//                           size: 24,
//                           color: isDark
//                               ? AppColors.neutral200
//                               : AppColors.neutral800,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_theme.dart';

class BottomSortFilterBar extends StatelessWidget {
  final int sortBadge;
  final int filterBadge;
  final bool isGridView;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;
  final VoidCallback onViewToggle;

  const BottomSortFilterBar({
    super.key,
    this.sortBadge = 0,
    this.filterBadge = 0,
    this.isGridView = true,
    required this.onSortTap,
    required this.onFilterTap,
    required this.onViewToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.neutral800 : AppColors.neutral50,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.neutral700 : AppColors.neutral300,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // ───── Sort ─────
                  Expanded(
                    child: GestureDetector(
                      onTap: onSortTap,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.swap_vert,
                              size: 20,
                              color: isDark
                                  ? AppColors.neutral200
                                  : AppColors.neutral800,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sort',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? AppColors.neutral200
                                    : AppColors.neutral800,
                              ),
                            ),
                            if (sortBadge > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary500,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '$sortBadge',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  _divider(isDark),

                  // ───── Filter ─────
                  Expanded(
                    child: GestureDetector(
                      onTap: onFilterTap,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tune,
                              size: 20,
                              color: isDark
                                  ? AppColors.neutral200
                                  : AppColors.neutral800,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? AppColors.neutral200
                                    : AppColors.neutral800,
                              ),
                            ),
                            if (filterBadge > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary500,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '$filterBadge',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  _divider(isDark),

                  // ───── View Toggle ─────
                  Expanded(
                    child: GestureDetector(
                      onTap: onViewToggle,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Icon(
                          isGridView ? Icons.grid_view : Icons.view_list,
                          size: 24,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      width: 1,
      height: 24,
      color: isDark ? AppColors.neutral700 : AppColors.neutral300,
    );
  }
}