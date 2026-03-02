import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class CompareEvent extends Equatable {
  const CompareEvent();

  @override
  List<Object?> get props => [];
}

/// Load compare items from API
class LoadCompareItems extends CompareEvent {
  const LoadCompareItems();
}

/// Remove a single compare item
class RemoveCompareItem extends CompareEvent {
  final String id;
  const RemoveCompareItem({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Remove all compare items
class RemoveAllCompareItems extends CompareEvent {
  const RemoveAllCompareItems();
}

/// Clear any success/error message
class ClearCompareMessage extends CompareEvent {
  const ClearCompareMessage();
}

// ─── STATE ───

enum CompareStatus { initial, loading, loaded, error }

class CompareState extends Equatable {
  final CompareStatus status;
  final List<CompareItem> items;
  final int totalCount;
  final String? successMessage;
  final String? errorMessage;
  final Set<String> processingIds;

  const CompareState({
    this.status = CompareStatus.initial,
    this.items = const [],
    this.totalCount = 0,
    this.successMessage,
    this.errorMessage,
    this.processingIds = const {},
  });

  CompareState copyWith({
    CompareStatus? status,
    List<CompareItem>? items,
    int? totalCount,
    String? successMessage,
    String? errorMessage,
    Set<String>? processingIds,
  }) {
    return CompareState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      successMessage: successMessage,
      errorMessage: errorMessage,
      processingIds: processingIds ?? this.processingIds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        totalCount,
        successMessage,
        errorMessage,
        processingIds,
      ];
}

// ─── BLOC ───

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final AccountRepository repository;

  CompareBloc({required this.repository}) : super(const CompareState()) {
    on<LoadCompareItems>(_onLoad);
    on<RemoveCompareItem>(_onRemove);
    on<RemoveAllCompareItems>(_onRemoveAll);
    on<ClearCompareMessage>(_onClearMessage);
  }

  Future<void> _onLoad(
    LoadCompareItems event,
    Emitter<CompareState> emit,
  ) async {
    emit(state.copyWith(status: CompareStatus.loading));

    try {
      final result = await repository.getCompareItems(first: 50);
      debugPrint('✅ CompareBloc: Loaded ${result.items.length} items');
      emit(state.copyWith(
        status: CompareStatus.loaded,
        items: result.items,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      debugPrint('⚠️ CompareBloc: Load error — $e');
      emit(state.copyWith(
        status: CompareStatus.error,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to load compare items.',
      ));
    }
  }

  Future<void> _onRemove(
    RemoveCompareItem event,
    Emitter<CompareState> emit,
  ) async {
    emit(state.copyWith(
      processingIds: {...state.processingIds, event.id},
    ));

    try {
      await repository.deleteCompareItem(event.id);
      final updatedItems =
          state.items.where((item) => item.id != event.id).toList();
      debugPrint('✅ CompareBloc: Removed item ${event.id}');
      emit(state.copyWith(
        items: updatedItems,
        totalCount: updatedItems.length,
        successMessage: 'Item removed from compare list.',
        processingIds: state.processingIds
            .where((id) => id != event.id)
            .toSet(),
      ));
    } catch (e) {
      debugPrint('⚠️ CompareBloc: Remove error — $e');
      emit(state.copyWith(
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to remove item.',
        processingIds: state.processingIds
            .where((id) => id != event.id)
            .toSet(),
      ));
    }
  }

  Future<void> _onRemoveAll(
    RemoveAllCompareItems event,
    Emitter<CompareState> emit,
  ) async {
    emit(state.copyWith(status: CompareStatus.loading));

    try {
      await repository.deleteAllCompareItems();
      debugPrint('✅ CompareBloc: Removed all items');
      emit(state.copyWith(
        status: CompareStatus.loaded,
        items: [],
        totalCount: 0,
        successMessage: 'All items removed from compare list.',
      ));
    } catch (e) {
      debugPrint('⚠️ CompareBloc: RemoveAll error — $e');
      emit(state.copyWith(
        status: CompareStatus.loaded,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to clear compare list.',
      ));
    }
  }

  void _onClearMessage(
    ClearCompareMessage event,
    Emitter<CompareState> emit,
  ) {
    emit(state.copyWith());
  }
}
