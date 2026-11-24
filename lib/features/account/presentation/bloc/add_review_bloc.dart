import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_mapper.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class AddReviewEvent extends Equatable {
  const AddReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Submit a new product review.
///
/// For a logged-in customer, [guestName] is left null — the reviewer's name
/// is looked up from their own profile when the review is sent. Guests have
/// no profile to pull from, so they type a name in and it's carried here.
class SubmitReview extends AddReviewEvent {
  final int productId;
  final String title;
  final String comment;
  final int rating;
  final String? guestName;

  /// Local file paths of photos/videos picked for this review, if any.
  final List<String>? attachmentPaths;

  const SubmitReview({
    required this.productId,
    required this.title,
    required this.comment,
    required this.rating,
    this.guestName,
    this.attachmentPaths,
  });

  @override
  List<Object?> get props =>
      [productId, title, comment, rating, guestName, attachmentPaths];
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

  AddReviewBloc({required this.repository}) : super(const AddReviewState()) {
    on<SubmitReview>(_onSubmit);
    on<ClearAddReviewMessage>(_onClearMessage);
  }

  Future<void> _onSubmit(
    SubmitReview event,
    Emitter<AddReviewState> emit,
  ) async {
    emit(state.copyWith(status: AddReviewStatus.submitting));

    try {
      // Guest reviewers type their own name in (no profile to pull from).
      // Logged-in customers keep the existing behaviour untouched — their
      // own profile name is what the review is attributed to, matching the
      // storefront's behaviour.
      final guestName = event.guestName?.trim();
      final name = (guestName != null && guestName.isNotEmpty)
          ? guestName
          : (await repository.getCustomerProfile()).displayName;

      final review = await repository.createProductReview(
        productId: event.productId,
        title: event.title,
        comment: event.comment,
        rating: event.rating,
        name: name,
        attachmentPaths: event.attachmentPaths,
      );

      emit(
        state.copyWith(
          status: AddReviewStatus.success,
          createdReview: review,
          successMessage: 'Review submitted successfully!',
        ),
      );
    } catch (e) {
      debugPrint('❌ AddReviewBloc._onSubmit error: $e');
      emit(
        state.copyWith(
          status: AddReviewStatus.error,
          errorMessage: ErrorMapper.getUserMessage(e),
        ),
      );
    }
  }

  void _onClearMessage(
    ClearAddReviewMessage event,
    Emitter<AddReviewState> emit,
  ) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
