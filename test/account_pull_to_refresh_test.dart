import 'dart:async';

import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/downloadable_products_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/orders_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/review_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/wishlist_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/downloadable_products_page.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/orders_page.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/reviews_page.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/wishlist_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  const order = CustomerOrder(
    numericId: 1,
    incrementId: '1001',
    status: 'pending',
    grandTotal: 100,
  );

  testWidgets('orders list: pulling down reloads with the current filter', (
    tester,
  ) async {
    final repository = _FakeAccountRepository();
    final bloc = _SeededOrdersBloc(repository: repository)
      ..seedState(
        const OrdersState(
          status: OrdersStatus.loaded,
          orders: [order],
          totalCount: 1,
          statusFilter: 'pending',
        ),
      );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      _app(
        BlocProvider<OrdersBloc>.value(value: bloc, child: const OrdersPage()),
      ),
    );
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(repository.orderStatusCalls, ['pending']);
  });

  testWidgets('orders empty state: pulling down reloads', (tester) async {
    final repository = _FakeAccountRepository();
    final bloc = _SeededOrdersBloc(repository: repository)
      ..seedState(const OrdersState(status: OrdersStatus.loaded));
    addTearDown(bloc.close);

    await tester.pumpWidget(
      _app(
        BlocProvider<OrdersBloc>.value(value: bloc, child: const OrdersPage()),
      ),
    );
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.fling(
      find.byType(RefreshIndicator),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(repository.orderStatusCalls, [null]);
  });

  testWidgets('wishlist: list stays visible while a pull-to-refresh loads', (
    tester,
  ) async {
    final repository = _FakeAccountRepository();
    final bloc = _SeededWishlistBloc(repository: repository)
      ..seedState(
        WishlistState(
          status: WishlistStatus.loaded,
          items: [
            WishlistItem(
              id: '/api/shop/wishlists/1',
              name: 'Blue Shirt',
              price: 10,
            ),
          ],
          totalCount: 1,
        ),
      );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      _app(
        BlocProvider<WishlistBloc>.value(
          value: bloc,
          child: const WishlistPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Reload is in flight: bloc is loading but the list is not swapped out.
    expect(repository.wishlistCalls, 1);
    expect(bloc.state.status, WishlistStatus.loading);
    expect(find.text('Blue Shirt'), findsOneWidget);

    repository.wishlistResponse.complete((
      items: <WishlistItem>[],
      totalCount: 0,
      hasNextPage: false,
      endCursor: null,
    ));
    await tester.pumpAndSettle();

    expect(bloc.state.status, WishlistStatus.loaded);
  });

  testWidgets('product reviews: pulling down reloads the same product', (
    tester,
  ) async {
    final repository = _FakeAccountRepository();
    final bloc = _SeededReviewBloc(repository: repository)
      ..seedState(
        const ReviewState(
          status: ReviewStatus.loaded,
          mode: ReviewMode.product,
          reviews: [
            ProductReview(name: 'Jo', title: 'Great', rating: 5, comment: 'Ok'),
          ],
          totalCount: 1,
        ),
      );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      _app(
        BlocProvider<ReviewBloc>.value(
          value: bloc,
          child: const ReviewsPage(productId: 22),
        ),
      ),
    );
    await tester.pump();

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(repository.productReviewCalls, [22]);
    expect(bloc.state.mode, ReviewMode.product);
  });

  testWidgets('product reviews without a productId offer no refresh', (
    tester,
  ) async {
    final bloc = _SeededReviewBloc(repository: _FakeAccountRepository())
      ..seedState(
        const ReviewState(
          status: ReviewStatus.loaded,
          mode: ReviewMode.product,
        ),
      );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      _app(
        BlocProvider<ReviewBloc>.value(value: bloc, child: const ReviewsPage()),
      ),
    );
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsNothing);
  });

  testWidgets('downloadable products empty state: pulling down reloads', (
    tester,
  ) async {
    final repository = _FakeAccountRepository();
    final bloc = _SeededDownloadableProductsBloc(repository: repository)
      ..seedState(
        const DownloadableProductsState(
          status: DownloadableProductsStatus.loaded,
        ),
      );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      _app(
        BlocProvider<DownloadableProductsBloc>.value(
          value: bloc,
          child: const DownloadableProductsPage(),
        ),
      ),
    );
    await tester.pump();

    await tester.fling(
      find.byType(RefreshIndicator),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(repository.downloadableCalls, 1);
  });
}

Widget _app(Widget home) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

class _SeededOrdersBloc extends OrdersBloc {
  _SeededOrdersBloc({required super.repository});

  void seedState(OrdersState state) => emit(state);
}

class _SeededWishlistBloc extends WishlistBloc {
  _SeededWishlistBloc({required super.repository});

  void seedState(WishlistState state) => emit(state);
}

class _SeededReviewBloc extends ReviewBloc {
  _SeededReviewBloc({required super.repository});

  void seedState(ReviewState state) => emit(state);
}

class _SeededDownloadableProductsBloc extends DownloadableProductsBloc {
  _SeededDownloadableProductsBloc({required super.repository});

  void seedState(DownloadableProductsState state) => emit(state);
}

class _FakeAccountRepository extends AccountRepository {
  _FakeAccountRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  final List<String?> orderStatusCalls = [];
  int wishlistCalls = 0;
  final List<int?> productReviewCalls = [];
  int downloadableCalls = 0;
  final wishlistResponse =
      Completer<
        ({
          List<WishlistItem> items,
          int totalCount,
          bool hasNextPage,
          String? endCursor,
        })
      >();

  @override
  Future<
    ({
      List<CustomerOrder> orders,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerOrders({int first = 20, String? after, String? status}) async {
    orderStatusCalls.add(status);
    return (
      orders: const <CustomerOrder>[],
      totalCount: 0,
      hasNextPage: false,
      endCursor: null,
    );
  }

  @override
  Future<
    ({
      List<WishlistItem> items,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getWishlist({int first = 20, String? after}) {
    wishlistCalls++;
    return wishlistResponse.future;
  }

  @override
  Future<({List<ProductReview> reviews, int totalCount})> getProductReviews({
    int first = 10,
    int? status,
    int? productId,
  }) async {
    productReviewCalls.add(productId);
    return (reviews: const <ProductReview>[], totalCount: 0);
  }

  @override
  Future<
    ({
      List<DownloadableProduct> products,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerDownloadableProducts({int first = 10, String? after}) async {
    downloadableCalls++;
    return (
      products: const <DownloadableProduct>[],
      totalCount: 0,
      hasNextPage: false,
      endCursor: null,
    );
  }
}
