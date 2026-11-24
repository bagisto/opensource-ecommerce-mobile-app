import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/earnings/data/models/seller_earnings.dart';
import 'package:bagisto_flutter/marketplace/features/earnings/data/repository/seller_earnings_repository.dart';
import 'package:bagisto_flutter/marketplace/features/earnings/presentation/bloc/seller_earnings_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/bloc/seller_reporting_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeEarningsRepository implements SellerEarningsRepository {
  _FakeEarningsRepository({
    this.pages = const {},
    this.stats = const SellerPayoutStatistics(),
    this.types = const [],
    this.failWith,
  });

  final Map<int, PaginatedResult<SellerTransaction>> pages;
  final SellerPayoutStatistics stats;
  final List<SellerReportType> types;
  final SellerApiException? failWith;

  final List<Map<String, String?>> reportCalls = [];

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<PaginatedResult<SellerTransaction>> transactions({
    int page = 1,
  }) async {
    if (failWith != null) throw failWith!;
    return pages[page] ??
        const PaginatedResult(
          items: [],
          totalCount: 0,
          lastPage: 1,
          currentPage: 1,
        );
  }

  @override
  Future<SellerPayoutStatistics> statistics({
    String? start,
    String? end,
  }) async {
    if (failWith != null) throw failWith!;
    return stats;
  }

  @override
  Future<List<SellerReportType>> reportTypes() async {
    if (failWith != null) throw failWith!;
    return types;
  }

  @override
  Future<SellerReport> report({
    required String type,
    String format = 'graph',
    String? start,
    String? end,
    String? period,
  }) async {
    if (failWith != null) throw failWith!;
    reportCalls.add({
      'type': type,
      'format': format,
      'start': start,
      'end': end,
      'period': period,
    });
    return SellerReport(type: type, entity: 'sales', format: format);
  }
}

const _stats = SellerPayoutStatistics(
  startDate: '2026-07-15',
  endDate: '2026-08-14',
  currency: 'USD',
  totalSale: 39.98,
  formattedTotalSale: r'$39.98',
  totalSellerSale: 31.984,
  formattedTotalSellerSale: r'$31.98',
  totalCommission: 7.996,
  formattedTotalCommission: r'$8.00',
  remainingPayout: 31.984,
  formattedRemainingPayout: r'$31.98',
);

