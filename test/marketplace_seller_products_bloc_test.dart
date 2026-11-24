import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_products_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

SellerProductListItem _item(String sku) => SellerProductListItem(
  iri: SellerIri('/api/seller/products/$sku'),
  productId: 1,
  sku: sku,
  name: sku,
  type: 'simple',
  price: 10,
  quantity: 5,
);

class _FakeProductRepository implements SellerProductRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
  _FakeProductRepository({required this.pages, this.failWith});

  /// Page number → the rows that page returns.
  final Map<int, List<SellerProductListItem>> pages;
  final SellerApiException? failWith;

  int lastPageRequested = 0;
  SellerProductFilters? lastFilters;
  int listCallCount = 0;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<PaginatedResult<SellerProductListItem>> list({
    int page = 1,
    SellerProductFilters filters = const SellerProductFilters(),
  }) async {
    listCallCount++;
    lastPageRequested = page;
    lastFilters = filters;
    if (failWith != null) throw failWith!;

    return PaginatedResult<SellerProductListItem>(
      items: pages[page] ?? const [],
      totalCount: pages.values.fold(0, (sum, rows) => sum + rows.length),
      lastPage: pages.keys.isEmpty
          ? 1
          : pages.keys.reduce((a, b) => a > b ? a : b),
      currentPage: page,
    );
  }

  @override
  Future<SellerProductDetail> detail(SellerIri iri) =>
      throw UnimplementedError();

  @override
  Future<SellerProductListItem> create({
    required String type,
    required int attributeFamilyId,
    required String sku,
    bool isDraft = false,
    List<Map<String, dynamic>>? superAttributes,
  }) => throw UnimplementedError();

  @override
  Future<SellerProductDetail> update(SellerProductDraft draft) =>
      throw UnimplementedError();

  @override
  Future<void> delete(SellerIri iri) => throw UnimplementedError();

  List<int>? deletedIds;

  @override
  Future<SellerProductDeleteBatch> deleteBatch(List<int> catalogueIds) async {
    deletedIds = catalogueIds;
    return const SellerProductDeleteBatch(
      requested: 1,
      deleted: 1,
      unassigned: 0,
      skipped: 0,
    );
  }

  @override
  Future<List<SellerProductCategoryNode>> assignableCategories() =>
      throw UnimplementedError();

  Future<List<SellerProductListItem>> variantsOf(String parentSku) =>
      throw UnimplementedError();
}

Future<void> _settle(SellerProductsBloc bloc) =>
    Future<void>.delayed(Duration.zero);

