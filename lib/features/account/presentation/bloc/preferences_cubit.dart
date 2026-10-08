import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/currency/currency_formatter.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/graphql/account_queries.dart';
import '../../data/models/account_models.dart';

void _logPreferencesMessage(String message) {
  // ignore: avoid_print
  print(message);
}

/// State for the Preferences bottom sheet.
/// Manages language, currency selections, and CMS pages.
///
/// Figma node-id: 215-5028 (pop-over-preferences)
class PreferencesState extends Equatable {
  final List<ShopLocale> locales;
  final List<ShopCurrency> currencies;
  final String? selectedLocaleCode;
  final String? selectedCurrency;
  final bool isLoadingLocales;
  final bool isLoadingCurrencies;
  final List<CmsPage> cmsPages;
  final bool isLoadingCmsPages;
  final String? errorMessage;

  const PreferencesState({
    this.locales = const [],
    this.currencies = const [],
    this.selectedLocaleCode,
    this.selectedCurrency,
    this.isLoadingLocales = false,
    this.isLoadingCurrencies = false,
    this.cmsPages = const [],
    this.isLoadingCmsPages = false,
    this.errorMessage,
  });

  PreferencesState copyWith({
    List<ShopLocale>? locales,
    List<ShopCurrency>? currencies,
    String? selectedLocaleCode,
    String? selectedCurrency,
    bool? isLoadingLocales,
    bool? isLoadingCurrencies,
    List<CmsPage>? cmsPages,
    bool? isLoadingCmsPages,
    String? errorMessage,
  }) {
    return PreferencesState(
      locales: locales ?? this.locales,
      currencies: currencies ?? this.currencies,
      selectedLocaleCode: selectedLocaleCode ?? this.selectedLocaleCode,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isLoadingLocales: isLoadingLocales ?? this.isLoadingLocales,
      isLoadingCurrencies: isLoadingCurrencies ?? this.isLoadingCurrencies,
      cmsPages: cmsPages ?? this.cmsPages,
      isLoadingCmsPages: isLoadingCmsPages ?? this.isLoadingCmsPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    locales,
    currencies,
    selectedLocaleCode,
    selectedCurrency,
    isLoadingLocales,
    isLoadingCurrencies,
    cmsPages,
    isLoadingCmsPages,
    errorMessage,
  ];
}

/// Cubit to manage Preferences page state.
class PreferencesCubit extends Cubit<PreferencesState> {
  static const String _localesCacheKey = 'cached_shop_locales';
  static const String _currenciesCacheKey = 'cached_shop_currencies';

  /// Re-reads the channel's locales and currencies from the API into the
  /// cache (see `ChannelBootstrapService`), so languages or currencies the
  /// admin assigned after app start show up.
  final Future<void> Function()? refreshChannel;

  PreferencesCubit({this.refreshChannel}) : super(const PreferencesState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([_initializeLocales(), _initializeCurrencies()]);
    final refresh = refreshChannel;
    if (refresh == null) return;
    try {
      await refresh();
    } catch (e) {
      _logPreferencesMessage('🔴 PreferencesCubit channel refresh failed: $e');
      return;
    }
    if (isClosed) return;
    await Future.wait([_initializeLocales(), _initializeCurrencies()]);
  }

  Future<void> _initializeLocales() async {
    _logPreferencesMessage('🟡 PreferencesCubit._initializeLocales started');
    final cachedLocales = await _loadCachedLocales();
    if (isClosed) return;
    _logPreferencesMessage(
      '🟡 PreferencesCubit cache count: ${cachedLocales.length}',
    );
    final cachedSelectedCode = _resolveSelectedLocaleCode(
      cachedLocales,
      state.selectedLocaleCode,
    );

    if (cachedLocales.isNotEmpty) {
      emit(
        state.copyWith(
          locales: cachedLocales,
          selectedLocaleCode: cachedSelectedCode,
          isLoadingLocales: false,
          errorMessage: null,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingLocales: false, errorMessage: null));
    }
  }

  Future<void> _initializeCurrencies() async {
    final cachedCurrencies = await _loadCachedCurrencies();
    if (isClosed) return;
    if (cachedCurrencies.isNotEmpty) {
      await CurrencyFormatter.syncCurrencySymbols({
        for (final currency in cachedCurrencies) currency.code: currency.symbol,
      });
    }
    if (isClosed) return;
    final cachedSelectedCode = _resolveSelectedCurrencyCode(
      cachedCurrencies,
      state.selectedCurrency,
    );

    if (cachedCurrencies.isNotEmpty) {
      emit(
        state.copyWith(
          currencies: cachedCurrencies,
          selectedCurrency: cachedSelectedCode,
          isLoadingCurrencies: false,
          errorMessage: null,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingCurrencies: false, errorMessage: null));
    }
  }

  String? _resolveSelectedLocaleCode(
    List<ShopLocale> locales,
    String? currentSelection,
  ) {
    if (currentSelection != null &&
        locales.any((locale) => locale.code == currentSelection)) {
      return currentSelection;
    }

    return locales.isNotEmpty ? locales.first.code : null;
  }

  String? _resolveSelectedCurrencyCode(
    List<ShopCurrency> currencies,
    String? currentSelection,
  ) {
    if (currentSelection != null &&
        currencies.any((currency) => currency.code == currentSelection)) {
      return currentSelection;
    }

    return currencies.isNotEmpty ? currencies.first.code : null;
  }

  Future<List<ShopLocale>> _loadCachedLocales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_localesCacheKey);
      if (cachedJson == null || cachedJson.isEmpty) {
        return const [];
      }

      final decoded = jsonDecode(cachedJson);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ShopLocale.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<ShopCurrency>> _loadCachedCurrencies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_currenciesCacheKey);
      if (cachedJson == null || cachedJson.isEmpty) {
        return const [];
      }

      final decoded = jsonDecode(cachedJson);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ShopCurrency.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Load CMS pages from the API
  Future<void> loadCmsPages() async {
    emit(state.copyWith(isLoadingCmsPages: true, errorMessage: null));
    try {
      final result = await GraphQLClientProvider.client.value.query(
        QueryOptions(
          document: gql(AccountQueries.getCmsPages),
          errorPolicy: ErrorPolicy.all,
        ),
      );

      if (result.hasException) {
        emit(
          state.copyWith(
            isLoadingCmsPages: false,
            errorMessage: ErrorMapper.fromQueryResult(
              result,
              context: 'loading pages',
            ),
          ),
        );
        return;
      }

      final data = result.data?['pages'] as Map<String, dynamic>?;
      final edges = data?['edges'] as List<dynamic>? ?? [];

      final pages = edges.map((edge) {
        final node = edge['node'] as Map<String, dynamic>;
        return CmsPage.fromJson(node);
      }).toList();

      emit(state.copyWith(cmsPages: pages, isLoadingCmsPages: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingCmsPages: false,
          errorMessage: ErrorMapper.getUserMessage(e, context: 'loading pages'),
        ),
      );
    }
  }

  /// Update selected language/locale
  void updateSelectedLocale(String localeCode) {
    emit(state.copyWith(selectedLocaleCode: localeCode));
  }

  /// Update selected currency
  void updateSelectedCurrency(String currency) {
    emit(state.copyWith(selectedCurrency: currency));
  }

  /// Reload locales (pull-to-refresh or retry)
  Future<void> reloadLocales() async {
    await _initializeLocales();
  }

  Future<void> reloadCurrencies() async {
    await _initializeCurrencies();
  }

  /// Reload CMS pages
  Future<void> reloadCmsPages() async {
    await loadCmsPages();
  }
}
