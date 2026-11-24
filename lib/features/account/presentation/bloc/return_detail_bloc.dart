import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_mapper.dart';
import '../../data/models/account_models.dart';
import '../../data/models/returns_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class ReturnDetailEvent extends Equatable {
  const ReturnDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load return detail from API
class LoadReturnDetail extends ReturnDetailEvent {
  final int returnId;
  const LoadReturnDetail(this.returnId);

  @override
  List<Object?> get props => [returnId];
}

/// Load the conversation thread for the return
class LoadReturnMessages extends ReturnDetailEvent {
  final int returnId;
  const LoadReturnMessages(this.returnId);

  @override
  List<Object?> get props => [returnId];
}

/// Send a customer message to the conversation thread
class SendReturnMessage extends ReturnDetailEvent {
  final int returnId;
  final String message;
  final String? attachment;
  final String? attachmentName;

  const SendReturnMessage({
    required this.returnId,
    required this.message,
    this.attachment,
    this.attachmentName,
  });

  @override
  List<Object?> get props => [returnId, message, attachment, attachmentName];
}

/// Cancel the return request
class CancelReturn extends ReturnDetailEvent {
  final int returnId;
  const CancelReturn(this.returnId);

  @override
  List<Object?> get props => [returnId];
}

/// Mark the return as solved
class CloseReturn extends ReturnDetailEvent {
  final int returnId;
  const CloseReturn(this.returnId);

  @override
  List<Object?> get props => [returnId];
}

/// Reopen a canceled/declined return
class ReopenReturn extends ReturnDetailEvent {
  final int returnId;
  const ReopenReturn(this.returnId);

  @override
  List<Object?> get props => [returnId];
}

/// Clear transient error/success messages
class ClearReturnDetailMessage extends ReturnDetailEvent {
  const ClearReturnDetailMessage();
}

// ─── STATE ───

enum ReturnDetailStatus { initial, loading, loaded, error }

/// Which customer action (if any) is currently running
enum ReturnAction { none, canceling, closing, reopening }

class ReturnDetailState extends Equatable {
  final ReturnDetailStatus status;
  final CustomerReturn? returnDetail;
  final OrderDetail? orderDetail;
  final String? customerName;
  final List<ReturnMessage> messages;
  final bool messagesLoading;
  final bool sendingMessage;
  final ReturnAction action;
  final String? errorMessage;
  final String? successMessage;

  const ReturnDetailState({
    this.status = ReturnDetailStatus.initial,
    this.returnDetail,
    this.orderDetail,
    this.customerName,
    this.messages = const [],
    this.messagesLoading = false,
    this.sendingMessage = false,
    this.action = ReturnAction.none,
    this.errorMessage,
    this.successMessage,
  });

  ReturnDetailState copyWith({
    ReturnDetailStatus? status,
    CustomerReturn? returnDetail,
    OrderDetail? orderDetail,
    String? customerName,
    List<ReturnMessage>? messages,
    bool? messagesLoading,
    bool? sendingMessage,
    ReturnAction? action,
    String? errorMessage,
    String? successMessage,
  }) {
    return ReturnDetailState(
      status: status ?? this.status,
      returnDetail: returnDetail ?? this.returnDetail,
      orderDetail: orderDetail ?? this.orderDetail,
      customerName: customerName ?? this.customerName,
      messages: messages ?? this.messages,
      messagesLoading: messagesLoading ?? this.messagesLoading,
      sendingMessage: sendingMessage ?? this.sendingMessage,
      action: action ?? this.action,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    returnDetail,
    orderDetail,
    customerName,
    messages,
    messagesLoading,
    sendingMessage,
    action,
    errorMessage,
    successMessage,
  ];
}

// ─── BLOC ───

class ReturnDetailBloc extends Bloc<ReturnDetailEvent, ReturnDetailState> {
  final AccountRepository repository;

