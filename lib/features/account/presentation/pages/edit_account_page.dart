import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/account_models.dart';
import '../bloc/edit_account_bloc.dart';
import '../widgets/edit_account_form_field.dart';

/// Edit Account Page — Figma node-id=245-6502
///
/// Displays an editable form with the customer's profile information:
///   - First Name *
///   - Last Name *
///   - Gender (dropdown)
///   - Phone
///   - DOB (date picker)
///   - Subscribe Newsletters (checkbox)
///   - Change Email (navigates to dialog)
///   - Change Password (navigates to dialog)
///   - Delete Account (red, with confirmation)
///   - Save Profile (bottom sticky button)
///
/// Architecture follows the same pattern as Next.js commerce:
///   Component (form) → BLoC event → Repository → GraphQL mutation
class EditAccountPage extends StatefulWidget {
  final CustomerProfile? profile;

  const EditAccountPage({super.key, this.profile});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;

  String? _selectedGender;
  DateTime? _selectedDob;
  bool _subscribedToNewsLetter = false;

  final _formKey = GlobalKey<FormState>();

  static const List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _firstNameCtrl = TextEditingController(text: p?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: p?.lastName ?? '');
    _phoneCtrl = TextEditingController(text: p?.phone ?? '');
    _selectedGender = p?.gender;
    _subscribedToNewsLetter = p?.subscribedToNewsLetter ?? false;

    // Parse DOB
    if (p?.dateOfBirth != null && p!.dateOfBirth!.isNotEmpty) {
      _selectedDob = DateTime.tryParse(p.dateOfBirth!);
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<EditAccountBloc, EditAccountState>(
      listener: (context, state) {
        // Show success snackbar
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.successGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          context.read<EditAccountBloc>().add(const ClearEditAccountMessage());
        }

        // Show error snackbar
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFFB2C36),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          context.read<EditAccountBloc>().add(const ClearEditAccountMessage());
        }

        // Account deleted — logout and pop
        if (state.status == EditAccountStatus.accountDeleted) {
          context.read<AuthBloc>().add(const AuthLogoutRequested());
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        // Update form fields when fresh profile is loaded from API
        if (state.status == EditAccountStatus.loaded && state.profile != null) {
          _updateFormFields(state.profile!);
        }

        // Update form fields when profile is refreshed after save
        if (state.status == EditAccountStatus.saved && state.profile != null) {
          _updateFormFields(state.profile!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Navigation bar — Figma: navigation-bar/title ──
                _buildAppBar(context, isDark),

                // ── Form content ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Name *
                          _buildInputField(
                            context,
                            label: 'First Name *',
                            controller: _firstNameCtrl,
                            isDark: isDark,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),

                          // Last Name *
                          _buildInputField(
                            context,
                            label: 'Last Name *',
                            controller: _lastNameCtrl,
                            isDark: isDark,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),

                          // Gender (dropdown)
                          _buildGenderField(context, isDark),

                          // Phone
                          _buildInputField(
                            context,
                            label: 'Phone',
                            controller: _phoneCtrl,
                            isDark: isDark,
                            keyboardType: TextInputType.phone,
                          ),

                          // DOB (date picker)
                          _buildDobField(context, isDark),

                          // Subscribe Newsletters checkbox
                          _buildNewsletterCheckbox(context, isDark),

                          const SizedBox(height: 8),

                          // Change Email button
                          _buildActionTile(
                            context,
                            icon: Icons.email_outlined,
                            label: 'Change Email',
                            isDark: isDark,
                            onTap: () => _showChangeEmailDialog(context),
                          ),

                          const SizedBox(height: 2),

                          // Change Password button
                          _buildActionTile(
                            context,
                            icon: Icons.lock_outline,
                            label: 'Change Password',
                            isDark: isDark,
                            onTap: () => _showChangePasswordDialog(context),
                          ),

                          const SizedBox(height: 8),

                          // Delete Account button
                          _buildActionTile(
                            context,
                            icon: Icons.delete_outline,
                            label: 'Delete Account',
                            isDark: isDark,
                            isDestructive: true,
                            onTap: () => _showDeleteAccountDialog(context),
                          ),

                          // Bottom spacing for the sticky button
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Bottom sticky Save Profile button ──
                _buildSaveButton(context, isDark, state),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── App Bar — Figma: navigation-bar/title (node 245:6607) ──

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? AppColors.neutral900 : AppColors.white,
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Back arrow — Figma: arrow (I245:6607;103:1820)
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 24,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
              ),
            ),
          ),
          // Title — Figma: center (I245:6607;103:1822)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                'Account Edit',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? AppColors.neutral200 : AppColors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input Field — Figma: input-field with floating label ──

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required bool isDark,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: EditAccountFormField(
        label: label,
        controller: controller,
        isDark: isDark,
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }

