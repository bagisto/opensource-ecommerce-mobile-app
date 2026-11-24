import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/order_detail_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/order_detail_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// A cancelable order holding a booking item the customer may not cancel.
/// Both sources of that fact are true here: the order's own flag and the
/// per-product probe the bloc runs.
const _bookingOrder = OrderDetail(
  incrementId: '2480',
  status: 'pending',
  orderCurrencyCode: 'USD',
  grandTotal: 20,
  subTotal: 20,
  numericId: 2480,
  hasNonCancelableBooking: true,
  items: [
    OrderItem(
      name: 'Photo session',
      type: 'booking',
      productId: 2507,
      qtyOrdered: 1,
      price: 20,
      total: 20,
    ),
  ],
);

Future<void> _openOrder(
  WidgetTester tester,
  AccountRepository repository,
) async {
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) =>
            OrderDetailBloc(repository: repository)
              ..add(const LoadOrderDetail(2480)),
        child: const OrderDetailPage(orderId: 2480),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the non-cancelable booking notice is shown exactly once', (
    tester,
  ) async {
    await _openOrder(tester, _FakeRepository(order: _bookingOrder));

    expect(
      find.byKey(const Key('orderNonCancelableBookingNotice')),
      findsOneWidget,
    );
    // The details tab must not repeat it.
    expect(
      find.byKey(const ValueKey('order_booking_not_canceled_note')),
      findsNothing,
    );
  });

  testWidgets('the booking notice is repeated inside the cancel confirmation', (
    tester,
  ) async {
    await _openOrder(tester, _FakeRepository(order: _bookingOrder));

    await tester.tap(find.text('Cancel Order'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('order_booking_not_canceled_note')),
      findsOneWidget,
    );
  });

  testWidgets('a successful cancellation reports the server message', (
    tester,
  ) async {
    final repository = _FakeRepository(
      order: _bookingOrder,
      cancelResult: (
        success: true,
        message: 'Order has been canceled successfully',
        orderId: 2480,
        status: 'canceled',
      ),
      refreshed: const OrderDetail(
        incrementId: '2480',
        status: 'canceled',
        orderCurrencyCode: 'USD',
        grandTotal: 20,
        numericId: 2480,
      ),
    );

    await _openOrder(tester, repository);

    await tester.tap(find.text('Cancel Order'));
    await tester.pumpAndSettle();
    // The dialog's confirm action carries the same label as the button.
    await tester.tap(find.text('Cancel Order').last);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Order has been canceled successfully'), findsOneWidget);
    expect(repository.canceledOrderIds, [2480]);
  });
}

class _FakeRepository extends AccountRepository {
  final OrderDetail order;
  final OrderDetail? refreshed;
  final ({bool success, String message, int orderId, String status})?
  cancelResult;
  final List<int> canceledOrderIds = [];
  bool _canceled = false;

  _FakeRepository({required this.order, this.cancelResult, this.refreshed})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<OrderDetail> getCustomerOrder(int orderId) async =>
      _canceled ? (refreshed ?? order) : order;

  @override
  Future<({bool success, String message, int orderId, String status})>
  cancelOrder({required int orderId}) async {
    canceledOrderIds.add(orderId);
    _canceled = true;
    return cancelResult ??
        (success: false, message: 'not supported', orderId: orderId, status: '');
  }

  // Side checks the page runs after a load; left to the real repository each
  // would attempt a network call.
  @override
  Future<bool?> getBookingAllowsCancellation(int productId) async => false;

  @override
  Future<List<CustomerOrder>> getReturnableOrders({
    String? incrementId,
  }) async => const [];

  @override
  Future<bool> isEuWithdrawalEnabled() async => false;
}
