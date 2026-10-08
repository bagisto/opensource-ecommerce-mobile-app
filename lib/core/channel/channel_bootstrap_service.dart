import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/account/data/models/account_models.dart';
import '../../l10n/app_localizations.dart';
import '../constants/api_constants.dart';
import '../currency/currency_cubit.dart';
import '../currency/currency_formatter.dart';
import '../graphql/queries.dart';
import '../locale/locale_cubit.dart';

class ChannelBootstrapService {
  static const String _localesCacheKey = 'cached_shop_locales';
  static const String _currenciesCacheKey = 'cached_shop_currencies';

  /// Channel logo URL set in admin; absent when the channel has none.
  static const String logoUrlCacheKey = 'cached_channel_logo_url';

  final GraphQLClient client;
  final SharedPreferences prefs;

  const ChannelBootstrapService({required this.client, required this.prefs});

  Future<void> bootstrap() async {
    debugPrint('🟡 ChannelBootstrapService.bootstrap started');

    final result = await client.query(
      QueryOptions(
        document: gql(StoreConfigQueries.getChannelById),
        variables: {'id': channelId.toString()},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      debugPrint(
        '🔴 ChannelBootstrapService bootstrap failed: ${result.exception}',
      );
      throw result.exception!;
    }

    final channel = result.data?['channel'] as Map<String, dynamic>?;
    if (channel == null) {
      debugPrint(
        '🔴 ChannelBootstrapService bootstrap failed: no channel data',
      );
      return;
    }

    final locales = _parseLocales(channel);
    final currencies = _parseCurrencies(channel);
    final defaultLocaleCode = _resolveDefaultLocaleCode(channel, locales);
    final defaultCurrencyCode = _resolveDefaultCurrencyCode(
      channel,
      currencies,
    );

    await prefs.setString(
      _localesCacheKey,
      jsonEncode(_encodeLocales(locales)),
    );
    await prefs.setString(
      _currenciesCacheKey,
      jsonEncode(_encodeCurrencies(currencies)),
    );

    final logoUrl = channel['logoUrl']?.toString().trim() ?? '';
    if (logoUrl.isEmpty) {
      await prefs.remove(logoUrlCacheKey);
    } else {
      await prefs.setString(logoUrlCacheKey, logoUrl);
    }

    // Only set defaults when the user has not already selected a preference.
    final savedLocale = prefs.getString(LocaleCubit.localeKey);
    if (savedLocale == null &&
        defaultLocaleCode != null &&
        defaultLocaleCode.isNotEmpty) {
      await prefs.setString(LocaleCubit.localeKey, defaultLocaleCode);
    }

    final savedCurrency = prefs.getString(CurrencyCubit.currencyKey);
    if (savedCurrency == null &&
        defaultCurrencyCode != null &&
        defaultCurrencyCode.isNotEmpty) {
      await CurrencyFormatter.updateSelectedCurrency(
        defaultCurrencyCode,
        prefs: prefs,
      );
    }

    await CurrencyFormatter.syncCurrencySymbols({
      for (final currency in currencies)
        currency.code.toUpperCase(): currency.symbol,
    }, prefs: prefs);

    debugPrint(
      '🟢 ChannelBootstrapService bootstrap complete: '
      '${locales.length} locales, ${currencies.length} currencies, '
      'defaultLocale=$defaultLocaleCode, defaultCurrency=$defaultCurrencyCode',
    );
  }

  List<ShopLocale> _parseLocales(Map<String, dynamic> channel) {
    final edges = channel['locales']?['edges'] as List<dynamic>? ?? const [];
    return edges
        .map((edge) => edge['node'])
        .whereType<Map<String, dynamic>>()
        .map(ShopLocale.fromJson)
        .toList();
  }

  List<ShopCurrency> _parseCurrencies(Map<String, dynamic> channel) {
    final edges = channel['currencies']?['edges'] as List<dynamic>? ?? const [];
    return edges
        .map((edge) => edge['node'])
        .whereType<Map<String, dynamic>>()
        .map(ShopCurrency.fromJson)
        .toList();
  }

  String? _resolveDefaultLocaleCode(
    Map<String, dynamic> channel,
    List<ShopLocale> locales,
  ) {
    final rawDefault =
        (channel['defaultLocale'] as Map<String, dynamic>?)?['code']
            ?.toString()
            .trim();
    final supportedCodes = AppLocalizations.supportedLocales
        .map((locale) => locale.languageCode.toLowerCase())
        .toSet();

    if (rawDefault != null &&
        supportedCodes.contains(rawDefault.toLowerCase())) {
      return rawDefault;
    }

    for (final locale in locales) {
      if (supportedCodes.contains(locale.code.toLowerCase())) {
        return locale.code;
      }
    }

    return prefs.getString(LocaleCubit.localeKey);
  }

  String? _resolveDefaultCurrencyCode(
    Map<String, dynamic> channel,
    List<ShopCurrency> currencies,
  ) {
    final rawDefault =
        (channel['baseCurrency'] as Map<String, dynamic>?)?['code']
            ?.toString()
            .trim();

    if (rawDefault != null &&
        currencies.any(
          (currency) => currency.code.toUpperCase() == rawDefault.toUpperCase(),
        )) {
      return rawDefault;
    }

    if (currencies.isNotEmpty) {
      return currencies.first.code;
    }

    return prefs.getString(CurrencyCubit.currencyKey);
  }

  List<Map<String, dynamic>> _encodeLocales(List<ShopLocale> locales) {
    return locales.map((locale) => locale.toJson()).toList();
  }

  List<Map<String, dynamic>> _encodeCurrencies(List<ShopCurrency> currencies) {
    return currencies.map((currency) => currency.toJson()).toList();
  }
}
