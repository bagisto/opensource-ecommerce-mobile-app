import 'package:bagisto_flutter/core/navigation/app_navigator.dart';
import 'package:bagisto_flutter/features/home/presentation/helpers/main_shell_navigation_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('re-requesting cart tab while already on cart still refreshes cart', () {
    final action = resolveMainShellTabRequest(
      currentIndex: AppNavigator.cartTab,
      requestedIndex: AppNavigator.cartTab,
    );

    expect(action.shouldSwitchTabs, isFalse);
    expect(action.shouldReloadCart, isTrue);
  });

  test(
    'switching from another tab to cart both switches tabs and refreshes cart',
    () {
      final action = resolveMainShellTabRequest(
        currentIndex: AppNavigator.accountTab,
        requestedIndex: AppNavigator.cartTab,
      );

      expect(action.shouldSwitchTabs, isTrue);
      expect(action.shouldReloadCart, isTrue);
    },
  );

  test('switching to a non-cart tab does not trigger cart refresh', () {
    final action = resolveMainShellTabRequest(
      currentIndex: AppNavigator.homeTab,
      requestedIndex: AppNavigator.categoriesTab,
    );

    expect(action.shouldSwitchTabs, isTrue);
    expect(action.shouldReloadCart, isFalse);
  });
}
