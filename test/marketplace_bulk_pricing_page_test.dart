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

/// Fakes for the Manage Pricing page: one product, one tier.
class _Products implements SellerProductRepository {
  _Products();

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
        specialPriceFrom: '2026-08-01',
        specialPriceTo: '2026-08-31',
        quantity: 4,
      ),
      // One the seller only resells: its price is theirs, nothing else is.
      const SellerProductListItem(
        iri: SellerIri('/theme/api-4.9/public/api/seller/products/42'),
        productId: 62,
        sku: 'admin-lamp',
        name: 'Admin Lamp',
        type: 'simple',
        price: 324,
        isOwner: false,
      ),
    ],
    totalCount: 2,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Bulk implements SellerBulkOpsRepository {
  _Bulk({this.skipped = 0});

  /// How many rows the server reports as left out of a save.
  final int skipped;

  @override
  Future<SellerBulkSaveResult> savePrices(List<SellerPriceEdit> edits) async =>
      SellerBulkSaveResult(saved: 1, skipped: skipped);

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

void main() {
  testWidgets('Manage Pricing is a single page: no tabs, titled Pricing', (
    tester,
  ) async {
    final cubit = SellerBulkGridCubit(
      bulkRepository: _Bulk(),
      productRepository: _Products(),
    );
    await cubit.load();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          // A stock source is still handed in by the shell; it must not bring
          // the tab back.
          child: const SellerBulkGridPage(stockSourceId: 5),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TabBar), findsNothing);
    expect(find.byType(TabBarView), findsNothing);
    expect(find.text('Stock'), findsNothing);
    expect(find.text('Pricing'), findsOneWidget);

    // The pricing rows are still there and editable.
    expect(find.byKey(const Key('bulkPrice_61')), findsOneWidget);
  });

  testWidgets('a resold product offers its price and nothing else', (
    tester,
  ) async {
    final cubit = SellerBulkGridCubit(
      bulkRepository: _Bulk(),
      productRepository: _Products(),
    );
    await cubit.load();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: const SellerBulkGridPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Owned product: every pricing field.
    expect(find.byKey(const Key('bulkSalePrice_61')), findsOneWidget);
    expect(find.byKey(const Key('bulkValidFrom_61')), findsOneWidget);
    expect(find.byKey(const Key('bulkValidTo_61')), findsOneWidget);
    expect(find.byKey(const Key('bulkTiers_61')), findsOneWidget);

    // Resold product: price only.
    expect(find.byKey(const Key('bulkPrice_62')), findsOneWidget);
    expect(find.byKey(const Key('bulkSalePrice_62')), findsNothing);
    expect(find.byKey(const Key('bulkValidFrom_62')), findsNothing);
    expect(find.byKey(const Key('bulkValidTo_62')), findsNothing);
    expect(find.byKey(const Key('bulkTiers_62')), findsNothing);
  });

  Future<void> saveOnePrice(WidgetTester tester, {required int skipped}) async {
    final cubit = SellerBulkGridCubit(
      bulkRepository: _Bulk(skipped: skipped),
      productRepository: _Products(),
    );
    await cubit.load();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: const SellerBulkGridPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    cubit.editPrice(62, price: 330);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerBulkSave')));
    await tester.pumpAndSettle();
  }

  testWidgets('a clean save says the prices were saved', (tester) async {
    await saveOnePrice(tester, skipped: 0);

    expect(find.text('Prices saved successfully.'), findsOneWidget);
    expect(find.text('1 saved, 0 skipped'), findsNothing);
  });

  testWidgets('a save that left rows out still shows the counts', (
    tester,
  ) async {
    await saveOnePrice(tester, skipped: 2);

    expect(find.text('1 saved, 2 skipped'), findsOneWidget);
  });
}
