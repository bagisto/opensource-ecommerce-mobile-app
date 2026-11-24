import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CurrencyFormatter {
  static const _currencyKey = 'app_currency_code';
  static const _currencySymbolsKey = 'app_currency_symbols';

  static final Map<String, String> _defaultSymbols = {
    'USD': r'$',
    'INR': '₹',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CNY': '¥',
    'AED': 'د.إ',
    'SAR': '﷼',
    'CAD': r'C$',
    'AUD': r'A$',
  };

  static String? _currentCode;
  static Map<String, String> _symbolsByCode = {..._defaultSymbols};

  static void initialize(SharedPreferences prefs) {
    _currentCode = prefs.getString(_currencyKey);
    final rawSymbols = prefs.getString(_currencySymbolsKey);
    if (rawSymbols == null || rawSymbols.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(rawSymbols);
      if (decoded is! Map) return;

      _symbolsByCode = {
        ..._defaultSymbols,
        for (final entry in decoded.entries)
          entry.key.toString().toUpperCase(): entry.value.toString(),
      };
    } catch (_) {
      _symbolsByCode = {..._defaultSymbols};
    }
  }

  static Future<void> updateSelectedCurrency(
    String? currencyCode, {
    SharedPreferences? prefs,
  }) async {
    _currentCode = currencyCode?.toUpperCase();
    final resolvedPrefs = prefs ?? await SharedPreferences.getInstance();
    if (currencyCode == null || currencyCode.isEmpty) {
      await resolvedPrefs.remove(_currencyKey);
      return;
    }
    await resolvedPrefs.setString(_currencyKey, currencyCode);
  }

  static Future<void> syncCurrencySymbols(
    Map<String, String> symbolsByCode, {
    SharedPreferences? prefs,
  }) async {
    final normalized = <String, String>{
      ..._defaultSymbols,
      for (final entry in symbolsByCode.entries)
        entry.key.toUpperCase(): entry.value,
    };
    _symbolsByCode = normalized;

    final resolvedPrefs = prefs ?? await SharedPreferences.getInstance();
    await resolvedPrefs.setString(_currencySymbolsKey, jsonEncode(normalized));
  }

  static String symbolFor([String? currencyCode]) {
    final resolvedCode = (currencyCode ?? _currentCode)?.toUpperCase();
    if (resolvedCode == null || resolvedCode.isEmpty) {
      return _defaultSymbols['USD']!;
    }

    final symbol = _symbolsByCode[resolvedCode];
    if (symbol != null && symbol.isNotEmpty) {
      return symbol;
    }

    return '$resolvedCode ';
  }

  static String formatAmount(
    num? amount, {
    String? currencyCode,
    String? currencySymbol,
    int fractionDigits = 2,
  }) {
    final value = (amount ?? 0).toDouble();
    final configuredSymbol = currencySymbol?.trim();
    final symbol = configuredSymbol == null || configuredSymbol.isEmpty
        ? symbolFor(currencyCode)
        : configuredSymbol;
    return '$symbol${value.toStringAsFixed(fractionDigits)}';
  }
}
