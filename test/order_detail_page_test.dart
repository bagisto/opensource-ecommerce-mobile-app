import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/order_detail_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/order_detail_page.dart';
import 'package:bagisto_flutter/features/account/presentation/widgets/address_form_field.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'store_config_fakes.dart';

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
              'additional': {
                'attributes': [
                  {
                    'attribute_name': 'Booking From',
                    'option_label': '18 October, 2026 01:00 PM',
                  },
                ],
              },
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
    // Booking details from the item's `additional`, like the storefront.
    expect(inTab('Booking From : 18 October, 2026 01:00 PM'), findsOneWidget);
    // Web refund columns: Price, Qty (refunded), Subtotal (refunded).
    expect(inTab('Price'), findsOneWidget);
    expect(inTab('Qty'), findsOneWidget);
    expect(inTab('1'), findsOneWidget);
    // Order-level quantities and payment rows are not part of a refund.
    for (final label in [
      'Ordered Qty',
      'Shipped Qty',
      'Invoiced Qty',
      'Total Paid',
      'Total Due',
      'Tax',
    ]) {
      expect(inTab(label), findsNothing, reason: label);
    }
    // Refund totals come from the order's *Refunded fields.
    expect(inTab('Shipping & Handling'), findsOneWidget);
    expect(inTab(r'$10.00'), findsOneWidget);
    expect(inTab('Grand Total'), findsOneWidget);
    expect(inTab(r'$109.00'), findsOneWidget);
    // Price, item subtotal and refund subtotal.
    expect(inTab(r'$99.00'), findsNWidgets(3));
  });

  testWidgets('Reorder is hidden when the cart page is disabled', (
    WidgetTester tester,
  ) async {
    final config = seededStoreConfigCubit(const {'cartPageEnabled': false});
    addTearDown(config.close);
    await tester.pumpWidget(
      BlocProvider.value(
        value: config,
        child: refundApp(
          const OrderDetail(
            incrementId: '3',
            status: 'completed',
            grandTotal: 10,
            subTotal: 10,
            orderCurrencyCode: 'USD',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reorder'), findsNothing);
  });

  for (final hidden in [true, false]) {
    testWidgets('Reorder button ${hidden ? 'hidden' : 'shown'} by store config', (
      WidgetTester tester,
    ) async {
      final config = seededStoreConfigCubit(
        hidden ? const {'reorderEnabled': false} : const {},
      );
      addTearDown(config.close);
      await tester.pumpWidget(
        BlocProvider.value(
          value: config,
          child: refundApp(
            const OrderDetail(
              incrementId: '3',
              status: 'completed',
              grandTotal: 10,
              subTotal: 10,
              orderCurrencyCode: 'USD',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reorder'), hidden ? findsNothing : findsOneWidget);
    });
  }

  testWidgets('withdraw dialog uses the app input field style', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) => OrderDetailBloc(
            repository: _FakeAccountRepository(
              order: const OrderDetail(
                numericId: 2,
                incrementId: '2',
                status: 'processing',
                grandTotal: 10,
                subTotal: 10,
                orderCurrencyCode: 'USD',
              ),
              euWithdrawalEnabled: true,
            ),
          )..add(const LoadOrderDetail(2)),
          child: const OrderDetailPage(orderId: 2),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('order_eu_withdraw')));
    await tester.tap(find.byKey(const ValueKey('order_eu_withdraw')));
    await tester.pumpAndSettle();

    expect(find.byType(AddressFormField), findsOneWidget);
  });

  testWidgets('Invoices and Shipments tabs hide when the order has none', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      refundApp(
        const OrderDetail(
          incrementId: '5',
          status: 'pending',
          grandTotal: 10,
          subTotal: 10,
          orderCurrencyCode: 'USD',
          items: [
            OrderItem(name: 'Ring', qtyOrdered: 1, price: 10, total: 10),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Invoices'), findsNothing);
    expect(find.text('Shipments'), findsNothing);
  });

  testWidgets('only the tabs with data are shown', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      refundApp(
        const OrderDetail(
          incrementId: '6',
          status: 'processing',
          grandTotal: 10,
          subTotal: 10,
          orderCurrencyCode: 'USD',
          items: [
            OrderItem(
              name: 'Ring',
              qtyOrdered: 1,
              qtyInvoiced: 1,
              price: 10,
              total: 10,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Invoices'), findsOneWidget);
    expect(find.text('Shipments'), findsNothing);
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

  final bool euWithdrawalEnabled;

  _FakeAccountRepository({required this.order, this.euWithdrawalEnabled = false})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<OrderDetail> getCustomerOrder(int orderId) async => order;

  @override
  Future<bool> isEuWithdrawalEnabled() async => euWithdrawalEnabled;

  @override
  Future<EuWithdrawal?> getEuWithdrawalForOrder(int orderId) async => null;

  @override
  Future<List<CustomerOrder>> getReturnableOrders({String? incrementId}) async =>
      const [];
}
