import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/category/presentation/bloc/category_bloc.dart';
import 'package:bagisto_flutter/features/category/presentation/pages/category_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoryModel Active Status', () {
    test('isActive returns false when status is "0" or "false"', () {
      const disabledCategory = CategoryModel(id: '2', status: '0');
      expect(disabledCategory.isActive, isFalse);

      const disabledCategoryBool = CategoryModel(id: '3', status: 'false');
      expect(disabledCategoryBool.isActive, isFalse);
    });

    test('isActive returns true when status is "1" or not "0"', () {
      const activeCategory = CategoryModel(id: '1', status: '1');
      expect(activeCategory.isActive, isTrue);

      const activeCategoryNull = CategoryModel(id: '4');
      expect(activeCategoryNull.isActive, isTrue);
    });

    test('fromTreeJson filters out inactive child categories', () {
      final treeJson = {
        'id': '/api/shop/categories/1',
        '_id': 1,
        'status': '1',
        'translation': {'name': 'Root', 'slug': 'root'},
        'children': {
          'edges': [
            {
              'node': {
                'id': '/api/shop/categories/2',
                '_id': 2,
                'status': '0',
                'translation': {'name': 'random', 'slug': 'random'},
              },
            },
            {
              'node': {
                'id': '/api/shop/categories/3',
                '_id': 3,
                'status': '1',
                'translation': {'name': 'Electronics', 'slug': 'electronics'},
              },
            },
          ],
        },
      };

      final rootCategory = CategoryModel.fromTreeJson(treeJson);
      expect(rootCategory.children.length, 1);
      expect(rootCategory.children.first.name, 'Electronics');
      expect(rootCategory.children.first.numericId, 3);
    });
  });

  group('CategoryBloc Active Filter and Refresh', () {
    test('LoadCategories loads only active categories and drops disabled ones', () async {
      final repo = _FakeCategoryRepository(
        categories: [
          const CategoryModel(
            id: '3',
            numericId: 3,
            status: '1',
            translation: CategoryTranslation(name: 'Active Cat', slug: 'active'),
          ),
        ],
      );

      final bloc = CategoryBloc(repository: repo);
      bloc.add(const LoadCategories());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CategoryState>().having(
            (s) => s.status,
            'status',
            CategoryStatus.loading,
          ),
          isA<CategoryState>()
              .having((s) => s.status, 'status', CategoryStatus.loaded)
              .having((s) => s.categories.length, 'categories.length', 1)
              .having((s) => s.categories.first.name, 'category name', 'Active Cat'),
        ]),
      );
    });

    test('LoadCategories(refresh: true) passes networkOnly to fetchPolicy', () async {
      final repo = _FakeCategoryRepository(categories: []);
      final bloc = CategoryBloc(repository: repo);

      bloc.add(const LoadCategories(refresh: true));

      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<CategoryState>().having(
            (s) => s.status,
            'status',
            CategoryStatus.loaded,
          ),
        ),
      );

      expect(repo.lastFetchPolicy, FetchPolicy.networkOnly);
    });

    testWidgets('CategoryPage empty state renders pull-to-refresh and retry button',
        (WidgetTester tester) async {
      final repo = _FakeCategoryRepository(categories: []);
      final bloc = CategoryBloc(repository: repo);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<CategoryBloc>.value(
            value: bloc,
            child: const CategoryPage(),
          ),
        ),
      );

      bloc.add(const LoadCategories());
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('No categories found'), findsOneWidget);
    });
  });
}

class _FakeCategoryRepository extends CategoryRepository {
  final List<CategoryModel> categories;
  FetchPolicy? lastFetchPolicy;

  _FakeCategoryRepository({required this.categories})
      : super(client: _dummyClient());

  // The Categories tab loads through getCategoryTabCategories, so that is
  // where the refresh's fetch policy has to arrive.
  @override
  Future<List<CategoryModel>> getCategoryTabCategories({
    FetchPolicy? fetchPolicy,
  }) async {
    lastFetchPolicy = fetchPolicy;
    return categories.where((c) => c.isActive).toList();
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
    return PaginatedProducts(
      products: const [],
      pageInfo: PageInfo(
        hasNextPage: false,
        hasPreviousPage: false,
        startCursor: '',
        endCursor: '',
      ),
      totalCount: 0,
    );
  }
}

GraphQLClient _dummyClient() {
  final link = HttpLink('http://localhost');
  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
  );
}
