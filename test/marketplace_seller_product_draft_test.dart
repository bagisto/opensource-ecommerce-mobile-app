import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:flutter_test/flutter_test.dart';

const _detail = SellerProductDetail(
  iri: SellerIri('/theme/api-4.9/public/api/seller/products/50'),
  productId: 65,
  sku: 'demo-sneaker',
  name: 'Runner Sneakers',
  type: 'simple',
  status: 1,
  price: 74,
  quantity: 60,
  weight: 1,
  urlKey: 'demo-sneaker',
  shortDescription: '<p>Runner Sneakers</p>',
  visibleIndividually: true,
  featured: true,
  isNew: true,
  isDraft: false,
);

void main() {
  test('an untouched draft sends nothing but the id', () {
    final draft = SellerProductDraft.fromDetail(_detail);

    expect(draft.toInput(), {
      'id': '/theme/api-4.9/public/api/seller/products/50',
    });
    expect(draft.hasChanges, isFalse);
  });

  test('only the changed scalar goes out', () {
    final draft = SellerProductDraft.fromDetail(
      _detail,
    ).copyWith(name: 'Runner Sneakers v2');

    expect(draft.toInput(), {
      'id': '/theme/api-4.9/public/api/seller/products/50',
      'name': 'Runner Sneakers v2',
    });
    expect(draft.hasChanges, isTrue);
  });

  test('a value equal to the stored one is not resent', () {
    final draft = SellerProductDraft.fromDetail(
      _detail,
    ).copyWith(name: 'Runner Sneakers', price: 74);

    expect(draft.toInput().keys, ['id']);
  });

  test('flags are sent as 1 and 0 only when they flip', () {
    final draft = SellerProductDraft.fromDetail(
      _detail,
    ).copyWith(status: false, featured: true);

    final input = draft.toInput();

    expect(input['status'], 0);
    expect(input.containsKey('featured'), isFalse);
  });

  test('an empty string clears a field rather than being dropped', () {
    final draft = SellerProductDraft.fromDetail(
      _detail,
    ).copyWith(metaKeywords: '');

    // metaKeywords was null on the product, so "" is not a change...
    expect(draft.toInput().containsKey('metaKeywords'), isFalse);

    final cleared = SellerProductDraft.fromDetail(
      _detail,
    ).copyWith(shortDescription: '');

    // ...but clearing a field that had text is.
    expect(cleared.toInput()['shortDescription'], '');
  });

  test('a touched image list is sent whole, an untouched one is omitted', () {
    final untouched = SellerProductDraft.fromDetail(_detail);
    expect(untouched.toInput().containsKey('images'), isFalse);

    final touched = SellerProductDraft.fromDetail(_detail).copyWith(
      images: const ['https://example.com/a.jpg', 'data:image/png;base64,AAA'],
    );

    expect(touched.toInput()['images'], [
      'https://example.com/a.jpg',
      'data:image/png;base64,AAA',
    ]);
  });

  test('stock rows map to inventorySourceId and qty', () {
    final draft = SellerProductDraft.fromDetail(_detail).copyWith(
      stocks: const [
        SellerStockEntry(inventorySourceId: 5, qty: 0, sourceName: 'Default'),
        SellerStockEntry(inventorySourceId: 6, qty: 12, sourceName: 'North'),
      ],
    );

    expect(draft.toInput()['inventories'], [
      {'inventorySourceId': 5, 'qty': 0},
      {'inventorySourceId': 6, 'qty': 12},
    ]);
  });

  test('custom attributes are sent as name/value pairs', () {
    final draft = SellerProductDraft.fromDetail(
      _detail,
    ).copyWith(customAttributes: const {'color': '4', 'cost': '120.00'});

    expect(draft.toInput()['customAttributes'], [
      {'name': 'color', 'value': '4'},
      {'name': 'cost', 'value': '120.00'},
    ]);
  });

  test('categories replace the whole set', () {
    final draft = SellerProductDraft.fromDetail(
      _detail,
    ).copyWith(categories: const [2, 5]);

    expect(draft.toInput()['categories'], [2, 5]);
  });

  test('submitting a draft for review flips isDraft', () {
    final draft = SellerProductDraft.fromDetail(
      _detail.copyWithDraft(true),
    ).copyWith(isDraft: false);

    expect(draft.toInput()['isDraft'], false);
  });

  group('SellerProductCategoryNode', () {
    test('prefers the ready-made path label', () {
      final node = SellerProductCategoryNode.fromJson(const {
        '_id': 5,
        'parentId': 2,
        'name': 'Winter Wear',
        'level': 2,
        'path': 'Mens / Winter Wear',
      });

      expect(node.id, 5);
      expect(node.label, 'Mens / Winter Wear');
    });

    test('falls back to the plain name', () {
      final node = SellerProductCategoryNode.fromJson(const {
        '_id': 2,
        'name': 'Mens',
        'level': 1,
      });

      expect(node.label, 'Mens');
    });
  });
  test('emptying the sale price lifts the sale', () {
    // A partial update sends only what changed, so a null reads as "leave it
    // alone": a seller could set a sale from the editor and never lift it.
    // Checked live: the server clears the price on a 0 and each date on an
    // empty string, and ignores a null on this endpoint.
    const onSale = SellerProductDetail(
      iri: SellerIri('/api/seller/products/50'),
      productId: 65,
      sku: 'demo-sneaker',
      name: 'Runner Sneakers',
      type: 'simple',
      price: 100,
      specialPrice: 70,
      specialPriceFrom: '2026-09-01',
      specialPriceTo: '2026-09-30',
    );

    final draft = SellerProductDraft.fromDetail(
      onSale,
    ).copyWith(clearSpecialPrice: true);

    final input = draft.toInput();
    expect(input['specialPrice'], 0);
    expect(input['specialPriceFrom'], '');
    expect(input['specialPriceTo'], '');
  });

  test('a sale left alone is not touched', () {
    const onSale = SellerProductDetail(
      iri: SellerIri('/api/seller/products/50'),
      productId: 65,
      sku: 'demo-sneaker',
      name: 'Runner Sneakers',
      type: 'simple',
      price: 100,
      specialPrice: 70,
      specialPriceFrom: '2026-09-01',
      specialPriceTo: '2026-09-30',
    );

    final input = SellerProductDraft.fromDetail(onSale).toInput();

    expect(input.containsKey('specialPrice'), isFalse);
    expect(input.containsKey('specialPriceFrom'), isFalse);
    expect(input.containsKey('specialPriceTo'), isFalse);
  });

  test('a changed sale price still goes as itself', () {
    const onSale = SellerProductDetail(
      iri: SellerIri('/api/seller/products/50'),
      productId: 65,
      sku: 'demo-sneaker',
      name: 'Runner Sneakers',
      type: 'simple',
      price: 100,
      specialPrice: 70,
    );

    final input = SellerProductDraft.fromDetail(
      onSale,
    ).copyWith(specialPrice: 55).toInput();

    expect(input['specialPrice'], 55);
  });
  test('unsaved flags go out as the ON defaults the product lists', () {
    const fresh = SellerProductDetail(
      iri: SellerIri('/theme/api-4.9/public/api/seller/products/50'),
      productId: 65,
      sku: 'fresh',
      name: 'Fresh',
      type: 'simple',
      status: 0,
      price: 0,
      quantity: 0,
      weight: 0,
      urlKey: 'fresh',
      shortDescription: '',
      visibleIndividually: false,
      featured: false,
      isNew: false,
      isDraft: false,
      attributes: [
        SellerProductAttributeValue(
          code: 'status',
          name: 'Status',
          type: 'boolean',
          value: '1',
        ),
        SellerProductAttributeValue(
          code: 'new',
          name: 'New',
          type: 'boolean',
          value: '1',
        ),
        SellerProductAttributeValue(
          code: 'featured',
          name: 'Featured',
          type: 'boolean',
          value: '1',
        ),
        SellerProductAttributeValue(
          code: 'visible_individually',
          name: 'Visible',
          type: 'boolean',
          value: '1',
        ),
      ],
    );

    expect(fresh.attributeFlag('status'), isTrue);
    expect(SellerProductDraft.fromDetail(fresh).toInput(), {
      'id': '/theme/api-4.9/public/api/seller/products/50',
      'status': 1,
      'visibleIndividually': 1,
      'new': 1,
      'featured': 1,
    });
  });

  test('a flag the product lists as 0 is not sent', () {
    const off = SellerProductDetail(
      iri: SellerIri('/theme/api-4.9/public/api/seller/products/50'),
      productId: 65,
      sku: 'off',
      name: 'Off',
      type: 'simple',
      status: 0,
      price: 0,
      quantity: 0,
      weight: 0,
      urlKey: 'off',
      shortDescription: '',
      attributes: [
        SellerProductAttributeValue(
          code: 'status',
          name: 'Status',
          type: 'boolean',
          value: '0',
        ),
      ],
    );

    expect(off.attributeFlag('status'), isFalse);
    expect(SellerProductDraft.fromDetail(off).toInput(), {
      'id': '/theme/api-4.9/public/api/seller/products/50',
    });
  });
}

extension on SellerProductDetail {
  /// Small helper so the draft test can build a stored-as-draft product.
  SellerProductDetail copyWithDraft(bool value) => SellerProductDetail(
    iri: iri,
    productId: productId,
    sku: sku,
    name: name,
    type: type,
    status: status,
    isDraft: value,
    price: price,
    quantity: quantity,
  );
}
