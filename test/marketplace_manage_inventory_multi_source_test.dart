import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/models/seller_inventory_source.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/repository/seller_inventory_source_repository.dart';
import 'package:bagisto_flutter/marketplace/features/manage_inventory/data/models/seller_manage_inventory.dart';
import 'package:bagisto_flutter/marketplace/features/manage_inventory/data/repository/seller_manage_inventory_repository.dart';
import 'package:bagisto_flutter/marketplace/features/manage_inventory/presentation/bloc/seller_manage_inventory_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeManageRepo extends SellerManageInventoryRepository {
  _FakeManageRepo({
    required this.items,
    this.productInventories = const {},
  }) : super(
          client: GraphQLClient(
            link: Link.from([]),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        );

  final List<SellerManageInventoryItem> items;
  final Map<int, int> productInventories;
  List<SellerInventoryQtyEdit>? savedEdits;

  @override
  Future<SellerManageInventoryResultPage> list({
    int first = 20,
    String? after,
    String? search,
    int? status,
    String? type,
  }) async {
    return SellerManageInventoryResultPage(
      items: items,
      hasNextPage: false,
      endCursor: null,
      totalCount: items.length,
    );
  }

  @override
  Future<Map<int, int>> getProductInventories(String manageInventoryId) async {
    return productInventories;
  }

  @override
  Future<void> saveQuantities(List<SellerInventoryQtyEdit> edits) async {
    savedEdits = edits;
  }
}

class _FakeSourceRepo extends SellerInventorySourceRepository {
  _FakeSourceRepo(this.sources)
      : super(
          client: GraphQLClient(
            link: Link.from([]),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        );

  final List<SellerInventorySource> sources;

  @override
  Future<PaginatedResult<SellerInventorySource>> list({
    int page = 1,
    String? search,
    int? status,
  }) async {
    return PaginatedResult<SellerInventorySource>(
      items: sources,
      totalCount: sources.length,
      currentPage: 1,
      lastPage: 1,
    );
  }
}

void main() {
  const sourceDefault = SellerInventorySource(
    iri: SellerIri('/api/seller/inventory_sources/2'),
    id: 2,
    code: 'vendor_1_default',
    name: 'Default',
    status: true,
  );

  const sourceName = SellerInventorySource(
    iri: SellerIri('/api/seller/inventory_sources/6'),
    id: 6,
    code: 'code',
    name: 'name',
    status: true,
  );

  const sampleItem = SellerManageInventoryItem(
    id: '/api/seller/seller_manage_inventories/92',
    productId: 127,
    name: 'Simple aman',
    sku: 'wdqewfqqwer',
    type: 'simple',
    quantity: 0,
    manageStock: true,
  );

  test('cubit load sets multiple inventory sources and canEditStock is true', () async {
    final cubit = SellerManageInventoryCubit(
      repository: _FakeManageRepo(items: [sampleItem]),
      inventorySourceRepository: _FakeSourceRepo([sourceDefault, sourceName]),
    );

    await cubit.load();

    expect(cubit.state.status, SellerManageInventoryStatus.loaded);
    expect(cubit.state.sources.length, 2);
    expect(cubit.state.sources[0].name, 'Default');
    expect(cubit.state.sources[1].name, 'name');
    expect(cubit.state.canEditStock, isTrue);

    await cubit.close();
  });

  test('toggleExpand fetches product source breakdown and caches it', () async {
    final cubit = SellerManageInventoryCubit(
      repository: _FakeManageRepo(
        items: [sampleItem],
        productInventories: {2: 5, 6: 10},
      ),
      inventorySourceRepository: _FakeSourceRepo([sourceDefault, sourceName]),
    );

    await cubit.load();
    await cubit.toggleExpand(sampleItem);

    expect(cubit.state.expandedProductIds.contains(sampleItem.productId), isTrue);
    expect(cubit.state.getQuantity(sampleItem.productId, 2, 0), 5);
    expect(cubit.state.getQuantity(sampleItem.productId, 6, 0), 10);
    expect(cubit.state.getProductTotalStock(sampleItem), 15);

    await cubit.close();
  });

  test('setSourceQuantity records edits and saveEdits persists them', () async {
    final repo = _FakeManageRepo(
      items: [sampleItem],
      productInventories: {2: 0, 6: 0},
    );
    final cubit = SellerManageInventoryCubit(
      repository: repo,
      inventorySourceRepository: _FakeSourceRepo([sourceDefault, sourceName]),
    );

    await cubit.load();
    await cubit.toggleExpand(sampleItem);

    // Edit source 2 ("Default") to 7
    cubit.setSourceQuantity(sampleItem, 2, 7);
    expect(cubit.state.hasEdits, isTrue);
    expect(cubit.state.isSourceChanged(sampleItem.productId, 2), isTrue);
    expect(cubit.state.isSourceChanged(sampleItem.productId, 6), isFalse);
    expect(cubit.state.getQuantity(sampleItem.productId, 2, 0), 7);
    expect(cubit.state.getProductTotalStock(sampleItem), 7);

    // Save edits
    final success = await cubit.saveEdits();
    expect(success, isTrue);
    expect(cubit.state.hasEdits, isFalse);
    expect(cubit.state.items.first.quantity, 7);
    expect(repo.savedEdits, isNotNull);
    expect(repo.savedEdits!.length, 1);
    expect(repo.savedEdits!.first.productId, 127);
    expect(repo.savedEdits!.first.inventorySourceId, 2);
    expect(repo.savedEdits!.first.qty, 7);

    await cubit.close();
  });
}
