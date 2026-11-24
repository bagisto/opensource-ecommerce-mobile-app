import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/asset_constants.dart';
import '../theme/app_theme.dart';

/// Circular category image that renders the remote [imageUrl] or falls back to
/// the web placeholder asset when no image exists or if network loading fails.
class CategoryCircularImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const CategoryCircularImage({
    super.key,
    required this.imageUrl,
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trimmedUrl = imageUrl?.trim();
    final hasValidUrl = trimmedUrl != null && trimmedUrl.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasValidUrl
          ? CachedNetworkImage(
              imageUrl: trimmedUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: size,
                height: size,
                color: isDark ? AppColors.neutral700 : AppColors.neutral200,
              ),
              errorWidget: (context, url, error) => Image.asset(
                AppAssets.categoryPlaceholder,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset(
              AppAssets.categoryPlaceholder,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
    );
  }
}
