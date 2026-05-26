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
}) {
  return MainShellTabRequestAction(
    shouldSwitchTabs: currentIndex != requestedIndex,
    shouldReloadCart: requestedIndex == AppNavigator.cartTab,
  );
}
