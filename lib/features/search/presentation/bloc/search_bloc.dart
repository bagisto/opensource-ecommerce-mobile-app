import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../category/data/models/product_model.dart';
import '../../../category/data/models/category_model.dart';
import '../../../category/data/repository/category_repository.dart';

// ─── Events ────────────────────────────────────────────────────────────────

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

/// Initialize search page (load recent searches + top categories)
class InitSearch extends SearchEvent {}

/// User typed a search query
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

/// User submitted search
class SubmitSearch extends SearchEvent {
  final String query;
  const SubmitSearch(this.query);
  @override
  List<Object?> get props => [query];
}

/// Clear search results (go back to initial state)
class ClearSearch extends SearchEvent {}

/// Remove a recent search
class RemoveRecentSearch extends SearchEvent {
  final String query;
  const RemoveRecentSearch(this.query);
  @override
  List<Object?> get props => [query];
}

/// Clear all recent searches
class ClearAllRecentSearches extends SearchEvent {}

// ─── State ─────────────────────────────────────────────────────────────────

enum SearchStatus { initial, searching, results, empty, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final String query;
  final List<ProductModel> searchResults;
  final List<String> recentSearches;
  final List<CategoryModel> topCategories;
  final String? errorMessage;
  final bool hasMore;
  final int totalCount;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.searchResults = const [],
    this.recentSearches = const [],
    this.topCategories = const [],
    this.errorMessage,
    this.hasMore = false,
    this.totalCount = 0,
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<ProductModel>? searchResults,
    List<String>? recentSearches,
    List<CategoryModel>? topCategories,
    String? errorMessage,
    bool? hasMore,
    int? totalCount,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      searchResults: searchResults ?? this.searchResults,
      recentSearches: recentSearches ?? this.recentSearches,
      topCategories: topCategories ?? this.topCategories,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        searchResults,
        recentSearches,
        topCategories,
        errorMessage,
        hasMore,
        totalCount,
      ];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CategoryRepository repository;
  static const _recentSearchesKey = 'recent_searches';
  static const _maxRecentSearches = 10;

  SearchBloc({required this.repository}) : super(const SearchState()) {
    on<InitSearch>(_onInitSearch);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SubmitSearch>(_onSubmitSearch);
    on<ClearSearch>(_onClearSearch);
    on<RemoveRecentSearch>(_onRemoveRecentSearch);
    on<ClearAllRecentSearches>(_onClearAllRecentSearches);
  }

  Future<List<String>> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_recentSearchesKey) ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveRecentSearches(List<String> searches) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_recentSearchesKey, searches);
    } catch (e) {
      debugPrint('Failed to save recent searches: $e');
    }
  }

  Future<void> _addToRecentSearches(String query) async {
    if (query.trim().isEmpty) return;
    final trimmed = query.trim();
    final recent = List<String>.from(state.recentSearches);
    recent.remove(trimmed); // remove if exists
    recent.insert(0, trimmed); // add to front
    if (recent.length > _maxRecentSearches) {
      recent.removeRange(_maxRecentSearches, recent.length);
    }
    await _saveRecentSearches(recent);
  }

  Future<void> _onInitSearch(
      InitSearch event, Emitter<SearchState> emit) async {
    // Load recent searches
    final recentSearches = await _loadRecentSearches();

    // Load top categories
    List<CategoryModel> categories = [];
    try {
      categories = await repository.getHomeCategories();
      // Take first 5 categories
      if (categories.length > 5) {
        categories = categories.sublist(0, 5);
      }
    } catch (_) {
      // Silently ignore category fetch errors
    }

    emit(state.copyWith(
      status: SearchStatus.initial,
      recentSearches: recentSearches,
      topCategories: categories,
    ));
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(state.copyWith(
        status: SearchStatus.initial,
        query: '',
        searchResults: [],
      ));
      return;
    }

    emit(state.copyWith(status: SearchStatus.searching, query: query));

    try {
      final result = await repository.getProducts(
        query: query,
        first: 20,
      );

      if (result.products.isEmpty) {
        emit(state.copyWith(
          status: SearchStatus.empty,
          searchResults: [],
          totalCount: 0,
          hasMore: false,
        ));
      } else {
        emit(state.copyWith(
          status: SearchStatus.results,
          searchResults: result.products,
          totalCount: result.totalCount,
          hasMore: result.pageInfo.hasNextPage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitSearch(
    SubmitSearch event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) return;

    // Save to recent searches
    await _addToRecentSearches(query);

    // Update recent searches in state
    final recentSearches = await _loadRecentSearches();

    emit(state.copyWith(
      status: SearchStatus.searching,
      query: query,
      recentSearches: recentSearches,
    ));

    try {
      final result = await repository.getProducts(
        query: query,
        first: 20,
      );

      if (result.products.isEmpty) {
        emit(state.copyWith(
          status: SearchStatus.empty,
          searchResults: [],
          totalCount: 0,
          hasMore: false,
        ));
      } else {
        emit(state.copyWith(
          status: SearchStatus.results,
          searchResults: result.products,
          totalCount: result.totalCount,
          hasMore: result.pageInfo.hasNextPage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      status: SearchStatus.initial,
      query: '',
      searchResults: [],
    ));
  }

  Future<void> _onRemoveRecentSearch(
    RemoveRecentSearch event,
    Emitter<SearchState> emit,
  ) async {
    final recent = List<String>.from(state.recentSearches)..remove(event.query);
    await _saveRecentSearches(recent);
    emit(state.copyWith(recentSearches: recent));
  }

  Future<void> _onClearAllRecentSearches(
    ClearAllRecentSearches event,
    Emitter<SearchState> emit,
  ) async {
    await _saveRecentSearches([]);
    emit(state.copyWith(recentSearches: []));
  }
}
