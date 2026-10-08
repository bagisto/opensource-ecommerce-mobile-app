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

/// Cancel an existing order.
class CancelOrder extends OrderDetailEvent {
  final int orderId;
  const CancelOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Withdraw from the contract of an order (EU right of withdrawal).
class WithdrawFromContract extends OrderDetailEvent {
  final int orderId;
  final String? reasonText;
  const WithdrawFromContract({required this.orderId, this.reasonText});

  @override
  List<Object?> get props => [orderId, reasonText];
}

// ─── STATE ───

enum OrderDetailStatus {
  initial,
  loading,
  loaded,
  error,
  reordering,
  reorderSuccess,
  canceling,
  cancelSuccess,
}

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

  /// This order as listed by `returnableOrders`; null when the backend does
  /// not accept a return for it.
  final CustomerOrder? returnableOrder;

  /// True when the order has a booking item whose product does not allow
  /// cancellation, so canceling the order will not cancel that booking.
  final bool hasNonCancelableBooking;

  /// EU withdrawal is enabled for the channel (`euWithdrawalStatus`).
  final bool euWithdrawalEnabled;

  /// This order's withdrawal request, once one exists.
  final EuWithdrawal? euWithdrawal;
  final bool isWithdrawing;

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
    this.returnableOrder,
    this.hasNonCancelableBooking = false,
    this.euWithdrawalEnabled = false,
    this.euWithdrawal,
    this.isWithdrawing = false,
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
    CustomerOrder? returnableOrder,
    bool? hasNonCancelableBooking,
    bool? euWithdrawalEnabled,
    EuWithdrawal? euWithdrawal,
    bool? isWithdrawing,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      order: order ?? this.order,
      invoices: invoices ?? this.invoices,
      shipments: shipments ?? this.shipments,
      shipmentDetail: shipmentDetail ?? this.shipmentDetail,
      shipmentsLoading: shipmentsLoading ?? this.shipmentsLoading,
      shipmentDetailLoading:
          shipmentDetailLoading ?? this.shipmentDetailLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      reorderItemsCount: reorderItemsCount,
      returnableOrder: returnableOrder ?? this.returnableOrder,
      hasNonCancelableBooking:
          hasNonCancelableBooking ?? this.hasNonCancelableBooking,
      euWithdrawalEnabled: euWithdrawalEnabled ?? this.euWithdrawalEnabled,
      euWithdrawal: euWithdrawal ?? this.euWithdrawal,
      isWithdrawing: isWithdrawing ?? this.isWithdrawing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    order,
    invoices,
    shipments,
    shipmentDetail,
    shipmentsLoading,
    shipmentDetailLoading,
    errorMessage,
    successMessage,
    reorderItemsCount,
    returnableOrder,
    hasNonCancelableBooking,
    euWithdrawalEnabled,
    euWithdrawal,
    isWithdrawing,
  ];
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
    on<CancelOrder>(_onCancel);
    on<WithdrawFromContract>(_onWithdraw);
  }

  /// Get the repository instance
  AccountRepository get repo => repository;

  /// Status after a failed reorder/cancel: keep showing the loaded order
  /// (the page shows the message as a snackbar) instead of the error page.
  OrderDetailStatus get _afterActionStatus => state.order != null
      ? OrderDetailStatus.loaded
      : OrderDetailStatus.error;

  Future<void> _onLoad(
    LoadOrderDetail event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(status: OrderDetailStatus.loading));

    try {
      final order = await repository.getCustomerOrder(event.orderId);

      emit(state.copyWith(status: OrderDetailStatus.loaded, order: order));

      await _checkBookingCancellation(order, emit);
      await _checkEuWithdrawal(order, emit);

      // Ask the backend whether this order still accepts a return.
      try {
        final returnable = await repository.getReturnableOrders(
          incrementId: order.incrementId,
        );
        final match = returnable
            .where((o) => o.numericId == order.numericId)
            .firstOrNull;
        if (match != null) emit(state.copyWith(returnableOrder: match));
      } catch (e) {
        debugPrint('⚠️ OrderDetailBloc return eligibility check failed: $e');
      }
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onLoad error: $e');
      emit(
        state.copyWith(
          status: OrderDetailStatus.error,
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to load order details',
        ),
      );
    }
  }

  /// Loads whether EU withdrawal is enabled and any existing request for
  /// this order.
  Future<void> _checkEuWithdrawal(
    OrderDetail order,
    Emitter<OrderDetailState> emit,
  ) async {
    final orderId = order.numericId;
    if (orderId == null) return;
    try {
      if (!await repository.isEuWithdrawalEnabled()) return;
      emit(state.copyWith(euWithdrawalEnabled: true));
      final existing = await repository.getEuWithdrawalForOrder(orderId);
      if (existing != null) emit(state.copyWith(euWithdrawal: existing));
    } catch (e) {
      debugPrint('⚠️ OrderDetailBloc EU withdrawal check failed: $e');
    }
  }

  Future<void> _onWithdraw(
    WithdrawFromContract event,
    Emitter<OrderDetailState> emit,
  ) async {
    if (state.isWithdrawing) return;
    emit(state.copyWith(isWithdrawing: true));
    try {
      final withdrawal = await repository.createEuWithdrawal(
        orderId: event.orderId,
        reasonText: event.reasonText,
      );
      emit(state.copyWith(isWithdrawing: false, euWithdrawal: withdrawal));
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onWithdraw error: $e');
      emit(
        state.copyWith(
          isWithdrawing: false,
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to submit the withdrawal request',
        ),
      );
    }
  }

  /// Flags orders holding a booking whose product has cancellation turned
  /// off (`BookingProduct.allowCancellation`).
  Future<void> _checkBookingCancellation(
    OrderDetail order,
    Emitter<OrderDetailState> emit,
  ) async {
    final productIds = order.items
        .where((item) => item.type == 'booking' && item.productId != null)
        .map((item) => item.productId!)
        .toSet();
    for (final productId in productIds) {
      try {
        if (await repository.getBookingAllowsCancellation(productId) ==
            false) {
          emit(state.copyWith(hasNonCancelableBooking: true));
          return;
        }
      } catch (e) {
        debugPrint('⚠️ OrderDetailBloc booking cancellation check failed: $e');
      }
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

      emit(state.copyWith(invoices: invoicesResult.invoices));
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

      emit(
        state.copyWith(shipments: result.shipments, shipmentsLoading: false),
      );
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

      emit(
        state.copyWith(shipmentDetail: shipment, shipmentDetailLoading: false),
      );
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
        emit(
          state.copyWith(
            status: OrderDetailStatus.reorderSuccess,
            successMessage: result.message,
            reorderItemsCount: result.itemsAddedCount,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: _afterActionStatus,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onReorder error: $e');
      emit(
        state.copyWith(
          status: _afterActionStatus,
          errorMessage: e is AccountException ? e.message : 'Failed to reorder',
        ),
      );
    }
  }

  Future<void> _onCancel(
    CancelOrder event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(status: OrderDetailStatus.canceling));

    try {
      final result = await repository.cancelOrder(orderId: event.orderId);

      if (result.success) {
        // Re-fetch the order so the UI reflects the new (canceled) status.
        OrderDetail? refreshed;
        try {
          refreshed = await repository.getCustomerOrder(event.orderId);
        } catch (_) {
          // Cancellation succeeded; keep the existing order on refresh failure.
        }

        emit(
          state.copyWith(
            status: OrderDetailStatus.cancelSuccess,
            order: refreshed ?? state.order,
            successMessage: result.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: _afterActionStatus,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ OrderDetailBloc._onCancel error: $e');
      emit(
        state.copyWith(
          status: _afterActionStatus,
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to cancel order',
        ),
      );
    }
  }
}
