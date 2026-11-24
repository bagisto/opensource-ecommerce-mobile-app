import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_bulk_ops.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_bulk_ops_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/bloc/seller_bulk_ops_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// The bulk pricing grid, against the panel's own.
///
/// The panel's grid at /seller/pricing edits four things per product — sale
/// price, price, valid from, valid to — and pages through the catalogue with a
/// search box. The app offered one price box on the first ten products.
///
/// `createSellerPricingMassSave` takes all four; verified live 2026-08-18 on
/// product 353, which came back with specialPriceFrom 2026-09-01 and
/// specialPriceTo 2026-09-30.
SellerProductListItem _item(int id, String sku, {double? price}) {
  return SellerProductListItem(
    iri: SellerIri('/theme/api-4.9/public/api/seller/products/$id'),
    productId: id + 20,
    sku: sku,
    name: sku.toUpperCase(),
    type: 'simple',
    price: price,
    specialPrice: 11,
    specialPriceFrom: '2026-08-01',
    specialPriceTo: '2026-08-31',
    quantity: 4,
  );
}

class _Products implements SellerProductRepository {
  final requests = <(int, String?)>[];

  @override
  Future<PaginatedResult<SellerProductListItem>> list({
    int page = 1,
    SellerProductFilters filters = const SellerProductFilters(),
  }) async {
    requests.add((page, filters.search));

    if (filters.search == 'mug') {
      return PaginatedResult(
        items: [_item(41, 'demo-mug', price: 12.5)],
        totalCount: 1,
        lastPage: 1,
        currentPage: 1,
      );
    }

    return PaginatedResult(
      items: page == 1
          ? [_item(41, 'demo-mug', price: 12.5), _item(40, 'demo-tee')]
          : [_item(26, 'nike-air-max', price: 13.5)],
      totalCount: 3,
      lastPage: 2,
      currentPage: page,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Bulk implements SellerBulkOpsRepository {
  final saved = <List<Map<String, Object?>>>[];
  final read = <Map<int, String>>[];

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<List<SellerCustomerGroup>> customerGroups() async => const [
    SellerCustomerGroup(id: 1, code: 'guest', label: 'Guest'),
    SellerCustomerGroup(id: 2, code: 'general', label: 'General'),
    SellerCustomerGroup(id: 3, code: 'wholesale', label: 'Wholesale'),
  ];

  @override
  Future<SellerBulkSaveResult> savePrices(List<SellerPriceEdit> edits) async {
    saved.add(edits.map((edit) => edit.toRecord()).toList());
    return const SellerBulkSaveResult(saved: 1);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<SellerBulkGridCubit> _open(_Products products, _Bulk bulk) async {
  final cubit = SellerBulkGridCubit(
    bulkRepository: bulk,
    productRepository: products,
  );
  await cubit.load();
  return cubit;
}

void main() {
  customerGroupParsingTests();
  test('a row opens on the sale price and the days it runs', () async {
    // The listing carries all four price fields as of 2026-08-19; the grid
    // used to read every row's product separately to fill three of them.
    final cubit = await _open(_Products(), _Bulk());

    final row = cubit.state.products.first;
    expect(row.specialPrice, 11);
    expect(row.specialPriceFrom, '2026-08-01');
    expect(row.specialPriceTo, '2026-08-31');
  });

  test('the dates the server sends are read as days', () {
    // "2026-09-01T00:00:00+05:30" is what comes back; the grid shows and
    // sends the day.
    final row = SellerProductListItem.fromJson(const {
      'id': '/api/seller/products/41',
      'productId': 61,
      'sku': 'demo-mug',
      'name': 'Stoneware Mug',
      'type': 'simple',
      'price': 200,
      'specialPrice': 150,
      'specialPriceFrom': '2026-09-01T00:00:00+05:30',
      'specialPriceTo': '2026-09-30T00:00:00+05:30',
    });

    expect(row.specialPriceFrom, '2026-09-01');
    expect(row.specialPriceTo, '2026-09-30');
  });

  test('all four fields travel on one row of the save', () async {
    final products = _Products();
    final bulk = _Bulk();
    final cubit = await _open(products, bulk);

    // Typed one field at a time, as a seller fills the row in.
    cubit.editPrice(61, price: 20);
    cubit.editPrice(61, specialPrice: 15);
    cubit.editPrice(61, specialPriceFrom: '2026-09-01');
    cubit.editPrice(61, specialPriceTo: '2026-09-30');

    await cubit.savePrices();

    expect(bulk.saved.single.single, {
      'productId': 61,
      'price': 20.0,
      'specialPrice': 15.0,
      'specialPriceFrom': '2026-09-01',
      'specialPriceTo': '2026-09-30',
    });
  });

  test('a second field does not wipe the first', () async {
    // editPrice used to replace the whole entry, so typing a sale price after
    // a price sent the sale price alone.
    final products = _Products();
    final cubit = await _open(products, _Bulk());

    cubit.editPrice(61, price: 20);
    cubit.editPrice(61, specialPrice: 15);

    expect(cubit.state.priceEdits[61]?.price, 20);
    expect(cubit.state.priceEdits[61]?.specialPrice, 15);
  });

  test('the whole catalogue is reachable, not just the first page', () async {
    final products = _Products();
    final bulk = _Bulk();
    final cubit = await _open(products, bulk);

    expect(cubit.state.products, hasLength(2));
    expect(cubit.state.hasMore, isTrue);

    await cubit.loadMore();

    expect(cubit.state.products, hasLength(3));
    expect(cubit.state.hasMore, isFalse);
    expect(products.requests, [(1, null), (2, null)]);
  });

  group('mass actions', () {
    // Read off the panel's own bulk toolbar (v-pricing-bulk) on
    // /seller/pricing: action set / increase / decrease, mode amount or
    // percent — hidden for "set" — applied to the price, rounded to the cent
    // and floored at zero by its round(), then the selection is emptied.
    test('one value is set on every selected row', () async {
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelectAll();
      cubit.applyToSelected(
        action: SellerBulkAction.setTo,
        mode: SellerBulkMode.amount,
        value: 20,
      );

      expect(cubit.state.priceEdits[61]?.price, 20);
      expect(cubit.state.priceEdits[60]?.price, 20);
    });

    test('an increase works from what the product charges now', () async {
      // 12.5 comes from the per-row pricing read, not the list.
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelected(61);
      cubit.applyToSelected(
        action: SellerBulkAction.increaseBy,
        mode: SellerBulkMode.amount,
        value: 2.5,
      );

      expect(cubit.state.priceEdits[61]?.price, 15);
      expect(cubit.state.priceEdits.containsKey(60), isFalse);
    });

    test('a percentage is that share of the current price', () async {
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelected(61);
      cubit.applyToSelected(
        action: SellerBulkAction.increaseBy,
        mode: SellerBulkMode.percent,
        value: 10,
      );

      // 12.50 + 10% = 13.75, not 22.50.
      expect(cubit.state.priceEdits[61]?.price, 13.75);
    });

    test('a figure is rounded to the cent', () async {
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelected(61);
      cubit.applyToSelected(
        action: SellerBulkAction.decreaseBy,
        mode: SellerBulkMode.percent,
        value: 33,
      );

      // 12.50 - 33% = 8.375.
      expect(cubit.state.priceEdits[61]?.price, 8.38);
    });

    test('a decrease never takes a price below zero', () async {
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelected(61);
      cubit.applyToSelected(
        action: SellerBulkAction.decreaseBy,
        mode: SellerBulkMode.amount,
        value: 999,
      );

      expect(cubit.state.priceEdits[61]?.price, 0);
    });

    test('applying empties the selection', () async {
      // Otherwise the bar runs again over rows the seller has moved on from.
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelectAll();
      cubit.applyToSelected(
        action: SellerBulkAction.setTo,
        mode: SellerBulkMode.amount,
        value: 20,
      );

      expect(cubit.state.selected, isEmpty);
    });

    test('applying queues, it does not send', () async {
      final bulk = _Bulk();
      final cubit = await _open(_Products(), bulk);

      cubit.toggleSelectAll();
      cubit.applyToSelected(
        action: SellerBulkAction.setTo,
        mode: SellerBulkMode.amount,
        value: 20,
      );

      expect(bulk.saved, isEmpty);
      expect(await cubit.savePrices(), isTrue);
      expect(bulk.saved.single, hasLength(2));
    });

    test('stock is applied in whole units', () async {
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelected(61);
      cubit.applyStockToSelected(
        action: SellerBulkAction.increaseBy,
        qty: 6,
        sourceId: 5,
      );

      // Every row in the fixture holds 4.
      expect(cubit.state.stockEdits[61]?.quantities[5], 10);
    });

    test('a row the bulk endpoints cannot address is never selected', () async {
      final cubit = await _open(_Products(), _Bulk());

      cubit.toggleSelectAll();

      expect(cubit.state.selected, {61, 60});
    });
  });

  group('customer group prices', () {
    // The panel keeps these under each row: what one group pays from a given
    // quantity up, either a fixed price or a discount. The seller API has no
    // customer-group query, so the list comes from the product-discount form's
    // options, and it returns no way to read a product's stored tiers at all.
    test('the groups a tier can be set for are read', () async {
      final cubit = await _open(_Products(), _Bulk());

      expect(cubit.state.customerGroups.map((group) => group.label), [
        'Guest',
        'General',
        'Wholesale',
      ]);
    });

    test('a product nobody touched sends no tiers', () async {
      // The save replaces every group price a product has and the app cannot
      // read the stored ones, so sending an empty list would delete tiers set
      // in the panel. Verified live: an empty list really does delete them.
      final bulk = _Bulk();
      final cubit = await _open(_Products(), bulk);

      cubit.editPrice(61, price: 20);
      await cubit.savePrices();

      expect(
        bulk.saved.single.single.containsKey('customerGroupPrices'),
        isFalse,
      );
    });

    test('the tiers travel with the rest of the row', () async {
      final bulk = _Bulk();
      final cubit = await _open(_Products(), bulk);

      cubit.editPrice(61, price: 20);
      cubit.setTiers(61, const [
        SellerGroupPrice(
          customerGroupId: 3,
          qty: 5,
          valueType: 'discount',
          value: 10,
        ),
      ]);
      await cubit.savePrices();

      expect(bulk.saved.single.single, {
        'productId': 61,
        'price': 20.0,
        'customerGroupPrices': [
          {
            'customerGroupId': 3,
            'qty': 5,
            'valueType': 'discount',
            'value': 10.0,
          },
        ],
      });
    });

    test('a row with no group picked yet is left out', () async {
      final bulk = _Bulk();
      final cubit = await _open(_Products(), bulk);

      cubit.setTiers(61, const [
        SellerGroupPrice(customerGroupId: 2, qty: 1, value: 500),
        SellerGroupPrice(qty: 1, value: 400),
      ]);
      await cubit.savePrices();

      final tiers =
          bulk.saved.single.single['customerGroupPrices']! as List<Object?>;
      expect(tiers, hasLength(1));
    });

    test('clearing the tiers sends the empty set that deletes them', () async {
      final bulk = _Bulk();
      final cubit = await _open(_Products(), bulk);

      cubit.setTiers(61, const []);
      await cubit.savePrices();

      expect(bulk.saved.single.single['customerGroupPrices'], isEmpty);
    });
  });

  test('search asks the server, and starts the list again', () async {
    final products = _Products();
    final cubit = await _open(products, _Bulk());

    await cubit.load(search: 'mug');

    expect(products.requests.last, (1, 'mug'));
    expect(cubit.state.products.single.sku, 'demo-mug');
    expect(cubit.state.page, 1);
    expect(cubit.state.totalCount, 1);
  });
}

void customerGroupParsingTests() {
  test('a group is read from the API\'s _id and name', () {
    final group = SellerCustomerGroup.fromJson({
      '_id': 3,
      'code': 'wholesale',
      'name': 'Wholesale',
      'isUserDefined': false,
    });

    expect(group.id, 3);
    expect(group.label, 'Wholesale');
  });

  test('the older id and label keys still read', () {
    final group = SellerCustomerGroup.fromJson({
      'id': 2,
      'code': 'general',
      'label': 'General',
    });

    expect(group.id, 2);
    expect(group.label, 'General');
  });
}
