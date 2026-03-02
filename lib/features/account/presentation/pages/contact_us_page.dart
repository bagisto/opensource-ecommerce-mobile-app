import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/contact_us_cubit.dart';

/// Contact Us Page - Modal bottom sheet with form
/// Fields: Name, Email, Contact (Phone), Message
/// On successful submission, closes the sheet and shows success message
class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  /// Show the contact us bottom sheet from any context
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => ContactUsCubit(),
        child: const ContactUsPage(),
      ),
    );
  }

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
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
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.successMessage ?? 'Message sent successfully!'),
                      backgroundColor: AppColors.success500,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  // Close the sheet after brief delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                }
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'An error occurred'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contact Us',
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

                  // ── Name Field ──
                  _buildTextField(
                    label: 'Name',
                    controller: _nameController,
                    hintText: 'Enter your name',
                    inputBg: inputBg,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  // ── Email Field ──
                  _buildTextField(
                    label: 'Email',
                    controller: _emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    inputBg: inputBg,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  // ── Contact (Phone) Field ──
                  _buildTextField(
                    label: 'Contact',
                    controller: _contactController,
                    hintText: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    inputBg: inputBg,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  // ── Message Field ──
                  _buildTextField(
                    label: 'Message',
                    controller: _messageController,
                    hintText: 'Enter your message',
                    minLines: 4,
                    maxLines: 6,
                    inputBg: inputBg,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),

                  // ── Save Button ──
                  BlocBuilder<ContactUsCubit, ContactUsState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isSubmitting ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            disabledBackgroundColor: AppColors.primary600,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state.isSubmitting
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isDark ? AppColors.white : AppColors.neutral900,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Send Message',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
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
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final contact = _contactController.text.trim();
    final message = _messageController.text.trim();

    // Validate name
    if (name.isEmpty) {
      _showErrorSnackbar('Name field cannot be empty');
      return;
    }
    if (name.length < 2) {
      _showErrorSnackbar('Name must be at least 2 characters');
      return;
    }

    // Validate email
    if (email.isEmpty) {
      _showErrorSnackbar('Email field cannot be empty');
      return;
    }
    if (!_isValidEmail(email)) {
      _showErrorSnackbar('Please enter a valid email address');
      return;
    }

    // Validate contact number
    if (contact.isEmpty) {
      _showErrorSnackbar('Contact number cannot be empty');
      return;
    }
    if (contact.length < 10) {
      _showErrorSnackbar('Please enter a valid contact number');
      return;
    }

    // Validate message
    if (message.isEmpty) {
      _showErrorSnackbar('Message field cannot be empty');
      return;
    }
    if (message.length < 10) {
      _showErrorSnackbar('Message must be at least 10 characters');
      return;
    }

    // Submit form
    context.read<ContactUsCubit>().submitContactForm(
          name: name,
          email: email,
          contact: contact,
          message: message,
        );
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
