import 'dart:async';

import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/earnings/data/models/seller_earnings.dart';
import 'package:bagisto_flutter/marketplace/features/earnings/data/repository/seller_earnings_repository.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart'
    show SellerDashboardPreset;
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/bloc/seller_reporting_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/pages/seller_reports_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// The three reporting pages, as tabs.
///
/// They were chips, which read as filters rather than as the pages they are
/// and matched nothing else in the seller section.
class _Reports implements SellerEarningsRepository {
  final ran = <String>[];
  final requests = <({String? start, String? end, String? period})>[];
  final gates = <String, Completer<void>>{};

  @override
  Future<List<SellerReportType>> reportTypes() async => const [
    SellerReportType(type: 'total-sales', entity: 'sales', isExportable: true),
    SellerReportType(type: 'total-orders', entity: 'sales'),
    SellerReportType(type: 'total-sold-quantities', entity: 'products'),
    SellerReportType(type: 'total-customers', entity: 'customers'),
    SellerReportType(type: 'customers-with-most-sales', entity: 'customers'),
  ];

  @override
  Future<SellerReport> report({
    required String type,
    String format = 'graph',
    String? start,
    String? end,
    String? period,
  }) async {
    ran.add(type);
    requests.add((start: start, end: end, period: period));
    await gates[start]?.future;
    if (type == 'customers-with-most-sales') {
      // A ranked report answers with the rows themselves, and a customer
      // registered through the API has no first or last name.
      return SellerReport(
        type: type,
        entity: 'customers',
        format: format,
        rows: const [
          {
            'full_name': 'test test',
            'email': 'test@test.com',
            'formatted_total': r'$218.46',
          },
          {
            'full_name': null,
            'email': 'buyer@example.com',
            'formatted_total': r'$39.98',
          },
        ],
      );
    }
    return SellerReport(
      type: type,
      entity: 'sales',
      format: format,
      rangeLabel: '$start - $end',
      exportUrl:
          'https://example.com/export?start=$start&end=$end&period=$period',
      statistics: const {
        'sales': {'current': 10, 'previous': 0, 'progress': 100},
      },
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _RankedReports extends _Reports {
  _RankedReports(this.type, this.rows);

  final String type;
  final List<Map<String, dynamic>> rows;

  @override
  Future<List<SellerReportType>> reportTypes() async => [
    SellerReportType(type: type, entity: 'products'),
  ];

  @override
  Future<SellerReport> report({
    required String type,
    String format = 'graph',
    String? start,
    String? end,
    String? period,
  }) async => SellerReport.fromJson({
    'type': type,
    'entity': 'products',
    'format': format,
    'statistics': rows,
  });
}

Future<SellerReportingCubit> _pump(
  WidgetTester tester,
  _Reports reports,
) async {
  final cubit = SellerReportingCubit(repository: reports);
  await cubit.load();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: const SellerReportsPage()),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

void main() {
  testWidgets('yearly product review rankings show API names and counts', (
    tester,
  ) async {
    const names = [
      'EchoWire Pro Wired Earphones - Inline Mic, Tangle-Free, Bass Boost',
      'Bogus Piono',
      'Plastic Sofa Model 753',
      "Coastal Breeze Men's Blue Zipper Hoodie",
      'Loveseat Sofa Model 749',
    ];
    final cubit = await _pump(
      tester,
      _RankedReports('products-with-most-reviews', [
        for (final name in names) {'product_name': name, 'reviews': 1},
      ]),
    );
    addTearDown(cubit.close);
    await cubit.selectPreset(SellerDashboardPreset.thisYear);
    await tester.pumpAndSettle();

    for (final name in names) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('1'), findsNWidgets(5));
    expect(find.text('\u2014'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rankings retain existing field priority and zero counts', (
    tester,
  ) async {
    final cubit = await _pump(
      tester,
      _RankedReports('top-selling-products-by-quantity', [
        {
          'name': 'Existing product name',
          'product_name': 'Fallback name',
          'quantity': 12,
          'reviews': 3,
        },
        {'product_name': 'No reviews yet', 'reviews': 0},
      ]),
    );
    addTearDown(cubit.close);
    expect(find.text('Existing product name'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Fallback name'), findsNothing);
    expect(find.text('3'), findsNothing);
    expect(find.text('No reviews yet'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  test('opens on Last 30 Days and every preset sends its range', () async {
    final reports = _Reports();
    final now = DateTime(2026, 10, 5, 19);
    final cubit = SellerReportingCubit(repository: reports, now: () => now);
    addTearDown(cubit.close);
    await cubit.load();
    // Opens on the web's 30-day window, grouping left to the server.
    expect(reports.requests.first, (
      start: '2026-09-05',
      end: '2026-10-05',
      period: null,
    ));
    for (final (preset, start, end) in [
      (SellerDashboardPreset.today, '2026-10-05', '2026-10-05'),
      (SellerDashboardPreset.last7Days, '2026-09-29', '2026-10-05'),
      (SellerDashboardPreset.last30Days, '2026-09-05', '2026-10-05'),
      (SellerDashboardPreset.thisMonth, '2026-10-01', '2026-10-05'),
      (SellerDashboardPreset.lastMonth, '2026-09-01', '2026-09-30'),
      (SellerDashboardPreset.last6Months, '2026-04-05', '2026-10-05'),
      (SellerDashboardPreset.thisYear, '2026-01-01', '2026-10-05'),
      (SellerDashboardPreset.lastYear, '2025-01-01', '2025-12-31'),
    ]) {
      await cubit.selectPreset(preset);
      for (final entity in ['sales', 'products', 'customers']) {
        await cubit.selectEntity(entity);
        reports.requests.clear();
        await cubit.refresh();
        expect(reports.requests, isNotEmpty);
        expect(
          reports.requests,
          everyElement((start: start, end: end, period: null)),
        );
      }
    }
  });

  test('refresh recalculates the preset range at date boundaries', () async {
    final reports = _Reports();
    var now = DateTime(2028, 2, 29, 23, 59);
    final cubit = SellerReportingCubit(repository: reports, now: () => now);
    addTearDown(cubit.close);
    await cubit.load();
    await cubit.selectPreset(SellerDashboardPreset.today);
    expect(reports.requests.last.start, '2028-02-29');
    now = DateTime(2028, 3);
    await cubit.refresh();
    expect(reports.requests.last, (
      start: '2028-03-01',
      end: '2028-03-01',
      period: null,
    ));
  });

  test(
    'a custom range is sent as picked and clear restores Last 30 Days',
    () async {
      final reports = _Reports();
      final cubit = SellerReportingCubit(
        repository: reports,
        now: () => DateTime(2026, 9, 10),
      );
      addTearDown(cubit.close);
      await cubit.load();
      await cubit.selectRange(start: '2025-01-01', end: '2025-12-31');
      await cubit.refresh();
      expect(cubit.state.preset, SellerDashboardPreset.custom);
      expect(reports.requests.last, (
        start: '2025-01-01',
        end: '2025-12-31',
        period: null,
      ));
      await cubit.clearRange();
      expect(cubit.state.preset, SellerDashboardPreset.last30Days);
      expect(reports.requests.last.start, '2026-08-11');
      expect(reports.requests.last.end, '2026-09-10');
    },
  );

  test('older responses cannot replace the latest range', () async {
    final reports = _Reports();
    final cubit = SellerReportingCubit(
      repository: reports,
      now: () => DateTime(2026, 9, 10),
    );
    addTearDown(cubit.close);
    await cubit.load();
    final gate = Completer<void>();
    reports.gates['2026-09-01'] = gate;
    final older = cubit.selectPreset(SellerDashboardPreset.thisMonth);
    await cubit.selectPreset(SellerDashboardPreset.thisYear);
    final latest = cubit.state.report;
    expect(latest?.rangeLabel, '2026-01-01 - 2026-09-10');
    gate.complete();
    await older;
    expect(cubit.state.report, latest);
    expect(cubit.state.preset, SellerDashboardPreset.thisYear);
  });

  testWidgets('date filter offers the web presets and updates the label', (
    tester,
  ) async {
    final reports = _Reports();
    final cubit = await _pump(tester, reports);
    addTearDown(cubit.close);
    await tester.tap(find.byKey(const Key('sellerReportPreset')));
    await tester.pumpAndSettle();
    for (final label in [
      'Today',
      'Last 7 Days',
      'Last 30 Days',
      'This Month',
      'Last Month',
      'Last 6 Months',
      'This Year',
      'Last Year',
    ]) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.byKey(const Key('sellerReportClearRange')), findsNothing);
    await tester.tap(find.text('This Year').last);
    await tester.pumpAndSettle();
    final request = reports.requests.last;
    expect(find.text('${request.start} - ${request.end}'), findsWidgets);
    expect(find.byKey(const Key('sellerReportClearRange')), findsOneWidget);
    await tester.tap(find.byKey(const Key('sellerReportClearRange')));
    await tester.pumpAndSettle();
    expect(cubit.state.preset, SellerDashboardPreset.last30Days);
    expect(find.byKey(const Key('sellerReportClearRange')), findsNothing);
  });

  testWidgets('the reporting pages are tabs', (tester) async {
    await _pump(tester, _Reports());

    expect(find.byKey(const Key('sellerReportEntities')), findsOneWidget);
    expect(find.byType(Tab), findsNWidgets(3));
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('tapping a tab opens that page and keeps it open', (
    tester,
  ) async {
    // The controller is rebuilt on every state change, so a tab that does not
    // carry the open page springs back to the first one.
    final reports = _Reports();
    final cubit = await _pump(tester, reports);
    reports.ran.clear();

    await tester.tap(find.byKey(const Key('sellerReportEntity_customers')));
    await tester.pumpAndSettle();

    expect(cubit.state.entity, 'customers');
    expect(reports.ran, ['total-customers', 'customers-with-most-sales']);

    final bar = tester.widget<TabBar>(
      find.byKey(const Key('sellerReportEntities')),
    );
    expect(
      DefaultTabController.of(tester.element(find.byWidget(bar))).index,
      2,
    );
  });

  testWidgets('a customer with no name is named by their email', (
    tester,
  ) async {
    // `full_name` is null for every customer the API creates, and the row
    // showed a dash where the name goes — four dashes down the page.
    final reports = _Reports();
    final cubit = await _pump(tester, reports);

    await cubit.selectEntity('customers');
    await tester.pumpAndSettle();

    expect(find.text('test test'), findsOneWidget);
    expect(find.text('buyer@example.com'), findsOneWidget);
    expect(find.text('—'), findsNothing);
  });
}
