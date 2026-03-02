import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/graphql/account_queries.dart';
import '../../data/models/account_models.dart';

/// Model for a locale/language option
class LocaleOption extends Equatable {
  final String id;
  final String code;
  final String name;
  final String direction;

  const LocaleOption({
    required this.id,
    required this.code,
    required this.name,
    required this.direction,
  });

  @override
  List<Object?> get props => [id, code, name, direction];
}

/// State for the Preferences bottom sheet.
/// Manages language, currency selections, and CMS pages.
///
/// Figma node-id: 215-5028 (pop-over-preferences)
class PreferencesState extends Equatable {
  final List<LocaleOption> locales;
  final String? selectedLocaleCode;
  final String? selectedCurrency;
  final bool isLoadingLocales;
  final List<CmsPage> cmsPages;
  final bool isLoadingCmsPages;
  final String? errorMessage;

  const PreferencesState({
    this.locales = const [],
    this.selectedLocaleCode,
    this.selectedCurrency,
    this.isLoadingLocales = false,
    this.cmsPages = const [],
    this.isLoadingCmsPages = false,
    this.errorMessage,
  });

  PreferencesState copyWith({
    List<LocaleOption>? locales,
    String? selectedLocaleCode,
    String? selectedCurrency,
    bool? isLoadingLocales,
    List<CmsPage>? cmsPages,
    bool? isLoadingCmsPages,
    String? errorMessage,
  }) {
    return PreferencesState(
      locales: locales ?? this.locales,
      selectedLocaleCode: selectedLocaleCode ?? this.selectedLocaleCode,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isLoadingLocales: isLoadingLocales ?? this.isLoadingLocales,
      cmsPages: cmsPages ?? this.cmsPages,
      isLoadingCmsPages: isLoadingCmsPages ?? this.isLoadingCmsPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    locales,
    selectedLocaleCode,
    selectedCurrency,
    isLoadingLocales,
    cmsPages,
    isLoadingCmsPages,
    errorMessage,
  ];
}

/// Cubit to manage Preferences page state.
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit() : super(const PreferencesState()) {
    _initializeLocales();
  }

  /// Load available locales from the API
  Future<void> _initializeLocales() async {
    emit(state.copyWith(isLoadingLocales: true, errorMessage: null));
    try {
      final client = GraphQLClientProvider.client.value;
      
      final result = await client.query(
        QueryOptions(
          document: gql(AccountQueries.getLocales),
          errorPolicy: ErrorPolicy.all,
        ),
      );

      if (result.hasException) {
        emit(state.copyWith(
          isLoadingLocales: false,
          errorMessage: result.exception.toString(),
        ));
        return;
      }

      final data = result.data?['locales'] as Map<String, dynamic>?;
      final edges = data?['edges'] as List<dynamic>? ?? [];
      
      final locales = edges.map((edge) {
        final node = edge['node'] as Map<String, dynamic>;
        return LocaleOption(
          id: node['id']?.toString() ?? '',
          code: node['code']?.toString() ?? '',
          name: node['name']?.toString() ?? '',
          direction: node['direction']?.toString() ?? 'ltr',
        );
      }).toList();

      emit(state.copyWith(
        locales: locales,
        isLoadingLocales: false,
        selectedLocaleCode: locales.isNotEmpty ? locales.first.code : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingLocales: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Load CMS pages from the API
  Future<void> loadCmsPages() async {
    emit(state.copyWith(isLoadingCmsPages: true, errorMessage: null));
    try {
      final client = GraphQLClientProvider.client.value;
      
      final result = await client.query(
        QueryOptions(
          document: gql(AccountQueries.getCmsPages),
          errorPolicy: ErrorPolicy.all,
        ),
      );

      if (result.hasException) {
        emit(state.copyWith(
          isLoadingCmsPages: false,
          errorMessage: result.exception.toString(),
        ));
        return;
      }

      final data = result.data?['pages'] as Map<String, dynamic>?;
      final edges = data?['edges'] as List<dynamic>? ?? [];
      
      final pages = edges.map((edge) {
        final node = edge['node'] as Map<String, dynamic>;
        return CmsPage.fromJson(node);
      }).toList();

      emit(state.copyWith(
        cmsPages: pages,
        isLoadingCmsPages: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingCmsPages: false,
        errorMessage: e.toString(),
      ));
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

  /// Reload CMS pages
  Future<void> reloadCmsPages() async {
    await loadCmsPages();  }
}