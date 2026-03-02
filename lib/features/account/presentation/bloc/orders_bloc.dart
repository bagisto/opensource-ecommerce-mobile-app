import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

/// Load customer orders from API (initial or refresh)
class LoadOrders extends OrdersEvent {
  final String? statusFilter;
  const LoadOrders({this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}

/// Load next page of orders (pagination)
class LoadMoreOrders extends OrdersEvent {
  const LoadMoreOrders();
}

/// Clear transient error/success messages
class ClearOrderMessage extends OrdersEvent {
  const ClearOrderMessage();
}

// ─── STATE ───

enum OrdersStatus { initial, loading, loaded, error }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<CustomerOrder> orders;
  final int totalCount;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? statusFilter;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.totalCount = 0,
    this.hasNextPage = false,
    this.endCursor,
    this.isLoadingMore = false,
    this.errorMessage,
    this.statusFilter,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<CustomerOrder>? orders,
    int? totalCount,
    bool? hasNextPage,
    String? endCursor,
    bool? isLoadingMore,
    String? errorMessage,
    String? statusFilter,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        totalCount,
        hasNextPage,
        endCursor,
        isLoadingMore,
        errorMessage,
        statusFilter,
      ];
}

// ─── BLOC ───

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final AccountRepository repository;

  OrdersBloc({required this.repository}) : super(const OrdersState()) {
    on<LoadOrders>(_onLoad);
    on<LoadMoreOrders>(_onLoadMore);
    on<ClearOrderMessage>(_onClearMessage);
  }

  Future<void> _onLoad(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(
      status: OrdersStatus.loading,
      statusFilter: event.statusFilter,
    ));

    try {
      final result = await repository.getCustomerOrders(
        first: 20,
        status: event.statusFilter,
      );

      emit(state.copyWith(
        status: OrdersStatus.loaded,
        orders: result.orders,
        totalCount: result.totalCount,
        hasNextPage: result.hasNextPage,
        endCursor: result.endCursor,
      ));
    } catch (e) {
      debugPrint('❌ OrdersBloc._onLoad error: $e');
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreOrders event,
    Emitter<OrdersState> emit,
  ) async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final result = await repository.getCustomerOrders(
        first: 20,
        after: state.endCursor,
        status: state.statusFilter,
      );

      emit(state.copyWith(
        status: OrdersStatus.loaded,
        orders: [...state.orders, ...result.orders],
        totalCount: result.totalCount,
        hasNextPage: result.hasNextPage,
        endCursor: result.endCursor,
        isLoadingMore: false,
      ));
    } catch (e) {
      debugPrint('❌ OrdersBloc._onLoadMore error: $e');
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClearMessage(
    ClearOrderMessage event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}
