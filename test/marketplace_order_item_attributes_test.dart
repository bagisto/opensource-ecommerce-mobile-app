import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an item keeps the lines web prints under it', () {
    final line = SellerOrderLine.fromJson({
      'id': 1,
      'orderItemId': 9,
      'name': 'Booking — Default',
      'sku': 'booking-default',
      'attributes': [
        {'name': 'Booking From', 'label': '12 October, 2026 02:40 PM'},
        {'name': 'Booking Till', 'label': '12 October, 2026 03:10 PM'},
        {'name': 'Location', 'label': 'Sector 63, Noida'},
        {'name': ' ', 'label': 'ignored'},
      ],
    });

    expect(line.attributes.map((a) => a.name), [
      'Booking From',
      'Booking Till',
      'Location',
    ]);
    expect(line.attributes.first.label, '12 October, 2026 02:40 PM');
  });

  test('an item without attributes has none', () {
    final line = SellerOrderLine.fromJson({
      'id': 1,
      'orderItemId': 9,
      'name': 'Plain',
      'sku': 'plain',
    });

    expect(line.attributes, isEmpty);
  });
}
