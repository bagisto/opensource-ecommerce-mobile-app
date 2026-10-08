import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/category/presentation/bloc/category_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

CategoryModel _category(int id, String name) => CategoryModel(
  id: '/api/shop/categories/$id',
  numericId: id,
  position: id,
  status: '1',
  translation: CategoryTranslation(name: name, slug: name.toLowerCase()),
);

class _FakeCategoryRepository extends CategoryRepository {
  _FakeCategoryRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(),
        ),
      );

  int loadCalls = 0;
  final filters = <String>[];

  @override
  Future<List<CategoryModel>> getCategoryTabCategories() async {
    loadCalls++;
    return [_category(8, 'Electronics'), _category(23, 'Furniture')];
  }

  @override
  Future<PaginatedProducts> getFilterProducts({
    required String filter,
    String? sortKey,
    bool? reverse,
    int? first,
    int? last,
    String? after,
    String? before,
    bool useCacheFirst = false,
  }) async {
    filters.add(filter);
    return const PaginatedProducts(
      totalCount: 0,
      pageInfo: PageInfo(),
      products: [],
    );
  }
}

void main() {
  test('ShowCategory loads categories first and selects the requested one',
      () async {
    final repository = _FakeCategoryRepository();
    final bloc = CategoryBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const ShowCategory(23));
    await bloc.stream.firstWhere(
      (s) => s.selectedCategory?.numericId == 23,
    );

    expect(repository.loadCalls, 1);
    expect(bloc.state.selectedCategory?.name, 'Furniture');
    expect(repository.filters.last, '{"category_id":23}');
  });

  test('ShowCategory ignores ids that are not top-level categories', () async {
    final repository = _FakeCategoryRepository();
    final bloc = CategoryBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const ShowCategory(99));
    await bloc.stream.firstWhere((s) => s.status == CategoryStatus.loaded);
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.selectedCategory?.numericId, 8);
  });
}
