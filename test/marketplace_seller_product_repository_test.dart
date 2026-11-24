import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Captures the variables the repository sends and answers from memory.
class _RecordingLink {
  _RecordingLink({this.data, this.errors = const []});

  final Map<String, dynamic>? data;
  final List<String> errors;
  Map<String, dynamic>? lastVariables;

  GraphQLClient get client {
    final link = Link.function((request, [forward]) async* {
      lastVariables = request.variables;
      yield Response(
        data: data,
        errors: errors
            .map((message) => GraphQLError(message: message))
            .toList(),
        response: const {},
        context: const Context(),
      );
    });

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }
}

Map<String, dynamic> _listPayload({int totalCount = 2, int lastPage = 2}) => {
  'sellerProducts': {
    'collection': [
      {
        'id': '/theme/api-4.9/public/api/seller/products/50',
        'productId': 65,
        'sku': 'demo-sneaker',
        'name': 'Runner Sneakers',
        'type': 'simple',
        'price': 74,
        'quantity': 60,
        'isOwner': true,
        'isApproved': false,
        'isDraft': false,
        'rejectionReason': null,
        'approvalState': 'pending',
      },
      {
        'id': '/theme/api-4.9/public/api/seller/products/51',
        'productId': 66,
        'sku': 'demo-lamp',
        'name': 'Desk Lamp',
        'type': 'simple',
        'price': 34.25,
        'quantity': 45,
        'isOwner': true,
        'isApproved': true,
        'isDraft': false,
        'rejectionReason': null,
        'approvalState': 'approved',
      },
    ],
    'paginationInfo': {
      'itemsPerPage': 10,
      'lastPage': lastPage,
      'totalCount': totalCount,
      'currentPage': 1,
      'hasNextPage': lastPage > 1,
    },
  },
};

void main() {
  test(
    'dashboard lookup preserves seller IRI and checks every search page',
    () async {
      final requests = <Map<String, dynamic>>[];
      final client = GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: Link.function((request, [forward]) async* {
          requests.add(request.variables);
          final page = request.variables['page'];
          yield Response(
            data: {
              'sellerProducts': {
                'collection': [
                  {
                    'id':
                        '/theme/api-4.9/public/api/seller/products/${page == 1 ? 65 : 50}',
                    'productId': page == 1 ? 999 : 65,
                    'sku': page == 1 ? 'demo-sneaker-extra' : 'demo-sneaker',
                  },
                ],
                'paginationInfo': {'lastPage': 2, 'totalCount': 2},
              },
            },
            response: const {},
          );
        }),
      );
      final product = await SellerProductRepository(
        client: client,
      ).findByCoreProductId(65, sku: 'demo-sneaker');
      expect(
        product?.iri.value,
        '/theme/api-4.9/public/api/seller/products/50',
      );
      expect(requests, [
        {'page': 1, 'search': 'demo-sneaker'},
        {'page': 2, 'search': 'demo-sneaker'},
      ]);
    },
  );

  test('dashboard lookup does not fall back to a different product', () async {
    final link = _RecordingLink(data: _listPayload(lastPage: 1));
    final repository = SellerProductRepository(client: link.client);
    expect(
      await repository.findByCoreProductId(999, sku: 'demo-sneaker'),
      isNull,
    );
  });

  test('invalid dashboard identity makes no catalogue request', () async {
    final link = _RecordingLink(data: _listPayload());
    final repository = SellerProductRepository(client: link.client);
    expect(
      await repository.findByCoreProductId(0, sku: 'demo-sneaker'),
      isNull,
    );
    expect(await repository.findByCoreProductId(65, sku: ''), isNull);
    expect(link.lastVariables, isNull);
  });

  test('list maps rows and pagination', () async {
    final link = _RecordingLink(
      data: _listPayload(totalCount: 13, lastPage: 2),
    );
    final repository = SellerProductRepository(client: link.client);

    final page = await repository.list();

    expect(page.items, hasLength(2));
    expect(page.items.first.sku, 'demo-sneaker');
    expect(page.totalCount, 13);
    expect(page.lastPage, 2);
    expect(page.currentPage, 1);
    expect(page.hasNextPage, isTrue);
  });

  test('list sends the page and every set filter', () async {
    final link = _RecordingLink(data: _listPayload());
    final repository = SellerProductRepository(client: link.client);

    await repository.list(
      page: 3,
      filters: const SellerProductFilters(
        search: 'shoe',
        type: 'simple',
        isDraft: 1,
      ),
    );

    expect(link.lastVariables, {
      'page': 3,
      'search': 'shoe',
      'type': 'simple',
      'is_draft': 1,
    });
  });

  test('list surfaces a server error with its message', () async {
    final link = _RecordingLink(errors: const ['Unauthorized.']);
    final repository = SellerProductRepository(client: link.client);

    await expectLater(
      repository.list(),
      throwsA(
        isA<SellerApiException>().having(
          (e) => e.kind,
          'kind',
          SellerApiFailure.unauthorized,
        ),
      ),
    );
  });

  test('detail echoes the IRI it was given and maps the product', () async {
    final link = _RecordingLink(
      data: {
        'sellerProduct': {
          'id': '/theme/api-4.9/public/api/seller/products/50',
          'productId': 65,
          'sku': 'demo-sneaker',
          'name': 'Runner Sneakers',
          'type': 'simple',
          'status': 1,
          'isApproved': false,
          'isDraft': false,
          'approvalState': 'pending',
          'price': 74,
          'quantity': 60,
          'imagesCount': 1,
          'images': [
            {'url': 'http://example.com/a.jpg', 'position': 0},
          ],
          'inventories': [
            {
              'sourceId': 5,
              'sourceCode': 'vendor_38_default',
              'sourceName': 'Default',
              'qty': 60,
            },
          ],
          'categories': <dynamic>[],
          'attributes': <dynamic>[],
        },
      },
    );
    final repository = SellerProductRepository(client: link.client);

    final detail = await repository.detail(
      const SellerIri('/theme/api-4.9/public/api/seller/products/50'),
    );

    expect(link.lastVariables, {
      'id': '/theme/api-4.9/public/api/seller/products/50',
    });
    expect(detail.name, 'Runner Sneakers');
    expect(detail.totalStock, 60);
  });

  test(
    'detail reads videos, and none from a server without the field',
    () async {
      Map<String, dynamic> product(List<Map<String, dynamic>>? videos) => {
        'sellerProduct': {
          'id': '/api/seller/products/50',
          'productId': 65,
          'sku': 'demo',
          'name': 'Demo',
          'type': 'simple',
          'videos': ?videos,
        },
      };
      const iri = SellerIri('/api/seller/products/50');

      final withVideos = await SellerProductRepository(
        client: _RecordingLink(
          data: product([
            {
              'id': '/api/seller_product_videos/14',
              'type': 'videos',
              'url': 'http://example.com/a.mp4',
              'position': 1,
            },
          ]),
        ).client,
      ).detail(iri);
      expect(withVideos.videos.map((v) => v.url), ['http://example.com/a.mp4']);

      final without = await SellerProductRepository(
        client: _RecordingLink(data: product(null)).client,
      ).detail(iri);
      expect(without.videos, isEmpty);
    },
  );

  test('a missing product is a notFound failure', () async {
    final link = _RecordingLink(errors: const ['Resource not found.']);
    final repository = SellerProductRepository(client: link.client);

    await expectLater(
      repository.detail(const SellerIri('/api/seller/products/999')),
      throwsA(
        isA<SellerApiException>().having(
          (e) => e.kind,
          'kind',
          SellerApiFailure.notFound,
        ),
      ),
    );
  });
}
