import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Shape copied from a live `sellerDashboard` response.
const _liveDashboard = {
  'sellerDashboard': {
    'id': '/theme/api-4.9/public/api/seller/dashboard',
    'startDate': '2026-07-15T00:00:00+05:30',
    'endDate': '2026-08-14T15:39:23+05:30',
    'dateRange': '15 Jul - 14 Aug',
    'overAll': {
      'total_customers': {'previous': 2, 'current': 5, 'progress': 150},
      'total_orders': {'previous': 4, 'current': 6, 'progress': 50},
      'total_sales': {
        'previous': 100,
        'current': 250,
        'formatted_total': r'$250.00',
        'progress': 150,
      },
    },
    'totalSales': {
      'over_time': [
        {'label': '15 Jul', 'total': 0, 'count': 0},
      ],
    },
    'recentOrders': {'pending': <dynamic>[]},
    'stockThreshold': <dynamic>[],
    'topProducts': <dynamic>[],
    'topCustomers': <dynamic>[],
    'topCategories': <dynamic>[],
  },
};

GraphQLClient _clientReturning(Map<String, dynamic> data) {
  final link = Link.function((request, [forward]) async* {
    yield Response(data: data, response: const {}, context: const Context());
  });
  return GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: link,
  );
}

void main() {
  test('maps the panels and the date range', () async {
    final repository = SellerDashboardRepository(
      client: _clientReturning(_liveDashboard),
    );

    final dashboard = await repository.load();

    expect(dashboard.dateRange, '15 Jul - 14 Aug');
    expect(dashboard.startDate, '2026-07-15T00:00:00+05:30');
    expect(dashboard.endDate, '2026-08-14T15:39:23+05:30');
    expect(dashboard.overAll.containsKey('total_orders'), isTrue);
    expect(dashboard.totalSales['over_time'], isA<List<dynamic>>());
  });

  test('reads a KPI including its formatted total', () async {
    final repository = SellerDashboardRepository(
      client: _clientReturning(_liveDashboard),
    );

    final dashboard = await repository.load();
    final sales = dashboard.kpi('total_sales');

    expect(sales.current, 250);
    expect(sales.previous, 100);
    expect(sales.progress, 150);
    expect(sales.formattedTotal, r'$250.00');
    expect(sales.isUp, isTrue);
  });

  test('date filter sends only the existing dashboard variables', () async {
    final requests = <Map<String, dynamic>>[];
    final repository = SellerDashboardRepository(
      client: GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: Link.function((request, [forward]) async* {
          requests.add(request.variables);
          yield Response(data: _liveDashboard, response: const {});
        }),
      ),
    );
    await repository.load();
    await repository.load(start: '2026-01-01', end: '2026-09-11');
    expect(requests, [
      {'id': '/api/seller/dashboard', 'start': null, 'end': null},
      {
        'id': '/api/seller/dashboard',
        'start': '2026-01-01',
        'end': '2026-09-11',
      },
    ]);
  });

  test('an unknown KPI reads as zero rather than throwing', () async {
    final repository = SellerDashboardRepository(
      client: _clientReturning(_liveDashboard),
    );

    final dashboard = await repository.load();
    final missing = dashboard.kpi('total_refunds');

    expect(missing.current, 0);
    expect(missing.formattedTotal, isNull);
  });
}
