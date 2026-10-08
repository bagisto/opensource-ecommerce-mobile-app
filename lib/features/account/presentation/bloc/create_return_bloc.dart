import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_mapper.dart';
import '../../data/models/account_models.dart';
import '../../data/models/returns_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class CreateReturnEvent extends Equatable {
  const CreateReturnEvent();

  @override
  List<Object?> get props => [];
}

/// Load the customer's orders so one can be picked for the return.
/// Mirrors the web `rma/create` page which starts with an order selector.
class LoadCreateReturn extends CreateReturnEvent {
  const LoadCreateReturn();
}

/// Load more orders (pagination) in the order picker
class LoadMoreCreateReturnOrders extends CreateReturnEvent {
  const LoadMoreCreateReturnOrders();
}

/// Pick an order → load its returnable items + reasons (moves to the form)
class SelectOrderForReturn extends CreateReturnEvent {
  final CustomerOrder order;
  const SelectOrderForReturn(this.order);

  @override
  List<Object?> get props => [order];
}

/// Go back to the order picker from the form
class BackToOrderPicker extends CreateReturnEvent {
  const BackToOrderPicker();
}

/// Reload reasons when the resolution type changes
/// ("return" or "cancel_items")
class ChangeResolutionType extends CreateReturnEvent {
  final String resolutionType;
  const ChangeResolutionType(this.resolutionType);

  @override
  List<Object?> get props => [resolutionType];
}

/// Submit the return request
class SubmitReturn extends CreateReturnEvent {
  final int orderItemId;
  final int rmaQty;
  final int rmaReasonId;
  final String? information;
  final String? packageCondition;

  const SubmitReturn({
    required this.orderItemId,
    required this.rmaQty,
    required this.rmaReasonId,
    this.information,
    this.packageCondition,
  });

  @override
  List<Object?> get props => [
    orderItemId,
    rmaQty,
    rmaReasonId,
    information,
    packageCondition,
  ];
}

/// Clear transient error messages
class ClearCreateReturnMessage extends CreateReturnEvent {
  const ClearCreateReturnMessage();
}

// ─── STATE ───

/// Which step of the create flow is on screen
enum CreateReturnPhase { selectOrder, fillForm }

enum CreateReturnStatus {
  initial,
  loading,
  loaded,
  error,
  submitting,
  success,
}

class CreateReturnState extends Equatable {
  static const Object _cursorUnchanged = Object();

  final CreateReturnStatus status;
  final CreateReturnPhase phase;

  // Order picker
  final List<CustomerOrder> orders;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMoreOrders;

  // Selected order + form data
  final CustomerOrder? selectedOrder;
  final List<ReturnableItem> items;
  final List<ReturnReason> reasons;
  final bool reasonsLoading;
  final String resolutionType;

  final CustomerReturn? createdReturn;
  final String? errorMessage;

  const CreateReturnState({
    this.status = CreateReturnStatus.initial,
    this.phase = CreateReturnPhase.selectOrder,
    this.orders = const [],
    this.hasNextPage = false,
    this.endCursor,
    this.isLoadingMoreOrders = false,
    this.selectedOrder,
    this.items = const [],
    this.reasons = const [],
    this.reasonsLoading = false,
    this.resolutionType = 'return',
    this.createdReturn,
    this.errorMessage,
  });

  CreateReturnState copyWith({
    CreateReturnStatus? status,
    CreateReturnPhase? phase,
    List<CustomerOrder>? orders,
    bool? hasNextPage,
    Object? endCursor = _cursorUnchanged,
    bool? isLoadingMoreOrders,
    CustomerOrder? selectedOrder,
    List<ReturnableItem>? items,
    List<ReturnReason>? reasons,
    bool? reasonsLoading,
    String? resolutionType,
    CustomerReturn? createdReturn,
    String? errorMessage,
  }) {
    return CreateReturnState(
      status: status ?? this.status,
      phase: phase ?? this.phase,
      orders: orders ?? this.orders,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: identical(endCursor, _cursorUnchanged)
          ? this.endCursor
          : endCursor as String?,
      isLoadingMoreOrders: isLoadingMoreOrders ?? this.isLoadingMoreOrders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      items: items ?? this.items,
      reasons: reasons ?? this.reasons,
      reasonsLoading: reasonsLoading ?? this.reasonsLoading,
      resolutionType: resolutionType ?? this.resolutionType,
      createdReturn: createdReturn ?? this.createdReturn,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    phase,
    orders,
    hasNextPage,
    endCursor,
    isLoadingMoreOrders,
    selectedOrder,
    items,
    reasons,
    reasonsLoading,
    resolutionType,
    createdReturn,
    errorMessage,
  ];
}

// ─── BLOC ───

class CreateReturnBloc extends Bloc<CreateReturnEvent, CreateReturnState> {
  final AccountRepository repository;

  CreateReturnBloc({required this.repository})
    : super(const CreateReturnState()) {
    on<LoadCreateReturn>(_onLoadOrders);
    on<LoadMoreCreateReturnOrders>(_onLoadMoreOrders);
    on<SelectOrderForReturn>(_onSelectOrder);
    on<BackToOrderPicker>(_onBackToPicker);
    on<ChangeResolutionType>(_onChangeResolutionType);
    on<SubmitReturn>(_onSubmit);
    on<ClearCreateReturnMessage>(_onClearMessage);
  }

