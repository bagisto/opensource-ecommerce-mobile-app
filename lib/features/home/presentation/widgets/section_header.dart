import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Section header with title and "See All" arrow button.
///
/// Figma spec: 18px medium title on left, arrow icon on right.
/// Used for "Featured Products", "Hot Deals", "New Products",
/// "Recently Viewed Products" sections.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final double horizontalPadding;
  final TextStyle? titleStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.horizontalPadding = 20,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: onSeeAll,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style:
                    titleStyle ??
                    TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: isDark
                          ? AppColors.neutral100
                          : AppColors.neutral900,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onSeeAll != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  key: ValueKey('see_all_$title'),
                  size: 16,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral900,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
