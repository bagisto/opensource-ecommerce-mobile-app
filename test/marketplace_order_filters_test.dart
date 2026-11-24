import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SellerOrderFilters', () {
    test('nothing set sends nothing', () {
      // An empty filter is a real filter to the server: sending
      // `status: ""` matches no order at all.
      expect(const SellerOrderFilters().toVariables(), isEmpty);
      expect(
        const SellerOrderFilters(status: '', customerName: '   ').toVariables(),
        isEmpty,
      );
    });

    test('it sends the names the API takes, not the Dart ones', () {
      const filters = SellerOrderFilters(
        status: 'processing',
        from: '2026-01-01',
        customerName: 'test',
        customerEmail: 'test@test.com',
        location: 'Bengaluru',
        paymentMethod: 'cashondelivery',
        shippingMethod: 'flatrate_flatrate',
        productName: 'Shirt',
        totalItemCount: 2,
        sellerTotal: 199.5,
      );

      expect(filters.toVariables(), {
        'status': 'processing',
        'from': '2026-01-01',
        'customer_name': 'test',
        'customer_email': 'test@test.com',
        'location': 'Bengaluru',
        'payment_method': 'cashondelivery',
        'shipping_method': 'flatrate_flatrate',
        'product_name': 'Shirt',
        'total_item_count': 2,
        'seller_total': 199.5,
      });
    });

    test('the count is what the badge shows', () {
      expect(const SellerOrderFilters().activeCount, 0);
      expect(
        const SellerOrderFilters(
          status: 'completed',
          location: 'Pune',
        ).activeCount,
        2,
      );
    });

    test('a value is trimmed before it travels', () {
      expect(const SellerOrderFilters(location: '  Pune  ').toVariables(), {
        'location': 'Pune',
      });
    });
  });

  group('SellerOrderAddress', () {
    // The server sends the street as a list of lines, not one string.
    const json = {
      'name': 'Aarav Sharma',
      'address': ['21 Residency Road', 'Flat 4'],
      'city': 'Bengaluru',
      'state': 'KA',
      'country': 'IN',
      'postcode': '560025',
      'phone': '9876543210',
      'email': 'aarav@example.com',
    };

    test('it reads the street lines the server sends as a list', () {
      final address = SellerOrderAddress.fromJson(json);

      expect(address.lines, ['21 Residency Road', 'Flat 4']);
      expect(address.name, 'Aarav Sharma');
    });

    test('it lays the address out as a reader writes it', () {
      expect(SellerOrderAddress.fromJson(json).displayLines, [
        '21 Residency Road',
        'Flat 4',
        'Bengaluru, KA, 560025',
        'IN',
      ]);
    });

    test('a single-string street still reads', () {
      // Defensive: the field is typed as a list but the shape has changed
      // once already.
      final address = SellerOrderAddress.fromJson({
        'address': '21 Residency Road',
        'city': 'Pune',
      });

      expect(address.lines, ['21 Residency Road']);
    });

    test('an address with nothing in it is recognised as empty', () {
      expect(SellerOrderAddress.fromJson(const {}).isEmpty, isTrue);
      expect(SellerOrderAddress.fromJson(json).isEmpty, isFalse);
    });
  });

  group('SellerOrderDetail', () {
    test('it reads the payment and shipping the 2.4.9 API added', () {
      final detail = SellerOrderDetail.fromJson({
        'id': 4,
        'incrementId': '4',
        'status': 'processing',
        'shippingMethod': 'flatrate_flatrate',
        'shippingTitle': 'Flat Rate - Flat Rate',
        'paymentMethod': 'cashondelivery',
        'paymentMethodTitle': 'Cash On Delivery',
        'billingAddress': {
          'name': 'Aarav Sharma',
          'address': ['21 Residency Road'],
          'city': 'Bengaluru',
        },
        'shippingAddress': {
          'name': 'Aarav Sharma',
          'address': ['21 Residency Road'],
          'city': 'Bengaluru',
        },
      });

      expect(detail.paymentLabel, 'Cash On Delivery');
      expect(detail.shippingLabel, 'Flat Rate - Flat Rate');
      expect(detail.billingAddress?.city, 'Bengaluru');
      expect(detail.shippingAddress?.name, 'Aarav Sharma');
    });

    test('a title-less method falls back to the code', () {
      final detail = SellerOrderDetail.fromJson({
        'id': 4,
        'incrementId': '4',
        'status': 'processing',
        'shippingMethod': 'flatrate_flatrate',
        'paymentMethod': 'cashondelivery',
      });

      expect(detail.shippingLabel, 'flatrate_flatrate');
      expect(detail.paymentLabel, 'cashondelivery');
    });

    test('an order with no address exposes none', () {
      // A virtual order ships nothing, so the pane is left out rather than
      // rendered blank.
      final detail = SellerOrderDetail.fromJson({
        'id': 4,
        'incrementId': '4',
        'status': 'processing',
        'shippingAddress': <String, dynamic>{},
      });

      expect(detail.shippingAddress, isNull);
      expect(detail.billingAddress, isNull);
    });
  });
}
