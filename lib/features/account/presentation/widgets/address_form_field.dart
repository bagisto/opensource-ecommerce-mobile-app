import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable form field matching Figma input-field component.
///
/// Two variants:
///   1. **Text input** — standard TextFormField with floating label
///   2. **Dropdown** — shows dropdown icon, taps open a bottom sheet
///
/// Figma styling:
///   - Border: 1px solid neutral/200 (#E5E5E5), rounded 10px
///   - Label: Roboto 12px regular neutral/800 (#262626)
///   - Input text: Roboto 16px regular neutral/800 (#262626)
///   - Placeholder: Roboto 16px regular neutral/500 (#737373)
///   - Padding: horizontal 12, vertical 14
class AddressFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final bool isRequired;
  final bool isDropdown;
  final VoidCallback? onDropdownTap;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final int maxLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode autovalidateMode;

  const AddressFormField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.isRequired = false,
    this.isDropdown = false,
    this.onDropdownTap,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
    this.onFieldSubmitted,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.neutral700 : AppColors.neutral200;
    final focusBorderColor = AppColors.primary500;
    final errorBorderColor = Colors.red.shade400;
    final labelColor = isDark ? AppColors.neutral300 : AppColors.neutral800;
    final textColor = isDark ? AppColors.neutral200 : AppColors.neutral800;
    final hintColor = isDark ? AppColors.neutral500 : AppColors.neutral500;
    final bgColor = isDark ? AppColors.neutral900 : AppColors.white;

    final labelText = isRequired ? '$label*' : label;

    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor, width: 1),
    );

    final focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: focusBorderColor, width: 1.5),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: errorBorderColor, width: 1),
    );

    if (isDropdown) {
      return GestureDetector(
        onTap: enabled ? onDropdownTap : null,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            enabled: enabled,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: textColor,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: hintColor,
              ),
              floatingLabelStyle: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: labelColor,
                backgroundColor: bgColor,
              ),
              floatingLabelBehavior:
                  controller != null && controller!.text.isNotEmpty
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: outlineBorder,
              enabledBorder: outlineBorder,
              focusedBorder: focusBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              disabledBorder: outlineBorder,
              filled: false,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: isDark ? AppColors.neutral400 : AppColors.neutral800,
                size: 24,
              ),
            ),
            validator: validator,
            autovalidateMode: autovalidateMode,
          ),
        ),
      );
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: textColor,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: hintColor,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: labelColor,
          backgroundColor: bgColor,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: hintColor,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: outlineBorder,
        enabledBorder: outlineBorder,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: outlineBorder,
        filled: false,
      ),
      validator: validator,
      autovalidateMode: autovalidateMode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
