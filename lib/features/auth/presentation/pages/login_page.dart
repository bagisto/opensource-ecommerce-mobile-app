import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/widgets/channel_logo.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';
import '../../../../core/widgets/app_back_button.dart';

/// Login page for existing customers
/// Figma: authentication flow — login screen
///
/// Layout:
///   ─ AppBar with back arrow
///   ─ Bagisto logo + wordmark
///   ─ "Welcome back!" heading (Text-2)
///   ─ Email text field
///   ─ Password text field (with visibility toggle)
///   ─ "Forgot Password?" link
///   ─ [Login] primary button (full width)
///   ─ "Sign in with" + social icons
///   ─ "Don't have an account? Sign Up" link
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'pauldoe@example.com');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        leading: const AppBackButton(),
        actions: [
          // Preferences button
          // IconButton(
          //   icon: Icon(
          //     Icons.settings,
          //     color: isDark ? AppColors.neutral200 : AppColors.neutral900,
          //     size: 24,
          //   ),
          //   tooltip: 'Preferences',
          //   onPressed: () => PreferencesBottomSheet.show(context),
          // ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.authLoginSuccess),
                backgroundColor: Color(0xFF00A63E),
              ),
            );
            // Pop back to account page (which will detect logged-in state)
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // ── Logo ──
                  _buildLogo(isDark),

                  const SizedBox(height: 32),

                  // ── Heading ──
                  Text(
                    l10n.authWelcomeBack,
                    style: AppTextStyles.text2(context),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.authLoginToAccount,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.17,
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // ── Email Field ──
                  _buildTextField(
                    controller: _emailController,
                    fieldKey: const Key('login_email_field'),
                    semanticsIdentifier: 'login_email_field',
                    label: l10n.authEmailAddress,
                    hintText: l10n.authEnterYourEmail,
                    keyboardType: TextInputType.emailAddress,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.authPleaseEnterEmail;
                      }
                      if (!RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return l10n.authPleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Password Field ──
                  _buildTextField(
                    controller: _passwordController,
                    fieldKey: const Key('login_password_field'),
                    semanticsIdentifier: 'login_password_field',
                    label: l10n.authPassword,
                    hintText: l10n.authEnterYourPassword,
                    isDark: isDark,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.authPleaseEnterPassword;
                      }
                      if (value.length < 6) {
                        return l10n.authPasswordMinLength;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // ── Forgot Password ──
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary500,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.authForgotPasswordTitle,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.17,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Login Button ──
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        height: 50,
                        child: Semantics(
                          identifier: 'login_submit_button',
                          button: true,
                          child: ElevatedButton(
                            key: const Key('login_submit_button'),
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: AppColors.white,
                              disabledBackgroundColor: AppColors.primary500
                                  .withValues(alpha: 0.6),
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
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : Text(l10n.authLogin),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // ── Divider with "Sign in with" ──
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Divider(
                  //         color: isDark
                  //             ? AppColors.neutral700
                  //             : AppColors.neutral200,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'Sign in with',
                  //         style: TextStyle(
                  //           fontFamily: 'Roboto',
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 16,
                  //           height: 1.17,
                  //           color: isDark
                  //               ? AppColors.neutral400
                  //               : AppColors.neutral600,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Divider(
                  //         color: isDark
                  //             ? AppColors.neutral700
                  //             : AppColors.neutral200,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //
                  // const SizedBox(height: 18),
                  //
                  // // ── Social Login Icons ──
                  // const Center(child: SocialLoginIcons()),
                  //
                  // const SizedBox(height: 36),

                  // ── Sign Up Link ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.authNoAccountPrompt,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.17,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.authSignUp,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.17,
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildTextField({
    required TextEditingController controller,
    required Key fieldKey,
    required String semanticsIdentifier,
    required String label,
    required String hintText,
    required bool isDark,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.17,
            color: isDark ? AppColors.neutral300 : AppColors.neutral800,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          identifier: semanticsIdentifier,
          textField: true,
          child: TextFormField(
            key: fieldKey,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: isDark ? AppColors.neutral500 : AppColors.neutral400,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: isDark ? AppColors.neutral800 : AppColors.neutral50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary500,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
