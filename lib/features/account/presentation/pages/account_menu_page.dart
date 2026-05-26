import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/account_dashboard_bloc.dart';
import '../bloc/address_book_bloc.dart';
import '../bloc/compare_bloc.dart';
import '../bloc/downloadable_products_bloc.dart';
import '../bloc/edit_account_bloc.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/review_bloc.dart';
import '../bloc/wishlist_bloc.dart';
import '../helpers/account_dashboard_helpers.dart';
import '../pages/address_book_page.dart';
import '../pages/compare_products_page.dart';
import '../pages/downloadable_products_page.dart';
import '../pages/edit_account_page.dart';
import '../pages/orders_page.dart';
import '../pages/preferences_bottom_sheet.dart';
import '../pages/reviews_page.dart';
import '../pages/settings_bottom_sheet.dart';
import '../pages/wishlist_page.dart';
import '../widgets/account_menu_item.dart';

/// Account Menu Page — Figma node-id=220-6770
///
/// Displays the user's profile header (avatar + name + email) and a list
/// of account settings items:
///   - My Orders
///   - My Downloadable Products
///   - Wishlist
///   - Product Review
///   - Address Book
///   - Edit Account
///   - Logout
///
/// Each item navigates to its respective sub-page. Logout dispatches
/// [AuthLogoutRequested] and auto-pops when the auth state changes.
class AccountMenuPage extends StatelessWidget {
  final CustomerProfile? profile;

  const AccountMenuPage({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for auth state changes — auto-pop on logout
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated || state is AuthError) {
          // Auto-pop back to dashboard (which will show logged-out view)
          if (context.mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        body: SafeArea(
          child: _AccountMenuBody(profile: profile, isDark: isDark),
        ),
      ),
    );
  }
}

/// Extracted body widget to keep build method lean and enable
/// `context.read<AuthBloc>()` calls from a stable context.
class _AccountMenuBody extends StatelessWidget {
  final CustomerProfile? profile;
  final bool isDark;

