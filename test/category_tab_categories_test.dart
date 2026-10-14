import 'dart:convert';

import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/category/presentation/bloc/category_bloc.dart';
import 'package:bagisto_flutter/features/category/presentation/pages/category_page.dart';
import 'package:bagisto_flutter/features/category/presentation/widgets/category_banner.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> _translation(int id, String name) => {
  '__typename': 'CategoryTranslation',
  'id': '/api/shop/category-translations/$id',
  'name': name,
  'slug': name.toLowerCase().replaceAll(' ', '-'),
  'description': null,
  'urlPath': '',
};

Map<String, dynamic> _child(int id, String name, String status) => {
  '__typename': 'Category',
  'id': '/api/shop/categories/$id',
  '_id': id,
  'position': 1,
  'status': status,
  'logoUrl': null,
  'bannerUrl': null,
  'translation': _translation(id, name),
};

Map<String, dynamic> _category(
  int id,
  String name, {
  int? parentId,
  int position = 1,
  String status = '1',
  List<Map<String, dynamic>> children = const [],
}) => {
  '__typename': 'Category',
  'id': '/api/shop/categories/$id',
  '_id': id,
  'position': position,
  'status': status,
  'logoUrl': null,
  'bannerUrl': null,
  'parent': parentId == null
      ? null
      : {
          '__typename': 'Category',
          'id': '/api/shop/categories/$parentId',
          '_id': parentId,
        },
  'translation': _translation(id, name),
  'children': {
    '__typename': 'CategoryCollection',
    'edges': [
      for (final c in children) {'__typename': 'CategoryEdge', 'node': c},
    ],
  },
};

/// Same shape as the test server on 2026-09-17.
List<Map<String, dynamic>> _serverCategories() => [
  _category(1, 'Root', children: [_child(2, 'Men', '1')]),
  _category(
    2,
    'Men',
    parentId: 1,
    children: [_child(3, 'Winter Wear', '1'), _child(8, 'Ties', '0')],
  ),
  _category(3, 'Winter Wear', parentId: 2),
  _category(5, 'bangles', position: 2),
  _category(6, 'books', position: 3),
  _category(7, 'bottles', position: 33),
  _category(9, 'Hidden', position: 4, status: '0'),
];

CategoryRepository _repository(
  List<Map<String, dynamic>> categories, {
  List<Map<String, dynamic>> Function(Map<String, dynamic> body)? onRequest,
}) {
  final httpClient = MockClient((request) async {
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    onRequest?.call(body);
    return http.Response(
      jsonEncode({
        'data': {
          '__typename': 'Query',
          'categories': {
            '__typename': 'CategoryCursorConnection',
            'pageInfo': {
              '__typename': 'CategoryPageInfo',
              'hasNextPage': false,
              'endCursor': null,
            },
            'edges': [
              for (final c in categories)
                {'__typename': 'CategoryEdge', 'node': c},
            ],
          },
        },
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  });
  return CategoryRepository(
    client: GraphQLClient(
      link: HttpLink('https://example.com/graphql', httpClient: httpClient),
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}

class _FakeRepository extends CategoryRepository {
  _FakeRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  bool treeCalled = false;

  @override
  Future<List<CategoryModel>> getCategoryTabCategories() async => const [
    CategoryModel(
      id: '/api/shop/categories/2',
      numericId: 2,
      bannerUrl: 'https://example.com/men.webp',
      translation: CategoryTranslation(name: 'Men'),
      children: [
        CategoryModel(
          id: '/api/shop/categories/3',
          numericId: 3,
          translation: CategoryTranslation(name: 'Winter Wear'),
        ),
      ],
    ),
  ];

  @override
  Future<List<CategoryModel>> getTreeCategories({int? parentId}) async {
    treeCalled = true;
    return const [];
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
  }) async => const PaginatedProducts(
    totalCount: 0,
    pageInfo: PageInfo(hasNextPage: false),
    products: [],
  );
}

void main() {
  descriptionTests();
  test(
    'category tab query uses the categories API with parent and children',
    () {
      final query = CategoryQueries.getCategoryTabCategories;
      expect(query, contains('categories('));
      expect(query, isNot(contains('treeCategories')));
      for (final field in ['parent', 'children', 'status', 'pageInfo']) {
        expect(query, contains(field));
      }
    },
  );

  test(
    'tab shows top-level active categories except Root, sorted by position',
    () async {
      final categories = await _repository(
        _serverCategories(),
      ).getCategoryTabCategories();

      expect(categories.map((c) => c.name), [
        'Men',
        'bangles',
        'books',
        'bottles',
      ]);
      expect(categories.first.children.map((c) => c.name), ['Winter Wear']);
    },
  );

  test('requests up to 100 categories per page', () async {
    Map<String, dynamic>? sent;
    await _repository(
      _serverCategories(),
      onRequest: (body) {
        sent = body;
        return const [];
      },
    ).getCategoryTabCategories();

    expect(sent!['variables']['first'], 100);
  });

  test('bloc loads the tab from the categories API', () async {
    final repository = _FakeRepository();
    final bloc = CategoryBloc(repository: repository);

    bloc.add(LoadCategories());
    final loaded = await bloc.stream.firstWhere(
      (s) => s.status == CategoryStatus.loaded,
    );

    expect(loaded.categories.map((c) => c.name), ['Men']);
    expect(loaded.subCategories.map((c) => c.name), ['Winter Wear']);
    expect(repository.treeCalled, isFalse);
    await bloc.close();
  });

  testWidgets('category name is absent from the category banner', (
    tester,
  ) async {
    final bloc = CategoryBloc(repository: _FakeRepository());
    bloc.add(LoadCategories());
    await bloc.stream.firstWhere(
      (state) => state.status == CategoryStatus.loaded,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(value: bloc, child: const CategoryPage()),
      ),
    );

    final banner = find.byType(CategoryBanner);
    expect(banner, findsOneWidget);
    expect(
      find.descendant(of: banner, matching: find.text('Men')),
      findsNothing,
    );
  });
}

void descriptionTests() {
  test('categories tab query requests the description', () {
    expect(
      CategoryQueries.getCategoryTabCategories,
      matches(RegExp(r'translation \{[^}]*description', dotAll: true)),
    );
  });

  test('plainDescription strips html and entities', () {
    final category = CategoryModel.fromTreeJson({
      'id': '/api/shop/categories/8',
      '_id': 8,
      'translation': {
        'name': 'Electronics',
        'description':
            '<p>Discover <b>cutting-edge</b>&nbsp;gear &amp; more</p>\n<p></p>',
      },
    });

    expect(category.plainDescription, 'Discover cutting-edge gear & more');
    expect(
      CategoryModel.fromTreeJson({
        'id': 'x',
        'translation': {'description': '<p> </p>'},
      }).plainDescription,
      isEmpty,
    );
  });
}
