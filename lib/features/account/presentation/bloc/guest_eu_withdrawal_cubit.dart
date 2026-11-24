import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

/// State of the guest EU withdrawal form.
class GuestEuWithdrawalState extends Equatable {
  final bool isSubmitting;
  final GuestEuWithdrawalLinkResponse? response;
  final String? errorMessage;

  const GuestEuWithdrawalState({
    this.isSubmitting = false,
    this.response,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isSubmitting, response, errorMessage];
}

/// Requests an email link for a guest EU contract withdrawal.
class GuestEuWithdrawalCubit extends Cubit<GuestEuWithdrawalState> {
  final AccountRepository repository;

  GuestEuWithdrawalCubit({required this.repository})
    : super(const GuestEuWithdrawalState());

  Future<void> submit({
    required String orderIncrementId,
    required String email,
  }) async {
    if (state.isSubmitting) return;
    emit(const GuestEuWithdrawalState(isSubmitting: true));
    try {
      final response = await repository.createGuestEuWithdrawal(
        orderIncrementId: orderIncrementId,
        email: email,
      );
      emit(
        response.success
            ? GuestEuWithdrawalState(response: response)
            : GuestEuWithdrawalState(errorMessage: response.message),
      );
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
