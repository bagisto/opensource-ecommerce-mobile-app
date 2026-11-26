import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

// Price fields exactly as the live API returns them.
const _configurable = {
  'id': '/api/shop/products/2533',
  '_id': 2533,
  'type': 'configurable',
  'price': '0',
  'specialPrice': null,
  'formattedPrice': r'$0.00',
  'formattedSpecialPrice': null,
  'minimumPrice': '4490',
  'formattedMinimumPrice': r'$4,490.00',
  'regularMinimumPrice': '5990',
  'formattedRegularMinimumPrice': r'$5,990.00',
};
const _simpleSpecial = {
  'id': '/api/shop/products/22',
  '_id': 22,
  'type': 'simple',
  'price': '3000',
  'specialPrice': '2700',
  'formattedPrice': r'$3,000.00',
  'formattedSpecialPrice': r'$2,700.00',
  'minimumPrice': '2700',
  'formattedMinimumPrice': r'$2,700.00',
  'regularMinimumPrice': '3000',
  'formattedRegularMinimumPrice': r'$3,000.00',
};
const _noDiscount = {
  'id': '/api/shop/products/2358',
  '_id': 2358,
  'type': 'simple',
  'price': '4000',
  'formattedPrice': r'$4,000.00',
  'minimumPrice': '4000',
  'formattedMinimumPrice': r'$4,000.00',
  'regularMinimumPrice': '4000',
  'formattedRegularMinimumPrice': r'$4,000.00',
};

void main() {
  test('home cards strike the regular price for discounted products', () {
    final configurable = HomeProduct.fromJson(Map.of(_configurable));
    expect(configurable.hasDiscount, isTrue);
    expect(configurable.displayPriceLabel, r'$4,490.00');
    expect(configurable.originalPriceLabel, r'$5,990.00');
    expect(configurable.discountPercent, 25);

    final simple = HomeProduct.fromJson(Map.of(_simpleSpecial));
    expect(simple.displayPriceLabel, r'$2,700.00');
    expect(simple.originalPriceLabel, r'$3,000.00');

    final plain = HomeProduct.fromJson(Map.of(_noDiscount));
    expect(plain.hasDiscount, isFalse);
    expect(plain.originalPriceLabel, isNull);
  });

  test('product model strikes the regular price for discounted products', () {
    final configurable = ProductModel.fromJson(Map.of(_configurable));
    expect(configurable.formattedDisplayPrice, r'$4,490.00');
    expect(configurable.formattedOriginalPrice, r'$5,990.00');
    expect(configurable.discountPercent, 25);

    final simple = ProductModel.fromJson(Map.of(_simpleSpecial));
    expect(simple.formattedOriginalPrice, r'$3,000.00');

    expect(ProductModel.fromJson(Map.of(_noDiscount)).formattedOriginalPrice,
        isNull);
  });

  test('home product queries request the regular price', () {
    expect(ProductQueries.getProducts, contains('formattedRegularMinimumPrice'));
  });

  test('regular price survives the recently viewed round trip', () {
    final product = HomeProduct.fromJson(Map.of(_configurable));
    final restored = HomeProduct.fromJson(product.toJson());
    expect(restored.originalPriceLabel, r'$5,990.00');
  });
}
