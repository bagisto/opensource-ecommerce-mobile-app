import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/features/cart/data/models/cart_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartModel Tax Fields & Calculations', () {
    test('parses subtotal and shipping incl tax and detects hasTaxIncluded', () {
      final json = {
        'id': '394',
        'subtotal': '240.30',
        'formattedSubtotal': '\$240.30',
        'subTotalInclTax': '288.36',
        'formattedSubTotalInclTax': '\$288.36',
        'shippingAmount': '12.00',
        'formattedShippingAmount': '\$12.00',
        'shippingAmountInclTax': '14.40',
        'formattedShippingAmountInclTax': '\$14.40',
        'taxTotal': '50.46',
        'formattedTaxTotal': '\$50.46',
        'grandTotal': '302.76',
        'formattedGrandTotal': '\$302.76',
        'items': {
          'edges': [
            {
              'node': {
                'id': '123',
                'name': 'simple rma admin product',
                'price': '240.30',
                'formattedPrice': '\$240.30',
                'priceInclTax': '288.36',
                'formattedPriceInclTax': '\$288.36',
                'total': '240.30',
                'formattedTotal': '\$240.30',
                'totalInclTax': '288.36',
                'formattedTotalInclTax': '\$288.36',
                'quantity': 1,
              }
            }
          ]
        }
      };

      final cart = CartModel.fromJson(json);

      expect(cart.subtotal, 240.30);
      expect(cart.formattedSubtotal, '\$240.30');
      expect(cart.subTotalInclTax, 288.36);
      expect(cart.formattedSubTotalInclTax, '\$288.36');
      expect(cart.shippingAmount, 12.00);
      expect(cart.formattedShippingAmount, '\$12.00');
      expect(cart.shippingAmountInclTax, 14.40);
      expect(cart.formattedShippingAmountInclTax, '\$14.40');
      expect(cart.taxAmount, 50.46);
      expect(cart.hasTaxIncluded, isTrue);

      final item = cart.items.first;
      expect(item.price, 240.30);
      expect(item.priceInclTax, 288.36);
      expect(item.formattedPriceInclTax, '\$288.36');
    });

    test('hasTaxIncluded is false when subTotalInclTax equals subtotal', () {
      final json = {
        'subtotal': '100.00',
        'subTotalInclTax': '100.00',
        'taxTotal': '0.00',
      };
      final cart = CartModel.fromJson(json);
      expect(cart.hasTaxIncluded, isFalse);
    });
  });

  group('StoreConfig Tax Settings', () {
    test('parses tax cart display settings correctly', () {
      final json = {
        'taxCartDisplayPrices': 'excluding_tax',
        'taxCartDisplaySubtotal': 'both',
        'taxCartDisplayShipping': 'both',
      };
      final config = StoreConfig.fromJson(json);

      expect(config.taxCartDisplayPrices, 'excluding_tax');
      expect(config.taxCartDisplaySubtotal, 'both');
      expect(config.taxCartDisplayShipping, 'both');
      expect(config.showSubtotalBoth, isTrue);
      expect(config.showSubtotalInclTax, isTrue);
      expect(config.showShippingBoth, isTrue);
      expect(config.showShippingInclTax, isTrue);
    });

    test('handles default / missing tax settings gracefully', () {
      final config = StoreConfig.fromJson({});

      expect(config.taxCartDisplayPrices, isNull);
      expect(config.taxCartDisplaySubtotal, isNull);
      expect(config.taxCartDisplayShipping, isNull);
      expect(config.showSubtotalBoth, isFalse);
      expect(config.showSubtotalInclTax, isFalse);
      expect(config.showShippingBoth, isFalse);
      expect(config.showShippingInclTax, isFalse);
    });

    test('parses full tax configuration suite', () {
      final json = {
        'taxCartDisplayPrices': 'both',
        'taxCartDisplaySubtotal': 'both',
        'taxCartDisplayShipping': 'both',
        'taxCartShowBreakdown': '1',
        'taxOrderDisplayPrices': 'both',
        'taxOrderDisplaySubtotal': 'both',
        'taxOrderDisplayShipping': 'both',
      };
      final config = StoreConfig.fromJson(json);

      expect(config.showItemPriceBoth, isTrue);
      expect(config.showTaxBreakdown, isTrue);
      expect(config.showOrderItemPriceBoth, isTrue);
      expect(config.showOrderSubtotalBoth, isTrue);
      expect(config.showOrderShippingBoth, isTrue);
    });
  });

  group('CartItemModel Price Formatting by Tax Setting', () {
    final item = CartItemModel(
      id: 1,
      cartId: 10,
      productId: 100,
      name: 'Test Product',
      price: 100.0,
      priceInclTax: 120.0,
      total: 200.0,
      totalInclTax: 240.0,
      quantity: 2,
      formattedPrice: '\$100.00',
      formattedPriceInclTax: '\$120.00',
      formattedTotal: '\$200.00',
      formattedTotalInclTax: '\$240.00',
    );

    test('excluding_tax displays base price with no sub-value', () {
      final config = StoreConfig.fromJson({'taxCartDisplayPrices': 'excluding_tax'});

      expect(item.formattedUnitPrice(config), '\$100.00');
      expect(item.formattedUnitPriceSubValue(config, (val) => 'Excl. Tax: $val'), isNull);
      expect(item.formattedLineTotal(config), '\$200.00');
      expect(item.formattedLineTotalSubValue(config, (val) => 'Excl. Tax: $val'), isNull);
    });

    test('including_tax displays price with tax and no sub-value', () {
      final config = StoreConfig.fromJson({'taxCartDisplayPrices': 'including_tax'});

      expect(item.formattedUnitPrice(config), '\$120.00');
      expect(item.formattedUnitPriceSubValue(config, (val) => 'Excl. Tax: $val'), isNull);
      expect(item.formattedLineTotal(config), '\$240.00');
      expect(item.formattedLineTotalSubValue(config, (val) => 'Excl. Tax: $val'), isNull);
    });

    test('both displays price with tax and Excl. Tax sub-value', () {
      final config = StoreConfig.fromJson({'taxCartDisplayPrices': 'both'});

      expect(item.formattedUnitPrice(config), '\$120.00');
      expect(
        item.formattedUnitPriceSubValue(config, (val) => 'Excl. Tax: $val'),
        'Excl. Tax: \$100.00',
      );
      expect(item.formattedLineTotal(config), '\$240.00');
      expect(
        item.formattedLineTotalSubValue(config, (val) => 'Excl. Tax: $val'),
        'Excl. Tax: \$200.00',
      );
    });
  });

  group('CartModel appliedTaxes breakdown', () {
    test('parses appliedTaxes map and detects hasAppliedTaxes', () {
      final json = {
        'id': '10',
        'subtotal': '100.00',
        'appliedTaxes': {
          'VAT (20%)': '\$20.00',
          'Eco Tax': '\$2.00',
        },
      };
      final cart = CartModel.fromJson(json);

      expect(cart.hasAppliedTaxes, isTrue);
      expect(cart.appliedTaxes!['VAT (20%)'], '\$20.00');
      expect(cart.appliedTaxes!['Eco Tax'], '\$2.00');
    });

    test('generates itemized taxBreakdownLines with items and delivery charges', () {
      final json = {
        'id': '10',
        'subtotal': '388.00',
        'subtotalInclTax': '465.60',
        'shippingAmount': '12.00',
        'shippingAmountInclTax': '14.40',
        'appliedTaxes': {
          'tax-in (20%)': '\$80.00',
        },
        'items': [
          {
            'id': '1',
            'name': 'seller unique simple product',
            'quantity': 2,
            'price': 194.0,
            'total': 388.0,
            'taxAmount': 77.60,
          }
        ],
      };
      final cart = CartModel.fromJson(json);

      expect(cart.taxBreakdownLines.length, 1);
      final line = cart.taxBreakdownLines.first;
      expect(line.rateName, 'tax-in (20%)');
      expect(line.rateTotal, '\$80.00');
      expect(line.items.length, 2);

      // Product item
      expect(line.items[0].name, 'seller unique simple product');
      expect(line.items[0].taxAmount, '\$77.60');
      expect(line.items[0].taxableAmount, '\$388.00');

      // Delivery charges item
      expect(line.items[1].name, 'Delivery Charges');
      expect(line.items[1].taxAmount, '\$2.40');
      expect(line.items[1].taxableAmount, '\$12.00');
    });
  });
}

