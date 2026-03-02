import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/preferences_cubit.dart';
import 'cms_page_detail_page.dart';
import 'contact_us_page.dart';

/// Preferences Bottom Sheet — Figma node-id=215-5028 (pop-over-preferences)
///
/// A modal bottom sheet with rounded top corners containing:
///   1. Header: "Preferences" title + close (X) icon
///   2. Menu items:
///      - Order and Return
///      - Settings
///      - Preferences (expandable with Language & Currency sub-items)
///      - Contact Us (expandable - opens contact form)
///      - Others (shows CMS pages)
///
/// Colors from Figma design tokens:
///   - Background: white (#FFFFFF) / dark: #262626
///   - List item bg: #F5F5F5 / dark: #262626
///   - Title: #171717 / dark: neutral200
///   - Body text: #171717 / dark: neutral200
///   - Border/divider: #D4D4D4
class PreferencesBottomSheet extends StatefulWidget {
  const PreferencesBottomSheet({super.key});

  /// Show the preferences bottom sheet from any context
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => PreferencesCubit(),
        child: const PreferencesBottomSheet(),
      ),
    );
  }

  @override
  State<PreferencesBottomSheet> createState() => _PreferencesBottomSheetState();
}

class _PreferencesBottomSheetState extends State<PreferencesBottomSheet> {
  bool _isOrderReturnExpanded = false;
  bool _isSettingsExpanded = false;
  bool _isPreferencesExpanded = false;
  bool _isOthersExpanded = false;

  @override
  void initState() {
    super.initState();
    // Load CMS pages when the Others section is first opened
    _maybeLoadCmsPages();
  }

