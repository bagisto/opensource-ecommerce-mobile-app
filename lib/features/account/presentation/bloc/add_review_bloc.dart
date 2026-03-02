import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class AddReviewEvent extends Equatable {
  const AddReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Submit a new product review
class SubmitReview extends AddReviewEvent {
  final int productId;
  final String title;
  final String comment;
  final int rating;
  final String name;

  const SubmitReview({
    required this.productId,
    required this.title,
    required this.comment,
    required this.rating,
    required this.name,
  });

  @override
  List<Object?> get props => [productId, title, comment, rating, name];
}

/// Clear transient messages
class ClearAddReviewMessage extends AddReviewEvent {
  const ClearAddReviewMessage();
}

// ─── STATE ───

enum AddReviewStatus { initial, submitting, success, error }

class AddReviewState extends Equatable {
  final AddReviewStatus status;
  final ProductReview? createdReview;
  final String? successMessage;
  final String? errorMessage;

  const AddReviewState({
    this.status = AddReviewStatus.initial,
    this.createdReview,
    this.successMessage,
    this.errorMessage,
  });

  AddReviewState copyWith({
    AddReviewStatus? status,
    ProductReview? createdReview,
    String? successMessage,
    String? errorMessage,
  }) {
    return AddReviewState(
      status: status ?? this.status,
      createdReview: createdReview ?? this.createdReview,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        createdReview,
        successMessage,
        errorMessage,
      ];
}

// ─── BLOC ───

class AddReviewBloc extends Bloc<AddReviewEvent, AddReviewState> {
  final AccountRepository repository;

  AddReviewBloc({required this.repository})
      : super(const AddReviewState()) {
    on<SubmitReview>(_onSubmit);
    on<ClearAddReviewMessage>(_onClearMessage);
  }

  Future<void> _onSubmit(
    SubmitReview event,
    Emitter<AddReviewState> emit,
  ) async {
    emit(state.copyWith(status: AddReviewStatus.submitting));

    try {
      final review = await repository.createProductReview(
        productId: event.productId,
        title: event.title,
        comment: event.comment,
        rating: event.rating,
        name: event.name,
      );

      emit(state.copyWith(
        status: AddReviewStatus.success,
        createdReview: review,
        successMessage: 'Review submitted successfully!',
      ));
    } catch (e) {
      debugPrint('❌ AddReviewBloc._onSubmit error: $e');
      emit(state.copyWith(
        status: AddReviewStatus.error,
        errorMessage: e.toString().replaceFirst('AccountException: ', ''),
      ));
    }
  }

  void _onClearMessage(
    ClearAddReviewMessage event,
    Emitter<AddReviewState> emit,
  ) {
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }
}
