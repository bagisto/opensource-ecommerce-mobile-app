import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/data/repository/home_repository.dart';
import 'package:bagisto_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Section 15 on the local server: a product carousel saved with no filters,
/// which the API returns as an empty JSON list.
final _testCarousel = ThemeCustomization.fromJson({
  'id': '/api/shop/sections/15',
  'type': 'product_carousel',
  'name': 'test car',
  'status': '1',
  'sortOrder': 9,
  'translation': {
    'locale': 'en',
    'options': '{"title": "test", "filters": []}',
  },
});

class _FakeHomeRepository extends HomeRepository {
  _FakeHomeRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  final productCalls = <({int first, String? filter})>[];

  @override
  Future<List<ThemeCustomization>> fetchSections() async => [_testCarousel];

  @override
  Future<List<HomeCategory>> fetchHomeCategories({
    int? parentId,
    int? limit,
  }) async => const [];

  @override
  Future<List<HomeProduct>> fetchProducts({
    int first = 8,
    String? filter,
    String sortKey = 'NEWEST',
    bool reverse = true,
  }) async {
    productCalls.add((first: first, filter: filter));
    return const [
      HomeProduct(
        id: '/api/shop/products/1',
        sku: 'test',
        type: 'simple',
        name: 'test',
        urlKey: 'test',
        price: 100,
        isSaleable: true,
      ),
    ];
  }
}

void main() {
  test('carousel with empty filter list has no filters and the admin title',
      () {
    expect(_testCarousel.filters, isEmpty);
    expect(_testCarousel.title, 'test');
  });

  test('title falls back to the section name', () {
    final carousel = ThemeCustomization.fromJson({
      'id': '1',
      'type': 'product_carousel',
      'name': 'New Products',
      'status': '1',
      'translation': {'locale': 'en', 'options': '{"filters": {"new": 1}}'},
    });
    expect(carousel.title, 'New Products');
    expect(carousel.filters, {'new': 1});
  });

  test('product carousel with empty filter list still loads products',
      () async {
    final repository = _FakeHomeRepository();
    final bloc = HomeBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const LoadHome());
    final state = await bloc.stream.firstWhere(
      (s) => s.status == HomeStatus.loaded,
    );

    expect(state.productSections[_testCarousel.id], hasLength(1));
    expect(repository.productCalls.single.filter, isNull);
  });
}
