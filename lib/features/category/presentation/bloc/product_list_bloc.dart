import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/filter_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repository/category_repository.dart';

// ─── Events ────────────────────────────────────────────────────────────────

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

/// Load products for a category with optional filters
class LoadProductList extends ProductListEvent {
  final int categoryId;
  final String categoryName;

  /// Category slug for fetching dynamic filters.
  /// If empty, falls back to generic filters.
  final String categorySlug;

  /// Optional base filter JSON from themeCustomization.
  /// e.g. '{"new":1}' or '{"featured":1}' or null.
  final String? initialFilter;

  const LoadProductList({
    required this.categoryId,
    required this.categoryName,
    this.categorySlug = '',
    this.initialFilter,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, categorySlug, initialFilter];
}

/// Apply a sort option
class ApplySort extends ProductListEvent {
  final SortOption sortOption;
  const ApplySort(this.sortOption);

  @override
  List<Object?> get props => [sortOption.key];
}

/// Toggle a filter option (select / deselect)
class ToggleFilter extends ProductListEvent {
  final String attributeCode; // e.g. "color", "size", "brand"
  final String optionId; // numeric id of the option

  const ToggleFilter({required this.attributeCode, required this.optionId});

  @override
  List<Object?> get props => [attributeCode, optionId];
}

/// Clear all filters for a specific attribute
class ClearAttributeFilters extends ProductListEvent {
  final String attributeCode;
  const ClearAttributeFilters(this.attributeCode);

  @override
  List<Object?> get props => [attributeCode];
}

/// Clear all active filters
class ClearAllFilters extends ProductListEvent {}

/// Apply filters and reload products
class ApplyFilters extends ProductListEvent {}

/// Update price range selection
class UpdatePriceRange extends ProductListEvent {
  final double min;
  final double max;
  const UpdatePriceRange({required this.min, required this.max});

  @override
  List<Object?> get props => [min, max];
}

/// Load more products (pagination)
class LoadMoreProductList extends ProductListEvent {}

// ─── State ─────────────────────────────────────────────────────────────────

enum ProductListStatus { initial, loading, refreshing, loaded, error }

/// Enum to track whether we're doing initial load or cache refresh
enum ProductListLoadType { initial, refresh }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final int categoryId;
  final String categoryName;
  final List<ProductModel> products;
  final PageInfo? pageInfo;
  final int totalProducts;
  final bool isLoadingMore;

  /// Base filter JSON from themeCustomization (e.g. '{"new":1}').
  /// This is preserved across sort/filter changes and merged with
  /// user-applied filters in [buildFilterString].
  final String? initialFilter;

  /// Category slug used for fetching dynamic filters
  final String categorySlug;

  /// Filter attributes fetched dynamically from categoryAttributeFilters API
  final List<FilterAttribute> filterAttributes;

  /// Currently active filters: { "color": ["6","7"], "size": ["9"] }
  final Map<String, Set<String>> activeFilters;

  /// Price range filter state
  final double? priceRangeMin;
  final double? priceRangeMax;
  final double? selectedPriceMin;
  final double? selectedPriceMax;

  /// Current sort option
  final SortOption currentSort;

  /// Whether filters are being loaded
  final bool isLoadingFilters;

  final String? errorMessage;