  // ── Gender Dropdown — Figma: input-field with dropdown icon ──

  Widget _buildGenderField(BuildContext context, bool isDark) {
    final borderColor = isDark ? AppColors.neutral700 : AppColors.neutral200;
    final textColor = isDark ? AppColors.neutral200 : AppColors.neutral800;
    final labelColor = isDark ? AppColors.neutral300 : AppColors.neutral800;
    final bgColor = isDark ? AppColors.neutral900 : AppColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _showGenderPicker(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedGender ?? '',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: _selectedGender != null
                                ? textColor
                                : (isDark
                                    ? AppColors.neutral500
                                    : AppColors.neutral500),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color:
                            isDark ? AppColors.neutral400 : AppColors.neutral500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating label — Figma: lable (I246:6895;169:7320)
          Positioned(
            left: 9,
            top: -10,
            child: Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                'Gender',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: labelColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGenderPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select Gender',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral600,
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              ..._genderOptions.map((gender) => ListTile(
                    title: Text(
                      gender,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: _selectedGender == gender
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _selectedGender == gender
                            ? AppColors.primary500
                            : (isDark
                                ? AppColors.neutral200
                                : AppColors.neutral800),
                      ),
                    ),
                    trailing: _selectedGender == gender
                        ? const Icon(Icons.check, color: AppColors.primary500)
                        : null,
                    onTap: () {
                      setState(() => _selectedGender = gender);
                      Navigator.pop(ctx, gender);
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ── DOB Field — Figma: input-field with calendar icon ──

  Widget _buildDobField(BuildContext context, bool isDark) {
    final borderColor = isDark ? AppColors.neutral700 : AppColors.neutral200;
    final textColor = isDark ? AppColors.neutral200 : AppColors.neutral800;
    final labelColor = isDark ? AppColors.neutral300 : AppColors.neutral800;
    final bgColor = isDark ? AppColors.neutral900 : AppColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _pickDate(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatDob(_selectedDob),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: _selectedDob != null
                                ? textColor
                                : (isDark
                                    ? AppColors.neutral500
                                    : AppColors.neutral500),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 24,
                        color:
                            isDark ? AppColors.neutral400 : AppColors.neutral800,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating label
          Positioned(
            left: 9,
            top: -10,
            child: Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                'DOB',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: labelColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(ctx).colorScheme.copyWith(
                  primary: AppColors.primary500,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDob = picked);
    }
  }

  String _formatDob(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatDobForApi(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // ── Subscribe Newsletters — Figma: checkbox-set (246:7610) ──

  Widget _buildNewsletterCheckbox(BuildContext context, bool isDark) {
    final textColor = isDark ? AppColors.neutral200 : AppColors.neutral800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() => _subscribedToNewsLetter = !_subscribedToNewsLetter);
        },
        child: Row(
          children: [
            // Checkbox icon — Figma uses filled orange checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _subscribedToNewsLetter
                    ? AppColors.primary500
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: _subscribedToNewsLetter
                    ? null
                    : Border.all(
                        color: isDark
                            ? AppColors.neutral500
                            : AppColors.neutral400,
                        width: 1.5,
                      ),
              ),
              child: _subscribedToNewsLetter
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 4),
            Text(
              'Subscribe Newsletters',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Action Tiles — Figma: list items (Change Email, Password, Delete) ──

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isDark,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final bgColor = isDark ? AppColors.neutral800 : AppColors.neutral100;
    final textColor = isDestructive
        ? const Color(0xFFFB2C36)
        : (isDark ? AppColors.neutral200 : AppColors.neutral900);
    final iconColor = isDestructive
        ? const Color(0xFFFB2C36)
        : (isDark ? AppColors.neutral300 : AppColors.neutral900);

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: isDestructive
              ? const Color(0xFFFB2C36).withValues(alpha: 0.08)
              : AppColors.primary500.withValues(alpha: 0.08),
          highlightColor: isDestructive
              ? const Color(0xFFFB2C36).withValues(alpha: 0.04)
              : AppColors.primary500.withValues(alpha: 0.04),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 24, color: iconColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Save Profile Button — Figma: navigation-bar/add-to-cart (246:7562) ──

  Widget _buildSaveButton(
      BuildContext context, bool isDark, EditAccountState state) {
    return Container(
      color: isDark ? AppColors.neutral900 : AppColors.neutral50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Material(
            color: AppColors.primary500,
            borderRadius: BorderRadius.circular(54),
            child: InkWell(
              onTap: state.isProcessing ? null : () => _onSaveProfile(context),
              borderRadius: BorderRadius.circular(54),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Center(
                  child: state.status == EditAccountStatus.saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Text(
                          'Save Profile',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Form Actions ──

  void _onSaveProfile(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<EditAccountBloc>().add(SaveProfile(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          gender: _selectedGender,
          phone: _phoneCtrl.text.trim().isNotEmpty
              ? _phoneCtrl.text.trim()
              : null,
          dateOfBirth: _formatDobForApi(_selectedDob),
          subscribedToNewsLetter: _subscribedToNewsLetter,
        ));
  }

  void _updateFormFields(CustomerProfile profile) {
    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text = profile.lastName;
    _phoneCtrl.text = profile.phone ?? '';
    _selectedGender = profile.gender;
    _subscribedToNewsLetter = profile.subscribedToNewsLetter;
    if (profile.dateOfBirth != null && profile.dateOfBirth!.isNotEmpty) {
      _selectedDob = DateTime.tryParse(profile.dateOfBirth!);
    }
  }

  // ── Change Email Dialog ──

  void _showChangeEmailDialog(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Change Email',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? AppColors.neutral200 : AppColors.neutral900,
          ),
        ),
        content: Form(
          key: dialogFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                decoration: _dialogInputDecoration(
                  'New Email',
                  isDark: isDark,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                decoration: _dialogInputDecoration(
                  'Current Password',
                  isDark: isDark,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDark ? AppColors.neutral300 : AppColors.neutral600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (dialogFormKey.currentState!.validate()) {
                Navigator.pop(dialogContext);
                context.read<EditAccountBloc>().add(ChangeEmail(
                      newEmail: emailCtrl.text.trim(),
                      currentPassword: passwordCtrl.text,
                    ));
              }
            },
            child: const Text(
              'Change',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Change Password Dialog ──

  void _showChangePasswordDialog(BuildContext context) {
    final currentPwdCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();
    final confirmPwdCtrl = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? AppColors.neutral200 : AppColors.neutral900,
          ),
        ),
        content: Form(
          key: dialogFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPwdCtrl,
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                decoration: _dialogInputDecoration(
                  'Current Password',
                  isDark: isDark,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Current password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: newPwdCtrl,
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                decoration: _dialogInputDecoration(
                  'New Password',
                  isDark: isDark,
                ),
                validator: (v) {
                  if (v == null || v.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmPwdCtrl,
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                decoration: _dialogInputDecoration(
                  'Confirm Password',
                  isDark: isDark,
                ),
                validator: (v) {
                  if (v != newPwdCtrl.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDark ? AppColors.neutral300 : AppColors.neutral600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (dialogFormKey.currentState!.validate()) {
                Navigator.pop(dialogContext);
                context.read<EditAccountBloc>().add(ChangePassword(
                      currentPassword: currentPwdCtrl.text,
                      newPassword: newPwdCtrl.text,
                      confirmPassword: confirmPwdCtrl.text,
                    ));
              }
            },
            child: const Text(
              'Change',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Delete Account Dialog ──

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordCtrl = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFFFB2C36),
          ),
        ),
        content: Form(
          key: dialogFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This action is permanent and cannot be undone. All your data will be deleted.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
                decoration: _dialogInputDecoration(
                  'Enter your password',
                  isDark: isDark,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDark ? AppColors.neutral300 : AppColors.neutral600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (dialogFormKey.currentState!.validate()) {
                Navigator.pop(dialogContext);
                context.read<EditAccountBloc>().add(
                      DeleteAccount(password: passwordCtrl.text),
                    );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFFFB2C36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared dialog input decoration ──

  InputDecoration _dialogInputDecoration(String label, {required bool isDark}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: isDark ? AppColors.neutral400 : AppColors.neutral500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary500),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFB2C36)),
      ),
    );
  }
}
