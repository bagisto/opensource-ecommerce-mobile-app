import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:flutter_test/flutter_test.dart';

/// Editing a bundle keeps the options it already has.
///
/// `bundleOptions` replaces the whole set: an entry carrying its
/// `bundleOptionId` is edited in place, one without it is created fresh. The
/// app read none of those ids, so every save deleted the seller's options and
/// made new ones — verified live, where option 12 came back as 13 and its
/// product row 17 as 18 after a save that changed nothing.
void main() {
  const payload = {
    'id': '/api/seller/products/322',
    'sku': 'probe-e2e-bn',
    'type': 'bundle',
    'bundleOptions': [
      {
        'bundleOptionId': 12,
        'label': 'Choose a bag',
        'type': 'radio',
        'isRequired': true,
        'sortOrder': 1,
        'products': [
          {
            'bundleOptionProductId': 17,
            'productId': 272,
            'sku': 'tote-red',
            'name': 'Red tote',
            'qty': 3,
            'isDefault': true,
            'sortOrder': 1,
          },
        ],
      },
    ],
  };

  test('an option read back carries the id the server gave it', () {
    final option = SellerProductDetail.fromJson(payload).bundleOptions.single;

    expect(option.bundleOptionId, 12);
    expect(option.products.single.bundleOptionProductId, 17);
  });

  test('the id travels back, so the option is edited and not replaced', () {
    final option = SellerProductDetail.fromJson(payload).bundleOptions.single;
    final input = option.toInput();

    expect(input['bundleOptionId'], 12);
    expect(
      (input['products'] as List).single,
      containsPair('bundleOptionProductId', 17),
    );
  });

  test('an option the seller just added carries no id', () {
    // Omitting it is how the server is told to create one.
    final input = SellerProductDetail.fromJson(
      payload,
    ).bundleOptions.single.copyWith(label: 'Choose a shoe').toInput();

    expect(input['bundleOptionId'], 12, reason: 'an edit keeps its identity');

    const fresh = SellerBundleOption(label: 'Choose a shoe');
    expect(fresh.toInput().containsKey('bundleOptionId'), isFalse);
  });
}
