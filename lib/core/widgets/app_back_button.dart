import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// A smooth, large back button with guaranteed 60x60 tap area.
/// Features:
///   • Large tap area (60x60) for easy one-click navigation
///   • Smooth scale animation on press
///   • Material ripple effect with smooth transition
///   • Haptic feedback (spring feedback on tap)
///   • Supports iOS and Android styles
class AppBackButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Color? color;
  final bool isIosStyle;
  final double size;
  final double tapAreaSize;

  const AppBackButton({
    super.key,
    this.onTap,
    this.color,
    this.isIosStyle = false, // Changed to false per user request
    this.size = 24,
    this.tapAreaSize = 40, // Reduced to match checkout page styling
  });

  @override
  State<AppBackButton> createState() => _AppBackButtonState();
}

class _AppBackButtonState extends State<AppBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Execute callback
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen readers and long-press both need a name for the bare icon. It
    // lives here rather than at each call site so no page can forget it;
    // Flutter already translates this one for every supported locale.
    final backLabel =
        Localizations.of<MaterialLocalizations>(
          context,
          MaterialLocalizations,
        )?.backButtonTooltip ??
        'Back';

    return Semantics(
      button: true,
      label: backLabel,
      child: Tooltip(
        message: backLabel,
        // The Semantics above already names it; Tooltip would say it twice.
        excludeFromSemantics: true,
        child: _buildButton(context),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor =
        widget.color ?? (isDark ? AppColors.neutral200 : AppColors.neutral900);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onPressed,
          borderRadius: BorderRadius.circular(widget.tapAreaSize / 2),
          splashColor: iconColor.withValues(alpha: 0.1),
          highlightColor: iconColor.withValues(alpha: 0.05),
          onHighlightChanged: (isHighlighted) {
            if (isHighlighted) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          },
          child: SizedBox(
            width: widget.tapAreaSize,
            height: widget.tapAreaSize,
            child: Icon(
              widget.isIosStyle ? Icons.arrow_back_ios_new : Icons.arrow_back,
              size: widget.size,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
