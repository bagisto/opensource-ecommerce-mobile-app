import 'dart:convert';

import 'package:bagisto_flutter/core/constants/api_constants.dart';
import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/data/repository/home_repository.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/footer_links_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Client whose response comes from [respond]; records every request body.
GraphQLClient _client(
  Map<String, dynamic> Function() respond, {
  List<Map<String, dynamic>>? requests,
}) {
  final httpClient = MockClient((request) async {
    requests?.add(jsonDecode(request.body) as Map<String, dynamic>);
    return http.Response(
      jsonEncode({
        'data': {'__typename': 'Query', ...respond()},
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  });
  return GraphQLClient(
    link: HttpLink('https://example.com/graphql', httpClient: httpClient),
    cache: GraphQLCache(store: InMemoryStore()),
  );
}

Map<String, dynamic> _sectionsData(String name) => {
  'sections': {
    '__typename': 'SectionCursorConnection',
    'edges': [
      {
        '__typename': 'SectionEdge',
        'node': {
          '__typename': 'Section',
          'id': '/api/shop/sections/6',
          '_id': 6,
          'type': 'static_content',
          'name': name,
          'status': '1',
          'sortOrder': 1,
          'translation': {
            '__typename': 'SectionTranslation',
            'locale': 'en',
            'options': jsonEncode({'html': '<p>$name</p>'}),
          },
        },
      },
    ],
  },
};

Map<String, dynamic> _category(int id, String name, {int? parentId}) => {
  '__typename': 'Category',
  'id': '/api/shop/categories/$id',
  '_id': id,
  'logoUrl': null,
  'position': id,
  'status': '1',
  'parent': parentId == null
      ? null
      : {
          '__typename': 'Category',
          'id': '/api/shop/categories/$parentId',
          '_id': parentId,
        },
  'translation': {
    '__typename': 'CategoryTranslation',
    'id': '/api/shop/category-translations/$id',
    '_id': id,
    'name': name,
    'slug': name.toLowerCase(),
  },
};

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'homepage sections use the sections API and refetch fresh content',
    () async {
      var name = 'Bold Collections';
      final requests = <Map<String, dynamic>>[];
      final repository = HomeRepository(
        client: _client(() => _sectionsData(name), requests: requests),
      );

      final first = await repository.fetchSections();
      expect(requests.single['query'], contains('sections('));
      expect(first.single.name, 'Bold Collections');
      expect(first.single.options['html'], '<p>Bold Collections</p>');

      name = 'Winter Collection';
      expect(
        (await repository.fetchSections()).single.name,
        'Winter Collection',
      );
    },
  );

  test(
    'home categories keep only direct children of the carousel parent',
    () async {
      final requests = <Map<String, dynamic>>[];
      final repository = HomeRepository(
        client: _client(
          () => {
            'categories': {
              '__typename': 'CategoryCursorConnection',
              'edges': [
                for (final node in [
                  _category(1, 'Root'),
                  _category(23, 'Furniture', parentId: 1),
                  _category(19, 'Plastic Sofa', parentId: 23),
                  _category(8, 'Electronics', parentId: 1),
                ])
                  {'__typename': 'CategoryEdge', 'node': node},
              ],
            },
          },
          requests: requests,
        ),
      );

      final categories = await repository.fetchHomeCategories(parentId: 1);

      expect(categories.map((c) => c.name), ['Electronics', 'Furniture']);
      expect(requests.single['variables']['first'], 100);
      expect(CategoryQueries.getHomeCategories, contains('parent'));
    },
  );

  test('home categories honour the carousel limit', () async {
    final repository = HomeRepository(
      client: _client(
        () => {
          'categories': {
            '__typename': 'CategoryCursorConnection',
            'edges': [
              for (final node in [
                _category(2, 'Men', parentId: 1),
                _category(3, 'Women', parentId: 1),
                _category(4, 'Kids', parentId: 1),
              ])
                {'__typename': 'CategoryEdge', 'node': node},
            ],
          },
        },
      ),
    );

    final categories = await repository.fetchHomeCategories(limit: 2);

    expect(categories.map((c) => c.name), ['Men', 'Women']);
  });

  test('theme translation locale matches case-insensitively', () {
    final tc = ThemeCustomization.fromJson({
      'id': '1',
      'type': 'image_carousel',
      'name': 'Banner',
      'status': '1',
      'sortOrder': 1,
      'translations': {
        'edges': [
          {
            'node': {'locale': 'en', 'options': '{"title":"English"}'},
          },
          {
            'node': {'locale': 'AR', 'options': '{"title":"Arabic"}'},
          },
        ],
      },
    }, preferredLocale: 'ar');

    expect(tc.options['title'], 'Arabic');
  });

  test('services_content options parse into service items', () {
    final services = HomeService.listFromOptions({
      'services': [
        {
          'title': 'Free Shipping',
          'description': 'On all orders',
          'service_icon': 'icon-truck',
        },
        {'title': '', 'description': 'skipped'},
        'bad',
      ],
    });

    expect(services, hasLength(1));
    expect(services.single.title, 'Free Shipping');
    expect(services.single.description, 'On all orders');
    expect(services.single.icon, 'icon-truck');
  });

  test('footer links parse both columns and resolve localhost URLs', () {
    final columns = HomeFooterLink.columnsFromOptions({
      'column_1': [
        {'title': 'About Us', 'url': 'http://localhost/page/about-us'},
      ],
      'column_2': [
        {
          'title': 'Privacy Policy',
          'url': 'http://localhost/page/privacy-policy',
        },
      ],
    });

    final links = columns.expand((column) => column).toList();
    expect(columns, hasLength(2));
    expect(links.map((link) => link.title), ['About Us', 'Privacy Policy']);
    expect(
      links.first.resolveUrl(bagistoPublicBaseUrl),
      'http://192.168.15.239/Bagisto-Api/new-setup/public/page/about-us',
    );
    expect(
      links.last.resolveUrl(bagistoPublicBaseUrl),
      'http://192.168.15.239/Bagisto-Api/new-setup/public/page/privacy-policy',
    );
  });

  testWidgets('footer links render both columns and report selected link', (
    tester,
  ) async {
    final columns = HomeFooterLink.columnsFromOptions({
      'column_1': [
        {'title': 'About Us', 'url': 'http://localhost/page/about-us'},
      ],
      'column_2': [
        {
          'title': 'Privacy Policy',
          'url': 'http://localhost/page/privacy-policy',
        },
      ],
    });
    HomeFooterLink? selectedLink;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FooterLinksSection(
            title: 'Footer Links',
            columns: columns,
            onLinkTap: (link) => selectedLink = link,
          ),
        ),
      ),
    );

    expect(find.text('About Us'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    await tester.tap(find.text('About Us'));
    expect(selectedLink?.title, 'About Us');
  });

  test('banner link resolves to a slug', () {
    expect(BannerImage(imageUrl: 'a', link: 'fashion').linkSlug, 'fashion');
    expect(
      BannerImage(
        imageUrl: 'a',
        link: 'https://shop.example.com/furniture/?x=1',
      ).linkSlug,
      'furniture',
    );
    expect(BannerImage(imageUrl: 'a', link: '').linkSlug, isNull);
    expect(BannerImage(imageUrl: 'a', link: '/').linkSlug, isNull);
  });

  test('relative banner image URL preserves the Bagisto deployment path', () {
    final banner = BannerImage(
      imageUrl: 'storage/themes/default/sections/1/banner.webp',
    );

    expect(
      banner.fullImageUrl(bagistoPublicBaseUrl),
      'http://192.168.15.239/Bagisto-Api/new-setup/public/storage/themes/default/sections/1/banner.webp',
    );
  });
}
