import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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

const _stored = SellerProductDetail(
  iri: SellerIri('/theme/api-4.9/public/api/seller/products/50'),
  productId: 65,
  sku: 'demo-sneaker',
  name: 'Runner Sneakers',
  type: 'simple',
  status: 1,
  price: 74,
);

void main() {
  test('create sends only the skeleton fields', () async {
    final link = _RecordingLink(
      data: {
        'createSellerProduct': {
          'sellerProduct': {
            'id': '/theme/api-4.9/public/api/seller/products/77',
            'productId': 91,
            'sku': 'new-sku',
            'type': 'simple',
            'isOwner': true,
            'isApproved': false,
            'isDraft': false,
            'approvalState': 'pending',
          },
        },
      },
    );
    final repository = SellerProductRepository(client: link.client);

    final created = await repository.create(
      type: 'simple',
      attributeFamilyId: 1,
      sku: 'new-sku',
    );

    expect(link.lastVariables?['input'], {
      'type': 'simple',
      'attributeFamilyId': 1,
      'sku': 'new-sku',
      'isDraft': false,
    });
    expect(created.iri.numericId, 77);
    expect(created.productId, 91);
  });

  test('create passes superAttributes for a configurable', () async {
    final link = _RecordingLink(
      data: {
        'createSellerProduct': {
          'sellerProduct': {
            'id': '/api/seller/products/78',
            'productId': 92,
            'sku': 'shirt',
            'type': 'configurable',
          },
        },
      },
    );
    final repository = SellerProductRepository(client: link.client);

    await repository.create(
      type: 'configurable',
      attributeFamilyId: 3,
      sku: 'shirt',
      superAttributes: const [
        {
          'attributeCode': 'color',
          'values': [1, 2],
        },
      ],
    );

    expect(
      (link.lastVariables?['input'] as Map)['superAttributes'],
      isA<List<dynamic>>(),
    );
  });

  test('a duplicate SKU surfaces the server message', () async {
    final link = _RecordingLink(
      errors: const ['The SKU has already been taken.'],
    );
    final repository = SellerProductRepository(client: link.client);

    await expectLater(
      repository.create(type: 'simple', attributeFamilyId: 1, sku: 'taken'),
      throwsA(
        isA<SellerApiException>().having(
          (e) => e.message,
          'message',
          'The SKU has already been taken.',
        ),
      ),
    );
  });

  test('update sends the diffed payload under input', () async {
    final link = _RecordingLink(
      data: {
        'updateSellerProduct': {
          'sellerProduct': {
            'id': '/theme/api-4.9/public/api/seller/products/50',
            'productId': 65,
            'sku': 'demo-sneaker',
            'name': 'Runner Sneakers v2',
            'type': 'simple',
            'price': 80,
          },
        },
      },
    );
    final repository = SellerProductRepository(client: link.client);

    final updated = await repository.update(
      SellerProductDraft.fromDetail(
        _stored,
      ).copyWith(name: 'Runner Sneakers v2', price: 80),
    );

    expect(link.lastVariables?['input'], {
      'id': '/theme/api-4.9/public/api/seller/products/50',
      'name': 'Runner Sneakers v2',
      'price': 80,
    });
    expect(updated.name, 'Runner Sneakers v2');
  });

  test('delete sends the IRI verbatim', () async {
    final link = _RecordingLink(
      data: {
        'deleteSellerProduct': {
          'sellerProduct': {
            'id': '/theme/api-4.9/public/api/seller/products/50',
          },
        },
      },
    );
    final repository = SellerProductRepository(client: link.client);

    await repository.delete(
      const SellerIri('/theme/api-4.9/public/api/seller/products/50'),
    );

    expect(link.lastVariables, {
      'id': '/theme/api-4.9/public/api/seller/products/50',
    });
  });

  test('bulk delete reports what happened to each id', () async {
    final link = _RecordingLink(
      data: {
        'createSellerProductDeleteBatch': {
          'sellerProductDeleteBatch': {
            'requested': 3,
            'deleted': 1,
            'unassigned': 1,
            'skipped': 1,
            'message': 'Done',
          },
        },
      },
    );
    final repository = SellerProductRepository(client: link.client);

    final batch = await repository.deleteBatch(const [50, 51, 52]);

    expect(link.lastVariables?['input'], {
      'ids': [50, 51, 52],
    });
    expect(batch.removed, 2);
    expect(batch.skipped, 1);
  });

  test('assignable categories map their path label', () async {
    final link = _RecordingLink(
      data: {
        'sellerProductCategories': [
          {
            '_id': 5,
            'parentId': 2,
            'name': 'Winter Wear',
            'level': 2,
            'path': 'Mens / Winter Wear',
          },
        ],
      },
    );
    final repository = SellerProductRepository(client: link.client);

    final categories = await repository.assignableCategories();

    expect(categories.single.label, 'Mens / Winter Wear');
  });

  test(
    'a restricted seller gets an empty category list, not an error',
    () async {
      final link = _RecordingLink(
        data: {'sellerProductCategories': <dynamic>[]},
      );
      final repository = SellerProductRepository(client: link.client);

      expect(await repository.assignableCategories(), isEmpty);
    },
  );
}
