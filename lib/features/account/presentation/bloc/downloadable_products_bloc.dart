import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class DownloadableProductsEvent extends Equatable {
  const DownloadableProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Load customer downloadable products from API (initial or refresh)
class LoadDownloadableProducts extends DownloadableProductsEvent {
  const LoadDownloadableProducts();
}

/// Load next page of downloadable products (pagination)
class LoadMoreDownloadableProducts extends DownloadableProductsEvent {
  const LoadMoreDownloadableProducts();
}

/// Clear transient error/success messages
class ClearDownloadableProductsMessage extends DownloadableProductsEvent {
  const ClearDownloadableProductsMessage();
}

// ─── STATE ───

enum DownloadableProductsStatus { initial, loading, loaded, error }

class DownloadableProductsState extends Equatable {
  final DownloadableProductsStatus status;
  final List<DownloadableProduct> products;
  final int totalCount;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMore;
  final String? errorMessage;

  const DownloadableProductsState({
    this.status = DownloadableProductsStatus.initial,
    this.products = const [],
    this.totalCount = 0,
    this.hasNextPage = false,
    this.endCursor,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  DownloadableProductsState copyWith({
    DownloadableProductsStatus? status,
    List<DownloadableProduct>? products,
    int? totalCount,
    bool? hasNextPage,
    String? endCursor,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return DownloadableProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        totalCount,
        hasNextPage,
        endCursor,
        isLoadingMore,
        errorMessage,
      ];
}

// ─── BLOC ───

class DownloadableProductsBloc
    extends Bloc<DownloadableProductsEvent, DownloadableProductsState> {
  final AccountRepository repository;

  DownloadableProductsBloc({required this.repository})
      : super(const DownloadableProductsState()) {
    on<LoadDownloadableProducts>(_onLoad);
    on<LoadMoreDownloadableProducts>(_onLoadMore);
    on<ClearDownloadableProductsMessage>(_onClearMessage);
  }

  Future<void> _onLoad(
    LoadDownloadableProducts event,
    Emitter<DownloadableProductsState> emit,
  ) async {
    emit(state.copyWith(
      status: DownloadableProductsStatus.loading,
    ));

    try {
      final result = await repository.getCustomerDownloadableProducts(
        first: 10,
      );

      emit(state.copyWith(
        status: DownloadableProductsStatus.loaded,
        products: result.products,
        totalCount: result.totalCount,
        hasNextPage: result.hasNextPage,
        endCursor: result.endCursor,
      ));
    } catch (e) {
      debugPrint('❌ DownloadableProductsBloc._onLoad error: $e');
      emit(state.copyWith(
        status: DownloadableProductsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreDownloadableProducts event,
    Emitter<DownloadableProductsState> emit,
  ) async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final result = await repository.getCustomerDownloadableProducts(
        first: 10,
        after: state.endCursor,
      );

      emit(state.copyWith(
        status: DownloadableProductsStatus.loaded,
        products: [...state.products, ...result.products],
        totalCount: result.totalCount,
        hasNextPage: result.hasNextPage,
        endCursor: result.endCursor,
        isLoadingMore: false,
      ));
    } catch (e) {
      debugPrint('❌ DownloadableProductsBloc._onLoadMore error: $e');
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClearMessage(
    ClearDownloadableProductsMessage event,
    Emitter<DownloadableProductsState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}
