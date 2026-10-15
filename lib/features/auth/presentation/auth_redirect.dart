import 'package:flutter/widgets.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../../core/store_config/store_config.dart';
import '../../home/presentation/pages/main_shell.dart';

/// Tab to open after login or sign-up, from the admin
/// `storeConfig.loginRedirectTo` setting. Null keeps the current tab.
int? loginRedirectTab(StoreConfig config) {
  switch (config.loginRedirectTo) {
    case 'home':
      return AppNavigator.homeTab;
    case 'account':
      return AppNavigator.accountTab;
    default:
      return null;
  }
}

/// Closes the login/sign-up screens and opens the tab the admin chose.
void navigateAfterAuth(BuildContext context) {
  final tab = loginRedirectTab(StoreConfig.of(context, listen: false));
  Navigator.of(context).popUntil((route) => route.isFirst);
  if (tab == null) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    MainShell.navigatorKey.currentState?.switchToTab(tab);
  });
}
