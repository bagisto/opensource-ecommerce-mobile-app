import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_marketing.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_marketing_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/bloc/seller_marketing_cubits.dart';
import 'package:flutter_test/flutter_test.dart';

/// The marketing screen once spun for ever. `load()` caught only
/// `SellerApiException`, so anything else — a timeout, an unexpected shape —
/// escaped, the status stayed `loading`, and the screen offered no message and
/// no retry. A screen must always resolve to something the seller can act on.
class _Repository implements SellerMarketingRepository {
  _Repository({this.throwing});

  /// What `productDiscounts` throws, if anything.
  final Object? throwing;

  @override
  Future<PaginatedResult<SellerProductDiscount>> productDiscounts({
    int page = 1,
    String? search,
    int? status,
  }) async {
    if (throwing != null) throw throwing!;
    return const PaginatedResult(
      items: [],
      totalCount: 0,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  Future<PaginatedResult<SellerJoinableDiscount>> joinableDiscounts({
    int page = 1,
    String? search,
    int? status,
    String? participation,
  }) async {
    return const PaginatedResult(
      items: [],
      totalCount: 0,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  Future<PaginatedResult<SellerCheckoutDeal>> checkoutDeals({
    int page = 1,
    String? search,
    int? status,
    int? couponType,
  }) async {
    return const PaginatedResult(
      items: [],
      totalCount: 0,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  test('a clean load reaches loaded', () async {
    final cubit = SellerMarketingCubit(repository: _Repository());
    await cubit.load();

    expect(cubit.state.status, SellerMarketingStatus.loaded);
  });

  test('an API failure reaches failed with the server message', () async {
    final cubit = SellerMarketingCubit(
      repository: _Repository(
        throwing: const SellerApiException(
          'Your role does not include this.',
          SellerApiFailure.forbidden,
        ),
      ),
    );
    await cubit.load();

    expect(cubit.state.status, SellerMarketingStatus.failed);
    expect(cubit.state.errorMessage, contains('does not include'));
  });

  test('any other error also reaches failed, rather than spinning', () async {
    // The exact shape of the old bug: not a SellerApiException.
    final cubit = SellerMarketingCubit(
      repository: _Repository(throwing: StateError('unexpected shape')),
    );
    await cubit.load();

    expect(
      cubit.state.status,
      SellerMarketingStatus.failed,
      reason: 'the screen would otherwise load for ever',
    );
    expect(cubit.state.errorMessage, isNotNull);
  });
}
