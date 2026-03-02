import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Custom form field matching the Figma input-field design
/// Figma node: input-field (246:6850, 246:6851, etc.)
///
/// Features:
///   - Floating label positioned at top-left (-10px from border)
///   - Border: 1px solid neutral/200, rounded 10px
///   - Padding: px-12, py-14
///   - Label: Roboto Regular 12px neutral/800
///   - Value: Roboto Regular 16px neutral/800
///   - Focus: border changes to primary/500
///   - Error: border changes to status-error/500
class EditAccountFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isDark;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const EditAccountFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.isDark,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  State<EditAccountFormField> createState() => _EditAccountFormFieldState();
}

class _EditAccountFormFieldState extends State<EditAccountFormField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        if (mounted) {
          setState(() => _hasFocus = _focusNode.hasFocus);
        }
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color get _borderColor {
    if (_errorText != null) return const Color(0xFFFB2C36);
    if (_hasFocus) return AppColors.primary500;
    return widget.isDark ? AppColors.neutral700 : AppColors.neutral200;
  }

  Color get _labelColor {
    if (_errorText != null) return const Color(0xFFFB2C36);
    if (_hasFocus) return AppColors.primary500;
    return widget.isDark ? AppColors.neutral300 : AppColors.neutral800;
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        widget.isDark ? AppColors.neutral200 : AppColors.neutral800;
    final bgColor =
        widget.isDark ? AppColors.neutral900 : AppColors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Input container — Figma: inputfiled (I246:6850;169:7317)
            TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: textColor,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary500),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFFB2C36)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFFB2C36)),
                ),
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                suffixIcon: widget.suffixIcon,
              ),
              validator: (value) {
                final error = widget.validator?.call(value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _errorText = error);
                });
                return error;
              },
            ),

            // Floating label — Figma: lable (I246:6850;169:7320)
            Positioned(
              left: 9,
              top: -10,
              child: Container(
                color: bgColor,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: _labelColor,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Error text below field
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _errorText!,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFFFB2C36),
              ),
            ),
          ),
      ],
    );
  }
}
