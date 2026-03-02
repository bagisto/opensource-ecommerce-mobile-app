import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable section header with title and "View All" arrow button
/// Figma: Used across all dashboard sections
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Container(
                width: 31,
                height: 19,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_circle_right,
                  size: 19,
                  color: AppColors.primary500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
