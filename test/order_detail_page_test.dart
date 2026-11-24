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
  testWidgets('refunded order shows the refund breakdown', (
    WidgetTester tester,
  ) async {
    final order = OrderDetail.fromJson({
      'incrementId': '2470',
      'status': 'closed',
      'orderCurrencyCode': 'USD',
      'grandTotal': 40,
      'subTotal': 30,
      'grandTotalRefunded': 40,
      'subTotalRefunded': 30,
      'shippingRefunded': 5,
      'taxAmountRefunded': 5,
      'discountRefunded': 0,
      'items': {
        'edges': [
          {
            'node': {
              'name': 'Beanie',
              'qtyOrdered': 2,
              'qtyRefunded': 2,
              'qtyCanceled': 0,
              'price': 15,
              'total': 30,
            },
          },
        ],
      },
    });
    expect(order.subTotalRefunded, 30);
    expect(order.shippingRefunded, 5);

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

    await tester.scrollUntilVisible(find.text('Refund Breakdown'), 200);
    expect(find.text('Subtotal Refunded'), findsOneWidget);
    expect(find.text('Shipping Refunded'), findsOneWidget);
    expect(find.text('Tax Refunded'), findsOneWidget);
    expect(find.text('Discount Refunded'), findsNothing);
    expect(find.text('Refunded'), findsWidgets);
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

  testWidgets('Invoices and Shipments tabs hide when the order has none', (
    WidgetTester tester,
  ) async {
    final repository = _FakeAccountRepository(
      order: const OrderDetail(
        incrementId: '5',
        status: 'pending',
        grandTotal: 10,
        subTotal: 10,
        orderCurrencyCode: 'USD',
        items: [
          OrderItem(name: 'Ring', qtyOrdered: 1, price: 10, total: 10),
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
                ..add(const LoadOrderDetail(5)),
          child: const OrderDetailPage(orderId: 5),
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
    final repository = _FakeAccountRepository(
      order: const OrderDetail(
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
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) =>
              OrderDetailBloc(repository: repository)
                ..add(const LoadOrderDetail(6)),
          child: const OrderDetailPage(orderId: 6),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Invoices'), findsOneWidget);
    expect(find.text('Shipments'), findsNothing);
  });
  testWidgets('EU withdrawal dialog shows Submit button for logged in user', (
    WidgetTester tester,
  ) async {
    final repository = _FakeAccountRepository(
      order: const OrderDetail(
        incrementId: '29',
        numericId: 29,
        status: 'pending',
        grandTotal: 196,
        subTotal: 196,
        orderCurrencyCode: 'USD',
        items: [
          OrderItem(
            name: 'Item',
            qtyOrdered: 1,
            price: 196,
            total: 196,
          ),
        ],
      ),
      euWithdrawalEnabled: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) =>
              OrderDetailBloc(repository: repository)
                ..add(const LoadOrderDetail(29)),
          child: const OrderDetailPage(orderId: 29),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final withdrawButton = find.byKey(const ValueKey('order_eu_withdraw'));
    expect(withdrawButton, findsOneWidget);
    await tester.tap(withdrawButton);
    await tester.pumpAndSettle();

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Send me the withdrawal link'), findsNothing);
  });

  testWidgets(
    'shows View your withdrawal button when request exists and opens receipt',
    (WidgetTester tester) async {
      final repository = _FakeAccountRepository(
        order: const OrderDetail(
          incrementId: '28',
          numericId: 28,
          status: 'pending',
          customerEmail: 'aman@gmail.com',
          grandTotal: 100,
          subTotal: 100,
          orderCurrencyCode: 'USD',
          items: [
            OrderItem(name: 'Item', qtyOrdered: 1, price: 100, total: 100),
          ],
        ),
        euWithdrawalEnabled: true,
        euWithdrawal: const EuWithdrawal(
          id: '/api/shop/eu-withdrawals/4',
          orderId: 28,
          orderIncrementId: '28',
          status: 'received',
          uuid: '58c27891-ab51-46ee-8df3-5d3c26159c9a',
          receivedAt: '2026-10-21T05:54:33.000000Z',
          customerEmail: 'aman@gmail.com',
          reasonText: 'Changed my mind',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider(
            create: (_) =>
                OrderDetailBloc(repository: repository)
                  ..add(const LoadOrderDetail(28)),
            child: const OrderDetailPage(orderId: 28),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final viewButton = find.byKey(const ValueKey('order_view_eu_withdrawal'));
      expect(viewButton, findsOneWidget);
      expect(find.text('View your withdrawal'), findsOneWidget);

      await tester.tap(viewButton);
      await tester.pumpAndSettle();

      expect(find.text('Withdrawal Receipt'), findsOneWidget);
      expect(find.text('Your withdrawal has been received'), findsOneWidget);
      expect(find.text('58c27891-ab51-46ee-8df3-5d3c26159c9a'), findsOneWidget);
      expect(find.text('#28'), findsOneWidget);
      expect(find.text('aman@gmail.com'), findsOneWidget);
      expect(find.text('Changed my mind'), findsOneWidget);
      expect(find.text('What happens next'), findsOneWidget);
    },
  );
}

class _FakeAccountRepository extends AccountRepository {
  final OrderDetail order;
  final bool euWithdrawalEnabled;
  final EuWithdrawal? euWithdrawal;

  _FakeAccountRepository({
    required this.order,
    this.euWithdrawalEnabled = false,
    this.euWithdrawal,
  }) : super(
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
  Future<EuWithdrawal?> getEuWithdrawalForOrder(int orderId) async =>
      euWithdrawal;

  @override
  Future<List<CustomerOrder>> getReturnableOrders({String? incrementId}) async =>
      const [];
}
