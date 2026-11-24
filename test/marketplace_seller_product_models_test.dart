import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:flutter_test/flutter_test.dart';

/// Row shape copied from a live `sellerProducts` response.
const _liveRow = {
  'id': '/theme/api-4.9/public/api/seller/products/50',
  'productId': 65,
  'sku': 'demo-sneaker-demo2',
  'name': 'Runner Sneakers',
  'type': 'simple',
  'price': 74,
  'quantity': 60,
  'isOwner': true,
  'isApproved': false,
  'isDraft': false,
  'rejectionReason': null,
  'approvalState': 'pending',
};

void main() {
  group('SellerProductListItem', () {
    test('keeps the install-prefixed IRI and the core product id apart', () {
      final item = SellerProductListItem.fromJson(_liveRow);

      expect(item.iri.value, '/theme/api-4.9/public/api/seller/products/50');
      expect(item.iri.numericId, 50);
      expect(item.productId, 65);
    });

    test('maps price and stock', () {
      final item = SellerProductListItem.fromJson(_liveRow);

      expect(item.price, 74);
      expect(item.quantity, 60);
      expect(item.approval, SellerProductApproval.pending);
    });

    test('a draft reads as draft even though the state says pending', () {
      final item = SellerProductListItem.fromJson({
        ..._liveRow,
        'isDraft': true,
        'approvalState': 'pending',
      });

      expect(item.approval, SellerProductApproval.draft);
    });

    test('a rejected product keeps its reason', () {
      final item = SellerProductListItem.fromJson({
        ..._liveRow,
        'approvalState': 'rejected',
        'rejectionReason': 'Images are too small.',
      });

      expect(item.approval, SellerProductApproval.rejected);
      expect(item.rejectionReason, 'Images are too small.');
    });

    test('an approved product reads as approved', () {
      final item = SellerProductListItem.fromJson({
        ..._liveRow,
        'isApproved': true,
        'approvalState': 'approved',
      });

      expect(item.approval, SellerProductApproval.approved);
    });
  });

  group('SellerProductDetail', () {
    test('maps images, stock, categories and attributes', () {
      final detail = SellerProductDetail.fromJson({
        ..._liveRow,
        'status': 1,
        'imagesCount': 1,
        'shortDescription': '<p>Runner Sneakers</p>',
        'weight': 1,
        'visibleIndividually': true,
        'featured': true,
        'new': true,
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
        'categories': [
          {'id': '2', 'name': 'Men'},
        ],
        'attributes': [
          {
            'code': 'color',
            'name': 'Color',
            'type': 'select',
            'value': null,
            'isRequired': false,
            'isUserDefined': true,
            'isFixedField': false,
            'options': [
              {'id': '1', 'label': 'Red'},
            ],
          },
        ],
      });

      expect(detail.images.single.url, 'http://example.com/a.jpg');
      expect(detail.stocks.single.sourceName, 'Default');
      expect(detail.totalStock, 60);
      expect(detail.categories.single.name, 'Men');
      expect(detail.attributes.single.options.single.name, 'Red');
      expect(detail.attributes.single.hasValue, isFalse);
      expect(detail.isEnabled, isTrue);
    });

    test('tolerates the nulls a sparse product returns', () {
      final detail = SellerProductDetail.fromJson({
        'id': '/api/seller/products/51',
        'sku': 'demo-lamp',
        'name': 'Desk Lamp',
        'type': 'simple',
        'images': null,
        'inventories': null,
        'categories': null,
        'attributes': null,
      });

      expect(detail.images, isEmpty);
      expect(detail.totalStock, 0);
      expect(detail.isEnabled, isFalse);
      expect(detail.baseImage, isNull);
    });
  });

  group('SellerProductFilters', () {
    test('omits unset and empty values', () {
      const filters = SellerProductFilters(search: '', type: 'simple');

      expect(filters.toVariables(), {'type': 'simple'});
    });

    test('sends every set filter under its query-string name', () {
      const filters = SellerProductFilters(
        search: 'shoe',
        type: 'configurable',
        status: 1,
        isApproved: 0,
        approvalState: 'rejected',
        isDraft: 0,
        excludeLinkedTo: 42,
        linkType: 'related_products',
      );

      expect(filters.toVariables(), {
        'search': 'shoe',
        'type': 'configurable',
        'status': 1,
        'is_approved': 0,
        'approval_state': 'rejected',
        'is_draft': 0,
        'exclude_linked_to': 42,
        'link_type': 'related_products',
      });
    });

    test('clear drops filters but keeps the search term', () {
      const filters = SellerProductFilters(search: 'shoe', type: 'simple');

      final cleared = filters.clear();

      expect(cleared.search, 'shoe');
      expect(cleared.type, isNull);
      expect(cleared.activeCount, 0);
    });

    test('counts the filters that are set, ignoring search', () {
      const filters = SellerProductFilters(
        search: 'shoe',
        type: 'simple',
        isDraft: 1,
      );

      expect(filters.activeCount, 2);
      expect(filters.isEmpty, isFalse);
    });
  });
}
