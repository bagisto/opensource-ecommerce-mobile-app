/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:async';
import 'dart:convert';
import 'package:bagisto_app_demo/utils/server_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shared_preference_helper.dart';

class ApplicationLocalizations {
  static ApplicationLocalizations? instance;

  ApplicationLocalizations._init(Locale locale) {
    instance = this;
    appLocale = locale;
  }

  Locale? appLocale;

  ApplicationLocalizations({this.appLocale});

  static ApplicationLocalizations? of(BuildContext? context) {
    return Localizations.of<ApplicationLocalizations>(
        context!, ApplicationLocalizations);
  }

  static const LocalizationsDelegate<ApplicationLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    var selectedCode = appStoragePref.getCustomerLanguage();
    Locale selectedLocale = supportedLocale.firstWhere(
      (locale) => locale.toString() == selectedCode ||
        locale.languageCode == selectedCode ||
        '${locale.languageCode}_${locale.countryCode}' == selectedCode,
      orElse: () => supportedLocale.first,
    );
    String localeFile = selectedLocale.countryCode != null && selectedLocale.countryCode!.isNotEmpty
      ? '${selectedLocale.languageCode}_${selectedLocale.countryCode}'
      : selectedLocale.languageCode;
    String jsonString =
        await rootBundle.loadString('assets/language/$localeFile.json');
    Map<String, dynamic> jsonLanguageMap = json.decode(jsonString);
    _localizedStrings = jsonLanguageMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  // called from every widget which needs a localized text
  String translate(String jsonkey) {
    return _localizedStrings?[jsonkey] ?? jsonkey;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<ApplicationLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return supportedLocale.any((supported) =>
      supported.languageCode == locale.languageCode &&
      (supported.countryCode == null || supported.countryCode == locale.countryCode)
    );
  }

  @override
  Future<ApplicationLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    ApplicationLocalizations localizations = ApplicationLocalizations._init( locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension StringExtend on String {
 String localized() {
    return ApplicationLocalizations.instance?.translate(this) ?? this;
  }
}
