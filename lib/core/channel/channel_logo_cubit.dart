import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../graphql/graphql_client.dart';
import 'channel_bootstrap_service.dart';

/// Manages the active channel logo URL.
///
/// Initialized with the cached logo URL from [ChannelBootstrapService] at startup.
/// Re-queries the server whenever [refresh] is called (e.g. pull-to-refresh on Home),
/// immediately notifying all [ChannelLogo] widgets without needing an app restart.
class ChannelLogoCubit extends Cubit<String?> {
  ChannelLogoCubit() : super(null);

  SharedPreferences? _prefs;

  void initialize(SharedPreferences prefs) {
    _prefs = prefs;
    final cached = prefs.getString(ChannelBootstrapService.logoUrlCacheKey);
    if (cached != null && cached.isNotEmpty) {
      emit(cached);
    }
  }

  /// Re-queries the channel logo from the server and updates cache and state.
  Future<void> refresh() async {
    final client = GraphQLClientProvider.buildClient();
    final logoUrl = await ChannelBootstrapService.fetchChannelLogoUrl(client);
    if (logoUrl == null) return; // Network failure, keep current state

    final normalized = logoUrl.isEmpty ? null : logoUrl;
    emit(normalized);

    if (normalized == null) {
      await _prefs?.remove(ChannelBootstrapService.logoUrlCacheKey);
    } else {
      await _prefs?.setString(
        ChannelBootstrapService.logoUrlCacheKey,
        normalized,
      );
    }
  }
}
