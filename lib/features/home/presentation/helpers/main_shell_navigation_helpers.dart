import '../../../../core/navigation/app_navigator.dart';

class MainShellTabRequestAction {
  final bool shouldSwitchTabs;
  final bool shouldReloadCart;

  const MainShellTabRequestAction({
    required this.shouldSwitchTabs,
    required this.shouldReloadCart,
  });
}

MainShellTabRequestAction resolveMainShellTabRequest({
  required int currentIndex,
  required int requestedIndex,
  bool cartPageEnabled = true,
}) {
  // Admin turned the cart page off: the cart tab cannot be opened.
  if (!cartPageEnabled && requestedIndex == AppNavigator.cartTab) {
    return const MainShellTabRequestAction(
      shouldSwitchTabs: false,
      shouldReloadCart: false,
    );
  }
  return MainShellTabRequestAction(
    shouldSwitchTabs: currentIndex != requestedIndex,
    shouldReloadCart: requestedIndex == AppNavigator.cartTab,
  );
}
