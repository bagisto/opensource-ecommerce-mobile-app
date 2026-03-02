import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load a single order detail by numeric ID.
class LoadOrderDetail extends OrderDetailEvent {
  final int orderId;
  const LoadOrderDetail(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Load invoices for the order.
class LoadOrderInvoices extends OrderDetailEvent {
  final int orderId;
  const LoadOrderInvoices(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Clear error / success messages.
class ClearOrderDetailMessage extends OrderDetailEvent {
  const ClearOrderDetailMessage();
}

/// Load shipments for the order.
class LoadOrderShipments extends OrderDetailEvent {
  final int orderId;
  const LoadOrderShipments(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Load a single shipment detail.
class LoadShipmentDetail extends OrderDetailEvent {
  final int shipmentId;
  const LoadShipmentDetail(this.shipmentId);

  @override
  List<Object?> get props => [shipmentId];
}

/// Reorder an existing order.
class ReorderOrder extends OrderDetailEvent {
  final int orderId;
  const ReorderOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

// ─── STATE ───

enum OrderDetailStatus { initial, loading, loaded, error, reordering, reorderSuccess }

class OrderDetailState extends Equatable {
  final OrderDetailStatus status;
  final OrderDetail? order;
  final List<OrderInvoice> invoices;
  final List<OrderShipment> shipments;
  final OrderShipment? shipmentDetail;
  final bool shipmentsLoading;
  final bool shipmentDetailLoading;
  final String? errorMessage;
  final String? successMessage;
  final int? reorderItemsCount;

  const OrderDetailState({
    this.status = OrderDetailStatus.initial,
    this.order,
    this.invoices = const [],
    this.shipments = const [],
    this.shipmentDetail,
    this.shipmentsLoading = false,
    this.shipmentDetailLoading = false,
    this.errorMessage,
    this.successMessage,
    this.reorderItemsCount,
  });

  OrderDetailState copyWith({
    OrderDetailStatus? status,
    OrderDetail? order,
    List<OrderInvoice>? invoices,
    List<OrderShipment>? shipments,
    OrderShipment? shipmentDetail,
    bool? shipmentsLoading,
    bool? shipmentDetailLoading,
    String? errorMessage,
    String? successMessage,
    int? reorderItemsCount,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      order: order ?? this.order,
      invoices: invoices ?? this.invoices,
      shipments: shipments ?? this.shipments,
      shipmentDetail: shipmentDetail ?? this.shipmentDetail,
      shipmentsLoading: shipmentsLoading ?? this.shipmentsLoading,
      shipmentDetailLoading: shipmentDetailLoading ?? this.shipmentDetailLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      reorderItemsCount: reorderItemsCount,
    );
  }

  @override
  List<Object?> get props => [status, order, invoices, shipments, shipmentDetail, shipmentsLoading, shipmentDetailLoading, errorMessage, successMessage, reorderItemsCount];
}

// ─── BLOC ───

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final AccountRepository repository;

  OrderDetailBloc({required this.repository})
      : super(const OrderDetailState()) {
    on<LoadOrderDetail>(_onLoad);
    on<LoadOrderInvoices>(_onLoadInvoices);
    on<LoadOrderShipments>(_onLoadShipments);
    on<LoadShipmentDetail>(_onLoadShipmentDetail);
    on<ClearOrderDetailMessage>(_onClearMessage);
    on<ReorderOrder>(_onReorder);
  }

  /// Get the repository instance
  AccountRepository get repo => repository;

  Future<void> _onLoad(
    LoadOrderDetail event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(status: OrderDetailStatus.loading));

    try {
      final order = await repository.getCustomerOrder(event.orderId);

      emit(state.copyWith(
        status: OrderDetailStatus.loaded,
        order: order,
      ));
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onLoad error: $e');
      emit(state.copyWith(
        status: OrderDetailStatus.error,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to load order details',
      ));
    }
  }

  Future<void> _onLoadInvoices(
    LoadOrderInvoices event,
    Emitter<OrderDetailState> emit,
  ) async {
    try {
      final invoicesResult = await repository.getCustomerInvoices(
        first: 20,
        orderId: event.orderId,
      );

      emit(state.copyWith(
        invoices: invoicesResult.invoices,
      ));
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onLoadInvoices error: $e');
      // Don't show error for invoices, just keep existing invoices
    }
  }

  Future<void> _onLoadShipments(
    LoadOrderShipments event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(shipmentsLoading: true));

    try {
      final result = await repository.getCustomerOrderShipments(
        orderId: event.orderId,
      );

      emit(state.copyWith(
        shipments: result.shipments,
        shipmentsLoading: false,
      ));
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onLoadShipments error: $e');
      emit(state.copyWith(shipmentsLoading: false));
    }
  }

  Future<void> _onLoadShipmentDetail(
    LoadShipmentDetail event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(shipmentDetailLoading: true));

    try {
      final shipment = await repository.getCustomerOrderShipment(
        event.shipmentId,
      );

      emit(state.copyWith(
        shipmentDetail: shipment,
        shipmentDetailLoading: false,
      ));
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onLoadShipmentDetail error: $e');
      emit(state.copyWith(shipmentDetailLoading: false));
    }
  }

  void _onClearMessage(
    ClearOrderDetailMessage event,
    Emitter<OrderDetailState> emit,
  ) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  Future<void> _onReorder(
    ReorderOrder event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(status: OrderDetailStatus.reordering));

    try {
      final result = await repository.reorderOrder(orderId: event.orderId);

      if (result.success) {
        emit(state.copyWith(
          status: OrderDetailStatus.reorderSuccess,
          successMessage: result.message,
          reorderItemsCount: result.itemsAddedCount,
        ));
      } else {
        emit(state.copyWith(
          status: OrderDetailStatus.error,
          errorMessage: result.message,
        ));
      }
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onReorder error: $e');
      emit(state.copyWith(
        status: OrderDetailStatus.error,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to reorder',
      ));
    }
  }
}