  ReturnDetailBloc({required this.repository})
    : super(const ReturnDetailState()) {
    on<LoadReturnDetail>(_onLoad);
    on<LoadReturnMessages>(_onLoadMessages);
    on<SendReturnMessage>(_onSendMessage);
    on<CancelReturn>(
      (event, emit) => _onAction(
        emit,
        action: ReturnAction.canceling,
        run: () => repository.cancelReturn(event.returnId),
      ),
    );
    on<CloseReturn>(
      (event, emit) => _onAction(
        emit,
        action: ReturnAction.closing,
        run: () => repository.closeReturn(event.returnId),
      ),
    );
    on<ReopenReturn>(
      (event, emit) => _onAction(
        emit,
        action: ReturnAction.reopening,
        run: () => repository.reopenReturn(event.returnId),
      ),
    );
    on<ClearReturnDetailMessage>(_onClearMessage);
  }

  Future<void> _onLoad(
    LoadReturnDetail event,
    Emitter<ReturnDetailState> emit,
  ) async {
    emit(state.copyWith(status: ReturnDetailStatus.loading));

    try {
      final detail = await repository.getCustomerReturn(event.returnId);
      OrderDetail? orderDetail;
      if (detail.orderId != null) {
        try {
          orderDetail = await repository.getCustomerOrder(detail.orderId!);
        } catch (e) {
          debugPrint('⚠️ Could not fetch order detail for RMA: $e');
        }
      }
      String? customerName = state.customerName;
      if (customerName == null) {
        try {
          final profile = await repository.getCustomerProfile();
          if (profile.displayName.isNotEmpty) {
            customerName = profile.displayName;
          }
        } catch (_) {}
      }
      emit(
        state.copyWith(
          status: ReturnDetailStatus.loaded,
          returnDetail: detail,
          orderDetail: orderDetail,
          customerName: customerName,
        ),
      );
    } catch (e) {
      debugPrint('❌ ReturnDetailBloc._onLoad error: $e');
      emit(
        state.copyWith(
          status: ReturnDetailStatus.error,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'loading return',
          ),
        ),
      );
    }
  }

  Future<void> _onLoadMessages(
    LoadReturnMessages event,
    Emitter<ReturnDetailState> emit,
  ) async {
    emit(state.copyWith(messagesLoading: true));

    try {
      final messages = await repository.getReturnMessages(event.returnId);
      emit(state.copyWith(messages: messages, messagesLoading: false));
    } catch (e) {
      debugPrint('❌ ReturnDetailBloc._onLoadMessages error: $e');
      // Messages are secondary content — keep the page usable on failure.
      emit(state.copyWith(messagesLoading: false));
    }
  }

  Future<void> _onSendMessage(
    SendReturnMessage event,
    Emitter<ReturnDetailState> emit,
  ) async {
    final text = event.message.trim();
    if (text.isEmpty || state.sendingMessage) return;

    emit(state.copyWith(sendingMessage: true));

    try {
      final sent = await repository.sendReturnMessage(
        returnId: event.returnId,
        message: text,
        attachment: event.attachment,
        attachmentName: event.attachmentName,
      );
      emit(
        state.copyWith(
          sendingMessage: false,
          messages: [...state.messages, sent],
        ),
      );
    } catch (e) {
      debugPrint('❌ ReturnDetailBloc._onSendMessage error: $e');
      emit(
        state.copyWith(
          sendingMessage: false,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'sending message',
          ),
        ),
      );
    }
  }

  Future<void> _onAction(
    Emitter<ReturnDetailState> emit, {
    required ReturnAction action,
    required Future<CustomerReturn> Function() run,
  }) async {
    if (state.action != ReturnAction.none) return;

    emit(state.copyWith(action: action));

    try {
      final updated = await run();
      emit(
        state.copyWith(
          action: ReturnAction.none,
          returnDetail: updated,
          successMessage: updated.statusTitle,
        ),
      );
    } catch (e) {
      debugPrint('❌ ReturnDetailBloc._onAction($action) error: $e');
      emit(
        state.copyWith(
          action: ReturnAction.none,
          errorMessage: ErrorMapper.getUserMessage(
            e,
            context: 'updating return',
          ),
        ),
      );
    }
  }

  void _onClearMessage(
    ClearReturnDetailMessage event,
    Emitter<ReturnDetailState> emit,
  ) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
