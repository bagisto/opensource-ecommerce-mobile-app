import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/home_models.dart';

/// Renders a `footer_links` customization: the storefront footer's link
/// columns, shown at the very bottom of the home page.
///
/// [columns] comes from [HomeFooterLink.columnsFromOptions]; empty columns are
/// dropped so a single configured column spans the row.
class FooterLinksSection extends StatelessWidget {
  final String title;
  final List<List<HomeFooterLink>> columns;
  final ValueChanged<HomeFooterLink> onLinkTap;

  const FooterLinksSection({
    super.key,
    required this.title,
    required this.columns,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visibleColumns = columns
        .where((column) => column.isNotEmpty)
        .toList();
    if (visibleColumns.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
          const SizedBox(height: 12),
          // The heading is the section's own title, so it is skipped rather
          // than replaced with a localized fallback when admin left it blank.
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? AppColors.neutral100 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < visibleColumns.length; index++) ...[
                if (index > 0) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final link in visibleColumns[index])
                        TextButton(
                          onPressed: () => onLinkTap(link),
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            foregroundColor: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral700,
                            minimumSize: const Size(0, 40),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              link.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
