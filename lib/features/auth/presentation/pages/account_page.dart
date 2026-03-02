import 'package:bagisto_flutter/features/account/presentation/pages/settings_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../account/presentation/bloc/account_dashboard_bloc.dart';
import '../../../account/presentation/pages/account_dashboard_page.dart';
import '../../../account/presentation/pages/preferences_bottom_sheet.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/social_login_icons.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

/// Account page — shows login/signup when unauthenticated,
/// and the full account dashboard when authenticated.
/// Figma: node-id=206-8238 (account-without-login)
/// Figma: node-id=220-6313 (account-dashboard)
class AccountPage extends StatefulWidget {
  final bool isActive;
  const AccountPage({super.key, this.isActive = false});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountDashboardBloc? _dashboardBloc;
  String? _currentToken;

  @override
  void didUpdateWidget(AccountPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the tab becomes active, refresh data in the background
    if (widget.isActive && !oldWidget.isActive) {
      _dashboardBloc?.add(const RefreshAccountDashboard());
    }
  }

  @override
  void dispose() {
    _dashboardBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return _buildAuthenticatedDashboard(context, state);
        }
        // Clean up bloc when logged out
        _dashboardBloc?.close();
        _dashboardBloc = null;
        _currentToken = null;
        return const _LoggedOutView();
      },
    );
  }

  Widget _buildAuthenticatedDashboard(
    BuildContext context,
    AuthAuthenticated state,
  ) {
    // Only recreate bloc when token changes (avoids rebuilds)
    if (_currentToken != state.token || _dashboardBloc == null) {
      _dashboardBloc?.close();
      _currentToken = state.token;

      final authClient = GraphQLClientProvider.authenticatedClient(state.token);
      final repository = AccountRepository(client: authClient.value);
      _dashboardBloc = AccountDashboardBloc(
        repository: repository,
        customerId: state.userId,
      );
      // Defer loading to next frame - prevents API call on app startup
      // Will be triggered when user actually views the account tab
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dashboardBloc?.add(const LoadAccountDashboard());
      });
    }

    return RepositoryProvider<AccountRepository>.value(
      value: _dashboardBloc!.repository,
      child: BlocProvider<AccountDashboardBloc>.value(
        value: _dashboardBloc!,
        child: const AccountDashboardPage(),
      ),
    );
  }
}

/// ─── LOGGED OUT VIEW ───
class _LoggedOutView extends StatelessWidget {
  const _LoggedOutView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // ── Bagisto Logo + Wordmark ──
                      _buildLogo(isDark),

                      const SizedBox(height: 32),

                      // ── "Nice to see you here" ──
                      Text(
                        'Nice to see you here',
                        style: AppTextStyles.text2(context),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // ── Sign Up & Login Buttons ──
                      _buildAuthButtons(context, isDark),

                      const SizedBox(height: 36),

                      // ── "Sign in with" ──
                      // Text(
                      //   'Sign in with',
                      //   style: TextStyle(
                      //     fontFamily: 'Roboto',
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 16,
                      //     height: 1.17,
                      //     color: isDark
                      //         ? AppColors.neutral400
                      //         : AppColors.neutral600,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      //
                      // const SizedBox(height: 18),
                      //
                      // // ── Social Login Icons ──
                      // const SocialLoginIcons(),
                      //
                      // const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),

            // ── Preferences Chip (bottom) ──
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildPreferencesChip(context, isDark),
            ),
          ],
        ),
      ),
    );
  }

  /// Bagisto logo icon + "bagisto" wordmark
  Widget _buildLogo(bool isDark) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/bagisto_logo.svg',
        height: 60,
        width: 60,
      ),
    );
  }

  /// Sign Up (primary) + Login (secondary) buttons
  Widget _buildAuthButtons(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          // Sign Up — Primary button
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const SignUpPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(54),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.17,
                  ),
                ),
                child: const Text('Sign Up'),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Login — Secondary (outlined) button
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary500,
                  side: BorderSide(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(54),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.17,
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Preferences chip at bottom
  /// Figma: list component — neutral/100 bg, 10px radius
  Widget _buildPreferencesChip(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => SettingsBottomSheet.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 24,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
            const SizedBox(width: 4),
            Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.17,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
