import 'package:flutter_test/flutter_test.dart';
import 'package:bagisto_flutter/features/category/data/models/category_model.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/category/presentation/bloc/product_list_bloc.dart';

void main() {
  group('Category displayMode tests', () {
    test('CategoryModel parses displayMode from tree and home json', () {
      final treeJson = {
        'id': '2',
        '_id': 2,
        'displayMode': 'description_only',
        'translation': {
          'name': 'Only Description Category',
          'description': '<p>Some description</p>',
        },
      };

      final treeModel = CategoryModel.fromTreeJson(treeJson);
      expect(treeModel.displayMode, 'description_only');

      final homeJson = {
        'id': '3',
        '_id': 3,
        'displayMode': 'products_only',
        'translation': {
          'name': 'Only Products Category',
        },
      };

      final homeModel = CategoryModel.fromHomeCategoryJson(homeJson);
      expect(homeModel.displayMode, 'products_only');
    });

    test('HomeCategory parses displayMode from json', () {
      final json = {
        'id': '2',
        '_id': 2,
        'displayMode': 'products_and_description',
        'position': 1,
        'translation': {
          'name': 'Both',
        },
      };

      final category = HomeCategory.fromJson(json);
      expect(category.displayMode, 'products_and_description');
    });

    test('ProductListState showDescription and showProducts getters', () {
      // 1. description_only: show banner + description, no products
      const descOnlyState = ProductListState(displayMode: 'description_only');
      expect(descOnlyState.showDescription, isTrue);
      expect(descOnlyState.showProducts, isFalse);

      // 2. products_only: show banner + products, no description
      const prodOnlyState = ProductListState(displayMode: 'products_only');
      expect(prodOnlyState.showDescription, isFalse);
      expect(prodOnlyState.showProducts, isTrue);

      // 3. products_and_description: show all
      const bothState = ProductListState(displayMode: 'products_and_description');
      expect(bothState.showDescription, isTrue);
      expect(bothState.showProducts, isTrue);

      // 4. default / null: show all as fallback
      const defaultState = ProductListState(displayMode: null);
      expect(defaultState.showDescription, isTrue);
      expect(defaultState.showProducts, isTrue);
    });
  });
}
