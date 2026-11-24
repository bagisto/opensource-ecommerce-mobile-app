import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_variant_bulk_action.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const _iri = SellerIri('/api/seller/products/1383');

void main() {
  test('mass update uses seller catalogue ID and core variant IDs', () {
    final request = SellerVariantBulkRequest(
      action: SellerVariantBulkAction.editPrices,
      variantIds: const [1819, 1820, 1819],
      commonValue: 25.5,
      values: const {1820: 29.0},
    );
    expect(request.toInput(_iri), {
      'productId': 1383,
      'action': 'editPrices',
      'variantIds': [1819, 1820],
      'price': 25.5,
      'values': {'1820': 29.0},
    });
  });

  test('SKU and stock payloads preserve field shapes', () {
    expect(
      SellerVariantBulkRequest(
        action: SellerVariantBulkAction.editSku,
        variantIds: const [1819],
        values: const {1819: 'new-sku'},
      ).toInput(_iri)['values'],
      {'1819': 'new-sku'},
    );
    expect(
      SellerVariantBulkRequest(
        action: SellerVariantBulkAction.editInventories,
        variantIds: const [1819],
        commonValue: const {'2': 5},
      ).toInput(_iri)['inventories'],
      {'2': 5},
    );
    expect(
      SellerVariantBulkRequest(
        action: SellerVariantBulkAction.editStatus,
        variantIds: const [1819],
        commonValue: true,
      ).toInput(_iri)['status'],
      true,
    );
  });

  test('Add Images supports Apply to All and per-variant overrides', () {
    final input = SellerVariantBulkRequest(
      action: SellerVariantBulkAction.addImages,
      variantIds: const [1819, 1820],
      commonValue: const ['data:image/png;base64,aGVsbG8='],
      values: const {
        1820: ['data:image/png;base64,d29ybGQ='],
      },
    ).toInput(_iri);

    expect(input['images'], ['data:image/png;base64,aGVsbG8=']);
    expect(input['values'], {
      '1820': ['data:image/png;base64,d29ybGQ='],
    });
  });

  test('bulk request rejects empty selection and incomplete per-row SKU', () {
    expect(
      () => const SellerVariantBulkRequest(
        action: SellerVariantBulkAction.removeVariants,
        variantIds: [],
      ).toInput(_iri),
      throwsFormatException,
    );
    expect(
      () => const SellerVariantBulkRequest(
        action: SellerVariantBulkAction.editSku,
        variantIds: [1819, 1820],
        values: {1819: 'one'},
      ).toInput(_iri),
      throwsFormatException,
    );
  });

  test('rebase keeps parent draft and uses refreshed variant values', () {
    const oldVariant = SellerProductVariant(
      variantId: 1819,
      sku: 'sku',
      name: 'Old',
      price: 10,
    );
    const freshVariant = SellerProductVariant(
      variantId: 1819,
      sku: 'sku',
      name: 'Old',
      price: 12,
    );
    const old = SellerProductDetail(
      iri: _iri,
      productId: 1814,
      sku: 'parent',
      name: 'Parent',
      type: 'configurable',
      description: 'Old description',
      variants: [oldVariant],
    );
    const fresh = SellerProductDetail(
      iri: _iri,
      productId: 1814,
      sku: 'parent',
      name: 'Parent',
      type: 'configurable',
      description: 'Old description',
      variants: [freshVariant],
    );
    final draft = SellerProductDraft.fromDetail(old).copyWith(
      description: 'Pending description',
      variants: [oldVariant.toEdit().copyWith(price: 11)],
    );
    final rebased = draft.rebaseAfterVariantBulk(
      fresh,
      const SellerVariantBulkRequest(
        action: SellerVariantBulkAction.editPrices,
        variantIds: [1819],
        commonValue: 12,
      ),
    );
    expect(rebased.description, 'Pending description');
    expect(rebased.variants, isNull);
    expect(rebased.toInput().containsKey('variants'), isFalse);
  });

  test('repository sends mutation and reads update count', () async {
    Map<String, dynamic>? sent;
    final client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: Link.function((request, [forward]) async* {
        sent = request.variables;
        yield Response(
          data: {
            'createSellerProductVariantMassUpdate': {
              'sellerProductVariantMassUpdate': {
                'id': 1383,
                'action': 'editPrices',
                'variantIds': [1819],
                'updated': 1,
                'message': '1 variant(s) updated.',
              },
            },
          },
          response: const {},
        );
      }),
    );
    final message = await SellerProductRepository(client: client)
        .bulkUpdateVariants(
          iri: _iri,
          request: const SellerVariantBulkRequest(
            action: SellerVariantBulkAction.editPrices,
            variantIds: [1819],
            commonValue: 10,
          ),
        );
    expect(message, '1 variant(s) updated.');
    expect(sent?['input']['productId'], 1383);
    expect(sent?['input']['variantIds'], [1819]);
  });
}
