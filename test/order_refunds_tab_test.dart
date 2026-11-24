import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/order_detail_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/order_detail_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// A refunded order, as the storefront's Refunds tab is fed: one item with a
/// refunded quantity and the order-level refund totals.
const _refundedOrder = OrderDetail(
  incrementId: '2470',
  status: 'closed',
  orderCurrencyCode: 'USD',
  grandTotal: 40,
  subTotal: 30,
  shippingAmount: 5,
  taxAmount: 5,
  grandTotalInvoiced: 40,
  grandTotalRefunded: 40,
  items: [
    OrderItem(
      name: 'Beanie',
      sku: 'BEANIE-001',
      qtyOrdered: 2,
      qtyShipped: 2,
      qtyInvoiced: 2,
      qtyRefunded: 2,
      price: 15,
      total: 30,
    ),
    OrderItem(
      name: 'Scarf',
      sku: 'SCARF-001',
      qtyOrdered: 1,
      qtyInvoiced: 1,
      price: 10,
      total: 10,
    ),
  ],
);

Future<void> _openOrder(WidgetTester tester, OrderDetail order) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) =>
            OrderDetailBloc(repository: _FakeAccountRepository(order: order))
              ..add(const LoadOrderDetail(2470)),
        child: const OrderDetailPage(orderId: 2470),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a refunded order offers a Refunds tab', (tester) async {
    await _openOrder(tester, _refundedOrder);

    expect(find.text('Refunds'), findsOneWidget);
  });

  testWidgets('the Refunds tab lists the refunded item and the totals', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _openOrder(tester, _refundedOrder);
    await tester.tap(find.text('Refunds'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('order_refunds_tab')), findsOneWidget);
    // Only the item with a refunded quantity belongs here.
    expect(find.text('Beanie'), findsOneWidget);
    expect(find.text('Scarf'), findsNothing);
    expect(find.text('Refunded Qty'), findsOneWidget);
    expect(find.text('Shipping & Handling'), findsOneWidget);
    expect(find.text('Total Paid'), findsOneWidget);
    expect(find.text('Total Refunded'), findsOneWidget);
    expect(find.text('Total Due'), findsOneWidget);
  });

  testWidgets('an order with no refund has no Refunds tab', (tester) async {
    await _openOrder(
      tester,
      const OrderDetail(
        incrementId: '2466',
        status: 'processing',
        orderCurrencyCode: 'USD',
        grandTotal: 14,
        subTotal: 14,
        items: [
          OrderItem(name: 'Beanie', qtyOrdered: 1, price: 14, total: 14),
        ],
      ),
    );

    expect(find.text('Refunds'), findsNothing);
  });
}

class _FakeAccountRepository extends AccountRepository {
  final OrderDetail order;

  _FakeAccountRepository({required this.order})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<OrderDetail> getCustomerOrder(int orderId) async => order;

  // The side checks the page runs after a load are not under test here, and
  // left to the real repository they would each attempt a network call.
  @override
  Future<List<CustomerOrder>> getReturnableOrders({String? incrementId}) async =>
      const [];

  @override
  Future<bool> isEuWithdrawalEnabled() async => false;

  @override
  Future<bool?> getBookingAllowsCancellation(int productId) async => null;
}