  /// Load CMS pages when Others section is expanded
  void _maybeLoadCmsPages() {
    final cubit = context.read<PreferencesCubit>();
    if (cubit.state.cmsPages.isEmpty && !cubit.state.isLoadingCmsPages) {
      cubit.loadCmsPages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.neutral800 : AppColors.white;
    final listItemBg = isDark ? AppColors.neutral700 : AppColors.neutral100;
    final textColor = isDark ? AppColors.neutral200 : AppColors.neutral900;
    final secondaryTextColor = isDark ? AppColors.neutral400 : AppColors.neutral500;

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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                
                // ── Header: "Preferences" + Close icon ──
                // Figma node: 215:5075
                _buildHeader(context, textColor),

                const SizedBox(height: 4),

                // ── Menu Items ──
                // Figma node: 215:5399
                
                // Order and Return (Expandable)
                _buildExpandableMenuItem(
                  label: 'Order and Return',
                  isExpanded: _isOrderReturnExpanded,
                  listItemBg: listItemBg,
                  textColor: textColor,
                  onTap: () {
                    setState(() {
                      _isOrderReturnExpanded = !_isOrderReturnExpanded;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Track Order'),
                    _buildSubMenuItem('Return Policy'),
                    _buildSubMenuItem('Return Request'),
                  ],
                ),

                const SizedBox(height: 2),

                // Settings (Expandable)
                _buildExpandableMenuItem(
                  label: 'Settings',
                  isExpanded: _isSettingsExpanded,
                  listItemBg: listItemBg,
                  textColor: textColor,
                  onTap: () {
                    setState(() {
                      _isSettingsExpanded = !_isSettingsExpanded;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Notifications'),
                    _buildSubMenuItem('Privacy'),
                    _buildSubMenuItem('Account'),
                  ],
                ),

                const SizedBox(height: 2),

                // Preferences (expandable)
                _buildPreferencesSection(
                  context: context,
                  isDark: isDark,
                  bgColor: bgColor,
                  listItemBg: listItemBg,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                const SizedBox(height: 2),

                // Contact Us (Expandable)
                _buildContactUsSection(
                  context: context,
                  listItemBg: listItemBg,
                  textColor: textColor,
                ),

                const SizedBox(height: 2),

                // Others (Expandable) - Shows CMS Pages
                _buildOthersSection(
                  context: context,
                  isDark: isDark,
                  listItemBg: listItemBg,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header with title and close button
  Widget _buildHeader(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Preferences',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: textColor,
            ),
          ),
          // Close button (X icon)
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
    );
  }

  /// Build an expandable menu item with sub-items
  Widget _buildExpandableMenuItem({
    required String label,
    required bool isExpanded,
    required Color listItemBg,
    required Color textColor,
    required VoidCallback onTap,
    List<Widget> children = const [],
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subItemBg = isDark ? AppColors.neutral700 : AppColors.neutral50;

    return Container(
      decoration: BoxDecoration(
        color: listItemBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: textColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                Container(
                  decoration: BoxDecoration(
                    color: subItemBg,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a sub-menu item
  Widget _buildSubMenuItem(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.neutral300 : AppColors.neutral600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the Preferences section with Language and Currency sub-items
  Widget _buildPreferencesSection({
    required BuildContext context,
    required bool isDark,
    required Color bgColor,
    required Color listItemBg,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: listItemBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Preferences header (expandable)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isPreferencesExpanded = !_isPreferencesExpanded;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Preferences',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    Icon(
                      _isPreferencesExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: textColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Language and Currency sub-items (shown when expanded)
          if (_isPreferencesExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: BlocBuilder<PreferencesCubit, PreferencesState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Language selector
                      _buildLanguageSelector(
                        context: context,
                        isDark: isDark,
                        bgColor: bgColor,
                        secondaryTextColor: secondaryTextColor,
                        state: state,
                      ),

                      const SizedBox(height: 12),

                      // Currency selector
                      _buildCurrencySelector(
                        context: context,
                        isDark: isDark,
                        bgColor: bgColor,
                        secondaryTextColor: secondaryTextColor,
                      ),

                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Build language selector dropdown
  Widget _buildLanguageSelector({
    required BuildContext context,
    required bool isDark,
    required Color bgColor,
    required Color secondaryTextColor,
    required PreferencesState state,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral600 : AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            if (state.isLoadingLocales)
              SizedBox(
                height: 40,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary500,
                      ),
                    ),
                  ),
                ),
              )
            else if (state.locales.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No languages available',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              )
            else
              DropdownButton<String>(
                value: state.selectedLocaleCode,
                isExpanded: true,
                underline: SizedBox(),
                items: state.locales.map((locale) {
                  return DropdownMenuItem<String>(
                    value: locale.code,
                    child: Text(
                      locale.name,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<PreferencesCubit>().updateSelectedLocale(value);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Build currency selector dropdown
  Widget _buildCurrencySelector({
    required BuildContext context,
    required bool isDark,
    required Color bgColor,
    required Color secondaryTextColor,
  }) {
    // TODO: Load available currencies from API
    final currencies = ['USD', 'EUR', 'GBP', 'INR'];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral600 : AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currency',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<PreferencesCubit, PreferencesState>(
              builder: (context, state) {
                return DropdownButton<String>(
                  value: state.selectedCurrency ?? 'USD',
                  isExpanded: true,
                  underline: SizedBox(),
                  items: currencies.map((currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(
                        currency,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<PreferencesCubit>().updateSelectedCurrency(value);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build the Others section - Shows CMS Pages
  Widget _buildOthersSection({
    required BuildContext context,
    required bool isDark,
    required Color listItemBg,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: listItemBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Others header (expandable)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isOthersExpanded = !_isOthersExpanded;
                  if (_isOthersExpanded) {
                    _maybeLoadCmsPages();
                  }
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Others',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    Icon(
                      _isOthersExpanded ? Icons.expand_less : Icons.expand_more,
                      color: textColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // CMS Pages list (shown when expanded)
          if (_isOthersExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: BlocBuilder<PreferencesCubit, PreferencesState>(
                builder: (context, state) {
                  if (state.isLoadingCmsPages) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state.cmsPages.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No pages available',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      state.cmsPages.length,
                      (index) {
                        final page = state.cmsPages[index];
                        return _buildCmsPageItem(
                          context: context,
                          page: page,
                          isDark: isDark,
                          secondaryTextColor: secondaryTextColor,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Build individual CMS page list item
  Widget _buildCmsPageItem({
    required BuildContext context,
    required dynamic page,
    required bool isDark,
    required Color secondaryTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to CMS page detail
            Navigator.of(context)
              ..pop() // Close preferences bottom sheet
              ..push(
                MaterialPageRoute(
                  builder: (_) => CmsPageDetailPage(page: page),
                ),
              );
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  page.displayTitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: secondaryTextColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the Contact Us section
  Widget _buildContactUsSection({
    required BuildContext context,
    required Color listItemBg,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: listItemBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Open Contact Us form as bottom sheet
            ContactUsPage.show(context);
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: textColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
