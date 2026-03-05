import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── MODE ───

/// Determines which API to call:
///   [customer] → customerReviews (logged-in user's own reviews)
///   [product]  → productReviews  (all product reviews, from product detail page)
enum ReviewMode { customer, product }

// ─── EVENTS ───

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Load reviews from API (initial or refresh)
/// [mode] controls which API endpoint is called.
/// [productId] — optional product ID to filter reviews (used when mode is product).
class LoadReviews extends ReviewEvent {
  final ReviewMode mode;
  final int? productId;
  const LoadReviews({this.mode = ReviewMode.customer, this.productId});

  @override
  List<Object?> get props => [mode, productId];
}

/// Load next page of reviews (pagination)
class LoadMoreReviews extends ReviewEvent {
  const LoadMoreReviews();
}

/// Clear transient error/success messages
class ClearReviewMessage extends ReviewEvent {
  const ClearReviewMessage();
}

// ─── STATE ───

enum ReviewStatus { initial, loading, loaded, error }

class ReviewState extends Equatable {
  final ReviewStatus status;
  final ReviewMode mode;
  final List<ProductReview> reviews;
  final int totalCount;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMore;
  final String? errorMessage;

  const ReviewState({
    this.status = ReviewStatus.initial,
    this.mode = ReviewMode.customer,
    this.reviews = const [],
    this.totalCount = 0,
    this.hasNextPage = false,
    this.endCursor,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ReviewState copyWith({
    ReviewStatus? status,
    ReviewMode? mode,
    List<ProductReview>? reviews,
    int? totalCount,
    bool? hasNextPage,
    String? endCursor,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return ReviewState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      reviews: reviews ?? this.reviews,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    mode,
    reviews,
    totalCount,
    hasNextPage,
    endCursor,
    isLoadingMore,
    errorMessage,
  ];
}

// ─── BLOC ───

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AccountRepository repository;

  ReviewBloc({required this.repository}) : super(const ReviewState()) {
    on<LoadReviews>(_onLoad);
    on<LoadMoreReviews>(_onLoadMore);
    on<ClearReviewMessage>(_onClearMessage);
  }

  Future<void> _onLoad(LoadReviews event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(status: ReviewStatus.loading, mode: event.mode));

    try {
      if (event.mode == ReviewMode.product) {
        // ── Product page: call getProductReviews ──
        final result = await repository.getProductReviews(
          first: 20,
          productId: event.productId,
        );
        emit(
          state.copyWith(
            status: ReviewStatus.loaded,
            mode: ReviewMode.product,
            reviews: result.reviews,
            totalCount: result.totalCount,
            hasNextPage: false,
            endCursor: null,
          ),
        );
      } else {
        // ── Account page: call getCustomerReviews ──
        final result = await repository.getCustomerReviews(first: 20);
        emit(
          state.copyWith(
            status: ReviewStatus.loaded,
            mode: ReviewMode.customer,
            reviews: result.reviews,
            totalCount: result.totalCount,
            hasNextPage: result.hasNextPage,
            endCursor: result.endCursor,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ ReviewBloc._onLoad error: $e');
      emit(
        state.copyWith(status: ReviewStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreReviews event,
    Emitter<ReviewState> emit,
  ) async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      // Only customerReviews supports cursor pagination
      final result = await repository.getCustomerReviews(
        first: 20,
        after: state.endCursor,
      );

      emit(
        state.copyWith(
          status: ReviewStatus.loaded,
          reviews: [...state.reviews, ...result.reviews],
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          endCursor: result.endCursor,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint('❌ ReviewBloc._onLoadMore error: $e');
      emit(state.copyWith(isLoadingMore: false, errorMessage: e.toString()));
    }
  }

  void _onClearMessage(ClearReviewMessage event, Emitter<ReviewState> emit) {
    emit(state.copyWith(errorMessage: null));
  }
}
