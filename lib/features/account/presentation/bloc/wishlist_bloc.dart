import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';

// ─── EVENTS ───

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or reload) the wishlist from the API
class LoadWishlist extends WishlistEvent {
  const LoadWishlist();
}

/// Load the next page of wishlist items
class LoadMoreWishlist extends WishlistEvent {
  const LoadMoreWishlist();
}

/// Remove an item from the wishlist
class RemoveWishlistItem extends WishlistEvent {
  final String id; // IRI id
  const RemoveWishlistItem({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Move item to cart
class MoveWishlistItemToCart extends WishlistEvent {
  final int numericId; // _id
  final int quantity;
  const MoveWishlistItemToCart({required this.numericId, this.quantity = 1});

  @override
  List<Object?> get props => [numericId, quantity];
}

/// Update local quantity for a wishlist item (before adding to cart)
class UpdateWishlistItemQuantity extends WishlistEvent {
  final String id; // IRI id
  final int quantity;
  const UpdateWishlistItemQuantity({required this.id, required this.quantity});

  @override
  List<Object?> get props => [id, quantity];
}

/// Clear success/error messages
class ClearWishlistMessage extends WishlistEvent {
  const ClearWishlistMessage();
}

// ─── STATE ───

enum WishlistStatus { initial, loading, loaded, error }

class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<WishlistItem> items;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? endCursor;
  final String? successMessage;
  final String? errorMessage;
  final String? errorUrlKey;
  final String? errorProductName;

  /// Track which item IDs are currently processing (remove/move to cart)
  final Set<String> processingIds;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.totalCount = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.endCursor,
    this.successMessage,
    this.errorMessage,
    this.errorUrlKey,
    this.errorProductName,
    this.processingIds = const {},
  });

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistItem>? items,
    int? totalCount,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? endCursor,
    String? successMessage,
    String? errorMessage,
    String? errorUrlKey,
    String? errorProductName,
    Set<String>? processingIds,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      endCursor: endCursor ?? this.endCursor,
      successMessage: successMessage,
      errorMessage: errorMessage,
      errorUrlKey: errorUrlKey ?? this.errorUrlKey,
      errorProductName: errorProductName ?? this.errorProductName,
      processingIds: processingIds ?? this.processingIds,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    totalCount,
    hasNextPage,
    isLoadingMore,
    endCursor,
    successMessage,
    errorMessage,
    errorUrlKey,
    errorProductName,
    processingIds,
  ];
}

