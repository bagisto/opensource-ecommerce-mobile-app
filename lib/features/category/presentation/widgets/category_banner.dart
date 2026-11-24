import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';

/// Promotional banner - can display dynamic image from API or static placeholder
/// Figma: banner-grou – full-width, locked to the 1920x700 storefront banner
/// ratio so the artwork is never letterboxed or cropped.
class CategoryBanner extends StatelessWidget {
  /// Banner image URL from API (optional)
  final String? bannerUrl;

  /// Banner title text (optional)
  final String? title;

  /// Banner subtitle text (optional)
  final String? subtitle;

  const CategoryBanner({
    super.key,
    this.bannerUrl,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Debug: Print banner URL when available
    if (bannerUrl != null && bannerUrl!.isNotEmpty) {
      debugPrint('[CategoryBanner] Rendering banner with URL: $bannerUrl');
    } else {
      debugPrint('[CategoryBanner] No banner URL - showing placeholder');
    }

    final titleText = title ?? '';
    final subtitleText = subtitle ?? '';
    final hasOverlayText = titleText.isNotEmpty || subtitleText.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        // Bagisto storefront banner size: 1920x700. Keeping the ratio means
        // the banner is never letterboxed or cropped.
        aspectRatio: 1920 / 700,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // Show gradient only when no banner image
            gradient: bannerUrl == null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            AppColors.neutral800,
                            AppColors.neutral700,
                          ]
                        : [
                            AppColors.primary500.withValues(alpha: 0.1),
                            AppColors.primary600.withValues(alpha: 0.15),
                          ],
                  )
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Banner image from API
                if (bannerUrl != null && bannerUrl!.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: bannerUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color:
                          isDark ? AppColors.neutral800 : AppColors.neutral100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        _buildPlaceholder(isDark),
                  )
                else
                  _buildPlaceholder(isDark),

                // Text overlay - only what the API supplied, never a
                // hardcoded promo string.
                if (hasOverlayText)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (titleText.isNotEmpty)
                          Text(
                            titleText,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _getTextColor(
                                isDark,
                                hasImage: bannerUrl != null,
                              ),
                            ),
                          ),
                        if (titleText.isNotEmpty && subtitleText.isNotEmpty)
                          const SizedBox(height: 4),
                        if (subtitleText.isNotEmpty)
                          Text(
                            subtitleText,
                            style: TextStyle(
                              fontSize: 14,
                              color: _getSubtitleColor(
                                isDark,
                                hasImage: bannerUrl != null,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? AppColors.neutral800 : AppColors.neutral100,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: isDark ? AppColors.neutral500 : AppColors.neutral400,
        ),
      ),
    );
  }

  Color _getTextColor(bool isDark, {required bool hasImage}) {
    if (hasImage) {
      // White text with shadow for better visibility on images
      return Colors.white;
    }
    return isDark ? AppColors.white : AppColors.neutral900;
  }

  Color _getSubtitleColor(bool isDark, {required bool hasImage}) {
    if (hasImage) {
      // White text with some transparency for subtitle on images
      return Colors.white.withValues(alpha: 0.9);
    }
    return isDark ? AppColors.neutral300 : AppColors.neutral700;
  }
}
