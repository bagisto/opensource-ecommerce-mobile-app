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
