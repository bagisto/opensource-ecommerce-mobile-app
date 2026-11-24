import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_configurable_attributes_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// A configurable is generated from option ids at create time and cannot be
/// changed afterwards, so the ids have to be right and the names have to be
/// readable. The seller API supplies neither: option ids arrive as IRIs and
/// every label comes back null.
void main() {
  group('option ids', () {
    test('the bare id is taken out of an IRI', () {
      expect(
        SellerConfigurableAttributesRepository.optionId(
          '/api/attribute_options/3',
        ),
        '3',
      );
    });

    test('an IRI carrying the install path still yields the id', () {
      // What this marketplace actually returns.
      expect(
        SellerConfigurableAttributesRepository.optionId(
          '/theme/api-4.9/public/api/seller_attribute_options/12',
        ),
        '12',
      );
    });

    test('a bare id is left alone', () {
      expect(SellerConfigurableAttributesRepository.optionId('7'), '7');
    });

    test('nothing in, nothing out', () {
      expect(SellerConfigurableAttributesRepository.optionId(null), '');
      expect(SellerConfigurableAttributesRepository.optionId(''), '');
    });
  });

  group('the configurable flag', () {
    test('the server sends it as 1, not true', () {
      // Checked against the live storefront: color and size come back with
      // isConfigurable 1, barcode_type with 0. A strict `== true` would have
      // rejected every attribute and left the picker permanently empty.
      expect(SellerConfigurableAttributesRepository.isConfigurable(1), isTrue);
      expect(SellerConfigurableAttributesRepository.isConfigurable(0), isFalse);
      expect(
        SellerConfigurableAttributesRepository.isConfigurable(true),
        isTrue,
      );
      expect(
        SellerConfigurableAttributesRepository.isConfigurable(false),
        isFalse,
      );
      expect(
        SellerConfigurableAttributesRepository.isConfigurable(null),
        isFalse,
      );
    });
  });

  group('product attribute options', () {
    test('an option keeps its id, not the IRI it arrived as', () {
      // The value stored against the attribute is the bare number, so a
      // dropdown built from the IRI could never match what the product holds.
      final attribute = SellerProductAttributeValue.fromJson(const {
        'code': 'color',
        'name': 'Color',
        'type': 'select',
        'value': '2',
        'options': [
          {'id': '/theme/api-4.9/public/api/seller_attribute_options/1'},
          {'id': '/theme/api-4.9/public/api/seller_attribute_options/2'},
        ],
      });

      expect(attribute.options.map((option) => option.id), ['1', '2']);
      // Which means the stored value now matches one of them.
      expect(
        attribute.options.any((option) => option.id == attribute.value),
        isTrue,
      );
    });

    test('a null label falls back to the id rather than a blank row', () {
      final attribute = SellerProductAttributeValue.fromJson(const {
        'code': 'size',
        'name': 'Size',
        'type': 'select',
        'options': [
          {'id': '/api/seller_attribute_options/6', 'label': null},
        ],
      });

      expect(attribute.options.single.name, '6');
    });

    test('a label is used when the server supplies one', () {
      final attribute = SellerProductAttributeValue.fromJson(const {
        'code': 'size',
        'name': 'Size',
        'type': 'select',
        'options': [
          {'id': '/api/seller_attribute_options/6', 'label': 'Small'},
        ],
      });

      expect(attribute.options.single.name, 'Small');
    });

    test('an option with no id at all is dropped', () {
      final attribute = SellerProductAttributeValue.fromJson(const {
        'code': 'color',
        'name': 'Color',
        'type': 'select',
        'options': [
          {'id': '', 'label': 'Broken'},
          {'id': '/api/seller_attribute_options/4', 'label': 'Black'},
        ],
      });

      expect(attribute.options, hasLength(1));
      expect(attribute.options.single.name, 'Black');
    });
  });
}
