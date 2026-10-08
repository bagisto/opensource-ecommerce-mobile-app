import '../../../../core/channel/channel_bootstrap_service.dart';
import '../../../../core/graphql/graphql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/preferences_cubit.dart';
import '../bloc/settings_cubit.dart';

/// Settings Bottom Sheet — Figma node-id=248-8062 (pop-over-settings-light)
///
/// A modal bottom sheet with rounded top corners containing:
///   1. Header: "Settings" title + close (X) icon
///   2. Change Theme button with sun/moon icon
///   3. Notifications section with master toggle + sub-toggles
///      - All Notifications (master toggle)
///      - Orders
///      - Offers
///   4. Offline Data section with toggles
///      - Track and Show Recently viewed products
///      - Show Search Tag
///
/// Colors from Figma design tokens:
///   - Background: white (#FFFFFF) / dark: neutral900 (#171717)
///   - List item bg: neutral100 (#F5F5F5) / dark: neutral800 (#262626)
///   - Title: neutral900 (#171717) / dark: neutral200
///   - Section header: neutral800 (#262626) / dark: neutral400
///   - Body text: neutral900 (#171717) / dark: neutral200
///   - Active toggle: primary500 (#FF6900)
///   - Inactive toggle: neutral300 (#D4D4D4)

class SettingsBottomSheet extends StatelessWidget {
  final BuildContext parentContext;

  const SettingsBottomSheet({super.key, required this.parentContext});

