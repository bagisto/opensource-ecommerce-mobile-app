import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/core/navigation/app_navigator.dart';
import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/features/auth/presentation/auth_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('admin login redirect picks the tab to open', () {
    expect(
      loginRedirectTab(StoreConfig.fromJson(const {'loginRedirectTo': 'home'})),
      AppNavigator.homeTab,
    );
    expect(
      loginRedirectTab(
        StoreConfig.fromJson(const {'loginRedirectTo': 'account'}),
      ),
      AppNavigator.accountTab,
    );
    // Not configured or unknown: stay where the shopper was.
    expect(loginRedirectTab(const StoreConfig()), isNull);
    expect(
      loginRedirectTab(StoreConfig.fromJson(const {'loginRedirectTo': 'x'})),
      isNull,
    );
  });

  test('store config query asks for loginRedirectTo', () {
    expect(StoreConfigQueries.getStoreConfig, contains('loginRedirectTo'));
  });
}