void main() {
  test('first load fills rows, total and paging', () async {
    final repository = _FakeProductRepository(
      pages: {
        1: [_item('a'), _item('b')],
        2: [_item('c')],
      },
    );
    final bloc = SellerProductsBloc(repository: repository);

    bloc.add(const LoadSellerProducts());
    await bloc.stream.firstWhere(
      (state) => state.status == SellerProductsStatus.loaded,
    );

    expect(bloc.state.items.map((item) => item.sku), ['a', 'b']);
    expect(bloc.state.totalCount, 3);
    expect(bloc.state.lastPage, 2);
    expect(bloc.state.hasNextPage, isTrue);
  });

  test('load more appends the next page', () async {
    final repository = _FakeProductRepository(
      pages: {
        1: [_item('a')],
        2: [_item('b')],
      },
    );
    final bloc = SellerProductsBloc(repository: repository);

    bloc.add(const LoadSellerProducts());
    await bloc.stream.firstWhere(
      (state) => state.status == SellerProductsStatus.loaded,
    );

    bloc.add(const LoadMoreSellerProducts());
    await bloc.stream.firstWhere(
      (state) => state.items.length == 2 && !state.isLoadingMore,
    );

    expect(bloc.state.items.map((item) => item.sku), ['a', 'b']);
    expect(repository.lastPageRequested, 2);
    expect(bloc.state.hasNextPage, isFalse);
  });

  test('load more on the last page does not call the API again', () async {
    final repository = _FakeProductRepository(
      pages: {
        1: [_item('a')],
      },
    );
    final bloc = SellerProductsBloc(repository: repository);

    bloc.add(const LoadSellerProducts());
    await bloc.stream.firstWhere(
      (state) => state.status == SellerProductsStatus.loaded,
    );
    final callsAfterFirstLoad = repository.listCallCount;

    bloc.add(const LoadMoreSellerProducts());
    await _settle(bloc);

    expect(repository.listCallCount, callsAfterFirstLoad);
  });

  test('a search resets to page one and replaces the rows', () async {
    final repository = _FakeProductRepository(
      pages: {
        1: [_item('shoe')],
      },
    );
    final bloc = SellerProductsBloc(repository: repository);

    bloc.add(const SearchSellerProducts('  shoe  '));
    await bloc.stream.firstWhere(
      (state) => state.status == SellerProductsStatus.loaded,
    );

    expect(repository.lastFilters?.search, 'shoe');
    expect(repository.lastPageRequested, 1);
    expect(bloc.state.items.single.sku, 'shoe');
  });

  test('applying filters carries them into the request', () async {
    final repository = _FakeProductRepository(
      pages: {
        1: [_item('a')],
      },
    );
    final bloc = SellerProductsBloc(repository: repository);

    bloc.add(
      const ApplySellerProductFilters(
        SellerProductFilters(type: 'configurable', isDraft: 1),
      ),
    );
    await bloc.stream.firstWhere(
      (state) => state.status == SellerProductsStatus.loaded,
    );

    expect(repository.lastFilters?.type, 'configurable');
    expect(repository.lastFilters?.isDraft, 1);
    expect(bloc.state.filters.activeCount, 2);
  });

  test('selection toggles and bulk delete sends the catalogue ids', () async {
    final repository = _FakeProductRepository(
      pages: {
        1: [_item('a'), _item('b')],
      },
    );
    final bloc = SellerProductsBloc(repository: repository);

    bloc.add(const LoadSellerProducts());
    await bloc.stream.firstWhere(
      (state) => state.status == SellerProductsStatus.loaded,
    );

    bloc.add(const ToggleSellerProductSelection(50));
    bloc.add(const ToggleSellerProductSelection(51));
    await bloc.stream.firstWhere((state) => state.selected.length == 2);
    expect(bloc.state.isSelecting, isTrue);

    bloc.add(const ToggleSellerProductSelection(51));
    await bloc.stream.firstWhere((state) => state.selected.length == 1);

    bloc.add(const DeleteSelectedSellerProducts());
    await bloc.stream.firstWhere((state) => state.lastBatch != null);

    expect(repository.deletedIds, [50]);
    expect(bloc.state.lastBatch?.removed, 1);
    expect(bloc.state.selected, isEmpty);
  });

  test('clearing the selection empties it', () async {
    final bloc = SellerProductsBloc(
      repository: _FakeProductRepository(
        pages: {
          1: [_item('a')],
        },
      ),
    );

    bloc.add(const ToggleSellerProductSelection(50));
    await bloc.stream.firstWhere((state) => state.selected.isNotEmpty);

    bloc.add(const ClearSellerProductSelection());
    await bloc.stream.firstWhere((state) => state.selected.isEmpty);

    expect(bloc.state.isSelecting, isFalse);
  });

  test('a failure surfaces the server message', () async {
    final repository = _FakeProductRepository(
      pages: const {},
      failWith: const SellerApiException(
        'You do not have permission to perform this action.',
        SellerApiFailure.forbidden,
      ),
    );
    final bloc = SellerProductsBloc(repository: repository);

    bloc.add(const LoadSellerProducts());
    await bloc.stream.firstWhere(
      (state) => state.status == SellerProductsStatus.failed,
    );

    expect(
      bloc.state.errorMessage,
      'You do not have permission to perform this action.',
    );
  });
}