// ─── BLOC ───

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final AccountRepository repository;
  final WishlistCubit? wishlistCubit; // Optional reference to global wishlist cubit

  WishlistBloc({
    required this.repository,
    this.wishlistCubit,
  }) : super(const WishlistState()) {
    on<LoadWishlist>(_onLoad);
    on<LoadMoreWishlist>(_onLoadMore);
    on<RemoveWishlistItem>(_onRemove);
    on<MoveWishlistItemToCart>(_onMoveToCart);
    on<UpdateWishlistItemQuantity>(_onUpdateQuantity);
    on<ClearWishlistMessage>(_onClearMessage);
  }

  Future<void> _onLoad(LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(state.copyWith(status: WishlistStatus.loading));
    try {
      final result = await repository.getWishlist(first: 20);
      debugPrint('✅ Wishlist loaded: ${result.items.length} items');
      emit(
        state.copyWith(
          status: WishlistStatus.loaded,
          items: result.items,
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          endCursor: result.endCursor,
        ),
      );
    } catch (e) {
      debugPrint('❌ Wishlist load error: $e');
      emit(
        state.copyWith(
          status: WishlistStatus.error,
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to load wishlist. Please try again.',
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final result = await repository.getWishlist(
        first: 20,
        after: state.endCursor,
      );
      debugPrint('✅ Wishlist more loaded: ${result.items.length} items');

      emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...result.items],
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          endCursor: result.endCursor,
        ),
      );
    } catch (e) {
      debugPrint('❌ Wishlist load more error: $e');
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to load more items. Please try again.',
        ),
      );
    }
  }

  Future<void> _onRemove(
    RemoveWishlistItem event,
    Emitter<WishlistState> emit,
  ) async {
    // Mark item as processing
    emit(state.copyWith(processingIds: {...state.processingIds, event.id}));

    try {
      await repository.deleteWishlistItem(id: event.id);

      // Remove from local list
      final updatedItems = state.items
          .where((item) => item.id != event.id)
          .toList();
      final updatedProcessing = Set<String>.from(state.processingIds)
        ..remove(event.id);

      // Also sync with global WishlistCubit if available
      final itemToRemove = state.items.firstWhere(
        (item) => item.id == event.id,
        orElse: () => state.items.first,
      );
      final productId = itemToRemove.productNumericId;
      if (productId != null && wishlistCubit != null) {
        wishlistCubit!.removeProductFromWishlist(productId);
        debugPrint('❤️ WishlistBloc: synced removal with WishlistCubit');
      }

      debugPrint('✅ Wishlist item removed');
      emit(
        state.copyWith(
          items: updatedItems,
          totalCount: updatedItems.length,
          processingIds: updatedProcessing,
          successMessage: 'Item removed from wishlist',
        ),
      );
    } catch (e) {
      final updatedProcessing = Set<String>.from(state.processingIds)
        ..remove(event.id);
      debugPrint('❌ Remove wishlist item error: $e');
      emit(
        state.copyWith(
          processingIds: updatedProcessing,
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to remove item. Please try again.',
        ),
      );
    }
  }

  Future<void> _onMoveToCart(
    MoveWishlistItemToCart event,
    Emitter<WishlistState> emit,
  ) async {
    // Find the item to get its IRI id for processing indicator
    final item = state.items.firstWhere(
      (i) => i.numericId == event.numericId,
      orElse: () => state.items.first,
    );
    final itemId = item.id ?? '';

    emit(state.copyWith(processingIds: {...state.processingIds, itemId}));

    try {
      final message = await repository.moveWishlistToCart(
        wishlistItemId: event.numericId,
        quantity: event.quantity,
      );

      // Remove from local list since it's moved to cart
      final updatedItems = state.items
          .where((i) => i.numericId != event.numericId)
          .toList();
      final updatedProcessing = Set<String>.from(state.processingIds)
        ..remove(itemId);

      // Also sync with global WishlistCubit if available
      if (wishlistCubit != null) {
        wishlistCubit!.removeProductFromWishlist(event.numericId);
        debugPrint('❤️ WishlistBloc: synced move-to-cart with WishlistCubit');
      }

      debugPrint('✅ Wishlist item moved to cart');
      emit(
        state.copyWith(
          items: updatedItems,
          totalCount: updatedItems.length,
          processingIds: updatedProcessing,
          successMessage: message,
        ),
      );
    } catch (e) {
      final updatedProcessing = Set<String>.from(state.processingIds)
        ..remove(itemId);
      debugPrint('❌ Move to cart error: $e');

      String? errorUrlKey;
      String? errorProductName;

      // If the product is configurable, we should provide the urlKey for navigation
      if (item.type == 'configurable') {
        errorUrlKey = item.urlKey;
        errorProductName = item.name;
      }

      emit(
        state.copyWith(
          processingIds: updatedProcessing,
          errorMessage: e is AccountException
              ? e.message
              : 'Failed to add to cart. Please try again.',
          errorUrlKey: errorUrlKey,
          errorProductName: errorProductName,
        ),
      );
    }
  }

  void _onUpdateQuantity(
    UpdateWishlistItemQuantity event,
    Emitter<WishlistState> emit,
  ) {
    final updatedItems = state.items.map((item) {
      if (item.id == event.id) {
        item.quantity = event.quantity;
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
  }

  void _onClearMessage(
    ClearWishlistMessage event,
    Emitter<WishlistState> emit,
  ) {
    emit(
      state.copyWith(
        successMessage: null,
        errorMessage: null,
        errorUrlKey: null,
        errorProductName: null,
      ),
    );
  }
}