  /// Show the settings bottom sheet from any context
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SettingsCubit()),
          BlocProvider(
            create: (_) => PreferencesCubit(
              refreshChannel: () async => ChannelBootstrapService(
                client: GraphQLClientProvider.buildClient(),
                prefs: await SharedPreferences.getInstance(),
              ).bootstrap(),
            ),
          ),
          BlocProvider.value(value: context.read<CurrencyCubit>()),
          BlocProvider.value(value: context.read<ThemeCubit>()),
          BlocProvider.value(value: context.read<LocaleCubit>()),
        ],
        child: SettingsBottomSheet(parentContext: context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.neutral900 : AppColors.white;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle (visual affordance) ──
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Header: "Settings" + Close icon ──
              // Figma node: 248:8064
              _buildHeader(context, isDark),

              // ── Change Theme button ──
              // Figma node: 248:8280
              _buildChangeThemeButton(context, isDark),

              const SizedBox(height: 24),

              // ── Notifications section ──
              // Figma node: 248:8206
              _buildNotificationsSection(context, isDark),

              const SizedBox(height: 24),

              // ── Offline Data section ──
              // Figma node: 248:8245
              _buildOfflineDataSection(context, isDark),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Header row: "Settings" title + close (X) button
  /// Figma node: 248:8064, 248:8065
  Widget _buildHeader(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.accountSettings,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Semantics(
              button: true,
              label: l10n.accountCloseSettings,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Change Theme button — Figma node: 248:8280
  /// Light bg (neutral100), 10px radius, 48px height, with sun/moon icon
  Widget _buildChangeThemeButton(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isCurrentlyDark = themeMode == ThemeMode.dark;
        final bgColor = isDark ? AppColors.neutral800 : AppColors.neutral100;

        return Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () async {
              await context.read<ThemeCubit>().toggleTheme();
            },
            borderRadius: BorderRadius.circular(10),
            splashColor: AppColors.primary500.withValues(alpha: 0.08),
            highlightColor: AppColors.primary500.withValues(alpha: 0.04),
            child: Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.accountChangeTheme,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                  ),
                  Icon(
                    isCurrentlyDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    size: 22,
                    color: AppColors.primary500,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, preferencesState) {
        final availableLocales = preferencesState.locales;
        final bgColor = isDark ? AppColors.neutral800 : AppColors.neutral100;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.accountLanguage,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  ),
                ),
              ),
              if (availableLocales.isNotEmpty)
                BlocBuilder<LocaleCubit, Locale?>(
                  builder: (context, locale) {
                    final selectedCode = locale?.languageCode;
                    final dropdownValue = availableLocales.any(
                      (item) => item.code == selectedCode,
                    )
                        ? selectedCode
                        : availableLocales.first.code;

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        borderRadius: BorderRadius.circular(8),
                        dropdownColor: isDark
                            ? AppColors.neutral800
                            : AppColors.white,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900,
                        ),
                        items: availableLocales.map((locale) {
                          return DropdownMenuItem<String>(
                            value: locale.code,
                            child: Text(locale.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          context.read<PreferencesCubit>().updateSelectedLocale(
                            value,
                          );
                          Navigator.of(context).pop();
                          parentContext.read<LocaleCubit>().setLocale(value);
                        },
                      ),
                    );
                  },
                )
              else if (preferencesState.isLoadingLocales)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (availableLocales.isEmpty)
                Text(
                  l10n.accountNoLanguagesAvailable,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencySelector(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, preferencesState) {
        final bgColor = isDark ? AppColors.neutral800 : AppColors.neutral100;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.accountCurrency,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  ),
                ),
              ),
              if (preferencesState.currencies.isNotEmpty)
                BlocBuilder<CurrencyCubit, String?>(
                  builder: (context, selectedCurrency) {
                    final dropdownValue = preferencesState.currencies.any(
                      (item) => item.code == selectedCurrency,
                    )
                        ? selectedCurrency
                        : preferencesState.currencies.first.code;

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        borderRadius: BorderRadius.circular(8),
                        dropdownColor: isDark
                            ? AppColors.neutral800
                            : AppColors.white,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral900,
                        ),
                        items: preferencesState.currencies.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency.code,
                            child: Text(currency.code),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          context.read<PreferencesCubit>().updateSelectedCurrency(
                            value,
                          );
                          Navigator.of(context).pop();
                          parentContext.read<CurrencyCubit>().setCurrency(value);
                        },
                      ),
                    );
                  },
                )
              else if (preferencesState.isLoadingCurrencies)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  'No currencies',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Notifications section — Figma node: 248:8206
  /// Contains:
  ///   - Section header "Notifications" with master toggle
  ///   - "All Notifications" list item with toggle
  ///   - "Orders" list item with toggle
  ///   - "Offers" list item with toggle
  Widget _buildNotificationsSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header — Figma node: 248:8207
            _buildSectionHeader(
              label: l10n.accountNotifications,
              isDark: isDark,
              value: state.allNotifications,
              onChanged: (val) => cubit.toggleAllNotifications(val),
            ),

            // Sub-items with 2px gap — Figma node: 248:8167
            _buildToggleListItem(
              label: l10n.accountAllNotifications,
              isDark: isDark,
              value: state.allNotifications,
              onChanged: (val) => cubit.toggleAllNotifications(val),
            ),
            const SizedBox(height: 2),
            _buildToggleListItem(
              label: l10n.accountOrders,
              isDark: isDark,
              value: state.ordersNotification,
              onChanged: (val) => cubit.toggleOrdersNotification(val),
            ),
            const SizedBox(height: 2),
            _buildToggleListItem(
              label: l10n.accountOffers,
              isDark: isDark,
              value: state.offersNotification,
              onChanged: (val) => cubit.toggleOffersNotification(val),
            ),
          ],
        );
      },
    );
  }

  /// Offline Data section — Figma node: 248:8245
  /// Contains:
  ///   - Section header "Offline Data" with toggle
  ///   - "Track and Show Recently viewed products" list item with toggle
  ///   - "Show Search Tag" list item with toggle
  Widget _buildOfflineDataSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final offlineMaster = state.trackRecentlyViewed && state.showSearchTag;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header — Figma node: 248:8246
            _buildSectionHeader(
              label: l10n.accountOfflineData,
              isDark: isDark,
              value: offlineMaster,
              onChanged: (val) => cubit.toggleOfflineData(val),
            ),

            // Sub-items with 2px gap — Figma node: 248:8250
            _buildToggleListItem(
              label: l10n.accountTrackRecentlyViewedProducts,
              isDark: isDark,
              value: state.trackRecentlyViewed,
              onChanged: (val) => cubit.toggleTrackRecentlyViewed(val),
            ),
            const SizedBox(height: 2),
            _buildToggleListItem(
              label: l10n.accountShowSearchTag,
              isDark: isDark,
              value: state.showSearchTag,
              onChanged: (val) => cubit.toggleShowSearchTag(val),
            ),
          ],
        );
      },
    );
  }

  /// Section header row: label + toggle switch
  /// Figma node: 248:8207, 248:8246
  /// Font: Roboto SemiBold 14px, color neutral800/neutral400
  Widget _buildSectionHeader({
    required String label,
    required bool isDark,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral800,
            ),
          ),
          _buildCustomSwitch(
            value: value,
            onChanged: onChanged,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// Individual toggle list item — Figma list component
  /// bg: neutral100 (#F5F5F5), 10px radius, h:48px, px:12
  /// Font: Roboto Regular 14px, color neutral900/neutral200
  Widget _buildToggleListItem({
    required String label,
    required bool isDark,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final bgColor = isDark ? AppColors.neutral800 : AppColors.neutral100;

    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
          _buildCustomSwitch(
            value: value,
            onChanged: onChanged,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// Custom toggle switch matching the Figma design
  /// Active: primary500 (#FF6900) with white thumb
  /// Inactive: neutral300 (#D4D4D4) with white thumb
  /// Size: 34w x 20h (matches Figma node: 248:8209)
  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    final activeTrackColor = AppColors.primary500;
    final inactiveTrackColor = isDark
        ? AppColors.neutral700
        : AppColors.neutral300;
    final thumbColor = AppColors.white;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Semantics(
        toggled: value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 34,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: value ? activeTrackColor : inactiveTrackColor,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: thumbColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
