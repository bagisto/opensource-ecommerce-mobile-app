import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/home_models.dart';
import '../../data/repository/home_repository.dart';

// ──────────────────── EVENTS ────────────────────

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

/// Load the full homepage: theme customizations → categories → products.
class LoadHome extends HomeEvent {
  const LoadHome();
}

/// Pull-to-refresh.
class RefreshHome extends HomeEvent {
  const RefreshHome();
}

// ──────────────────── STATE ────────────────────

enum HomeStatus { initial, loading, loaded, refreshing, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ThemeCustomization> customizations;
  final List<HomeCategory> categories;

  /// Keyed by customization `id` → products for that section.
  final Map<String, List<HomeProduct>> productSections;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.customizations = const [],
    this.categories = const [],
    this.productSections = const {},
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ThemeCustomization>? customizations,
    List<HomeCategory>? categories,
    Map<String, List<HomeProduct>>? productSections,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      customizations: customizations ?? this.customizations,
      categories: categories ?? this.categories,
      productSections: productSections ?? this.productSections,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    customizations,
    categories,
    productSections,
    errorMessage,
  ];
}

// ──────────────────── BLOC ────────────────────

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc({required HomeRepository repository})
    : _repository = repository,
      super(const HomeState()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    // Only show full-screen loader when there is no data yet.
    if (state.customizations.isEmpty) {
      emit(state.copyWith(status: HomeStatus.loading));
    }
    await _load(emit);
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    // Emit refreshing state to indicate refresh is in progress
    emit(state.copyWith(status: HomeStatus.refreshing));
    await _load(emit);
  }

  Future<void> _load(Emitter<HomeState> emit) async {
    const maxAttempts = 3;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await _doLoad(emit);
      } catch (e) {
        final isNetworkError = e.toString().contains('Network') ||
            e.toString().contains('TimeoutException') ||
            e.toString().contains('No stream event') ||
            e.toString().contains('SocketException') ||
            e.toString().contains('linkException');
        if (isNetworkError && attempt < maxAttempts) {
          debugPrint('[HomeBloc] network error (attempt $attempt/$maxAttempts, retrying): $e');
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
        // Final failure — show error
        if (state.customizations.isNotEmpty) {
          emit(state.copyWith(status: HomeStatus.loaded, errorMessage: e.toString()));
        } else {
          emit(state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
        }
        return; // Return after emitting state
      }
    }
    // If we exit the loop without returning, emit loaded state with existing data
    if (state.customizations.isNotEmpty) {
      emit(state.copyWith(status: HomeStatus.loaded));
    }
  }

  Future<void> _doLoad(Emitter<HomeState> emit) async {
    // 1) Fetch theme customizations + categories in parallel
    final results = await Future.wait([
      _repository.fetchThemeCustomizations(),
      _repository.fetchHomeCategories(),
    ]);

    final customizations = results[0] as List<ThemeCustomization>;
    final categories = results[1] as List<HomeCategory>;

      // 2) Fetch all product_carousel sections in parallel
      final productCarousels = customizations
          .where((tc) => tc.type == 'product_carousel')
          .toList();

      final productResults = await Future.wait(
        productCarousels.map((tc) async {
          try {
            final filters =
                tc.options['filters'] as Map<String, dynamic>? ?? {};
            final sort = filters['sort'] as String?;
            final limitRaw = filters['limit'];
            final limit = limitRaw != null
                ? int.tryParse(limitRaw.toString()) ?? 8
                : 8;

            // Build filter JSON excluding 'sort' and 'limit'
            final filterMap = <String, String>{};
            for (final entry in filters.entries) {
              if (entry.key == 'sort' || entry.key == 'limit') continue;
              if (entry.value != null) {
                filterMap[entry.key] = entry.value.toString();
              }
            }
            final filterJson = filterMap.isNotEmpty
                ? jsonEncode(filterMap)
                : null;

            String sortKey = 'NEWEST';
            bool reverse = true;
            if (sort == 'created_at-desc') {
              sortKey = 'NEWEST';
              reverse = true;
            } else if (sort == 'price-desc') {
              sortKey = 'PRICE';
              reverse = true;
            } else if (sort == 'price-asc') {
              sortKey = 'PRICE';
              reverse = false;
            } else if (sort == 'name-asc') {
              sortKey = 'TITLE';
              reverse = false;
            } else if (sort == 'name-desc') {
              sortKey = 'TITLE';
              reverse = true;
            }

            return MapEntry(
              tc.id,
              await _repository.fetchProducts(
                first: limit,
                filter: filterJson,
                sortKey: sortKey,
                reverse: reverse,
              ),
            );
          } catch (e) {
            // If one section fails, skip it — don't crash the whole homepage
            return MapEntry(tc.id, <HomeProduct>[]);
          }
        }),
      );

      final Map<String, List<HomeProduct>> productSections = Map.fromEntries(
        productResults,
      );

    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        customizations: customizations,
        categories: categories,
        productSections: productSections,
        errorMessage: null,
      ),
    );
  }
}
