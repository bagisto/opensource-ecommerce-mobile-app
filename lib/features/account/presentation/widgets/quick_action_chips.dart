import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/account_dashboard_bloc.dart';
import '../bloc/orders_bloc.dart';
import '../pages/orders_page.dart';
import '../pages/account_menu_page.dart';
import '../pages/settings_bottom_sheet.dart';

/// Quick action chips: My Orders, Account, Settings
/// Figma: node-id=220-6548
class QuickActionChips extends StatelessWidget {
  const QuickActionChips({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          _buildChip(
            context: context,
            label: 'My Orders',
            isDark: isDark,
            onTap: () {
              final repository = context.read<AccountRepository>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RepositoryProvider.value(
                    value: repository,
                    child: BlocProvider(
                      create: (_) =>
                          OrdersBloc(repository: repository)
                            ..add(const LoadOrders()),
                      child: const OrdersPage(),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          _buildChip(
            context: context,
            label: 'Account',
            isDark: isDark,
            onTap: () {
              _navigateToAccountMenu(context);
            },
          ),
          const SizedBox(width: 12),
          _buildChip(
            context: context,
            label: 'Settings',
            isDark: isDark,
            onTap: () {
              SettingsBottomSheet.show(context);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToAccountMenu(BuildContext context) {
    final profile = context.read<AccountDashboardBloc>().state.profile;
    final repository = context.read<AccountRepository>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: repository,
          child: BlocProvider.value(
            value: context.read<AuthBloc>(),
            child: AccountMenuPage(profile: profile),
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral800 : AppColors.neutral100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
