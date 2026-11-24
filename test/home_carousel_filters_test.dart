import 'dart:convert';

import 'package:bagisto_flutter/features/category/data/models/filter_model.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/data/repository/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A section saved with no filters: the admin stores an empty JSON list, not
/// an object, and a bare cast to a map takes the whole section down with it.
ThemeCustomization _section(
  String type,
  String options, {
  String name = 'test',
}) => ThemeCustomization.fromJson({
  'id': '/api/shop/sections/15',
  'type': type,
  'name': name,
  'status': '1',
  'sortOrder': 9,
  'translations': {
    'edges': [
      {
        'node': {'locale': 'en', 'options': options},
      },
    ],
  },
});

Map<String, dynamic> _category(
  int id,
  String name,
  int position,
  int? parent,
) => {
  '__typename': 'Category',
  'id': '/api/shop/categories/$id',
  // The API has been seen to send ids as text.
  '_id': '$id',
  'displayMode': 'products_only',
  'status': '1',
  'logoUrl': null,
  'bannerUrl': null,
  'position': position,
  'parent': parent == null
      ? null
      : {
          '__typename': 'Category',
          'id': '/api/shop/categories/$parent',
          '_id': parent,
        },
  'translation': {
    '__typename': 'CategoryTranslation',
    'id': '/api/shop/category-translations/$id',
    '_id': id,
    'name': name,
    'slug': name.toLowerCase(),
    'description': null,
  },
};

HomeRepository _repository() => HomeRepository(
  client: GraphQLClient(
    link: HttpLink(
      'https://example.com/graphql',
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'data': {
              '__typename': 'Query',
              'categories': {
                '__typename': 'CategoryCursorConnection',
                'edges': [
                  for (final node in [
                    _category(1, 'Root', 1, null),
                    _category(2, 'Men', 1, 1),
                    _category(3, 'Shirt', 2, 2),
                  ])
                    {'__typename': 'CategoryEdge', 'node': node},
                ],
              },
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        ),
      ),
    ),
    cache: GraphQLCache(store: InMemoryStore()),
  ),
);

void main() {
  group('section filters', () {
    test('an empty filter list reads as no filters, not a crash', () {
      final section = _section(
        'product_carousel',
        '{"title": "Deals", "filters": []}',
      );

      expect(section.filters, isEmpty);
      expect(section.title, 'Deals');
    });

    test('a real filter map is kept', () {
      final section = _section('product_carousel', '{"filters": {"new": 1}}');

      expect(section.filters, {'new': 1});
    });

    test('the title falls back to the admin name when none is set', () {
      final section = _section(
        'product_carousel',
        '{"filters": {}}',
        name: 'New Products',
      );

      expect(section.title, 'New Products');
    });
  });

  group('home categories', () {
    test(
      'a category with sub-categories is marked as having children',
      () async {
        final categories = await _repository().fetchHomeCategories(parentId: 1);

        expect(categories.map((c) => c.name), ['Men']);
        // Men has Shirt under it, so tapping it opens the Categories tab.
        expect(categories.single.hasChildren, isTrue);
      },
    );

    test(
      'a leaf category has no children, so it opens its product list',
      () async {
        final categories = await _repository().fetchHomeCategories(parentId: 2);

        expect(categories.map((c) => c.name), ['Shirt']);
        expect(categories.single.hasChildren, isFalse);
      },
    );

    test('an id sent as text is still parsed', () async {
      final categories = await _repository().fetchHomeCategories(parentId: 2);

      expect(categories.single.numericId, 3);
    });
  });

  group('sortOptionFromKey', () {
    test('maps all server sort keys correctly', () {
      final createdAtAsc = sortOptionFromKey('created_at-asc');
      expect(createdAtAsc?.sortKey, 'CREATED_AT');
      expect(createdAtAsc?.reverse, isFalse);

      final createdAtDesc = sortOptionFromKey('created_at-desc');
      expect(createdAtDesc?.sortKey, 'CREATED_AT');
      expect(createdAtDesc?.reverse, isTrue);

      final nameAsc = sortOptionFromKey('name-asc');
      expect(nameAsc?.sortKey, 'NAME');
      expect(nameAsc?.reverse, isFalse);

      final nameDesc = sortOptionFromKey('name-desc');
      expect(nameDesc?.sortKey, 'NAME');
      expect(nameDesc?.reverse, isTrue);

      final priceAsc = sortOptionFromKey('price-asc');
      expect(priceAsc?.sortKey, 'PRICE');
      expect(priceAsc?.reverse, isFalse);

      final priceDesc = sortOptionFromKey('price-desc');
      expect(priceDesc?.sortKey, 'PRICE');
      expect(priceDesc?.reverse, isTrue);

      expect(sortOptionFromKey(null), isNull);
      expect(sortOptionFromKey(''), isNull);
      expect(sortOptionFromKey('invalid-sort'), isNull);
    });

    test('fetchProducts passes sortKey and reverse to variables only when provided', () async {
      Map<String, dynamic>? capturedVariables;

      final repo = HomeRepository(
        client: GraphQLClient(
          link: HttpLink(
            'https://example.com/graphql',
            httpClient: MockClient(
              (request) async {
                final body = jsonDecode(request.body) as Map<String, dynamic>;
                capturedVariables = body['variables'] as Map<String, dynamic>?;
                return http.Response(
                  jsonEncode({
                    'data': {
                      '__typename': 'Query',
                      'products': {
                        '__typename': 'ProductCursorConnection',
                        'totalCount': 0,
                        'pageInfo': {
                          '__typename': 'PageInfo',
                          'startCursor': null,
                          'endCursor': null,
                          'hasNextPage': false,
                          'hasPreviousPage': false,
                        },
                        'edges': [],
                      },
                    },
                  }),
                  200,
                  headers: {'content-type': 'application/json'},
                );
              },
            ),
          ),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

      // When sortKey and reverse are null (default)
      await repo.fetchProducts(first: 12, filter: '{"new":"1"}');
      expect(capturedVariables?['first'], 12);
      expect(capturedVariables?['filter'], '{"new":"1"}');
      expect(capturedVariables?.containsKey('sortKey'), isFalse);
      expect(capturedVariables?.containsKey('reverse'), isFalse);

      // When sortKey and reverse are specified
      await repo.fetchProducts(
        first: 12,
        filter: '{"new":"1"}',
        sortKey: 'CREATED_AT',
        reverse: false,
      );
      expect(capturedVariables?['sortKey'], 'CREATED_AT');
      expect(capturedVariables?['reverse'], isFalse);
    });
  });
}

