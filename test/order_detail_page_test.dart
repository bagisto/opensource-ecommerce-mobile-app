import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/order_detail_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/order_detail_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  Widget refundApp(OrderDetail order) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider(
      create: (_) =>
          OrderDetailBloc(repository: _FakeAccountRepository(order: order))
            ..add(const LoadOrderDetail(2470)),
      child: const OrderDetailPage(orderId: 2470),
    ),
  );

  testWidgets('Refunds tab matches the storefront view', (
    WidgetTester tester,
  ) async {
    // Order #2 on the local server: Nike Shoes invoiced, shipped, refunded.
    final order = OrderDetail.fromJson({
      'incrementId': '2',
      'status': 'closed',
      'orderCurrencyCode': 'USD',
      'grandTotal': 109,
      'subTotal': 99,
      'shippingAmount': 10,
      'taxAmount': 0,
      'grandTotalInvoiced': 109,
      'grandTotalRefunded': 109,
      'subTotalRefunded': 99,
      'shippingRefunded': 10,
      'items': {
        'edges': [
          {
            'node': {
              'sku': 'Ring-001',
              'name': 'Nike Shoes',
              'qtyOrdered': 1,
              'qtyInvoiced': 1,
              'qtyShipped': 1,
              'qtyRefunded': 1,
              'price': 99,
              'total': 99,
              'amountRefunded': 99,
            },
          },
        ],
      },
    });

    await tester.pumpWidget(refundApp(order));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Refunds'));
    await tester.pumpAndSettle();

    final tab = find.byKey(const ValueKey('order_refunds_tab'));
    expect(tab, findsOneWidget);
    Finder inTab(String text) =>
        find.descendant(of: tab, matching: find.text(text));
    expect(inTab('Nike Shoes'), findsOneWidget);
    expect(inTab('SKU : Ring-001'), findsOneWidget);
    // Item quantities use the same rows as invoice item cards.
    for (final label in [
      'Ordered Qty',
      'Shipped Qty',
      'Invoiced Qty',
      'Refunded Qty',
    ]) {
      expect(inTab(label), findsOneWidget, reason: label);
    }
    expect(inTab(': 1'), findsNWidgets(4));
    expect(inTab('Unit Price:'), findsOneWidget);
    expect(inTab('Sub Total:'), findsOneWidget);
    for (final label in [
      'Shipping & Handling',
      'Tax',
      'Grand Total',
      'Total Paid',
      'Total Refunded',
      'Total Due',
    ]) {
      expect(inTab(label), findsOneWidget, reason: label);
    }
    // Tax is listed even at zero, like the web; nothing is due.
    expect(inTab(r'$0.00'), findsNWidgets(2));
    expect(inTab(r'$109.00'), findsNWidgets(3));
  });

  testWidgets('order without refunds has no Refunds tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      refundApp(
        const OrderDetail(
          incrementId: '3',
          status: 'completed',
          grandTotal: 10,
          subTotal: 10,
          orderCurrencyCode: 'USD',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Refunds'), findsNothing);
  });

  testWidgets('tapping More info shows selected options', (
    WidgetTester tester,
  ) async {
    final repository = _FakeAccountRepository(
      order: const OrderDetail(
        incrementId: '2466',
        status: 'processing',
        grandTotal: 14,
        subTotal: 14,
        orderCurrencyCode: 'USD',
        createdAt: '2026-05-20T10:00:00.000Z',
        items: [
          OrderItem(
            name: 'Arctic Cozy Knit Unisex Beanie',
            qtyOrdered: 1,
            qtyShipped: 0,
            qtyInvoiced: 1,
            price: 14,
            total: 14,
            additional: {
              'options': [
                {'label': 'Color', 'value': 'Blue'},
                {'label': 'Size', 'value': 'M'},
              ],
            },
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) =>
              OrderDetailBloc(repository: repository)
                ..add(const LoadOrderDetail(2466)),
          child: const OrderDetailPage(orderId: 2466),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('More info'), findsOneWidget);
    expect(find.text('Color'), findsNothing);
    expect(find.text('Blue'), findsNothing);
    expect(find.text('Size'), findsNothing);
    expect(find.text('M'), findsNothing);

    await tester.tap(find.text('More info'));
    await tester.pumpAndSettle();

    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    expect(find.text('Size'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
  });

  testWidgets('More info is hidden when order item has no selected options', (
    WidgetTester tester,
  ) async {
    final repository = _FakeAccountRepository(
      order: const OrderDetail(
        incrementId: '2466',
        status: 'processing',
        grandTotal: 14,
        subTotal: 14,
        orderCurrencyCode: 'USD',
        createdAt: '2026-05-20T10:00:00.000Z',
        items: [
          OrderItem(
            name: 'Arctic Cozy Knit Unisex Beanie',
            sku: 'BEANIE-001',
            qtyOrdered: 1,
            qtyShipped: 0,
            qtyInvoiced: 1,
            price: 14,
            total: 14,
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) =>
              OrderDetailBloc(repository: repository)
                ..add(const LoadOrderDetail(2466)),
          child: const OrderDetailPage(orderId: 2466),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('More info'), findsNothing);
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
}
