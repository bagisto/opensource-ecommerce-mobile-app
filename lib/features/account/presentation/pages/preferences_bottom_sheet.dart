import '../../../../core/channel/channel_bootstrap_service.dart';
import '../../../../core/graphql/graphql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/preferences_cubit.dart';
import 'cms_page_detail_page.dart';
import 'contact_us_page.dart';
import 'settings_bottom_sheet.dart';

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
  final bool showSettingsSection;
  final BuildContext parentContext;

  const PreferencesBottomSheet({
    super.key,
    required this.parentContext,
    this.showSettingsSection = true,
  });

  /// Show the preferences bottom sheet from any context
  static Future<void> show(
    BuildContext context, {
    bool showSettingsSection = true,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => PreferencesCubit(
              refreshChannel: () async => ChannelBootstrapService(
                client: GraphQLClientProvider.buildClient(),
                prefs: await SharedPreferences.getInstance(),
              ).bootstrap(),
            ),
          ),
          BlocProvider.value(value: context.read<CurrencyCubit>()),
          BlocProvider.value(value: context.read<LocaleCubit>()),
        ],
        child: PreferencesBottomSheet(
          parentContext: context,
          showSettingsSection: showSettingsSection,
        ),
      ),
    );
  }

  @override
  State<PreferencesBottomSheet> createState() => _PreferencesBottomSheetState();
}

class _PreferencesBottomSheetState extends State<PreferencesBottomSheet> {
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
    final l10n = AppLocalizations.of(context)!;
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
                
                if (widget.showSettingsSection) ...[
                  _buildNavigationMenuItem(
                    label: l10n.accountSettings,
                    listItemBg: listItemBg,
                    textColor: textColor,
                    onTap: () {
                      Navigator.of(context).pop();
                      SettingsBottomSheet.show(widget.parentContext);
                    },
                  ),

                  const SizedBox(height: 2),
                ],

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

  Widget _buildNavigationMenuItem({
    required String label,
    required Color listItemBg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
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
          child: Padding(
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

  /// Build header with title and close button
  Widget _buildHeader(BuildContext context, Color textColor) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.accountPreferences,
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

  /// Build the Preferences section with Language and Currency sub-items
  Widget _buildPreferencesSection({
    required BuildContext context,
    required bool isDark,
    required Color bgColor,
    required Color listItemBg,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final l10n = AppLocalizations.of(context)!;

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
                      l10n.accountPreferences,
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
                        secondaryTextColor: secondaryTextColor,
                        state: state,
                      ),

                      const SizedBox(height: 12),

                      // Currency selector
                      _buildCurrencySelector(
                        context: context,
                        isDark: isDark,
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
    required Color secondaryTextColor,
    required PreferencesState state,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final availableLocales = state.locales;

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
              l10n.accountLanguage,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            if (availableLocales.isNotEmpty)
              BlocBuilder<LocaleCubit, Locale?>(
                builder: (context, locale) {
                  final selectedCode = locale?.languageCode;
                  final dropdownValue = availableLocales.any(
                    (item) => item.code == selectedCode,
                  )
                      ? selectedCode
                      : availableLocales.first.code;

                  return DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: availableLocales.map((locale) {
                      return DropdownMenuItem<String>(
                        value: locale.code,
                        child: Text(
                          locale.name,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.neutral200
                                : AppColors.neutral900,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      context.read<PreferencesCubit>().updateSelectedLocale(value);
                      context.read<LocaleCubit>().setLocale(value);
                    },
                  );
                },
              )
            else if (state.isLoadingLocales)
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
            else if (availableLocales.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.accountNoLanguagesAvailable,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  /// Build currency selector dropdown
  Widget _buildCurrencySelector({
    required BuildContext context,
    required bool isDark,
    required Color secondaryTextColor,
  }) {
    final l10n = AppLocalizations.of(context)!;

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
              l10n.accountCurrency,
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
                if (state.currencies.isNotEmpty) {
                  return BlocBuilder<CurrencyCubit, String?>(
                    builder: (context, selectedCurrency) {
                      final dropdownValue = state.currencies.any(
                        (item) => item.code == selectedCurrency,
                      )
                          ? selectedCurrency
                          : state.currencies.first.code;

                      return DropdownButton<String>(
                        value: dropdownValue,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: state.currencies.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency.code,
                            child: Text(
                              '${currency.name} (${currency.code})',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.neutral200
                                    : AppColors.neutral900,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          context.read<PreferencesCubit>().updateSelectedCurrency(
                            value,
                          );
                          context.read<CurrencyCubit>().setCurrency(value);
                        },
                      );
                    },
                  );
                }

                if (state.isLoadingCurrencies) {
                  return SizedBox(
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
                  );
                }

                return Text(
                  'No currencies available',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
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
    final l10n = AppLocalizations.of(context)!;

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
                      l10n.accountOthers,
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
                        l10n.accountNoPagesAvailable,
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
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.accountContactUs,
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
