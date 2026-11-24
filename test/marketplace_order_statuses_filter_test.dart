import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a set of statuses is never sent as a variable', () {
    const filters = SellerOrderFilters(statuses: ['pending', 'processing']);

    expect(filters.toVariables().containsKey('status'), isFalse);
    expect(filters.isEmpty, isFalse);
  });

  test('copyWith can clear the statuses', () {
    const filters = SellerOrderFilters(statuses: ['pending', 'processing']);

    expect(filters.copyWith(statuses: const []).statuses, isEmpty);
    expect(filters.copyWith(search: 'x').statuses, ['pending', 'processing']);
  });
}
