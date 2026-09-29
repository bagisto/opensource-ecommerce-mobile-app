import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/category/data/models/filter_model.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

// Some Bagisto API installs serialize numeric fields such as `_id` as
// strings ("2") instead of ints (2). See GitHub issue #73.
void main() {
  group('CategoryModel', () {
    test('fromTreeJson accepts string _id and position', () {
      final category = CategoryModel.fromTreeJson({
        'id': '/api/shop/categories/2',
        '_id': '2',
        'position': '3',
      });

      expect(category.numericId, 2);
      expect(category.position, 3);
    });

    test('fromTreeJson still accepts int _id and position', () {
      final category = CategoryModel.fromTreeJson({
        'id': '/api/shop/categories/2',
        '_id': 2,
        'position': 3,
      });

      expect(category.numericId, 2);
      expect(category.position, 3);
    });

    test('fromTreeJson accepts string _id in children', () {
      final category = CategoryModel.fromTreeJson({
        'id': '/api/shop/categories/1',
        '_id': '1',
        'children': {
          'edges': [
            {
              'node': {
                'id': '/api/shop/categories/5',
                '_id': '5',
                'status': '1',
              },
            },
          ],
        },
      });

      expect(category.children.single.numericId, 5);
    });

    test('fromHomeCategoryJson accepts string _id and position', () {
      final category = CategoryModel.fromHomeCategoryJson({
        'id': '/api/shop/categories/2',
        '_id': '2',
        'position': '4',
      });

      expect(category.numericId, 2);
      expect(category.position, 4);
    });

    test('non-numeric _id parses to null instead of throwing', () {
      final category = CategoryModel.fromTreeJson({
        'id': '/api/shop/categories/2',
        '_id': 'abc',
      });

      expect(category.numericId, isNull);
    });
  });

  test('HomeCategory.fromJson accepts string _id', () {
    final category = HomeCategory.fromJson({
      'id': '/api/shop/categories/2',
      '_id': '2',
    });

    expect(category.numericId, 2);
  });

  test('FilterAttribute.fromCategoryFilterJson accepts string _id', () {
    final attribute = FilterAttribute.fromCategoryFilterJson({
      'id': '/api/shop/attributes/23',
      '_id': '23',
      'code': 'color',
    });

    expect(attribute.numericId, 23);
  });

  test('FilterAttribute.fromCategoryFilterJson accepts string position', () {
    final attribute = FilterAttribute.fromCategoryFilterJson({
      'id': '/api/shop/attributes/23',
      '_id': 23,
      'code': 'color',
      'position': '2',
    });

    expect(attribute.position, 2);
  });

  test('FilterOption.fromCategoryFilterJson accepts string _id', () {
    final option = FilterOption.fromCategoryFilterJson({
      'id': '/api/shop/attribute-options/7',
      '_id': '7',
      'adminName': 'Red',
    });

    expect(option.numericId, 7);
  });

  test('ProductModel.fromJson accepts string _id', () {
    final product = ProductModel.fromJson({
      'id': '/api/shop/products/12',
      '_id': '12',
      'name': 'Hoodie',
    });

    expect(product.numericId, 12);
  });

  test('ProductVariant.fromJson accepts string _id', () {
    final variant = ProductVariant.fromJson({
      'id': '/api/shop/products/13',
      '_id': '13',
    });

    expect(variant.numericId, 13);
  });

  group('product child models accept string _id', () {
    test('ProductImage', () {
      final image = ProductImage.fromJson({'id': '1', '_id': '21'});
      expect(image.numericId, 21);
    });

    test('SuperAttribute', () {
      final attribute = SuperAttribute.fromJson({'id': '1', '_id': '22'});
      expect(attribute.numericId, 22);
    });

    test('AttributeOption', () {
      final option = AttributeOption.fromJson({'id': '1', '_id': '23'});
      expect(option.numericId, 23);
    });

    test('DownloadableLink', () {
      final link = DownloadableLink.fromJson({'id': '1', '_id': '24'});
      expect(link.numericId, 24);
    });

    test('DownloadableSample', () {
      final sample = DownloadableSample.fromJson({'id': '1', '_id': '25'});
      expect(sample.numericId, 25);
    });
  });
}
