import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../features/auth/domain/services/auth_storage.dart';
import '../../features/account/data/repository/account_repository.dart';
import '../graphql/graphql_client.dart';

// ─── STATE ───

class WishlistCubitState extends Equatable {
  /// Map of product numeric ID → wishlist item IRI (needed for deletion).
  final Map<int, String> wishlistedProducts;

  /// Set of product IDs currently being processed (add/remove in flight).
  final Set<int> processingIds;

  /// Whether the wishlist has been loaded at least once.
  final bool isLoaded;

  const WishlistCubitState({
    this.wishlistedProducts = const {},
    this.processingIds = const {},
    this.isLoaded = false,
  });

  bool isWishlisted(int productId) =>
      wishlistedProducts.containsKey(productId);

  bool isProcessing(int productId) => processingIds.contains(productId);

  WishlistCubitState copyWith({
    Map<int, String>? wishlistedProducts,
    Set<int>? processingIds,
    bool? isLoaded,
  }) {
    return WishlistCubitState(
      wishlistedProducts: wishlistedProducts ?? this.wishlistedProducts,
      processingIds: processingIds ?? this.processingIds,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => [wishlistedProducts, processingIds, isLoaded];
}

// ─── CUBIT ───

/// Global cubit that tracks which products are in the user's wishlist.
///
/// Provides [isWishlisted] checks and [toggleWishlist] for add/remove.
/// Provided at the app level so all pages share the same wishlist state.
class WishlistCubit extends Cubit<WishlistCubitState> {
  WishlistCubit() : super(const WishlistCubitState());

  /// Load the user's full wishlist to populate wishlisted product IDs.
  /// Call after authentication or on app start.
  Future<void> loadWishlist() async {
    try {
      final accessToken = await AuthStorage.getToken();
      if (accessToken == null) {
        emit(const WishlistCubitState(isLoaded: true));
        return;
      }

      final client =
          GraphQLClientProvider.authenticatedClient(accessToken).value;
      final repo = AccountRepository(client: client);

      final map = await _fetchWishlistMap(repo);

      debugPrint(
        '❤️ WishlistCubit: loaded ${map.length} wishlisted products',
      );
      emit(WishlistCubitState(
        wishlistedProducts: map,
        isLoaded: true,
      ));
    } catch (e) {
      debugPrint('❤️ WishlistCubit: failed to load wishlist — $e');
      emit(state.copyWith(isLoaded: true));
    }
  }

  /// Toggle wishlist for a product. Adds if not wishlisted, removes if already.
  /// Returns `true` if added, `false` if removed, `null` if auth required/error.
  Future<bool?> toggleWishlist({required int productId}) async {
    if (state.isProcessing(productId)) return null;

    // Mark as processing
    emit(state.copyWith(
      processingIds: {...state.processingIds, productId},
    ));

    try {
      final accessToken = await AuthStorage.getToken();
      if (accessToken == null) {
        // Not authenticated — single emit to remove processing
        final updatedProcessing = Set<int>.from(state.processingIds)
          ..remove(productId);
        emit(state.copyWith(processingIds: updatedProcessing));
        return null;
      }

      final client =
          GraphQLClientProvider.authenticatedClient(accessToken).value;
      final repo = AccountRepository(client: client);

      if (state.isWishlisted(productId)) {
        // ── REMOVE from wishlist ──
        final wishlistIri = state.wishlistedProducts[productId]!;
        debugPrint(
          '❤️ WishlistCubit: removing product $productId (iri=$wishlistIri)',
        );

        await repo.deleteWishlistItem(id: wishlistIri);

        // Single atomic emit: remove from map + remove from processing
        final updatedMap = Map<int, String>.from(state.wishlistedProducts)
          ..remove(productId);
        final updatedProcessing = Set<int>.from(state.processingIds)
          ..remove(productId);

        emit(state.copyWith(
          wishlistedProducts: updatedMap,
          processingIds: updatedProcessing,
        ));

        debugPrint('❤️ WishlistCubit: removed product $productId ✓');
        return false;
      } else {
        // ── ADD to wishlist ──
        debugPrint('❤️ WishlistCubit: adding product $productId');

        // addToWishlist now returns the wishlist item IRI
        final wishlistIri = await repo.addToWishlist(productId: productId);

        if (wishlistIri != null && wishlistIri.isNotEmpty) {
          // We got the IRI directly — update map without a full reload
          final updatedMap = Map<int, String>.from(state.wishlistedProducts)
            ..[productId] = wishlistIri;
          final updatedProcessing = Set<int>.from(state.processingIds)
            ..remove(productId);

          emit(state.copyWith(
            wishlistedProducts: updatedMap,
            processingIds: updatedProcessing,
          ));
        } else {
          // Fallback: IRI not returned — reload from network
          debugPrint(
            '❤️ WishlistCubit: IRI not returned, reloading from network',
          );
          final freshMap = await _fetchWishlistMap(repo);
          final updatedProcessing = Set<int>.from(state.processingIds)
            ..remove(productId);

          emit(state.copyWith(
            wishlistedProducts: freshMap,
            processingIds: updatedProcessing,
          ));
        }

        debugPrint('❤️ WishlistCubit: added product $productId ✓');
        return true;
      }
    } catch (e) {
      debugPrint('❤️ WishlistCubit: toggle failed for $productId — $e');
      final updatedProcessing = Set<int>.from(state.processingIds)
        ..remove(productId);
      emit(state.copyWith(processingIds: updatedProcessing));
      rethrow;
    }
  }

  /// Clear wishlist state (e.g., on logout).
  void clearWishlist() {
    emit(const WishlistCubitState(isLoaded: true));
  }

  /// Refresh wishlist from the server in background.
  /// Call this when returning to pages that display wishlist status.
  Future<void> refreshWishlist() async {
    try {
      final accessToken = await AuthStorage.getToken();
      if (accessToken == null) {
        emit(const WishlistCubitState(isLoaded: true));
        return;
      }

      final client =
          GraphQLClientProvider.authenticatedClient(accessToken).value;
      final repo = AccountRepository(client: client);

      final map = await _fetchWishlistMap(repo);

      debugPrint(
        '❤️ WishlistCubit: refreshed, found ${map.length} wishlisted products',
      );
      emit(WishlistCubitState(
        wishlistedProducts: map,
        isLoaded: true,
      ));
    } catch (e) {
      debugPrint('❤️ WishlistCubit: refresh failed — $e');
      // Don't emit error state, keep existing state on refresh failure
    }
  }

  /// Remove a product from the local wishlist state.
  /// Call this when WishlistBloc removes an item to keep states in sync.
  void removeProductFromWishlist(int productId) {
    final updatedMap = Map<int, String>.from(state.wishlistedProducts)
      ..remove(productId);
    emit(state.copyWith(wishlistedProducts: updatedMap));
    debugPrint('❤️ WishlistCubit: product $productId removed from local state');
  }

  /// Fetch the full product→wishlistIRI map from the API.
  /// Uses [FetchPolicy.networkOnly] to avoid stale cache data.
  Future<Map<int, String>> _fetchWishlistMap(AccountRepository repo) async {
    final Map<int, String> map = {};
    bool hasNextPage = true;
    String? cursor;

    while (hasNextPage) {
      final result = await repo.getWishlist(first: 50, after: cursor);
      for (final item in result.items) {
        final productId = item.productNumericId;
        if (productId != null && item.id != null) {
          map[productId] = item.id!;
        }
      }
      hasNextPage = result.hasNextPage;
      cursor = result.endCursor;
    }

    return map;
  }
}
