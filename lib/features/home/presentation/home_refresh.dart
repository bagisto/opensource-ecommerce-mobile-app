import '../../../core/channel/channel_logo_cubit.dart';
import '../../../core/store_config/store_config_cubit.dart';

/// Home pull-to-refresh: reloads the home sections and, in parallel, the
/// admin store settings and channel logo so changes made in admin show up
/// without an app restart.
Future<void> refreshHomeData({
  required Future<void> Function() reloadHome,
  StoreConfigCubit? storeConfig,
  ChannelLogoCubit? channelLogo,
}) async {
  await Future.wait([
    reloadHome(),
    if (storeConfig != null) storeConfig.load(),
    if (channelLogo != null) channelLogo.refresh(),
  ]);
}
