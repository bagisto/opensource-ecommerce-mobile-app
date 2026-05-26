import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/address_book_bloc.dart';
import '../utils/address_debug_payload.dart';
import '../utils/address_state_field_behavior.dart';
import '../widgets/address_form_field.dart';

/// Add / Edit Address Page — Figma node-id=204-6116
///
/// Full form page with:
///   - Nav bar: back arrow + "Add New Address" / "Edit Address" title
///   - Scrollable form fields matching Figma exactly:
///     First Name*, Last Name*, Email, Company Name, VAT id,
///     Street Address*, Country* (dropdown), State* (dropdown),
///     City*, Zip/Postcode*, TelePhone*
///   - Toggle switch: Set as Default
///   - Bottom sticky "Save to Address Book" / "Update Address" button
///
/// Pass [editingAddress] to pre-populate the form for editing.
/// Integrates with Bagisto GraphQL API via [AddressBookBloc].
class AddAddressPage extends StatefulWidget {
  /// When non-null, the page operates in **edit mode**.
  final CustomerAddress? editingAddress;

  const AddAddressPage({super.key, this.editingAddress});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  /// Whether we are editing an existing address.
  bool get _isEditing => widget.editingAddress != null;

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _vatIdCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _postcodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  // Dropdown display controllers
  final _countryDisplayCtrl = TextEditingController();
  final _stateDisplayCtrl = TextEditingController();

  // Focus nodes
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _companyFocus = FocusNode();
  final _vatIdFocus = FocusNode();
  final _streetFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _postcodeFocus = FocusNode();
  final _phoneFocus = FocusNode();

  // Switch states
  bool _isDefaultBilling = false;

  // Country / State data
  List<Country> _countries = [];
  List<CountryState> _states = [];
  Country? _selectedCountry;
  CountryState? _selectedState;
  bool _loadingCountries = true;
  bool _loadingStates = false;

  // Submission state
  bool _isSubmitting = false;

  bool get _useStateDropdown => shouldUseStateDropdown(
    availableStateNames: _states.map((state) => state.name).toList(),
  );

