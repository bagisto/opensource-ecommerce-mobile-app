import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart'
    show SellerDashboardPreset;
import 'package:bagisto_flutter/marketplace/features/earnings/data/models/seller_earnings.dart';
import 'package:bagisto_flutter/marketplace/features/earnings/data/repository/seller_earnings_repository.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/bloc/seller_reporting_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/pages/seller_report_details_page.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/pages/seller_reports_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeReportsRepo implements SellerEarningsRepository {
  final requests = <({String type, String format, String? start, String? end, String? period})>[];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<SellerReportType>> reportTypes() async => const [
        SellerReportType(
          type: 'total-sales',
          entity: 'sales',
          isExportable: true,
        ),
        SellerReportType(
          type: 'purchase-funnel',
          entity: 'sales',
          isExportable: false,
        ),
      ];

  @override
  Future<SellerReport> report({
    required String type,
    String format = 'graph',
    String? start,
    String? end,
    String? period,
  }) async {
    requests.add((
      type: type,
      format: format,
      start: start,
      end: end,
      period: period,
    ));

    if (format == 'table') {
      return SellerReport(
        type: type,
        entity: 'sales',
        format: 'table',
        rangeLabel: '2026-09-01 to 2026-10-12',
        exportUrl: 'https://example.com/export.csv',
        statistics: const {
          'columns': [
            {'key': 'label', 'label': 'Interval'},
            {'key': 'count', 'label': 'Orders'},
            {'key': 'formatted_total', 'label': 'Total'},
          ],
          'records': [
            {'label': '2026-09-24', 'count': 1, 'formatted_total': r'$199.00'},
          ],
        },
      );
    }

    return SellerReport(
      type: type,
      entity: 'sales',
      format: 'graph',
      statistics: const {
        'total': {'current': 199.0, 'previous': 0.0, 'progress': 100},
      },
    );
  }
}

void main() {
  testWidgets('exportable report displays View Details and opens details table',
      (tester) async {
    final repo = _FakeReportsRepo();
    final cubit = SellerReportingCubit(
      repository: repo,
      now: () => DateTime(2026, 10, 12),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: const SellerReportsPage(),
        ),
      ),
    );

    await cubit.load();
    await tester.pumpAndSettle();

    // View Details button shown for exportable total-sales, not for purchase-funnel
    expect(find.byKey(const Key('sellerReportViewDetails_total-sales')), findsOneWidget);
    expect(find.byKey(const Key('sellerReportViewDetails_purchase-funnel')), findsNothing);

    // Tap View Details
    await tester.tap(find.byKey(const Key('sellerReportViewDetails_total-sales')));
    await tester.pumpAndSettle();

    // Verify SellerReportDetailsPage is pushed
    expect(find.byType(SellerReportDetailsPage), findsOneWidget);

    // Verify repository requested format: 'table'
    expect(
      repo.requests.any((r) => r.type == 'total-sales' && r.format == 'table'),
      isTrue,
    );

    // Verify table columns & records rendered
    expect(find.text('Interval'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('2026-09-24'), findsOneWidget);
    expect(find.text(r'$199.00'), findsOneWidget);

    // Verify period selector is shown for total-sales
    expect(find.byKey(const Key('sellerReportPeriodFilter')), findsOneWidget);
  });

  testWidgets('total-commission-paid details does not show period dropdown',
      (tester) async {
    final repo = _FakeReportsRepo();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SellerReportDetailsPage(
          type: const SellerReportType(
            type: 'total-commission-paid',
            entity: 'sales',
            isExportable: true,
          ),
          title: 'Total Commission Paid',
          repository: repo,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify repository requested format: 'table' with period: null
    expect(
      repo.requests.any(
        (r) =>
            r.type == 'total-commission-paid' &&
            r.format == 'table' &&
            r.period == null,
      ),
      isTrue,
    );

    // Verify date chips are rendered
    expect(find.byKey(const Key('sellerReportStartDate')), findsOneWidget);
    expect(find.byKey(const Key('sellerReportEndDate')), findsOneWidget);

    // Verify period selector is NOT shown for total-commission-paid
    expect(find.byKey(const Key('sellerReportPeriodFilter')), findsNothing);
  });

  testWidgets('export button displays Export CSV and Export XLS options',
      (tester) async {
    final repo = _FakeReportsRepo();
    String? exportedUrl;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SellerReportDetailsPage(
          type: const SellerReportType(
            type: 'total-sales',
            entity: 'sales',
            isExportable: true,
          ),
          title: 'Total Sales',
          repository: repo,
          onExport: (_, url) => exportedUrl = url,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify export button exists
    final exportBtn = find.byKey(const Key('sellerReportDetailExport'));
    expect(exportBtn, findsOneWidget);

    // Tap export button to open PopupMenu
    await tester.tap(exportBtn);
    await tester.pumpAndSettle();

    // Verify CSV and XLS options appear
    expect(find.byKey(const Key('sellerReportExportCsv')), findsOneWidget);
    expect(find.byKey(const Key('sellerReportExportXls')), findsOneWidget);
    expect(find.text('Export CSV'), findsOneWidget);
    expect(find.text('Export XLS'), findsOneWidget);

    // Tap Export CSV
    await tester.tap(find.byKey(const Key('sellerReportExportCsv')));
    await tester.pumpAndSettle();

    // Verify URL with file_format=csv was passed to onExport
    expect(exportedUrl, contains('file_format=csv'));
  });
}
