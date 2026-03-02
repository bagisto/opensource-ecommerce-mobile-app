import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class AccountDashboardEvent extends Equatable {
  const AccountDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccountDashboard extends AccountDashboardEvent {
  const LoadAccountDashboard();
}

class RefreshAccountDashboard extends AccountDashboardEvent {
  const RefreshAccountDashboard();
}

// ─── STATES ───

enum AccountDashboardStatus { initial, loading, loaded, error }

class AccountDashboardState extends Equatable {
  final AccountDashboardStatus status;
  final CustomerProfile? profile;
  final List<CustomerAddress> addresses;
  final List<RecentOrder> recentOrders;
  final List<WishlistItem> wishlistItems;
  final int wishlistTotalCount;
  final List<ProductReview> reviews;
  final int reviewsTotalCount;
  final String? errorMessage;

  const AccountDashboardState({
    this.status = AccountDashboardStatus.initial,
    this.profile,
    this.addresses = const [],
    this.recentOrders = const [],
    this.wishlistItems = const [],
    this.wishlistTotalCount = 0,
    this.reviews = const [],
    this.reviewsTotalCount = 0,
    this.errorMessage,
  });

  AccountDashboardState copyWith({
    AccountDashboardStatus? status,
    CustomerProfile? profile,
    List<CustomerAddress>? addresses,
    List<RecentOrder>? recentOrders,
    List<WishlistItem>? wishlistItems,
    int? wishlistTotalCount,
    List<ProductReview>? reviews,
    int? reviewsTotalCount,
    String? errorMessage,
  }) {
    return AccountDashboardState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      addresses: addresses ?? this.addresses,
      recentOrders: recentOrders ?? this.recentOrders,
      wishlistItems: wishlistItems ?? this.wishlistItems,
      wishlistTotalCount: wishlistTotalCount ?? this.wishlistTotalCount,
      reviews: reviews ?? this.reviews,
      reviewsTotalCount: reviewsTotalCount ?? this.reviewsTotalCount,
      errorMessage: errorMessage,
    );
  }

  /// Get default billing address
  CustomerAddress? get defaultBillingAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      // Return first address as billing if no default
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Get default shipping address
  CustomerAddress? get defaultShippingAddress {
    try {
      return addresses.firstWhere((a) => a.useForShipping);
    } catch (_) {
      // Fall back: return default address or second address
      if (addresses.length > 1) return addresses[1];
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    addresses,
    recentOrders,
    wishlistItems,
    wishlistTotalCount,
    reviews,
    reviewsTotalCount,
    errorMessage,
  ];
}

// ─── BLOC ───

class AccountDashboardBloc
    extends Bloc<AccountDashboardEvent, AccountDashboardState> {
  final AccountRepository repository;
  final String? customerId;

  AccountDashboardBloc({required this.repository, this.customerId})
    : super(const AccountDashboardState()) {
    on<LoadAccountDashboard>(_onLoad);
    on<RefreshAccountDashboard>(_onRefresh);
  }

  Future<void> _onLoad(
    LoadAccountDashboard event,
    Emitter<AccountDashboardState> emit,
  ) async {
    emit(state.copyWith(status: AccountDashboardStatus.loading));
    await _fetchAllData(emit);
  }

  Future<void> _onRefresh(
    RefreshAccountDashboard event,
    Emitter<AccountDashboardState> emit,
  ) async {
    await _fetchAllData(emit);
  }

  Future<void> _fetchAllData(Emitter<AccountDashboardState> emit) async {
    try {
      // Fetch all data in parallel for performance
      final results = await Future.wait([
        _safeCall(() => repository.getCustomerProfile()),
        _safeCall(() => repository.getCustomerAddresses(first: 10)),
        _safeCall(() => repository.getRecentOrders(first: 5)),
        _safeCall(() => repository.getWishlist(first: 10)),
        _safeCall(() => repository.getCustomerReviews(first: 10)),
      ]);

      final profile = results[0] as CustomerProfile?;
      final addresses = results[1] as List<CustomerAddress>? ?? [];
      final orders = results[2] as List<RecentOrder>? ?? [];

      // Extract wishlist data
      List<WishlistItem> wishlistItems = [];
      int wishlistTotal = 0;
      final wishlistResult = results[3];
      if (wishlistResult
          is ({
            List<WishlistItem> items,
            int totalCount,
            bool hasNextPage,
            String? endCursor,
          })) {
        wishlistItems = wishlistResult.items;
        wishlistTotal = wishlistResult.totalCount;
      }

      // Extract review data
      List<ProductReview> reviews = [];
      int reviewsTotal = 0;
      final reviewsResult = results[4];
      if (reviewsResult is ({List<ProductReview> reviews, int totalCount})) {
        reviews = reviewsResult.reviews;
        reviewsTotal = reviewsResult.totalCount;
      } else if (reviewsResult
          is ({
            List<ProductReview> reviews,
            int totalCount,
            bool hasNextPage,
            String? endCursor,
          })) {
        // In case getCustomerReviews is used which has more fields
        reviews = reviewsResult.reviews;
        reviewsTotal = reviewsResult.totalCount;
      }

      emit(
        state.copyWith(
          status: AccountDashboardStatus.loaded,
          profile: profile,
          addresses: addresses,
          recentOrders: orders,
          wishlistItems: wishlistItems,
          wishlistTotalCount: wishlistTotal,
          reviews: reviews,
          reviewsTotalCount: reviewsTotal,
          errorMessage: null,
        ),
      );

      debugPrint('✅ Account dashboard loaded successfully');
    } catch (e) {
      debugPrint('❌ Account dashboard error: $e');
      emit(
        state.copyWith(
          status: AccountDashboardStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Safely call a future with retry on network errors, return null on final failure
  Future<dynamic> _safeCall(
    Future<dynamic> Function() call, {
    int maxAttempts = 3,
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await call();
      } catch (e) {
        final isNetworkError =
            e.toString().contains('Network error') ||
            e.toString().contains('TimeoutException') ||
            e.toString().contains('No stream event') ||
            e.toString().contains('SocketException');
        if (isNetworkError && attempt < maxAttempts) {
          debugPrint(
            '⚠️ Account dashboard network error (attempt $attempt/$maxAttempts, retrying): $e',
          );
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
        debugPrint(
          '⚠️ Account dashboard partial error (continuing with other data): $e',
        );
        return null;
      }
    }
    return null;
  }
}