  @override
  void initState() {
    super.initState();
    _prepopulateIfEditing();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCountries();
      }
    });
  }

  /// Pre-fill form fields when editing an existing address.
  void _prepopulateIfEditing() {
    final addr = widget.editingAddress;
    if (addr == null) return;

    debugPrint(
      '📝 Edit Address loaded for addressId=${addr.numericId}: '
      '${jsonEncode(buildEditAddressDebugPayload(addr))}',
    );

    _firstNameCtrl.text = addr.firstName;
    _lastNameCtrl.text = addr.lastName;
    _emailCtrl.text = addr.email ?? '';
    _companyCtrl.text = addr.companyName ?? '';
    _vatIdCtrl.text = addr.vatId ?? '';
    _streetCtrl.text = addr.address;
    _cityCtrl.text = addr.city;
    _postcodeCtrl.text = addr.zipCode;
    _phoneCtrl.text = addr.phone ?? '';
    _isDefaultBilling = addr.isDefault;

    // Country & State will be matched after countries load
    // Store raw values so _loadCountries can match them
    _stateDisplayCtrl.text = addr.state;
    _countryDisplayCtrl.text = addr.country;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _companyCtrl.dispose();
    _vatIdCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _postcodeCtrl.dispose();
    _phoneCtrl.dispose();
    _countryDisplayCtrl.dispose();
    _stateDisplayCtrl.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _companyFocus.dispose();
    _vatIdFocus.dispose();
    _streetFocus.dispose();
    _cityFocus.dispose();
    _postcodeFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    try {
      final repo = context.read<AccountRepository>();
      final countries = await repo.getCountries();
      if (!mounted) return;
      setState(() {
        _countries = countries;
        _loadingCountries = false;
      });

      // If no countries loaded, show error
      if (_countries.isEmpty) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.accountNoCountriesAvailable),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
        }
        return;
      }

      // If editing, match the saved country code to a Country object
      final addr = widget.editingAddress;
      if (addr != null && _countries.isNotEmpty) {
        final match = _countries.cast<Country?>().firstWhere(
          (c) => c!.code == addr.country,
          orElse: () => null,
        );
        if (match != null) {
          setState(() {
            _selectedCountry = match;
            _countryDisplayCtrl.text = match.name;
          });
          // Load states for this country, then restore the saved state value
          // when the country has no predefined state list.
          await _loadStates(match, savedStateText: addr.state);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCountries = false;
        _countries = [];
      });
      debugPrint('❌ Failed to load countries: $e');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              ErrorMapper.getUserMessage(e, context: 'loading countries'),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }

  Future<void> _loadStates(Country country, {String? savedStateText}) async {
    final normalizedSavedState = savedStateText?.trim() ?? '';

    if (!mounted) return;
    setState(() {
      _loadingStates = true;
      _states = [];
      _selectedState = null;
      if (normalizedSavedState.isEmpty) {
        _stateDisplayCtrl.clear();
      }
    });

    try {
      final repo = context.read<AccountRepository>();
      final states = await repo.getCountryStates(countryId: country.numericId);
      if (!mounted) return;

      final stateMatch = normalizedSavedState.isEmpty
          ? null
          : states.cast<CountryState?>().firstWhere(
              (state) =>
                  state!.code == normalizedSavedState ||
                  state.name == normalizedSavedState,
              orElse: () => null,
            );
      final resolvedStateText = resolveStateFieldText(
        savedStateText: normalizedSavedState,
        matchedStateName: stateMatch?.name,
      );

      setState(() {
        _states = states;
        _loadingStates = false;
        _selectedState = stateMatch;
        _stateDisplayCtrl.text = resolvedStateText;
      });

      // Show warning if no states available for this country
      if (_states.isEmpty) {
        debugPrint('⚠️  No states available for country: ${country.name}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _states = [];
        _loadingStates = false;
      });
      debugPrint('❌ Failed to load states for ${country.name}: $e');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              ErrorMapper.getUserMessage(e, context: 'loading states'),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }

  Future<void> _onCountryTap() async {
    final l10n = AppLocalizations.of(context)!;

    if (_loadingCountries || _countries.isEmpty) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selected = await SelectionSheet.show<Country>(
      context: context,
      title: l10n.checkoutSelectCountry,
      items: _countries,
      selectedItem: _selectedCountry,
      itemLabel: (c) => c.name,
      isDark: isDark,
    );

    if (!mounted) return;
    if (selected == null || selected == _selectedCountry) return;

    // Wait for the bottom sheet dismiss animation to fully complete
    // so its widgets (including the search TextField / RenderEditable)
    // are fully detached before we trigger a rebuild.
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    setState(() {
      _selectedCountry = selected;
      _countryDisplayCtrl.text = selected.name;
    });
    _loadStates(selected);
  }

  Future<void> _onStateTap() async {
    final l10n = AppLocalizations.of(context)!;

    if (_loadingStates) return;
    if (_states.isEmpty) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = await SelectionSheet.show<CountryState>(
      context: context,
      title: l10n.checkoutSelectState,
      items: _states,
      selectedItem: _selectedState,
      itemLabel: (s) => s.name,
      isDark: isDark,
    );

    if (!mounted) return;
    if (selected == null) return;

    // Wait for the bottom sheet dismiss animation to fully complete
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    setState(() {
      _selectedState = selected;
      _stateDisplayCtrl.text = selected.name;
    });
  }

  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    // Validate country
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.accountPleaseSelectCountry),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    // Validate state
    if (_stateDisplayCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.accountPleaseSelectOrEnterState),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    context.read<AddressBookBloc>().add(
      _isEditing
          ? UpdateAddress(
              addressId: widget.editingAddress!.numericId!,
              firstName: _firstNameCtrl.text.trim(),
              lastName: _lastNameCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              companyName: _companyCtrl.text.trim(),
              vatId: _vatIdCtrl.text.trim(),
              address: _streetCtrl.text.trim(),
              country: _selectedCountry!.code,
              state: _selectedState?.code ?? _stateDisplayCtrl.text.trim(),
              city: _cityCtrl.text.trim(),
              postcode: _postcodeCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
              defaultAddress: _isDefaultBilling,
            )
          : CreateAddress(
              firstName: _firstNameCtrl.text.trim(),
              lastName: _lastNameCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              companyName: _companyCtrl.text.trim(),
              vatId: _vatIdCtrl.text.trim(),
              address: _streetCtrl.text.trim(),
              country: _selectedCountry!.code,
              state: _selectedState?.code ?? _stateDisplayCtrl.text.trim(),
              city: _cityCtrl.text.trim(),
              postcode: _postcodeCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
              defaultAddress: _isDefaultBilling,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AddressBookBloc, AddressBookState>(
      listenWhen: (prev, curr) =>
          prev.addressCreated != curr.addressCreated ||
          prev.addressUpdated != curr.addressUpdated ||
          (prev.actionMessage != curr.actionMessage &&
              curr.actionMessage != null),
      listener: (context, state) {
        // Update submission state
        if (_isSubmitting != state.isPerformingAction) {
          setState(() => _isSubmitting = state.isPerformingAction);
        }

        if (state.addressCreated || state.addressUpdated) {
          // Success — pop back to address book
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.addressUpdated
                      ? l10n.accountAddressUpdatedSuccessfully
                      : l10n.accountAddressAddedSuccessfully,
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          if (mounted) {
            Navigator.of(context).pop(true); // true = address was created
          }
          return;
        }

        // Error snackbar
        if (state.actionMessage != null &&
            !state.isPerformingAction &&
            !state.addressCreated &&
            !state.addressUpdated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.actionMessage!),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildNavBar(context, isDark),
              Expanded(child: _buildForm(context, isDark)),
              _buildBottomButton(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// Nav bar — back arrow + "Add New Address"
  Widget _buildNavBar(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: isDark ? AppColors.neutral900 : AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: l10n.accountGoBack,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(10),
                child: Tooltip(
                  message: l10n.accountBack,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _isEditing
                    ? l10n.accountEditAddress
                    : l10n.accountAddNewAddress,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? AppColors.neutral200 : AppColors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Scrollable form — all fields matching Figma layout
  Widget _buildForm(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── First Name* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _firstNameCtrl,
                label: l10n.checkoutFirstName,
                isRequired: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_lastNameFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.accountFirstNameRequired;
                  }
                  return null;
                },
              ),
            ),

            // ── Last Name* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _lastNameCtrl,
                label: l10n.checkoutLastName,
                isRequired: true,
                focusNode: _lastNameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.accountLastNameRequired;
                  }
                  return null;
                },
              ),
            ),

            // ── Email ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _emailCtrl,
                label: l10n.checkoutEmail,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_companyFocus),
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(v.trim())) {
                      return l10n.accountEnterValidEmail;
                    }
                  }
                  return null;
                },
              ),
            ),

            // ── Company Name ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _companyCtrl,
                label: l10n.accountCompanyName,
                focusNode: _companyFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_vatIdFocus),
              ),
            ),

            // ── VAT ID ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _vatIdCtrl,
                label: l10n.accountVatId,
                focusNode: _vatIdFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_streetFocus),
              ),
            ),

            // ── Street Address* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _streetCtrl,
                label: l10n.checkoutStreetAddress,
                isRequired: true,
                focusNode: _streetFocus,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.accountStreetAddressRequired;
                  }
                  return null;
                },
              ),
            ),

            // ── Country* (dropdown) ──
            _fieldWrapper(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  AddressFormField(
                    controller: _countryDisplayCtrl,
                    label: l10n.checkoutCountry,
                    isRequired: true,
                    isDropdown: true,
                    onDropdownTap: _onCountryTap,
                    enabled: !_loadingCountries,
                    validator: (v) {
                      if (_selectedCountry == null) {
                        return l10n.accountPleaseSelectCountry;
                      }
                      return null;
                    },
                  ),
                  if (_loadingCountries)
                    const Positioned(
                      right: 12,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── State* (dropdown or free text) ──
            _fieldWrapper(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  AddressFormField(
                    controller: _stateDisplayCtrl,
                    label: l10n.checkoutState,
                    isRequired: true,
                    isDropdown: _useStateDropdown,
                    onDropdownTap: _useStateDropdown && !_loadingStates
                        ? _onStateTap
                        : null,
                    enabled: _selectedCountry != null && !_loadingStates,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.checkoutStateRequired;
                      }
                      return null;
                    },
                  ),
                  if (_loadingStates)
                    const Positioned(
                      right: 12,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── City* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _cityCtrl,
                label: l10n.checkoutCity,
                isRequired: true,
                focusNode: _cityFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_postcodeFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.accountCityRequired;
                  }
                  return null;
                },
              ),
            ),

            // ── Zip/Postcode* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _postcodeCtrl,
                label: l10n.accountZipPostcode,
                isRequired: true,
                focusNode: _postcodeFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_phoneFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.accountZipPostcodeRequired;
                  }
                  return null;
                },
              ),
            ),

            // ── TelePhone* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _phoneCtrl,
                label: l10n.accountTelephone,
                isRequired: true,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.accountPhoneNumberRequired;
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 8),

            // ── Set as Default switch ──
            _buildSwitch(
              isDark: isDark,
              label: l10n.accountSetAsDefault,
              value: _isDefaultBilling,
              onChanged: (v) => setState(() => _isDefaultBilling = v),
            ),

            // Extra space for bottom button
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// Wraps each form field with consistent vertical padding (Figma: py=10, gap=8)
  Widget _fieldWrapper({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: child,
    );
  }

  /// Toggle switch row — Figma node: 1980:7194 / 1980:7199
  Widget _buildSwitch({
    required bool isDark,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final activeTrackColor = AppColors.primary500;
    final inactiveTrackColor = isDark
        ? AppColors.neutral700
        : AppColors.neutral400;
    final thumbColor = value
        ? AppColors.white
        : (isDark ? AppColors.neutral50 : AppColors.neutral50);

    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 24,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Switch(
              value: value,
              onChanged: _isSubmitting ? null : onChanged,
              activeTrackColor: activeTrackColor,
              inactiveTrackColor: inactiveTrackColor,
              thumbColor: WidgetStatePropertyAll(thumbColor),
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),
        ),
      ],
    );
  }

  /// Bottom sticky "Save to Address Book" button
  Widget _buildBottomButton(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: isDark ? AppColors.neutral800 : AppColors.neutral50,
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.primary500.withAlpha(128),
            disabledForegroundColor: AppColors.white.withAlpha(180),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(54),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(
                  _isEditing
                      ? l10n.accountUpdateAddress
                      : l10n.accountSaveToAddressBook,
                ),
        ),
      ),
    );
  }
}