  Future<void> _onLoadOrders(
    LoadCreateReturn event,
    Emitter<CreateReturnState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CreateReturnStatus.loading,
        phase: CreateReturnPhase.selectOrder,
      ),
    );

    try {
      // Only orders the backend still accepts returns for (return window,
      // status, remaining quantity). The list is not paginated.
      final orders = await repository.getReturnableOrders();
      emit(
        state.copyWith(
          status: CreateReturnStatus.loaded,
          orders: orders,
          hasNextPage: false,
          endCursor: null,
        ),
      );
    } catch (e) {
      debugPrint('❌ CreateReturnBloc._onLoadOrders error: $e');
      emit(
        state.copyWith(
          status: CreateReturnStatus.error,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'loading orders',
          ),
        ),
      );
    }
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreCreateReturnOrders event,
    Emitter<CreateReturnState> emit,
  ) async {
    if (!state.hasNextPage || state.isLoadingMoreOrders) return;

    emit(state.copyWith(isLoadingMoreOrders: true));

    try {
      final result = await repository.getCustomerOrders(
        first: 20,
        after: state.endCursor,
      );
      emit(
        state.copyWith(
          orders: [...state.orders, ...result.orders],
          hasNextPage: result.hasNextPage,
          endCursor: result.endCursor,
          isLoadingMoreOrders: false,
        ),
      );
    } catch (e) {
      debugPrint('❌ CreateReturnBloc._onLoadMoreOrders error: $e');
      emit(state.copyWith(isLoadingMoreOrders: false));
    }
  }

  Future<void> _onSelectOrder(
    SelectOrderForReturn event,
    Emitter<CreateReturnState> emit,
  ) async {
    final orderId = event.order.numericId;
    if (orderId == null) return;

    emit(
      state.copyWith(
        status: CreateReturnStatus.loading,
        selectedOrder: event.order,
        // reset resolution to default when switching orders
        resolutionType: 'return',
      ),
    );

    try {
      final results = await Future.wait([
        repository.getReturnableItems(orderId),
        repository.getReturnReasons('return'),
      ]);

      // Items with nothing left to return or cancel cannot be submitted.
      final items = (results[0] as List<ReturnableItem>)
          .where(
            (item) =>
                item.maxQuantityFor('return') > 0 ||
                item.maxQuantityFor('cancel_items') > 0,
          )
          .toList();

      emit(
        state.copyWith(
          status: CreateReturnStatus.loaded,
          phase: CreateReturnPhase.fillForm,
          items: items,
          reasons: results[1] as List<ReturnReason>,
        ),
      );
    } catch (e) {
      debugPrint('❌ CreateReturnBloc._onSelectOrder error: $e');
      emit(
        state.copyWith(
          status: CreateReturnStatus.error,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'loading returnable items',
          ),
        ),
      );
    }
  }

  void _onBackToPicker(
    BackToOrderPicker event,
    Emitter<CreateReturnState> emit,
  ) {
    emit(
      state.copyWith(
        status: CreateReturnStatus.loaded,
        phase: CreateReturnPhase.selectOrder,
        items: const [],
      ),
    );
    // Opened straight on one order (from the order page): the picker has
    // not been loaded yet.
    if (state.orders.isEmpty) add(const LoadCreateReturn());
  }

  Future<void> _onChangeResolutionType(
    ChangeResolutionType event,
    Emitter<CreateReturnState> emit,
  ) async {
    if (event.resolutionType == state.resolutionType) return;

    emit(
      state.copyWith(resolutionType: event.resolutionType, reasonsLoading: true),
    );

    try {
      final reasons = await repository.getReturnReasons(event.resolutionType);
      emit(state.copyWith(reasons: reasons, reasonsLoading: false));
    } catch (e) {
      debugPrint('❌ CreateReturnBloc._onChangeResolutionType error: $e');
      emit(
        state.copyWith(
          reasonsLoading: false,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'loading return reasons',
          ),
        ),
      );
    }
  }

  Future<void> _onSubmit(
    SubmitReturn event,
    Emitter<CreateReturnState> emit,
  ) async {
    final orderId = state.selectedOrder?.numericId;
    if (orderId == null || state.status == CreateReturnStatus.submitting) return;

    emit(state.copyWith(status: CreateReturnStatus.submitting));

    try {
      final created = await repository.createReturn(
        orderId: orderId,
        orderItemId: event.orderItemId,
        rmaQty: event.rmaQty,
        resolutionType: state.resolutionType,
        rmaReasonId: event.rmaReasonId,
        information: event.information,
        packageCondition: event.packageCondition,
      );

      emit(
        state.copyWith(
          status: CreateReturnStatus.success,
          createdReturn: created,
        ),
      );
    } catch (e) {
      debugPrint('❌ CreateReturnBloc._onSubmit error: $e');
      emit(
        state.copyWith(
          status: CreateReturnStatus.loaded,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'creating return request',
          ),
        ),
      );
    }
  }

  void _onClearMessage(
    ClearCreateReturnMessage event,
    Emitter<CreateReturnState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}
