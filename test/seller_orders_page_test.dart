import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/repository/seller_inventory_source_repository.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order_filters.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/repository/seller_order_repository.dart';
import 'package:bagisto_flutter/marketplace/features/orders/presentation/bloc/seller_order_detail_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/orders/presentation/bloc/seller_orders_bloc.dart';
import 'package:bagisto_flutter/marketplace/features/orders/presentation/pages/seller_orders_page.dart';
import 'package:bagisto_flutter/marketplace/features/orders/presentation/widgets/seller_order_action_sheets.dart';
import 'package:bagisto_flutter/marketplace/features/orders/presentation/widgets/seller_order_filter_sheet.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('payment requires confirmation and updates the order in place', (
    tester,
  ) async {
    final bloc = _TestSellerOrdersBloc(paymentPending: true);
    var calls = 0;
    await tester.pumpWidget(
      BlocProvider<SellerOrdersBloc>.value(
        value: bloc,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SellerOrdersPage(
              onRequestPayment: (context, order) async {
                calls++;
                bloc.add(SellerOrderPayoutUpdated(order.id, 'requested'));
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = find.byKey(const Key('sellerOrderRequestPayment_1'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(calls, 0);
    await tester.tap(find.text('Cancel').last);
    await tester.pumpAndSettle();
    expect(calls, 0);
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Request payment'),
      ).last,
    );
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.byKey(const Key('sellerOrderRequestPayment_1')), findsNothing);
    expect(find.text('Requested'), findsWidgets);
    expect(bloc.state.status, SellerOrdersStatus.loaded);
  });

  testWidgets(
    'does not render payout quick-filter chips on the seller orders list',
    (WidgetTester tester) async {
      final bloc = _TestSellerOrdersBloc();

      await tester.pumpWidget(
        BlocProvider<SellerOrdersBloc>.value(
          value: bloc,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: SellerOrdersPage()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Payout pending'), findsNothing);
      expect(find.text('Payment requested'), findsNothing);
    },
  );

  testWidgets('does not show payout status in the seller orders filter sheet', (
    WidgetTester tester,
  ) async {
    final bloc = _TestSellerOrdersBloc();

    await tester.pumpWidget(
      BlocProvider<SellerOrdersBloc>.value(
        value: bloc,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SellerOrdersPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerOrdersFilterButton')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('sellerOrderFilterPayoutStatus')),
      findsNothing,
    );
    expect(find.byKey(const Key('sellerOrderFilterStatus')), findsOneWidget);
  });

  testWidgets('order filter fields have visible containers in dark theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: FilledButton(
                onPressed: () => showSellerOrderFilterSheet(
                  context,
                  current: const SellerOrderFilters(),
                ),
                child: const Text('Open filters'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open filters'));
    await tester.pumpAndSettle();

    final statusDropdown = tester.widget<DropdownButtonFormField<String?>>(
      find.byKey(const Key('sellerOrderFilterStatus')),
    );
    expect(statusDropdown.decoration.filled, isTrue);
    expect(statusDropdown.decoration.fillColor, AppColors.neutral900);

    final textFields = tester.widgetList<TextField>(find.byType(TextField));
    expect(textFields, isNotEmpty);
    for (final field in textFields) {
      expect(field.decoration?.filled, isTrue);
      expect(field.decoration?.fillColor, AppColors.neutral900);
    }

    final applyButton = tester.widget<FilledButton>(
      find.byKey(const Key('sellerOrderFilterApply')),
    );
    final applyButtonTheme = Theme.of(
      tester.element(find.byKey(const Key('sellerOrderFilterApply'))),
    );
    expect(applyButton.style?.foregroundColor, isNull);
    expect(applyButtonTheme.colorScheme.onPrimary, AppColors.white);
  });

  testWidgets('invoice quantity values are centered inside their fields', (
    WidgetTester tester,
  ) async {
    final cubit = SellerOrderDetailCubit(
      repository: SellerOrderRepository(client: _dummyClient()),
      inventoryRepository: SellerInventorySourceRepository(
        client: _dummyClient(),
      ),
      orderId: 4,
    );
    const order = SellerOrderDetail(
      summary: SellerOrderSummary(
        id: 4,
        incrementId: 'DEMO-25-4',
        status: 'processing',
      ),
      items: [
        SellerOrderLine(
          id: 1,
          orderItemId: 11,
          name: 'Sectional Sofa Model 746',
          sku: 'SOFA-SECTIONALSOFA-0746',
          qtyOrdered: 3,
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<SellerOrderDetailCubit>.value(
        value: cubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: FilledButton(
                onPressed: () => showSellerInvoiceSheet(context, order: order),
                child: const Text('Open invoice'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open invoice'));
    await tester.pumpAndSettle();

    final qtyField = find.byKey(const Key('orderQty_11'));
    final textField = tester.widget<TextField>(
      find.descendant(of: qtyField, matching: find.byType(TextField)),
    );
    expect(textField.textAlign, TextAlign.center);
    expect(textField.textAlignVertical, TextAlignVertical.center);
  });

  testWidgets('order card figures row has top-aligned labels', (
    WidgetTester tester,
  ) async {
    final bloc = _TestSellerOrdersBloc();

    await tester.pumpWidget(
      BlocProvider<SellerOrdersBloc>.value(
        value: bloc,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SellerOrdersPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final orderTotal = tester.getTopLeft(find.text('Order total'));
    final yourEarnings = tester.getTopLeft(find.text('Your earnings'));
    final items = tester.getTopLeft(find.text('Items'));

    expect(orderTotal.dy, equals(yourEarnings.dy));
    expect(orderTotal.dy, equals(items.dy));
  });
}

class _TestSellerOrdersBloc extends SellerOrdersBloc {
  _TestSellerOrdersBloc({bool paymentPending = false})
    : super(repository: SellerOrderRepository(client: _dummyClient())) {
    emit(
      SellerOrdersState(
        status: SellerOrdersStatus.loaded,
        orders: [
          SellerOrderSummary(
            id: 1,
            incrementId: '100001',
            status: paymentPending ? 'completed' : 'processing',
            customerName: 'Ava Patel',
            customerEmail: 'ava@example.com',
            grandTotal: 149.99,
            sellerTotal: 129.99,
            payoutStatusRaw: paymentPending ? 'pending' : 'paid',
          ),
        ],
        totalCount: 1,
        currentPage: 1,
        lastPage: 1,
      ),
    );
  }
}

GraphQLClient _dummyClient() {
  return GraphQLClient(
    link: Link.function((request, [forward]) => const Stream.empty()),
    cache: GraphQLCache(store: InMemoryStore()),
  );
}
