import '../../../core/store_config/store_config_cubit.dart';

/// Home pull-to-refresh: reloads the home sections and, in parallel, the
/// admin store settings so a change made in admin shows up without an app
/// restart.
Future<void> refreshHomeData({
  required Future<void> Function() reloadHome,
  StoreConfigCubit? storeConfig,
}) async {
  await Future.wait([reloadHome(), ?storeConfig?.load()]);
}
