import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

/// The dashboard endpoint answers with several panels; the screen renders all
/// of them, so each one needs a parser that survives the shapes the server
/// actually sends.
void main() {
  group('SellerDashboard panels', () {
    test('the sales series parses its points', () {
      final dashboard = SellerDashboard.fromJson(const {
        'totalSales': {
          'over_time': [
            {'label': '16 Jul', 'total': 0, 'count': 0},
            {'label': '17 Jul', 'total': 39.98, 'count': 2},
          ],
        },
      });

      expect(dashboard.salesSeries, hasLength(2));
      expect(dashboard.salesSeries.last.label, '17 Jul');
      expect(dashboard.salesSeries.last.total, closeTo(39.98, 0.001));
      expect(dashboard.salesSeries.last.count, 2);
    });

    test('a money figure sent as a decimal string still parses', () {
      final dashboard = SellerDashboard.fromJson(const {
        'totalSales': {
          'over_time': [
            {'label': '1 Aug', 'total': '125.5000', 'count': 3},
          ],
        },
      });

      expect(dashboard.salesSeries.single.total, closeTo(125.5, 0.001));
    });

    test('the pipeline counts the rows each status carries', () {
      final dashboard = SellerDashboard.fromJson(const {
        'recentOrders': {
          'pending': [],
          'processing': [<dynamic>[]],
          'completed': [<dynamic>[], <dynamic>[]],
          'closed': [],
        },
      });

      expect(dashboard.ordersByStatus, {
        'pending': 0,
        'processing': 1,
        'completed': 2,
        'closed': 0,
      });
    });

    test('best sellers keep the formatted revenue the server sent', () {
      final dashboard = SellerDashboard.fromJson(const {
        'topProducts': [
          {
            'id': 56,
            'name': 'Stoneware Mug',
            'sku': 'demo-mug',
            'price': '12.5000',
            'formatted_price': r'$12.50',
            'formatted_revenue': r'$50.00',
            'images': [],
          },
        ],
      });

      final product = dashboard.bestSellers.single;
      expect(product.name, 'Stoneware Mug');
      expect(product.formattedPrice, r'$12.50');
      expect(product.formattedRevenue, r'$50.00');
      expect(product.imageUrl, isNull);
    });

    test('low stock carries the quantity left', () {
      final dashboard = SellerDashboard.fromJson(const {
        'stockThreshold': [
          {
            'id': 106,
            'name': 'Puffer Jacket',
            'sku': 'SP-008',
            'total_quantity': 8,
            'images': [],
          },
        ],
      });

      expect(dashboard.lowStock.single.quantity, 8);
    });

    test('a customer with no name falls back to their email', () {
      final dashboard = SellerDashboard.fromJson(const {
        'topCustomers': [
          {
            'id': 3,
            'email': 'shopper@example.com',
            'full_name': null,
            'orders': 1,
          },
        ],
      });

      expect(dashboard.bestCustomers.single.name, 'shopper@example.com');
      expect(dashboard.bestCustomers.single.orders, 1);
    });

    test('a marketplace that reports no panels renders empty, not broken', () {
      final dashboard = SellerDashboard.fromJson(const {});

      expect(dashboard.salesSeries, isEmpty);
      expect(dashboard.bestSellers, isEmpty);
      expect(dashboard.lowStock, isEmpty);
      expect(dashboard.bestCustomers, isEmpty);
      expect(dashboard.ordersByStatus, isEmpty);
      expect(dashboard.kpi('total_orders'), SellerKpi.empty);
    });
  });
}
