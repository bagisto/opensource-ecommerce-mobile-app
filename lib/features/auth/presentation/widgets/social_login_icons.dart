import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Social login icons: Google, Facebook, Apple
/// Figma: node-id=209-3764 (Frame 1984079277)
///
/// Layout: Row, gap 24px, centered
/// Each icon: 40×40 circle with white fill
class SocialLoginIcons extends StatelessWidget {
  const SocialLoginIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIconButton(
          assetPath: 'assets/images/google_icon.svg',
          label: 'Google',
          isDark: isDark,
          onTap: () {
            // TODO: Implement Google sign-in
          },
        ),
        const SizedBox(width: 24),
        _SocialIconButton(
          assetPath: 'assets/images/facebook_icon.svg',
          label: 'Facebook',
          isDark: isDark,
          onTap: () {
            // TODO: Implement Facebook sign-in
          },
        ),
        const SizedBox(width: 24),
        _SocialIconButton(
          assetPath: 'assets/images/apple_icon.svg',
          label: 'Apple',
          isDark: isDark,
          onTap: () {
            // TODO: Implement Apple sign-in
          },
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.assetPath,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: 'Sign in with $label',
        button: true,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF404040) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(assetPath, width: 24, height: 24),
          ),
        ),
      ),
    );
  }
}
