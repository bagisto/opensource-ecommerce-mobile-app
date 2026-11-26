import 'dart:convert';

import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/data/repository/home_repository.dart';
import 'package:bagisto_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> _category(int id, String name, int position, int? parent) =>
    {
      '__typename': 'Category',
      'id': '/api/shop/categories/$id',
      '_id': id,
      'logoUrl': null,
      'position': position,
      'status': '1',
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
      },
    };

/// Categories exactly as the local server returns them.
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

ThemeCustomization _carousel(String id, String? options) =>
    ThemeCustomization.fromJson({
      'id': id,
      'type': 'category_carousel',
      'name': 'Categories',
      'status': '1',
      'translation': {'locale': 'en', 'options': options},
    });

class _SectionsRepository extends HomeRepository {
  _SectionsRepository(this.sections)
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  final List<ThemeCustomization> sections;
  final _real = _repository();

  @override
  Future<List<ThemeCustomization>> fetchSections() async => sections;

  @override
  Future<List<HomeCategory>> fetchHomeCategories({
    int? parentId,
    int? limit,
  }) => _real.fetchHomeCategories(parentId: parentId, limit: limit);
}

void main() {
  test('carousel without filters shows every active category, like the web',
      () async {
    final categories = await _repository().fetchHomeCategories();

    expect(categories.map((c) => c.name), ['Root', 'Men', 'Shirt']);
  });

  test('carousel parent_id filter keeps only that parent\'s children',
      () async {
    final categories = await _repository().fetchHomeCategories(parentId: 2);

    expect(categories.map((c) => c.name), ['Shirt']);
  });

  test('categories know whether they have sub-categories', () async {
    final categories = await _repository().fetchHomeCategories();
    final byName = {for (final c in categories) c.name: c.hasChildren};

    // Root -> Men -> Shirt on the local server.
    expect(byName, {'Root': true, 'Men': true, 'Shirt': false});
  });

  test('each category carousel loads its own categories', () async {
    final noFilters = _carousel('/api/shop/sections/16', null);
    final menOnly = _carousel(
      '/api/shop/sections/17',
      '{"filters": {"parent_id": "2"}}',
    );
    final bloc = HomeBloc(repository: _SectionsRepository([noFilters, menOnly]));
    addTearDown(bloc.close);

    bloc.add(const LoadHome());
    final state = await bloc.stream.firstWhere(
      (s) => s.status == HomeStatus.loaded,
    );

    expect(
      state.categorySections[noFilters.id]?.map((c) => c.name),
      ['Root', 'Men', 'Shirt'],
    );
    expect(state.categorySections[menOnly.id]?.map((c) => c.name), ['Shirt']);
  });
}
