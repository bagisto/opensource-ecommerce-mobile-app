import '../../../account/presentation/pages/guest_eu_withdrawal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/widgets/channel_logo.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../account/presentation/bloc/account_dashboard_bloc.dart';
import '../../../account/presentation/pages/account_dashboard_page.dart';
import '../../../account/presentation/pages/preferences_bottom_sheet.dart';
import '../bloc/auth_bloc.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<LocaleCubit, Locale?>(
          listenWhen: (previous, current) =>
              current != null &&
              previous?.languageCode != current.languageCode,
          listener: (context, state) {
            _dashboardBloc?.add(const RefreshAccountDashboard());
          },
        ),
        BlocListener<CurrencyCubit, String?>(
          listenWhen: (previous, current) =>
              current != null && previous != current,
          listener: (context, state) {
            _dashboardBloc?.add(const RefreshAccountDashboard());
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
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
      ),
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
    final l10n = AppLocalizations.of(context)!;

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
                        l10n.authNiceToSeeYouHere,
                        style: AppTextStyles.text2(context),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // ── Sign Up & Login Buttons ──
                      _buildAuthButtons(context, isDark, l10n),

                      // ── Guest EU withdrawal (when enabled in admin) ──
                      const _GuestEuWithdrawalLink(),

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
              child: _buildPreferencesChip(context, isDark, l10n),
            ),
          ],
        ),
      ),
    );
  }

  /// Bagisto logo icon + "bagisto" wordmark
  Widget _buildLogo(bool isDark) {
    return Center(
      child: ChannelLogo(
        height: 60,
        fallback: SvgPicture.asset(
          'assets/images/bagisto_logo.svg',
          height: 60,
          width: 60,
        ),
      ),
    );
  }

  /// Sign Up (primary) + Login (secondary) buttons
  Widget _buildAuthButtons(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
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
                child: Text(l10n.authSignUp),
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
                child: Text(l10n.authLogin),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Preferences chip at bottom
  /// Figma: list component — neutral/100 bg, 10px radius
  Widget _buildPreferencesChip(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () =>
          PreferencesBottomSheet.show(context, showSettingsSection: true),
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
              Icons.tune_outlined,
              size: 24,
              color: isDark ? AppColors.neutral300 : AppColors.neutral900,
            ),
            const SizedBox(width: 4),
            Text(
              l10n.accountPreferences,
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

/// "Withdraw from Contract" link for guests, shown only when the channel
/// has EU withdrawal enabled (`euWithdrawalStatus`).
class _GuestEuWithdrawalLink extends StatefulWidget {
  const _GuestEuWithdrawalLink();

  @override
  State<_GuestEuWithdrawalLink> createState() => _GuestEuWithdrawalLinkState();
}

class _GuestEuWithdrawalLinkState extends State<_GuestEuWithdrawalLink> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    AccountRepository(client: GraphQLClientProvider.buildClient())
        .isEuWithdrawalEnabled()
        .then((enabled) {
          if (mounted && enabled) setState(() => _enabled = true);
        })
        .catchError((Object e) {
          debugPrint('⚠️ EU withdrawal status check failed: $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        key: const ValueKey('guest_eu_withdraw_link'),
        onPressed: () => GuestEuWithdrawalPage.navigate(context),
        child: Text(
          AppLocalizations.of(context)!.accountEuWithdraw,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.primary500,
          ),
        ),
      ),
    );
  }
}
