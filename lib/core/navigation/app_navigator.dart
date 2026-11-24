import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/main_shell.dart';

/// Centralized navigation service for tab-based e-commerce navigation.
///
/// Modern e-commerce apps use a shell with bottom tabs. Child pages
/// inside those tabs need a way to:
///   1. Switch between tabs (e.g. "Go to Cart" from product page)
///   2. Know which tab they came from (e.g. Cart back → Categories)
///
/// This InheritedWidget sits above the tabs so any descendant can call:
///   AppNavigator.of(context).switchToTab(2);  // go to Cart tab
///   AppNavigator.of(context).switchToCategories(); // convenience method
class AppNavigator extends InheritedWidget {
  final void Function(int index) switchToTab;
  final int Function() currentTab;

  const AppNavigator({
    super.key,
    required this.switchToTab,
    required this.currentTab,
    required super.child,
  });

  static AppNavigator? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppNavigator>();
  }

  static AppNavigator of(BuildContext context) {
    final navigator = maybeOf(context);
    assert(navigator != null, 'No AppNavigator found in context');
    return navigator!;
  }

  // ── Tab index constants ──
  static const int homeTab = 0;
  static const int categoriesTab = 1;
  static const int cartTab = 2;
  static const int accountTab = 3;

  // ── Convenience methods (static, need context) ──

  /// Switch to Home tab
  static void goHome(BuildContext context) => of(context).switchToTab(homeTab);

  /// Switch to Categories tab
  static void goCategories(BuildContext context) =>
      of(context).switchToTab(categoriesTab);

  /// Switch to Cart tab
  static void goCart(BuildContext context) => of(context).switchToTab(cartTab);

  /// Switch to Account tab
  static void goAccount(BuildContext context) =>
      of(context).switchToTab(accountTab);

  /// Navigate to Cart from a pushed page (e.g. ProductDetailPage).
  /// Uses Navigator to pop back to the MainShell, then switches to Cart tab.
  static void navigateToCart(BuildContext context) {
    // Pop back to the root (MainShell)
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Use post-frame callback to ensure we're in the right context after pop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the GlobalKey to directly access MainShellState
      final mainShellState = MainShell.navigatorKey.currentState;
      if (mainShellState != null) {
        mainShellState.switchToTab(cartTab);
      }
    });
  }

  /// Pops to the app shell, selects [tabIndex], then opens [pageBuilder].
  /// Useful when a flow should leave a feature page and open a route over a
  /// specific tab without briefly showing that tab's page first.
  static void navigateToTabPage(
    BuildContext context,
    int tabIndex,
    WidgetBuilder pageBuilder,
  ) {
    Navigator.of(context).popUntil((route) => route.isFirst);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mainShellState = MainShell.navigatorKey.currentState;
      if (mainShellState == null) return;

      mainShellState.switchToTab(tabIndex);
      Navigator.of(
        mainShellState.context,
      ).push(MaterialPageRoute(builder: pageBuilder));
    });
  }

  /// Navigate to Home from a pushed page.
  /// Pops all pushed routes back to the shell, then switches to Home tab.
  static void navigateHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mainShellState = MainShell.navigatorKey.currentState;
      if (mainShellState != null) {
        mainShellState.switchToTab(homeTab);
      }
    });
  }

  /// Navigate to Categories from a pushed page.
  /// Pops all pushed routes back to the shell, then switches to Categories tab.
  static void navigateToCategories(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the GlobalKey to directly access MainShellState
      final mainShellState = MainShell.navigatorKey.currentState;
      if (mainShellState != null) {
        mainShellState.switchToTab(categoriesTab);
      }
    });
  }

  @override
  bool updateShouldNotify(AppNavigator oldWidget) {
    return false; // The callbacks don't change
  }
}
