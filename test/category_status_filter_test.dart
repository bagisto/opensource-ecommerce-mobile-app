import 'dart:convert';

import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/home/data/repository/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

GraphQLClient _client(Map<String, dynamic> data) {
  final httpClient = MockClient(
    (_) async => http.Response(
      jsonEncode({
        'data': {'__typename': 'Query', ...data},
      }),
      200,
      headers: {'content-type': 'application/json'},
    ),
  );
  return GraphQLClient(
    link: HttpLink('https://example.com/graphql', httpClient: httpClient),
    cache: GraphQLCache(store: InMemoryStore()),
  );
}

Map<String, dynamic> _flatCategory(int id, String name, Object? status) => {
  '__typename': 'Category',
  'id': '/api/shop/categories/$id',
  '_id': id,
  'logoUrl': null,
  'position': id,
  'status': status,
  'parent': id == 1
      ? null
      : {'__typename': 'Category', 'id': '/api/shop/categories/1', '_id': 1},
  'translation': {
    '__typename': 'CategoryTranslation',
    'id': '/api/shop/category-translations/$id',
    '_id': id,
    'name': name,
    'slug': name.toLowerCase(),
  },
};

Map<String, dynamic> _categoriesData() => {
  'categories': {
    '__typename': 'CategoryCursorConnection',
    'edges': [
      {'__typename': 'CategoryEdge', 'node': _flatCategory(1, 'Root', '1')},
      {'__typename': 'CategoryEdge', 'node': _flatCategory(2, 'Men', '1')},
      {'__typename': 'CategoryEdge', 'node': _flatCategory(3, 'Winter', '0')},
      {'__typename': 'CategoryEdge', 'node': _flatCategory(4, 'Books', 1)},
      {'__typename': 'CategoryEdge', 'node': _flatCategory(5, 'Bags', 0)},
    ],
  },
};

void main() {
  test('home categories query requests status', () {
    expect(CategoryQueries.getHomeCategories, contains('status'));
  });

  test('CategoryModel.isActiveStatus', () {
    expect(CategoryModel.isActiveStatus('1'), isTrue);
    expect(CategoryModel.isActiveStatus(1), isTrue);
    expect(CategoryModel.isActiveStatus(true), isTrue);
    expect(CategoryModel.isActiveStatus(null), isTrue);
    expect(CategoryModel.isActiveStatus('0'), isFalse);
    expect(CategoryModel.isActiveStatus(0), isFalse);
    expect(CategoryModel.isActiveStatus(false), isFalse);
  });

  test('home carousel hides inactive categories', () async {
    final repository = HomeRepository(client: _client(_categoriesData()));

    final categories = await repository.fetchHomeCategories();

    expect(categories.map((c) => c.name), ['Men', 'Books']);
  });

  test('search categories hide inactive categories', () async {
    final repository = CategoryRepository(client: _client(_categoriesData()));

    final categories = await repository.getHomeCategories();

    expect(categories.map((c) => c.name), ['Root', 'Men', 'Books']);
  });

  test('tree categories drop inactive categories and children', () async {
    Map<String, dynamic> node(int id, String name, String status) => {
      '__typename': 'Category',
      'id': '/api/shop/categories/$id',
      '_id': id,
      'position': id,
      'logoPath': null,
      'logoUrl': null,
      'bannerUrl': null,
      'status': status,
      'translation': {
        '__typename': 'CategoryTranslation',
        'id': '/api/shop/category-translations/$id',
        'name': name,
        'slug': name.toLowerCase(),
        'urlPath': name.toLowerCase(),
      },
    };

    final repository = CategoryRepository(
      client: _client({
        'treeCategories': [
          {
            ...node(2, 'Men', '1'),
            'translation': {
              ...node(2, 'Men', '1')['translation'] as Map<String, dynamic>,
              'description': null,
              'metaTitle': null,
            },
            'children': {
              '__typename': 'CategoryCursorConnection',
              'edges': [
                {'__typename': 'CategoryEdge', 'node': node(6, 'Shirts', '1')},
                {'__typename': 'CategoryEdge', 'node': node(7, 'Ties', '0')},
              ],
            },
          },
          {
            ...node(3, 'Winter', '0'),
            'translation': {
              ...node(3, 'Winter', '0')['translation'] as Map<String, dynamic>,
              'description': null,
              'metaTitle': null,
            },
            'children': {
              '__typename': 'CategoryCursorConnection',
              'edges': [],
            },
          },
        ],
      }),
    );

    final categories = await repository.getTreeCategories();

    expect(categories.map((c) => c.name), ['Men']);
    expect(categories.single.children.map((c) => c.name), ['Shirts']);
  });
}
