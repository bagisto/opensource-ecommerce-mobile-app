import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/cart/data/models/cart_model.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/domain/models/customizable_file_selection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductModel customizableOptions', () {
    test('parses Bagisto customizable option connection with prices', () {
      final product = ProductModel.fromJson({
        'id': '/api/shop/products/2493',
        '_id': 2493,
        'sku': 'sku-3495349058',
        'type': 'simple',
        'name': 'Aurora Cream Winter Blazer Coat',
        'customizableOptions': {
          'edges': [
            {
              'node': {
                'id': '/api/product_customizable_options/11',
                '_id': 11,
                'type': 'multiselect',
                'isRequired': '1',
                'maxCharacters': null,
                'supportedFileExtensions': null,
                'sortOrder': 0,
                'translation': {
                  'id': '/api/product_customizable_option_translations/11',
                  'locale': 'en',
                  'label': 'Custom',
                },
                'customizableOptionPrices': {
                  'edges': [
                    {
                      'node': {
                        'id': '/api/product_customizable_option_prices/15',
                        '_id': 15,
                        'label': 'Test 1',
                        'price': '10',
                        'formattedPrice': r'$10.00',
                        'sortOrder': 0,
                      },
                    },
                  ],
                },
              },
            },
          ],
        },
      });

      expect(product.customizableOptions, hasLength(1));
      final option = product.customizableOptions.single;
      expect(option.id, '/api/product_customizable_options/11');
      expect(option.numericId, 11);
      expect(option.type, 'multiselect');
      expect(option.isRequired, isTrue);
      expect(option.label, 'Custom');
      expect(option.prices, hasLength(1));
      expect(option.prices.single.numericId, 15);
      expect(option.prices.single.label, 'Test 1');
      expect(option.prices.single.formattedPrice, r'$10.00');
    });

    test('normalizes supported file extensions', () {
      final option = ProductCustomizableOption.fromJson({
        'id': '/api/product_customizable_options/21',
        '_id': 21,
        'type': 'file',
        'isRequired': '1',
        'supportedFileExtensions': 'png, jpg,pdf',
        'translation': {'label': 'file'},
      });

      expect(option.supportedFileExtensionList, ['png', 'jpg', 'pdf']);
      expect(option.allowsFileName('sample.PDF'), isTrue);
      expect(option.allowsFileName('sample.txt'), isFalse);
    });
  });

  group('Cart custom option payload', () {
    test('simple add-to-cart variables include customizableOptions', () {
      final request = CartRepository.buildAddToCartRequest(
        productId: 2493,
        quantity: 1,
        customizableOptions: const {
          '11': [15],
        },
      );

      expect(request.mutation, CartMutations.addSimpleProductToCart);
      expect(request.variables['productId'], 2493);
      expect(request.variables['quantity'], 1);
      expect(request.variables['customizableOptions'], {
        '11': [15],
      });
    });

    test(
      'file selections are serialized for the GraphQL custom option payload',
      () {
        const file = CustomizableFileSelection(
          path: '/tmp/sample.pdf',
          name: 'sample.pdf',
          size: 128,
        );

        final request = CartRepository.buildAddToCartRequest(
          productId: 2493,
          quantity: 2,
          customizableOptions: const {
            '11': [15],
            '14': ['engraving text'],
            '21': [file],
          },
        );

        expect(request.mutation, CartMutations.addSimpleProductToCart);
        expect(request.variables['productId'], 2493);
        expect(request.variables['quantity'], 2);
        expect(request.variables['customizableOptions'], {
          '11': [15],
          '14': ['engraving text'],
          '21': ['sample.pdf'],
        });
      },
    );
  });

  group('CartModel shop API response', () {
    test('parses snake_case cart fields from Bagisto shop API', () {
      final cart = CartModel.fromJson({
        'id': 8723,
        'is_guest': true,
        'items_count': 1,
        'items_qty': 2,
        'sub_total': 100,
        'formatted_sub_total': r'$100.00',
        'tax_total': 5,
        'formatted_tax_total': r'$5.00',
        'shipping_amount': 0,
        'formatted_shipping_amount': r'$0.00',
        'discount_amount': 0,
        'formatted_discount_amount': r'$0.00',
        'grand_total': 105,
        'formatted_grand_total': r'$105.00',
        'items': [
          {
            'id': 55,
            'quantity': 2,
            'type': 'simple',
            'name': 'Aurora Cream Winter Blazer Coat',
            'price': 50,
            'formatted_price': r'$50.00',
            'total': 100,
            'formatted_total': r'$100.00',
            'product_url_key': 'aurora-cream-winter-blazer-coat',
            'can_change_qty': true,
          },
        ],
      });

      expect(cart.id, 8723);
      expect(cart.itemsCount, 1);
      expect(cart.itemsQty, 2);
      expect(cart.subtotal, 100);
      expect(cart.taxAmount, 5);
      expect(cart.grandTotal, 105);
      expect(cart.items.single.id, 55);
      expect(cart.items.single.quantity, 2);
      expect(
        cart.items.single.productUrlKey,
        'aurora-cream-winter-blazer-coat',
      );
    });
  });
}
