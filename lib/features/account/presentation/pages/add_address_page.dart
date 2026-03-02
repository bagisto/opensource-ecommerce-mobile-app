import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/address_book_bloc.dart';
import '../widgets/address_form_field.dart';

/// Add / Edit Address Page — Figma node-id=204-6116
///
/// Full form page with:
///   - Nav bar: back arrow + "Add New Address" / "Edit Address" title
///   - Scrollable form fields matching Figma exactly:
///     First Name*, Last Name*, Email, Company Name, VAT id,
///     Street Address*, Country* (dropdown), State* (dropdown),
///     City*, Zip/Postcode*, TelePhone*
///   - Toggle switches: Default billing / Default shipping address
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
  bool _isDefaultShipping = false;

  // Country / State data
  List<Country> _countries = [];
  List<CountryState> _states = [];
  Country? _selectedCountry;
  CountryState? _selectedState;
  bool _loadingCountries = true;
  bool _loadingStates = false;

  // Submission state
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _prepopulateIfEditing();
  }

  /// Pre-fill form fields when editing an existing address.
  void _prepopulateIfEditing() {
    final addr = widget.editingAddress;
    if (addr == null) return;

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
    _isDefaultShipping = addr.useForShipping;

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
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('No countries available. Please try again.'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
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
          // Load states for this country, then match saved state
          await _loadStates(match);
          if (mounted && _states.isNotEmpty) {
            final stateMatch = _states.cast<CountryState?>().firstWhere(
              (s) => s!.code == addr.state || s.name == addr.state,
              orElse: () => null,
            );
            if (stateMatch != null) {
              setState(() {
                _selectedState = stateMatch;
                _stateDisplayCtrl.text = stateMatch.name;
              });
            }
          }
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
            content: Text('Failed to load countries: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }

  Future<void> _loadStates(Country country) async {
    if (!mounted) return;
    setState(() {
      _loadingStates = true;
      _states = [];
      _selectedState = null;
      _stateDisplayCtrl.clear();
    });

    try {
      final repo = context.read<AccountRepository>();
      final states = await repo.getCountryStates(countryId: country.numericId);
      if (!mounted) return;
      setState(() {
        _states = states;
        _loadingStates = false;
      });

      // Show warning if no states available for this country
      if (_states.isEmpty) {
        debugPrint(
          '⚠️  No states available for country: ${country.name}',
        );
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
            content: Text('Failed to load states: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }

  Future<void> _onCountryTap() async {
    if (_loadingCountries || _countries.isEmpty) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selected = await SelectionSheet.show<Country>(
      context: context,
      title: 'Select Country',
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
    if (_loadingStates) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // If no states — allow free text entry
    if (_states.isEmpty) {
      _showFreeTextStateInput(isDark);
      return;
    }

    final selected = await SelectionSheet.show<CountryState>(
      context: context,
      title: 'Select State',
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

  Future<void> _showFreeTextStateInput(bool isDark) async {
    final value = await showFreeTextStateDialog(
      context: context,
      currentValue: _stateDisplayCtrl.text,
      isDark: isDark,
    );

    if (!mounted) return;
    if (value == null || value.isEmpty) return;

    setState(() {
      _selectedState = null;
      _stateDisplayCtrl.text = value;
    });
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    // Validate country
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please select a country'),
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
          const SnackBar(
            content: Text('Please select or enter a state'),
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
              useForShipping: _isDefaultShipping,
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
              useForShipping: _isDefaultShipping,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      ? 'Address updated successfully'
                      : 'Address added successfully',
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
    return Container(
      color: isDark ? AppColors.neutral900 : AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Go back',
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(10),
                child: Tooltip(
                  message: 'Back',
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
                _isEditing ? 'Edit Address' : 'Add New Address',
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
                label: 'First Name',
                isRequired: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_lastNameFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
            ),

            // ── Last Name* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _lastNameCtrl,
                label: 'Last Name',
                isRequired: true,
                focusNode: _lastNameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
            ),

            // ── Email ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _emailCtrl,
                label: 'Email',
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_companyFocus),
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(v.trim())) {
                      return 'Enter a valid email';
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
                label: 'Company Name',
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
                label: 'VAT id',
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
                label: 'Street Address',
                isRequired: true,
                focusNode: _streetFocus,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Street address is required';
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
                    label: 'Country',
                    isRequired: true,
                    isDropdown: true,
                    onDropdownTap: _onCountryTap,
                    enabled: !_loadingCountries,
                    validator: (v) {
                      if (_selectedCountry == null) {
                        return 'Please select a country';
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
                    label: 'State',
                    isRequired: true,
                    isDropdown: true,
                    onDropdownTap:
                        _loadingStates ? null : _onStateTap,
                    enabled: _selectedCountry != null && !_loadingStates,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'State is required';
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
                label: 'City',
                isRequired: true,
                focusNode: _cityFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_postcodeFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),
            ),

            // ── Zip/Postcode* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _postcodeCtrl,
                label: 'Zip/Postcode',
                isRequired: true,
                focusNode: _postcodeFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_phoneFocus),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Zip/Postcode is required';
                  }
                  return null;
                },
              ),
            ),

            // ── TelePhone* ──
            _fieldWrapper(
              child: AddressFormField(
                controller: _phoneCtrl,
                label: 'TelePhone',
                isRequired: true,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 8),

            // ── Change default billing address switch ──
            _buildSwitch(
              isDark: isDark,
              label: 'Change default billing address',
              value: _isDefaultBilling,
              onChanged: (v) => setState(() => _isDefaultBilling = v),
            ),

            const SizedBox(height: 8),

            // ── Change default shipping address switch ──
            _buildSwitch(
              isDark: isDark,
              label: 'Change default shipping address',
              value: _isDefaultShipping,
              onChanged: (v) => setState(() => _isDefaultShipping = v),
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
              : Text(_isEditing ? 'Update Address' : 'Save to Address Book'),
        ),
      ),
    );
  }
}
