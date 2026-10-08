import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

/// State of the guest EU withdrawal form.
class GuestEuWithdrawalState extends Equatable {
  final bool isSubmitting;
  final EuWithdrawal? withdrawal;
  final String? errorMessage;

  const GuestEuWithdrawalState({
    this.isSubmitting = false,
    this.withdrawal,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isSubmitting, withdrawal, errorMessage];
}

/// Submits a guest EU contract withdrawal (`createGuestEuWithdrawal`).
class GuestEuWithdrawalCubit extends Cubit<GuestEuWithdrawalState> {
  final AccountRepository repository;

  GuestEuWithdrawalCubit({required this.repository})
    : super(const GuestEuWithdrawalState());

  Future<void> submit({
    required String orderIncrementId,
    required String email,
    String? reasonText,
  }) async {
    if (state.isSubmitting) return;
    emit(const GuestEuWithdrawalState(isSubmitting: true));
    try {
      final withdrawal = await repository.createGuestEuWithdrawal(
        orderIncrementId: orderIncrementId,
        email: email,
        reasonText: reasonText,
      );
      emit(GuestEuWithdrawalState(withdrawal: withdrawal));
    } catch (e) {
      debugPrint('❌ GuestEuWithdrawalCubit.submit error: $e');
      emit(
        GuestEuWithdrawalState(
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to submit the withdrawal request',
        ),
      );
    }
  }
}
