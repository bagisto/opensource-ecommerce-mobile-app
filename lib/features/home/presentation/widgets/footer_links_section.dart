import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/home_models.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: isDark ? AppColors.neutral700 : AppColors.neutral200),
          const SizedBox(height: 12),
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