void main() {
  group('models', () {
    test('statistics keep the server-formatted money as sent', () {
      final stats = SellerPayoutStatistics.fromJson(const {
        'startDate': '2026-07-15',
        'currency': 'USD',
        'totalSale': 39.98,
        'formattedTotalSale': r'$39.98',
        'remainingPayout': 31.984,
        'formattedRemainingPayout': r'$31.98',
      });

      expect(stats.totalSale, 39.98);
      expect(stats.formattedRemainingPayout, r'$31.98');
      // Absent figures read as zero rather than throwing.
      expect(stats.totalPayout, 0);
      expect(stats.formattedTotalPayout, '');
    });

    test('report type turns its slug into a label', () {
      const type = SellerReportType(
        type: 'top-selling-products-by-revenue',
        entity: 'products',
      );

      expect(type.label, 'Top selling products by revenue');
    });

    test('graph report reads the headline whatever the report calls it', () {
      final report = SellerReport.fromJson(const {
        'type': 'total-orders',
        'entity': 'sales',
        'format': 'graph',
        'dateRange': {
          'current': '15 Jul - 14 Aug',
          'previous': '15 Jun - 15 Jul',
        },
        'statistics': {
          'orders': {'previous': 0, 'current': 12, 'progress': 100},
          'over_time': {
            'current': [
              {'label': '13 Aug', 'total': 20.5, 'count': 1},
              {'label': '14 Aug', 'total': 0, 'count': 0},
            ],
            'previous': <Map<String, dynamic>>[],
          },
        },
      });

      expect(report.headline?.current, 12);
      expect(report.rangeLabel, '15 Jul - 14 Aug');
      expect(report.previousRangeLabel, '15 Jun - 15 Jul');
      expect(report.overTime, hasLength(2));
      expect(report.overTime.first.total, 20.5);
    });

    test('a figure sent as a decimal string still reads as a number', () {
      // The live server sends `0` for an empty interval but `"39.9800"` for a
      // real one, in the same series.
      final report = SellerReport.fromJson(const {
        'type': 'total-sales',
        'entity': 'sales',
        'format': 'graph',
        'statistics': {
          'sales': {'previous': 0, 'current': '39.9800', 'progress': '100'},
          'over_time': {
            'current': [
              {'label': '13 Aug', 'total': 0, 'count': 0},
              {'label': '14 Aug', 'total': '39.9800', 'count': 1},
            ],
          },
        },
      });

      expect(report.headline?.current, 39.98);
      expect(report.overTime.first.total, 0);
      expect(report.overTime.last.total, 39.98);
    });

    test(
      'graph report keeps the previous period series beside the current',
      () {
        final report = SellerReport.fromJson(const {
          'type': 'total-sold-quantities',
          'entity': 'products',
          'format': 'graph',
          'statistics': {
            'quantities': {'previous': 0, 'current': 15, 'progress': 100},
            'over_time': {
              'previous': [
                {'label': '04 Nov', 'total': 0},
                {'label': '05 Apr', 'total': 2},
              ],
              'current': [
                {'label': '05 Aug', 'total': 9},
                {'label': '05 Sep', 'total': 2},
              ],
            },
          },
        });

        expect(report.overTime.map((p) => p.total), [9, 2]);
        expect(report.previousOverTime.map((p) => p.total), [0, 2]);
      },
    );

    test('a report with one series has no previous series', () {
      final report = SellerReport.fromJson(const {
        'type': 'x',
        'statistics': {
          'over_time': [
            {'label': '13 Aug', 'total': 1},
          ],
        },
      });

      expect(report.previousOverTime, isEmpty);
    });

    test('table report exposes the columns the server declared', () {
      final report = SellerReport.fromJson(const {
        'type': 'total-sales',
        'entity': 'sales',
        'format': 'table',
        'statistics': {
          'columns': [
            {'key': 'label', 'label': 'Interval'},
            {'key': 'formatted_total', 'label': 'Total'},
          ],
          'records': [
            {
              'label': '2026-08-13',
              'total': 39.98,
              'formatted_total': r'$39.98',
            },
          ],
        },
        'exportUrl': 'http://example.test/export',
      });

      expect(report.isTable, isTrue);
      expect(report.columns.map((c) => c.key), ['label', 'formatted_total']);
      expect(report.records.single['formatted_total'], r'$39.98');
      expect(report.exportUrl, 'http://example.test/export');
    });
  });

  group('SellerEarningsCubit', () {
    test('load reads the summary and the first page of payouts', () async {
      final cubit = SellerEarningsCubit(
        repository: _FakeEarningsRepository(
          stats: _stats,
          pages: {
            1: const PaginatedResult(
              items: [
                SellerTransaction(
                  id: 1,
                  method: 'bank_transfer',
                  baseTotal: 20,
                  downloadUrl: 'http://example.test/receipt.pdf',
                ),
              ],
              totalCount: 3,
              lastPage: 2,
              currentPage: 1,
            ),
          },
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerEarningsStatus.loaded);
      expect(cubit.state.statistics?.formattedRemainingPayout, r'$31.98');
      expect(cubit.state.transactions.single.method, 'bank_transfer');
      expect(cubit.state.hasNextPage, isTrue);
    });

    test('an empty payout history is a loaded screen, not an error', () async {
      final cubit = SellerEarningsCubit(
        repository: _FakeEarningsRepository(stats: _stats),
      );

      await cubit.load();

      expect(cubit.state.status, SellerEarningsStatus.loaded);
      expect(cubit.state.transactions, isEmpty);
      expect(cubit.state.statistics?.formattedTotalSale, r'$39.98');
    });

    test('loadMore appends the next page', () async {
      final cubit = SellerEarningsCubit(
        repository: _FakeEarningsRepository(
          stats: _stats,
          pages: {
            1: const PaginatedResult(
              items: [SellerTransaction(id: 1)],
              totalCount: 2,
              lastPage: 2,
              currentPage: 1,
            ),
            2: const PaginatedResult(
              items: [SellerTransaction(id: 2)],
              totalCount: 2,
              lastPage: 2,
              currentPage: 2,
            ),
          },
        ),
      );

      await cubit.load();
      await cubit.loadMore();

      expect(cubit.state.transactions.map((t) => t.id), [1, 2]);
      expect(cubit.state.hasNextPage, isFalse);
    });

    test('loadMore stops at the last page', () async {
      final repository = _FakeEarningsRepository(stats: _stats);
      final cubit = SellerEarningsCubit(repository: repository);

      await cubit.load();
      await cubit.loadMore();

      expect(cubit.state.transactions, isEmpty);
      expect(cubit.state.isLoadingMore, isFalse);
    });

    test('a rejected read surfaces the server message', () async {
      final cubit = SellerEarningsCubit(
        repository: _FakeEarningsRepository(
          failWith: const SellerApiException(
            'Forbidden',
            SellerApiFailure.forbidden,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerEarningsStatus.failed);
      expect(cubit.state.errorMessage, 'Forbidden');
    });
  });

  group('SellerReportingCubit', () {
    const types = [
      SellerReportType(
        type: 'total-sales',
        entity: 'sales',
        isExportable: true,
      ),
      SellerReportType(type: 'purchase-funnel', entity: 'sales'),
      SellerReportType(
        type: 'total-customers',
        entity: 'customers',
        isExportable: true,
      ),
    ];

    test('load runs every report on the page, not one', () async {
      // The panel gives sales, products and customers a page each and shows
      // all of that page's reports together; the app made a seller pick one
      // report at a time from a dropdown.
      final repository = _FakeEarningsRepository(types: types);
      final cubit = SellerReportingCubit(repository: repository);

      await cubit.load();

      expect(cubit.state.status, SellerReportingStatus.loaded);
      expect(cubit.state.entity, 'sales');
      expect(repository.reportCalls.map((call) => call['type']), [
        'total-sales',
        'purchase-funnel',
      ]);
      expect(cubit.state.reports.keys, {'total-sales', 'purchase-funnel'});
    });

    test('another page runs its own reports', () async {
      final repository = _FakeEarningsRepository(types: types);
      final cubit = SellerReportingCubit(repository: repository);

      await cubit.load();
      repository.reportCalls.clear();
      await cubit.selectEntity('customers');

      expect(repository.reportCalls.map((call) => call['type']), [
        'total-customers',
      ]);
      expect(cubit.state.openTypes.map((type) => type.type), [
        'total-customers',
      ]);
    });

    test('a ranked report answers with a list, and is read', () async {
      // top-payment-methods and its like return the rows themselves rather
      // than an object. The model cast that to a map, so the report threw
      // before it could be shown. Payload copied from the live server.
      final report = SellerReport.fromJson(const {
        'type': 'top-payment-methods',
        'entity': 'sales',
        'format': 'graph',
        'statistics': [
          {
            'method': 'cashondelivery',
            'title': 'Cash On Delivery',
            'total': 3,
            'formatted_total': r'$308.44',
          },
          {
            'method': 'moneytransfer',
            'title': 'Money Transfer',
            'total': 1,
            'formatted_total': r'$19.99',
          },
        ],
      });

      expect(report.rows, hasLength(2));
      expect(report.rows.first['title'], 'Cash On Delivery');
      expect(report.statistics, isEmpty);
      expect(report.headline, isNull);
    });

    test('reports group under the entity the server gave them', () async {
      final cubit = SellerReportingCubit(
        repository: _FakeEarningsRepository(types: types),
      );

      await cubit.load();

      expect(cubit.state.byEntity.keys, ['sales', 'customers']);
      expect(cubit.state.byEntity['sales'], hasLength(2));
    });

    test(
      'switching to a report with no table falls back to the graph',
      () async {
        final repository = _FakeEarningsRepository(types: types);
        final cubit = SellerReportingCubit(repository: repository);

        await cubit.load();
        await cubit.selectFormat('table');
        expect(cubit.state.format, 'table');

        await cubit.selectType(types[1]);

        expect(cubit.state.format, 'graph');
        expect(repository.reportCalls.last['type'], 'purchase-funnel');
        expect(repository.reportCalls.last['format'], 'graph');
      },
    );

    test('opens on Last 30 Days with grouping left to the server', () async {
      final repository = _FakeEarningsRepository(types: types);
      final cubit = SellerReportingCubit(repository: repository);

      await cubit.load();

      expect(cubit.state.preset, SellerDashboardPreset.last30Days);
      expect(repository.reportCalls.last['period'], isNull);
      expect(repository.reportCalls.last['start'], isNotNull);
    });

    test('a date range narrows every later run', () async {
      final repository = _FakeEarningsRepository(types: types);
      final cubit = SellerReportingCubit(repository: repository);

      await cubit.load();
      await cubit.selectRange(start: '2026-08-01', end: '2026-08-14');
      await cubit.selectFormat('table');

      expect(repository.reportCalls.last['start'], '2026-08-01');
      expect(repository.reportCalls.last['end'], '2026-08-14');
    });

    test(
      'a role with no reports lands on an empty menu, not a failure',
      () async {
        final cubit = SellerReportingCubit(
          repository: _FakeEarningsRepository(),
        );

        await cubit.load();

        expect(cubit.state.status, SellerReportingStatus.loaded);
        expect(cubit.state.types, isEmpty);
        expect(cubit.state.report, isNull);
      },
    );
  });
  test('the payout window reads as two dates', () {
    // The server sends full ISO timestamps and the card printed them raw:
    // "2026-07-20T00:00:00+05:30 — 2026-08-19T21:52:11+05:30", two lines of
    // offset and seconds nobody asked for.
    final statistics = SellerPayoutStatistics.fromJson(const {
      'startDate': '2026-07-20T00:00:00+05:30',
      'endDate': '2026-08-19T21:52:11+05:30',
      'totalSale': 348.417,
      'totalPayout': 71.984,
      'remainingPayout': 31.984,
    });

    expect(statistics.windowLabel, '20 Jul 2026 — 19 Aug 2026');
  });

  test('a window the server left open prints nothing', () {
    final statistics = SellerPayoutStatistics.fromJson(const {'totalSale': 0});

    expect(statistics.windowLabel, isNull);
  });

  test('the figures the panel prints are the ones the app shows', () {
    // Checked against the panel's own /seller/sales/transactions/statistics
    // on the same window: identical to the last decimal.
    final statistics = SellerPayoutStatistics.fromJson(const {
      'totalSale': 348.417,
      'totalSellerSale': 278.7336,
      'totalCommission': 69.6834,
      'totalPayout': 71.984,
      'remainingPayout': 31.984,
    });

    expect(statistics.totalSale, 348.417);
    expect(statistics.totalSellerSale, 278.7336);
    expect(statistics.totalCommission, 69.6834);
    expect(statistics.totalPayout, 71.984);
    expect(statistics.remainingPayout, 31.984);
  });
}