  /// Whether this is a cache-first load (subsequent visit with cached data)
  /// When true, UI should not show loader but still fetch from network
  final bool isCacheFirstLoad;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.categoryId = 0,
    this.categoryName = '',
    this.products = const [],
    this.pageInfo,
    this.totalProducts = 0,
    this.isLoadingMore = false,
    this.initialFilter,
    this.categorySlug = '',
    this.filterAttributes = const [],
    this.activeFilters = const {},
    this.priceRangeMin,
    this.priceRangeMax,
    this.selectedPriceMin,
    this.selectedPriceMax,
    this.currentSort = const SortOption(
      key: 'name-asc',
      title: 'From A-Z',
      sortKey: 'TITLE',
      reverse: false,
    ),
    this.isLoadingFilters = false,
    this.errorMessage,
    this.isCacheFirstLoad = false,
  });

  /// Total number of active filter values across all attributes
  int get totalActiveFilterCount {
    int count = 0;
    for (final values in activeFilters.values) {
      count += values.length;
    }
    // Count price filter if active
    if (selectedPriceMin != null || selectedPriceMax != null) count++;
    return count;
  }

  /// Number of active filter attributes (not individual values)
  int get activeFilterAttributeCount {
    return activeFilters.entries.where((e) => e.value.isNotEmpty).length;
  }

  /// Whether sort is not default
  bool get isSortActive => currentSort.key != 'name-asc';

  /// Whether a price filter is active
  bool get isPriceFilterActive =>
      selectedPriceMin != null || selectedPriceMax != null;

  /// Build the filter string for API call.
  ///
  /// Merges three filter sources in priority order:
  ///  1. [initialFilter] — base filter from themeCustomization (e.g. {"new":1})
  ///  2. [categoryId] — adds "category_id" if browsing a specific category
  ///  3. [activeFilters] — user-selected attribute filters (color, size, etc.)
  ///
  /// Result is a single-line JSON string, e.g.:
  ///   '{"new":1,"color":"6,7","size":"9"}'
  String buildFilterString() {
    final filterMap = <String, dynamic>{};

    // 1. Start with base filter from themeCustomization
    if (initialFilter != null && initialFilter!.isNotEmpty) {
      try {
        final base = json.decode(initialFilter!) as Map<String, dynamic>;
        filterMap.addAll(base);
      } catch (_) {
        // ignore malformed JSON
      }
    }

    // 2. Add category_id if browsing a specific category
    //    API expects string values: {"category_id": "22"}
    if (categoryId > 0) {
      filterMap['category_id'] = categoryId.toString();
    }

    // 3. Merge user-applied attribute filters
    for (final entry in activeFilters.entries) {
      if (entry.value.isNotEmpty) {
        filterMap[entry.key] = entry.value.join(',');
      }
    }

    // 4. Add price range filter if user has selected
    if (selectedPriceMin != null || selectedPriceMax != null) {
      final min = selectedPriceMin ?? priceRangeMin ?? 0;
      final max = selectedPriceMax ?? priceRangeMax ?? 99999;
      filterMap['price'] = '${min.toStringAsFixed(0)},${max.toStringAsFixed(0)}';
    }

    // 5. Ensure ALL values are strings (API requires string values)
    final stringMap = <String, String>{};
    for (final entry in filterMap.entries) {
      stringMap[entry.key] = entry.value.toString();
    }

    return json.encode(stringMap);
  }

  ProductListState copyWith({
    ProductListStatus? status,
    int? categoryId,
    String? categoryName,
    List<ProductModel>? products,
    PageInfo? pageInfo,
    int? totalProducts,
    bool? isLoadingMore,
    String? initialFilter,
    String? categorySlug,
    List<FilterAttribute>? filterAttributes,
    Map<String, Set<String>>? activeFilters,
    double? priceRangeMin,
    double? priceRangeMax,
    double? selectedPriceMin,
    double? selectedPriceMax,
    bool clearPriceSelection = false,
    SortOption? currentSort,
    bool? isLoadingFilters,
    String? errorMessage,
    bool? isCacheFirstLoad,
  }) {
    return ProductListState(
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      products: products ?? this.products,
      pageInfo: pageInfo ?? this.pageInfo,
      totalProducts: totalProducts ?? this.totalProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      initialFilter: initialFilter ?? this.initialFilter,
      categorySlug: categorySlug ?? this.categorySlug,
      filterAttributes: filterAttributes ?? this.filterAttributes,
      activeFilters: activeFilters ?? this.activeFilters,
      priceRangeMin: priceRangeMin ?? this.priceRangeMin,
      priceRangeMax: priceRangeMax ?? this.priceRangeMax,
      selectedPriceMin: clearPriceSelection ? null : (selectedPriceMin ?? this.selectedPriceMin),
      selectedPriceMax: clearPriceSelection ? null : (selectedPriceMax ?? this.selectedPriceMax),
      currentSort: currentSort ?? this.currentSort,
      isLoadingFilters: isLoadingFilters ?? this.isLoadingFilters,
      errorMessage: errorMessage ?? this.errorMessage,
      isCacheFirstLoad: isCacheFirstLoad ?? this.isCacheFirstLoad,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categoryId,
    categoryName,
    products,
    pageInfo,
    totalProducts,
    isLoadingMore,
    initialFilter,
    categorySlug,
    filterAttributes,
    activeFilters,
    priceRangeMin,
    priceRangeMax,
    selectedPriceMin,
    selectedPriceMax,
    currentSort,
    isLoadingFilters,
    errorMessage,
    isCacheFirstLoad,
  ];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final CategoryRepository repository;

  ProductListBloc({required this.repository})
    : super(const ProductListState()) {
    on<LoadProductList>(_onLoadProductList);
    on<ApplySort>(_onApplySort);
    on<ToggleFilter>(_onToggleFilter);
    on<ClearAttributeFilters>(_onClearAttributeFilters);
    on<ClearAllFilters>(_onClearAllFilters);
    on<ApplyFilters>(_onApplyFilters);
    on<UpdatePriceRange>(_onUpdatePriceRange);
    on<LoadMoreProductList>(_onLoadMore);
  }

  Future<void> _onLoadProductList(
    LoadProductList event,
    Emitter<ProductListState> emit,
  ) async {
    // Build filter string first to check for cached data
    final filterString = state.copyWith(
      categoryId: event.categoryId,
      categoryName: event.categoryName,
      categorySlug: event.categorySlug,
      initialFilter: event.initialFilter,
    ).buildFilterString();

    debugPrint(
      '[ProductListBloc] LoadProductList categoryId=${event.categoryId}, '
      'name=${event.categoryName}, slug="${event.categorySlug}"',
    );
    debugPrint('[ProductListBloc] filterString=$filterString');

    // STEP 1: Try to get cached data first (cache-first, no network)
    // This gives us instant loading from cache on subsequent visits
    try {
      final cachedResult = await repository.getFilterProducts(
        filter: filterString,
        first: 12,
        sortKey: state.currentSort.sortKey,
        reverse: state.currentSort.reverse,
        useCacheFirst: true, // Only check cache, no network
      );

      // Extract price range from cached filter attributes if available
      double? priceMin;
      double? priceMax;

      // If we have cached products, show them immediately without loader
      if (cachedResult.products.isNotEmpty) {
        debugPrint(
          '[ProductListBloc] Cache-first: showing ${cachedResult.products.length} cached products, '
          'will refresh from network in background',
        );

        // Emit cached data with 'refreshing' status (no loader shown)
        emit(state.copyWith(
          status: ProductListStatus.refreshing,
          categoryId: event.categoryId,
          categoryName: event.categoryName,
          categorySlug: event.categorySlug,
          initialFilter: event.initialFilter,
          products: cachedResult.products,
          pageInfo: cachedResult.pageInfo,
          totalProducts: cachedResult.totalCount,
          isLoadingFilters: false,
          isCacheFirstLoad: true,
        ));

        // STEP 2: Fetch fresh data from network in background
        await _refreshFromNetwork(event, emit, filterString);
      } else {
        // No cached data - show loader and fetch from network
        debugPrint('[ProductListBloc] No cached data - showing loader');
        emit(state.copyWith(
          status: ProductListStatus.loading,
          categoryId: event.categoryId,
          categoryName: event.categoryName,
          categorySlug: event.categorySlug,
          initialFilter: event.initialFilter,
          isCacheFirstLoad: false,
          isLoadingFilters: true,
        ));

        await _fetchFromNetwork(event, emit, filterString);
      }
    } catch (e) {
      // Cache lookup failed - treat as first load
      debugPrint('[ProductListBloc] Cache lookup failed: $e');
      emit(state.copyWith(
        status: ProductListStatus.loading,
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        categorySlug: event.categorySlug,
        initialFilter: event.initialFilter,
        isCacheFirstLoad: false,
        isLoadingFilters: true,
      ));

      await _fetchFromNetwork(event, emit, filterString);
    }
  }

  /// Fetch fresh data from network (for first load or after cache miss)
  Future<void> _fetchFromNetwork(
    LoadProductList event,
    Emitter<ProductListState> emit,
    String filterString,
  ) async {
    try {
      final futures = await Future.wait([
        repository
            .getCategoryAttributeFilters(categorySlug: event.categorySlug)
            .catchError((e) {
          debugPrint('[ProductListBloc] Filter fetch failed: $e');
          return <FilterAttribute>[];
        }),
        repository.getFilterProducts(
          filter: filterString,
          first: 12,
          sortKey: state.currentSort.sortKey,
          reverse: state.currentSort.reverse,
        ),
      ]);

      final filterAttributes = futures[0] as List<FilterAttribute>;
      final result = futures[1] as PaginatedProducts;

      // Extract price range
      double? priceMin;
      double? priceMax;
      for (final attr in filterAttributes) {
        if (attr.isPriceFilter) {
          priceMin = attr.minPrice;
          priceMax = attr.maxPrice;
          break;
        }
      }

      emit(state.copyWith(
        status: ProductListStatus.loaded,
        products: result.products,
        pageInfo: result.pageInfo,
        totalProducts: result.totalCount,
        filterAttributes: filterAttributes,
        priceRangeMin: priceMin,
        priceRangeMax: priceMax,
        isLoadingFilters: false,
        isCacheFirstLoad: false,
      ));
    } catch (e, stack) {
      debugPrint('[ProductListBloc] Network fetch failed: $e');
      debugPrint('$stack');

      // If we were in cache-first mode and network fails, keep showing cached data
      if (state.status == ProductListStatus.refreshing && state.products.isNotEmpty) {
        debugPrint('[ProductListBloc] Network failed, keeping cached products');
        emit(state.copyWith(
          status: ProductListStatus.loaded,
          isLoadingFilters: false,
          isCacheFirstLoad: false,
        ));
      } else {
        emit(state.copyWith(
          status: ProductListStatus.error,
          errorMessage: e.toString(),
          isLoadingFilters: false,
          isCacheFirstLoad: false,
        ));
      }
    }
  }

  /// Refresh data from network in background (after showing cached data)
  Future<void> _refreshFromNetwork(
    LoadProductList event,
    Emitter<ProductListState> emit,
    String filterString,
  ) async {
    try {
      // Fetch filter attributes and products in parallel
      final futures = await Future.wait([
        repository
            .getCategoryAttributeFilters(categorySlug: event.categorySlug)
            .catchError((e) {
          debugPrint('[ProductListBloc] Background filter fetch failed: $e');
          return <FilterAttribute>[];
        }),
        repository.getFilterProducts(
          filter: filterString,
          first: 12,
          sortKey: state.currentSort.sortKey,
          reverse: state.currentSort.reverse,
          useCacheFirst: false, // Force network fetch
        ),
      ]);

      final filterAttributes = futures[0] as List<FilterAttribute>;
      final result = futures[1] as PaginatedProducts;

      debugPrint(
        '[ProductListBloc] Background refresh got ${result.products.length} products',
      );

      // Extract price range
      double? priceMin;
      double? priceMax;
      for (final attr in filterAttributes) {
        if (attr.isPriceFilter) {
          priceMin = attr.minPrice;
          priceMax = attr.maxPrice;
          break;
        }
      }

      // Only update if we got valid data from network
      if (result.products.isNotEmpty) {
        emit(state.copyWith(
          status: ProductListStatus.loaded,
          products: result.products,
          pageInfo: result.pageInfo,
          totalProducts: result.totalCount,
          filterAttributes: filterAttributes,
          priceRangeMin: priceMin,
          priceRangeMax: priceMax,
          isLoadingFilters: false,
          isCacheFirstLoad: false,
        ));
      } else {
        // Network returned empty, keep cached data
        emit(state.copyWith(
          status: ProductListStatus.loaded,
          filterAttributes: filterAttributes,
          priceRangeMin: priceMin,
          priceRangeMax: priceMax,
          isLoadingFilters: false,
          isCacheFirstLoad: false,
        ));
      }
    } catch (e, stack) {
      debugPrint('[ProductListBloc] Background refresh failed: $e');
      debugPrint('$stack');
      // Keep showing cached data on background refresh failure
      emit(state.copyWith(
        status: ProductListStatus.loaded,
        isLoadingFilters: false,
        isCacheFirstLoad: false,
      ));
    }
  }

  Future<void> _onApplySort(
    ApplySort event,
    Emitter<ProductListState> emit,
  ) async {
    if (event.sortOption.key == state.currentSort.key) return;

    emit(
      state.copyWith(
        currentSort: event.sortOption,
        status: ProductListStatus.loading,
      ),
    );

    await _reloadProducts(emit);
  }

  void _onToggleFilter(ToggleFilter event, Emitter<ProductListState> emit) {
    final newFilters = Map<String, Set<String>>.from(
      state.activeFilters.map(
        (key, value) => MapEntry(key, Set<String>.from(value)),
      ),
    );

    final currentSet = newFilters[event.attributeCode] ?? <String>{};

    if (currentSet.contains(event.optionId)) {
      currentSet.remove(event.optionId);
    } else {
      currentSet.add(event.optionId);
    }

    if (currentSet.isEmpty) {
      newFilters.remove(event.attributeCode);
    } else {
      newFilters[event.attributeCode] = currentSet;
    }

    emit(state.copyWith(activeFilters: newFilters));
  }

  void _onClearAttributeFilters(
    ClearAttributeFilters event,
    Emitter<ProductListState> emit,
  ) {
    final newFilters = Map<String, Set<String>>.from(
      state.activeFilters.map(
        (key, value) => MapEntry(key, Set<String>.from(value)),
      ),
    );
    newFilters.remove(event.attributeCode);
    emit(state.copyWith(activeFilters: newFilters));
  }

  Future<void> _onClearAllFilters(
    ClearAllFilters event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(
      activeFilters: {},
      clearPriceSelection: true,
      status: ProductListStatus.loading,
    ));

    await _reloadProducts(emit);
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(status: ProductListStatus.loading));
    await _reloadProducts(emit);
  }

  void _onUpdatePriceRange(
    UpdatePriceRange event,
    Emitter<ProductListState> emit,
  ) {
    emit(state.copyWith(
      selectedPriceMin: event.min,
      selectedPriceMax: event.max,
    ));
  }

  Future<void> _reloadProducts(Emitter<ProductListState> emit) async {
    try {
      final filterString = state.buildFilterString();
      final result = await repository.getFilterProducts(
        filter: filterString,
        first: 12,
        sortKey: state.currentSort.sortKey,
        reverse: state.currentSort.reverse,
      );

      emit(
        state.copyWith(
          status: ProductListStatus.loaded,
          products: result.products,
          pageInfo: result.pageInfo,
          totalProducts: result.totalCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreProductList event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.isLoadingMore ||
        state.pageInfo == null ||
        !state.pageInfo!.hasNextPage) {
      debugPrint(
        '[ProductListBloc] LoadMore skipped: isLoadingMore=${state.isLoadingMore}, hasNextPage=${state.pageInfo?.hasNextPage}',
      );
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final filterString = state.buildFilterString();
      debugPrint(
        '[ProductListBloc] LoadMore after=${state.pageInfo!.endCursor}, filter=$filterString',
      );
      final result = await repository.getFilterProducts(
        filter: filterString,
        first: 12,
        after: state.pageInfo!.endCursor,
        sortKey: state.currentSort.sortKey,
        reverse: state.currentSort.reverse,
      );

      debugPrint(
        '[ProductListBloc] LoadMore got ${result.products.length} more, total now=${state.products.length + result.products.length}',
      );

      emit(
        state.copyWith(
          products: [...state.products, ...result.products],
          pageInfo: result.pageInfo,
          totalProducts: result.totalCount,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, errorMessage: e.toString()));
    }
  }
}
