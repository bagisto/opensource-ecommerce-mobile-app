import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../category/presentation/pages/category_page.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../auth/presentation/pages/account_page.dart';
import 'home_page.dart';

/// Main Shell with bottom navigation bar — modern e-commerce navigation.
///
/// Features:
///   • IndexedStack keeps all tabs alive (no rebuild on switch)
///   • AppNavigator InheritedWidget lets any child switch tabs
///   • Tab history stack: back button returns to the previous tab
///   • Android back button: previous tab → then exit
///   • Cart badge auto-updates from CartBloc
///
/// Tabs: Home(0) | Categories(1) | Cart(2) | Account(3)
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// GlobalKey for accessing MainShellState from anywhere in the app
  static final GlobalKey<MainShellState> navigatorKey = GlobalKey<MainShellState>();

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _currentIndex = 0; // Start on Home

  /// Tab history stack for proper back navigation.
  /// Stores the history of visited tabs so pressing back goes to the
  /// previous tab before exiting.
  final List<int> _tabHistory = [0]; // initial tab

  void switchToTab(int index) {
    if (index == _currentIndex) return;
    setState(() {
      // Push current tab to history before switching
      if (_tabHistory.isEmpty || _tabHistory.last != _currentIndex) {
        _tabHistory.add(_currentIndex);
      }
      _currentIndex = index;
    });
    // Refresh cart data when switching to Cart tab
    if (index == AppNavigator.cartTab) {
      context.read<CartBloc>().add(LoadCart());
    }
  }

  int get currentTab => _currentIndex;

  /// Handle Android/iOS back button: go to previous tab, then exit
  Future<bool> _onWillPop() async {
    if (_tabHistory.isNotEmpty) {
      final previousTab = _tabHistory.removeLast();
      setState(() => _currentIndex = previousTab);
      return false; // Don't exit app
    }
    return true; // Exit app
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AppNavigator(
        switchToTab: switchToTab,
        currentTab: () => _currentIndex,
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              const HomePage(),
              const CategoryPage(),
              const CartPage(),
              AccountPage(isActive: _currentIndex == 3),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context, isDark),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral50,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.transparent : AppColors.neutral100,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: 'Categories',
              ),
              _buildNavItemWithBadge(
                index: 2,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'Cart',
                badgeCount: context.watch<CartBloc>().state.itemCount,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => switchToTab(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive
                  ? AppColors.primary500
                  : isDark
                      ? AppColors.neutral300
                      : AppColors.neutral800,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isActive
                    ? AppColors.primary500
                    : isDark
                        ? AppColors.neutral300
                        : AppColors.neutral800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int badgeCount,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => switchToTab(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 24,
                  color: isActive
                      ? AppColors.primary500
                      : isDark
                          ? AppColors.neutral300
                          : AppColors.neutral800,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isActive
                    ? AppColors.primary500
                    : isDark
                        ? AppColors.neutral300
                        : AppColors.neutral800,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
