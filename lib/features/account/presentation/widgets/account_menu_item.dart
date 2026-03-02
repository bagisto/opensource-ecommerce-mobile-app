import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A single menu item row for the Account Menu page.
/// Figma: list component — neutral/100 bg, 10px radius, px-12 py-16.
/// Node IDs: 220:6778, 220:6779, 245:5777, 220:6780, 220:6781, 220:6782, 246:7686
class AccountMenuItem extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? textColor;
  final IconData? trailingIcon;

  const AccountMenuItem({
    super.key,
    required this.label,
    this.onTap,
    this.textColor,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.neutral800 : AppColors.neutral100;
    final fgColor =
        textColor ?? (isDark ? AppColors.neutral200 : AppColors.neutral900);

    return Semantics(
      button: onTap != null,
      label: label,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: AppColors.primary500.withValues(alpha: 0.08),
          highlightColor: AppColors.primary500.withValues(alpha: 0.04),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: fgColor,
                    ),
                  ),
                ),
                if (trailingIcon != null)
                  Icon(
                    trailingIcon,
                    size: 18,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
