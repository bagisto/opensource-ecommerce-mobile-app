import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../channel/channel_bootstrap_service.dart';
import '../channel/channel_logo_cubit.dart';

/// Renders the default Velocity logo (mark + "Velocity" wordmark).
class VelocityLogo extends StatelessWidget {
  final double height;
  final double? width;
  final Alignment alignment;
  final BoxFit fit;

  const VelocityLogo({
    super.key,
    required this.height,
    this.width,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      isDark
          ? 'assets/images/velocity_logo_dark.svg'
          : 'assets/images/velocity_logo.svg',
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  }
}

/// Store logo configured on the channel in admin (`channel.logoUrl`,
/// cached at startup by [ChannelBootstrapService]). Shows [fallback] (or
/// [VelocityLogo] by default) while loading, when the channel has no logo,
/// or when the image fails.
class ChannelLogo extends StatelessWidget {
  final Widget? fallback;
  final double height;
  final double? width;
  final Alignment alignment;

  const ChannelLogo({
    super.key,
    this.fallback,
    required this.height,
    this.width,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final defaultFallback = fallback ??
        VelocityLogo(
          height: height,
          width: width,
          alignment: alignment,
        );

    String? cubitUrl;
    bool hasCubit = false;
    try {
      final cubit = context.watch<ChannelLogoCubit>();
      cubitUrl = cubit.state;
      hasCubit = true;
    } catch (_) {
      hasCubit = false;
    }

    if (hasCubit) {
      if (cubitUrl == null || cubitUrl.isEmpty) return defaultFallback;
      return CachedNetworkImage(
        key: const ValueKey('channel_logo_image'),
        imageUrl: cubitUrl,
        width: width,
        height: height,
        fit: BoxFit.contain,
        alignment: alignment,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        placeholder: (_, _) => const SizedBox.shrink(),
        errorWidget: (_, _, _) => defaultFallback,
      );
    }

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final url = snapshot.data?.getString(
          ChannelBootstrapService.logoUrlCacheKey,
        );
        if (url == null || url.isEmpty) return defaultFallback;
        return CachedNetworkImage(
          key: const ValueKey('channel_logo_image'),
          imageUrl: url,
          width: width,
          height: height,
          fit: BoxFit.contain,
          alignment: alignment,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          placeholder: (_, _) => const SizedBox.shrink(),
          errorWidget: (_, _, _) => defaultFallback,
        );
      },
    );
  }
}
