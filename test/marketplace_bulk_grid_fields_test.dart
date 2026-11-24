import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_bulk_ops.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_bulk_ops_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/bloc/seller_bulk_ops_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_bulk_grid_page.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// What the pricing grid puts in its boxes.
///
/// Every field read the server's value and ignored the change waiting to be
/// saved, so a date picked from the calendar stayed blank and the figures a
/// mass action worked out never appeared — the seller could only tell it had
/// worked by saving and reloading.
class _Products implements SellerProductRepository {
  _Products({this.dated = true});

  /// Whether the product already has a sale window, so a test can start from
  /// the empty fields a seller sees on a product that has none.
  final bool dated;

  @override
  Future<PaginatedResult<SellerProductListItem>> list({
    int page = 1,
    SellerProductFilters filters = const SellerProductFilters(),
  }) async => PaginatedResult(
    items: [
      SellerProductListItem(
        iri: const SellerIri('/theme/api-4.9/public/api/seller/products/41'),
        productId: 61,
        sku: 'demo-mug',
        name: 'Stoneware Mug',
        type: 'simple',
        price: 12.5,
        specialPrice: 11,
        specialPriceFrom: dated ? '2026-08-01' : null,
        specialPriceTo: dated ? '2026-08-31' : null,
        quantity: 4,
      ),
    ],
    totalCount: 1,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Bulk implements SellerBulkOpsRepository {
  /// The rows whose drawers were opened, so a test can prove the read happens
  /// on demand rather than for the whole page.
  final opened = <String>[];

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<List<SellerGroupPrice>> tiersFor(SellerIri iri) async {
    opened.add(iri.value);
    return const [
      SellerGroupPrice(
        tierId: 61,
        customerGroupId: 3,
        customerGroupName: 'Wholesale',
        qty: 5,
        valueType: 'discount',
        value: 10,
      ),
    ];
  }

  @override
  Future<List<SellerCustomerGroup>> customerGroups() async => const [
    SellerCustomerGroup(id: 1, code: 'guest', label: 'Guest'),
    SellerCustomerGroup(id: 2, code: 'general', label: 'General'),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<SellerBulkGridCubit> _pump(
  WidgetTester tester, {
  bool dated = true,
}) async {
  final bulk = _Bulk();
  final cubit = SellerBulkGridCubit(
    bulkRepository: bulk,
    productRepository: _Products(dated: dated),
  );
  await cubit.load();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: const SellerBulkGridPage(stockSourceId: 5),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

/// The text a field is showing.
String _text(WidgetTester tester, Key key) {
  final field = tester.widget<TextField>(find.byKey(key));
  return field.controller?.text ?? '';
}

void main() {
  testWidgets('a row opens on the sale price and dates the product holds', (
    tester,
  ) async {
    await _pump(tester);

    expect(_text(tester, const Key('bulkPrice_61')), '12.50');
    expect(_text(tester, const Key('bulkSalePrice_61')), '11.00');
    expect(find.text('2026-08-01'), findsOneWidget);
    expect(find.text('2026-08-31'), findsOneWidget);
  });

  testWidgets('a date picked from the calendar is shown, not lost', (
    tester,
  ) async {
    // Starting from a product with no sale window, which is where the seller
    // saw nothing at all appear.
    final cubit = await _pump(tester, dated: false);

    expect(find.text('dd/mm/yyyy'), findsNWidgets(2));

    await tester.tap(find.byKey(const Key('bulkValidFrom_61')));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final picked = cubit.state.priceEdits[61]?.specialPriceFrom;
    expect(picked, matches(r'^\d{4}-\d{2}-\d{2}$'));
    // On screen, not just queued: one placeholder is left, and it is the day
    // the calendar handed back that replaced the other.
    expect(find.text('dd/mm/yyyy'), findsOneWidget);
    expect(find.text(picked!), findsOneWidget);
  });

  testWidgets('a mass action puts its figures on screen', (tester) async {
    final cubit = await _pump(tester);

    cubit.toggleSelectAll();
    cubit.applyToSelected(
      action: SellerBulkAction.increaseBy,
      mode: SellerBulkMode.amount,
      value: 2.5,
    );
    await tester.pumpAndSettle();

    expect(_text(tester, const Key('bulkPrice_61')), '15.00');
  });

  testWidgets('typing does not move the caret', (tester) async {
    // The value flows back from the queued edit, so a field rebuilt on it
    // would jump to the start on every keystroke.
    await _pump(tester);

    await tester.tap(find.byKey(const Key('bulkPrice_61')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('bulkPrice_61')), '19.9');
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(
      find.byKey(const Key('bulkPrice_61')),
    );
    expect(field.controller?.text, '19.9');
    expect(field.controller?.selection.baseOffset, 4);
  });

  testWidgets('a drawer opens on the tiers the product holds', (tester) async {
    // They used to open empty: nothing read a product's tiers back, so the
    // app could only write them. `sellerProduct.customerGroupPrices` was added
    // on 2026-08-19 and the drawer reads it when it is opened.
    final cubit = await _pump(tester);

    expect(find.byKey(const Key('bulkTierAdd_61')), findsNothing);

    await tester.tap(find.byKey(const Key('bulkTiers_61')));
    await tester.pumpAndSettle();

    expect(cubit.state.tiers[61], hasLength(1));
    expect(cubit.state.tiers[61]!.single.tierId, 61);
    expect(find.text('Wholesale'), findsOneWidget);
  });

  testWidgets('the tier value type dropdown fits in the pricing row', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pump(tester);

    await tester.tap(find.byKey(const Key('bulkTiers_61')));
    await tester.pumpAndSettle();

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(field.isExpanded, isTrue);
    expect(tester.takeException(), isNull);
  });
}
