import 'package:flutter/material.dart';

import '../../../../core/store_config/store_config.dart';
import '../../../../core/theme/app_theme.dart';

/// Top announcement offer bar on the homepage (below the search/app bar),
/// matching Bagisto web's desktop header announcement (`headerOfferTitle`).
///
/// Example: "Get UPTO 20% OFF on your 1st order SHOP NOW"
/// Tapping the link (or bar) navigates to the admin-configured destination
/// or scrolls/navigates home if no link is configured.
class HeaderOfferBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HeaderOfferBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final storeConfig = StoreConfig.of(context);
    final title = storeConfig.headerOfferTitle?.trim() ?? '';
    if (title.isEmpty) return const SizedBox.shrink();

    final linkTitle = storeConfig.headerOfferLinkTitle?.trim() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.neutral900 : AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          key: const ValueKey('header_offer_bar'),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Center(
            child: Text.rich(
              TextSpan(
                text: title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  height: 1.3,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
                children: [
                  if (linkTitle.isNotEmpty) ...[
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: linkTitle,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.2,
                        color: isDark ? AppColors.neutral100 : AppColors.black,
                      ),
                    ),
                  ],
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
