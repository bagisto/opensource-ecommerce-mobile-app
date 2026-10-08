import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../channel/channel_bootstrap_service.dart';

/// Store logo configured on the channel in admin (`channel.logoUrl`,
/// cached at startup by [ChannelBootstrapService]). Shows [fallback] while
/// loading, when the channel has no logo, or when the image fails.
class ChannelLogo extends StatelessWidget {
  final Widget fallback;
  final double height;

  const ChannelLogo({super.key, required this.fallback, required this.height});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final url = snapshot.data?.getString(
          ChannelBootstrapService.logoUrlCacheKey,
        );
        if (url == null || url.isEmpty) return fallback;
        return CachedNetworkImage(
          key: const ValueKey('channel_logo_image'),
          imageUrl: url,
          height: height,
          fit: BoxFit.contain,
          placeholder: (_, _) => fallback,
          errorWidget: (_, _, _) => fallback,
        );
      },
    );
  }
}
