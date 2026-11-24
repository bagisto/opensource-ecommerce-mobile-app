import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:flutter_test/flutter_test.dart';

/// What `updateSellerProduct` does with a type-specific payload.
///
/// Verified live against 2.4.9: a payload of `{id, variants}` is answered OK
/// and written nowhere. The same payload with any parent field beside it —
/// `sku`, `name`, `description`, it makes no difference which — writes every
/// variant. The type-specific sets (`variants`, `booking`, `links`,
/// `bundleOptions`, `downloadableLinks`, `downloadableSamples`) all travel on
/// that same request, so all of them need the parent field to be there.
const _iri = SellerIri('/theme/api-4.9/public/api/seller/products/296');

const _configurable = SellerProductDetail(
  iri: _iri,
  productId: 317,
  sku: 'probe-full',
  name: 'Configurable Shirt',
  type: 'configurable',
  status: 1,
);

SellerProductDraft get _draft => SellerProductDraft.fromDetail(_configurable);

void main() {
  test('variants alone still carry a parent field', () {
    final input = _draft
        .copyWith(
          variants: const [SellerVariantEdit(variantId: 318, price: 1200)],
        )
        .toInput();

    expect(input['variants'], isNotNull);
    expect(
      input['sku'],
      'probe-full',
      reason: 'the server ignores a payload holding nothing but variants',
    );
  });

  test('the anchor is the SKU the product already has', () {
    // Anything else would rename the product as a side effect of saving a
    // variant.
    final input = _draft.copyWith(booking: _booking).toInput();

    expect(input['sku'], _configurable.sku);
  });

  test('a parent field the seller changed is anchor enough', () {
    final input = _draft
        .copyWith(
          description: 'ihic',
          variants: const [SellerVariantEdit(variantId: 318, price: 1200)],
        )
        .toInput();

    expect(input['description'], 'ihic');
    // Nothing extra is invented when the payload already carries one.
    expect(input.containsKey('sku'), isFalse);
  });

  test('every type-specific set is anchored, not just variants', () {
    for (final draft in <SellerProductDraft>[
      _draft.copyWith(booking: _booking),
      _draft.copyWith(
        links: const [SellerGroupedLink(associatedProductId: 2, qty: 1)],
      ),
      _draft.copyWith(bundleOptions: const [SellerBundleOption(label: 'Bag')]),
      _draft.copyWith(
        downloadableLinks: const [SellerDownloadableLink(title: 'Album')],
      ),
      _draft.copyWith(
        downloadableSamples: const [SellerDownloadableSample(title: 'Sleeve')],
      ),
    ]) {
      expect(draft.toInput()['sku'], _configurable.sku);
    }
  });

  test('a plain edit is left exactly as it was', () {
    final input = _draft.copyWith(description: 'ihic').toInput();

    expect(input.keys.toSet(), {'id', 'description'});
  });
}

const _booking = SellerBookingConfig(
  type: 'default',
  slots: [SellerBookingSlot(day: 1, from: '09:00', to: '17:00')],
);
