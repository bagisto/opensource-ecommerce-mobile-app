import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_marketing.dart';
import 'package:flutter_test/flutter_test.dart';

/// A rule as the server hands it back.
///
/// It echoes an `attribute_type` it worked out itself, which is not part of
/// the input and must not be sent back.
const _payload = {
  'id': 28,
  'name': 'Monsoon 10% off',
  'status': true,
  'actionType': 'by_percent',
  'discountAmount': 10,
  'conditionType': 1,
  'channels': [1],
  'customerGroups': [1, 2, 3],
  'conditions': [
    {
      'attribute': 'product|category_ids',
      'operator': '{}',
      'value': '3',
      'attribute_type': 'multiselect',
    },
  ],
};

void main() {
  test('a rule reads the conditions the server sends', () {
    final discount = SellerProductDiscount.fromJson(_payload);

    expect(discount.conditions, hasLength(1));
    expect(discount.conditions.single.attribute, 'product|category_ids');
    expect(discount.conditions.single.operator, '{}');
    expect(discount.conditions.single.value, '3');
  });

  test('an edit carries the conditions back', () {
    // updateSellerProductDiscount is a full replace: a payload without
    // `conditions` clears them, so a rule edited from a screen that never
    // read them would lose them on save. Verified against the live server.
    final discount = SellerProductDiscount.fromJson(_payload);
    final input = discount.copyWith(name: 'Monsoon 15% off').toInput();

    expect(input['conditions'], [
      {'attribute': 'product|category_ids', 'operator': '{}', 'value': '3'},
    ]);
  });

  test('the type the server added is not sent back', () {
    final input = SellerProductDiscount.fromJson(_payload).toInput();
    final condition = (input['conditions'] as List).single as Map;

    expect(condition.containsKey('attribute_type'), isFalse);
    expect(condition.keys.toSet(), {'attribute', 'operator', 'value'});
  });

  test('a rule with no conditions sends an empty list, not nothing', () {
    // The key still travels: leaving it out and sending an empty list mean
    // the same thing to the server, and sending it keeps the shape honest.
    final discount = SellerProductDiscount.fromJson({
      ..._payload,
      'conditions': const <dynamic>[],
    });

    expect(discount.conditions, isEmpty);
    expect(discount.toInput()['conditions'], isEmpty);
  });

  test('a condition names its attribute the way a seller reads it', () {
    const condition = SellerDiscountCondition(
      attribute: 'product|category_ids',
      operator: '{}',
      value: '3',
    );

    expect(condition.attributeLabel, 'category ids');
  });
}
