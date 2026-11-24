import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/account_models.dart';

/// Profile header with avatar, name, email, and settings icon
/// Figma: node-id=220-6547
class ProfileHeader extends StatelessWidget {
  final CustomerProfile? profile;
  final String? fallbackName;
  final String? fallbackEmail;
  final VoidCallback? onSettingsTap;

  const ProfileHeader({
    super.key,
    this.profile,
    this.fallbackName,
    this.fallbackEmail,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final name = profile?.displayName ?? fallbackName ?? l10n.accountUserFallback;
    final email = profile?.email ?? fallbackEmail ?? '';
    final initials =
        profile?.initials ?? (name.isNotEmpty ? name[0].toUpperCase() : 'U');
    final initialsText =
        initials.length > 2 ? initials.substring(0, 2) : initials;
    final imageUrl = profile?.imageUrl?.trim();

    return SafeArea(
      bottom: false,
      child: Container(
        color: isDark ? AppColors.neutral900 : AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            // Avatar circle with image or initials fallback
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primary500,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: (imageUrl != null && imageUrl.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Center(
                        child: Text(
                          initialsText,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      errorWidget: (_, _, _) => Center(
                        child: Text(
                          initialsText,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        initialsText,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            // Name and email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral800,
                    ),
                  ),
                ],
              ),
            ),
            // Settings icon — navigates to Account Menu
            if (onSettingsTap != null)
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  // onTap: onSettingsTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    // child: Icon(
                    //   Icons.settings_outlined,
                    //   size: 24,
                    //   color: isDark
                    //       ? AppColors.neutral300
                    //       : AppColors.neutral900,
                    // ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