  const _AccountMenuBody({required this.profile, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Prefer live profile from AccountDashboardBloc if available,
    // otherwise fall back to the profile passed as constructor arg.
    CustomerProfile? liveProfile;
    try {
      final dashState = context.watch<AccountDashboardBloc>().state;
      liveProfile = dashState.profile;
    } catch (_) {
      // AccountDashboardBloc not in tree — use constructor profile
    }
    final effectiveProfile = liveProfile ?? profile;

    // Resolve user display info from profile or AuthBloc state
    final authState = context.watch<AuthBloc>().state;
    final String userName;
    final String userEmail;
    final String initials;

    if (effectiveProfile != null) {
      userName = effectiveProfile.displayName;
      userEmail = effectiveProfile.email;
      initials = effectiveProfile.initials;
    } else if (authState is AuthAuthenticated) {
      userName = authState.userName ?? l10n.accountUserFallback;
      userEmail = authState.userEmail ?? '';
      initials = _computeInitials(userName);
    } else {
      userName = l10n.accountUserFallback;
      userEmail = '';
      initials = 'U';
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Profile Header with back arrow ──
          _buildProfileHeader(
            context,
            isDark: isDark,
            name: userName,
            email: userEmail,
            initials: initials,
          ),

          const SizedBox(height: 4),

          // ── Account Settings Menu ──
          _buildMenuSection(context, isDark),

          // Bottom padding for safe area
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Profile header row: back arrow + avatar + name/email
  /// Figma node: 220:6792
  Widget _buildProfileHeader(
    BuildContext context, {
    required bool isDark,
    required String name,
    required String email,
    required String initials,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
      child: Row(
        children: [
          // Back arrow — Figma node: 220:7822
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(10),
              child: Tooltip(
                message: l10n.accountBack,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 24,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Avatar circle — Figma node: 220:6794
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primary500,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials.length > 2 ? initials.substring(0, 2) : initials,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Name + Email — Figma node: 220:6796
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Menu section — "Account Settings" header + menu items
  /// Figma node: 220:6774
  Widget _buildMenuSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label — Figma node: 220:6777
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              l10n.accountSettings,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
          ),

          // Menu items with 2px gap — Figma gap: 2px
          AccountMenuItem(
            label: l10n.accountMyOrders,
            trailingIcon: Icons.chevron_right,
            onTap: () => _onMenuItemTap(context, AccountMenuAction.myOrders),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountMyDownloadableProducts,
            trailingIcon: Icons.chevron_right,
            onTap: () =>
                _onMenuItemTap(context, AccountMenuAction.downloadableProducts),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountWishlist,
            trailingIcon: Icons.chevron_right,
            onTap: () => _onMenuItemTap(context, AccountMenuAction.wishlist),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountCompareProducts,
            trailingIcon: Icons.chevron_right,
            onTap: () =>
                _onMenuItemTap(context, AccountMenuAction.compareProducts),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountProductReview,
            trailingIcon: Icons.chevron_right,
            onTap: () =>
                _onMenuItemTap(context, AccountMenuAction.productReview),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountAddressBook,
            trailingIcon: Icons.chevron_right,
            onTap: () => _onMenuItemTap(context, AccountMenuAction.addressBook),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountEditAccount,
            trailingIcon: Icons.chevron_right,
            onTap: () => _onMenuItemTap(context, AccountMenuAction.editAccount),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountPreferences,
            trailingIcon: Icons.chevron_right,
            onTap: () => _onMenuItemTap(context, AccountMenuAction.preferences),
          ),
          const SizedBox(height: 2),
          AccountMenuItem(
            label: l10n.accountLogout,
            onTap: () => _onLogout(context),
          ),
        ],
      ),
    );
  }

  /// Handle menu item taps — navigate to sub-pages
  void _onMenuItemTap(BuildContext context, AccountMenuAction action) {
    switch (action) {
      case AccountMenuAction.myOrders:
        final repository = context.read<AccountRepository>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
              value: repository,
              child: BlocProvider(
                create: (_) =>
                    OrdersBloc(repository: repository)..add(const LoadOrders()),
                child: const OrdersPage(),
              ),
            ),
          ),
        );
        break;
      case AccountMenuAction.downloadableProducts:
        final repository = context.read<AccountRepository>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
              value: repository,
              child: BlocProvider(
                create: (_) =>
                    DownloadableProductsBloc(repository: repository)
                      ..add(const LoadDownloadableProducts()),
                child: const DownloadableProductsPage(),
              ),
            ),
          ),
        );
        break;
      case AccountMenuAction.wishlist:
        final repository = context.read<AccountRepository>();
        final wishlistCubit = context.read<WishlistCubit>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
              value: repository,
              child: BlocProvider(
                create: (_) => WishlistBloc(
                  repository: repository,
                  wishlistCubit: wishlistCubit,
                )..add(const LoadWishlist()),
                child: const WishlistPage(),
              ),
            ),
          ),
        );
        break;
      case AccountMenuAction.compareProducts:
        final repository = context.read<AccountRepository>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
              value: repository,
              child: BlocProvider(
                create: (_) =>
                    CompareBloc(repository: repository)
                      ..add(const LoadCompareItems()),
                child: const CompareProductsPage(),
              ),
            ),
          ),
        );
        break;
      case AccountMenuAction.productReview:
        final repository = context.read<AccountRepository>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
              value: repository,
              child: BlocProvider(
                create: (_) =>
                    ReviewBloc(repository: repository)
                      ..add(const LoadReviews()),
                child: const ReviewsPage(),
              ),
            ),
          ),
        );
        break;
      case AccountMenuAction.addressBook:
        final repository = context.read<AccountRepository>();
        refreshAccountDashboardAfterAddressBook(
          openAddressBook: () {
            return Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RepositoryProvider.value(
                  value: repository,
                  child: BlocProvider(
                    create: (_) =>
                        AddressBookBloc(repository: repository)
                          ..add(const LoadAddresses()),
                    child: const AddressBookPage(),
                  ),
                ),
              ),
            );
          },
          onReturn: () {
            if (!context.mounted) return;
            try {
              context.read<AccountDashboardBloc>().add(
                const RefreshAccountDashboard(),
              );
            } catch (_) {
              // AccountDashboardBloc not in tree — skip
            }
          },
        );
        break;
      case AccountMenuAction.editAccount:
        final repository = context.read<AccountRepository>();
        // Resolve the latest profile from dashboard BLoC if available
        CustomerProfile? currentProfile;
        try {
          currentProfile = context.read<AccountDashboardBloc>().state.profile;
        } catch (_) {
          currentProfile = profile;
        }
        currentProfile ??= profile;

        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => RepositoryProvider.value(
                  value: repository,
                  child: BlocProvider(
                    create: (_) => EditAccountBloc(repository: repository)
                      ..add(LoadEditAccount(fallbackProfile: currentProfile)),
                    child: EditAccountPage(profile: currentProfile),
                  ),
                ),
              ),
            )
            .then((_) {
              // Refresh dashboard data after returning from edit account
              if (context.mounted) {
                try {
                  context.read<AccountDashboardBloc>().add(
                    const RefreshAccountDashboard(),
                  );
                } catch (_) {
                  // AccountDashboardBloc not in tree — skip
                }
              }
            });
        break;
      case AccountMenuAction.settings:
        SettingsBottomSheet.show(context);
        break;
      case AccountMenuAction.preferences:
        PreferencesBottomSheet.show(context, showSettingsSection: false);
        break;
    }
  }

  /// Handle Logout — show confirmation dialog, then dispatch event.
  /// The page auto-pops via BlocListener when AuthUnauthenticated is emitted.
  void _onLogout(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.accountLogout,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          content: Text(
            l10n.accountLogoutConfirmation,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cartCancel,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral300 : AppColors.neutral600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog first
                // Dispatch logout — BlocListener will auto-pop this page
                authBloc.add(const AuthLogoutRequested());
              },
              child: Text(
                l10n.accountLogout,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Compute initials from a full name string.
  /// Handles edge cases: empty string, whitespace-only, single name, etc.
  static String _computeInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts.first.isNotEmpty && parts.last.isNotEmpty) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    return 'U';
  }
}

/// Enum for account menu actions
enum AccountMenuAction {
  myOrders,
  downloadableProducts,
  wishlist,
  compareProducts,
  productReview,
  addressBook,
  editAccount,
  settings,
  preferences,
}
