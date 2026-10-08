import 'dart:convert';

import 'package:bagisto_flutter/core/locale/locale_resolution.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('preferences refresh the channel locales and currencies', () async {
    SharedPreferences.setMockInitialValues({
      'cached_shop_locales': jsonEncode([
        {'code': 'en', 'name': 'English'},
      ]),
    });

    final cubit = PreferencesCubit(
      refreshChannel: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'cached_shop_locales',
          jsonEncode([
            {'code': 'en', 'name': 'English'},
            {'code': 'fr', 'name': 'French'},
          ]),
        );
        await prefs.setString(
          'cached_shop_currencies',
          jsonEncode([
            {'code': 'USD', 'name': 'US Dollar', 'symbol': r'$'},
            {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
          ]),
        );
      },
    );
    addTearDown(cubit.close);

    final state = await cubit.stream.firstWhere(
      (s) => s.locales.length == 2 && s.currencies.length == 2,
    );
    expect(state.locales.map((l) => l.code), ['en', 'fr']);
    expect(state.currencies.map((c) => c.code), ['USD', 'EUR']);
  });

  test('channel locale codes resolve to a supported UI locale', () {
    const supported = [Locale('ar'), Locale('en'), Locale('fr')];

    expect(resolveAppLocale(const Locale('AR'), supported), const Locale('ar'));
    expect(resolveAppLocale(const Locale('fr'), supported), const Locale('fr'));
    // Channel locales without app translations fall back to English, not
    // to the first supported locale (Arabic, right-to-left).
    expect(resolveAppLocale(const Locale('hi'), supported), const Locale('en'));
    expect(
      resolveAppLocale(const Locale('pt_BR'), supported),
      const Locale('en'),
    );
    expect(resolveAppLocale(null, supported), isNull);
  });
}
