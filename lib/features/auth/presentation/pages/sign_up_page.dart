import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/widgets/channel_logo.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';

/// Sign Up page for new customers
/// Figma: authentication flow — registration screen
///
/// Layout:
///   ─ AppBar with back arrow
///   ─ Bagisto logo + wordmark
///   ─ "Create Account" heading (Text-2)
///   ─ First Name, Last Name, Email, Password, Confirm Password fields
///   ─ [Sign Up] primary button (full width)
///   ─ "Sign in with" + social icons
///   ─ "Already have an account? Login" link
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
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
        leading: AppBackButton(size: 24),
        leadingWidth: 60,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.authAccountCreatedSuccess),
                backgroundColor: Color(0xFF00A63E),
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is AuthRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF00A63E),
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
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
                    l10n.authCreateAccount,
                    style: AppTextStyles.text2(context),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.authSignupGetStarted,
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

                  // ── First Name & Last Name (side by side) ──
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          label: l10n.checkoutFirstName,
                          hintText: l10n.authFirstNameHint,
                          isDark: isDark,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.authRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          label: l10n.checkoutLastName,
                          hintText: l10n.authLastNameHint,
                          isDark: isDark,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.authRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Email Field ──
                  _buildTextField(
                    controller: _emailController,
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
                    label: l10n.authPassword,
                    hintText: l10n.authCreatePasswordHint,
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

                  const SizedBox(height: 16),

                  // ── Confirm Password Field ──
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: l10n.authConfirmPassword,
                    hintText: l10n.authConfirmPasswordHint,
                    isDark: isDark,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.authPleaseConfirmPassword;
                      }
                      if (value != _passwordController.text) {
                        return l10n.authPasswordsDoNotMatch;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // ── Sign Up Button ──
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSignUp,
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
                              : Text(l10n.authSignUp),
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

                  // ── Login Link ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.authAlreadyHaveAccountPrompt,
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
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.authLogin,
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
        TextFormField(
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
      ],
    );
  }
}
