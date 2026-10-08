import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/phone_validation.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/contact_us_cubit.dart';

/// Contact Us Page - Modal bottom sheet with form
/// Fields: Name, Email, Contact (Phone), Message
/// On successful submission, closes the sheet and shows success message
class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  /// Show the contact us bottom sheet from any context
  static Future<void> show(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => ContactUsCubit(),
        child: const ContactUsPage(),
      ),
    );

    if (result != null && context.mounted) {
      _showOverlayToast(context, result);
    }
  }

  /// Show a toast message on top of everything using Overlay
  static void _showOverlayToast(BuildContext context, String message) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Positioned(
          bottom: bottomPadding + 24,
          left: 20,
          right: 20,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: AppColors.successGreen,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _contactController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final bgColor = isDark ? AppColors.neutral800 : AppColors.white;
    final textColor = isDark ? AppColors.neutral200 : AppColors.neutral900;
    final secondaryTextColor = isDark ? AppColors.neutral400 : AppColors.neutral500;
    final inputBg = isDark ? AppColors.neutral700 : AppColors.neutral100;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: BlocListener<ContactUsCubit, ContactUsState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  final message = state.successMessage ??
                      l10n.accountMessageSentSuccessfully;
                  Navigator.of(context).pop(message);
                } else if (state.errorMessage != null) {
                  Navigator.of(context).pop(state.errorMessage);
                }
              },
              child: BlocBuilder<ContactUsCubit, ContactUsState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // ── Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.accountContactUs,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      label: l10n.accountName,
                      controller: _nameController,
                      hintText: l10n.accountEnterYourName,
                      inputBg: inputBg,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isDark: isDark,
                      isRequired: true,
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: l10n.checkoutEmail,
                      controller: _emailController,
                      hintText: l10n.accountEnterYourEmail,
                      keyboardType: TextInputType.emailAddress,
                      inputBg: inputBg,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isDark: isDark,
                      isRequired: true,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: l10n.accountContact,
                      controller: _contactController,
                      hintText: l10n.accountEnterYourPhoneNumber,
                      keyboardType: TextInputType.phone,
                      inputBg: inputBg,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isDark: isDark,
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: l10n.accountMessage,
                      controller: _messageController,
                      hintText: l10n.accountEnterYourMessage,
                      minLines: 4,
                      maxLines: 6,
                      inputBg: inputBg,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isDark: isDark,
                      isRequired: true,
                      validator: _validateMessage,
                    ),
                    const SizedBox(height: 24),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                state.isSubmitting ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              disabledBackgroundColor: AppColors.primary600,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              l10n.accountSendMessage,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        if (state.isSubmitting) ...[
                          const SizedBox(height: 12),
                          const Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build a text input field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int minLines = 1,
    int maxLines = 1,
    required Color inputBg,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDark,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: textColor,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: secondaryTextColor,
            ),
            filled: true,
            fillColor: inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.primary600,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  /// Handle form submission
  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final contact = _contactController.text.trim();
    final message = _messageController.text.trim();

    // Submit form
    context.read<ContactUsCubit>().submitContactForm(
          name: name,
          email: email,
          contact: contact,
          message: message,
        );
  }

  // Validation mirrors the storefront contact form: name, email and message
  // are required; contact is optional but must be a valid phone number.
  String? _validateName(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final name = value?.trim() ?? '';
    if (name.isEmpty) return l10n.accountNameFieldEmpty;
    return null;
  }

  String? _validateEmail(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final email = value?.trim() ?? '';
    if (email.isEmpty) return l10n.accountEmailFieldEmpty;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return l10n.accountPleaseEnterValidEmailAddress;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final contact = value?.trim() ?? '';
    if (contact.isEmpty) return null;
    if (!isValidPhoneNumber(contact)) {
      return l10n.accountPleaseEnterValidContactNumber;
    }
    return null;
  }

  String? _validateMessage(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final message = value?.trim() ?? '';
    if (message.isEmpty) return l10n.accountMessageFieldEmpty;
    return null;
  }
}
