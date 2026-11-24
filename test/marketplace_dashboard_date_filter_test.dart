import 'dart:async';

import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/pages/seller_dashboard_page.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/widgets/seller_dashboard_date_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements SellerDashboardRepository {
  final requests = <({String? start, String? end})>[];
  final pending = <Completer<SellerDashboard>>[];
  bool defer = false;
  bool fail = false;

  @override
  Future<SellerDashboard> load({String? start, String? end}) async {
    requests.add((start: start, end: end));
    if (defer) {
      final request = Completer<SellerDashboard>();
      pending.add(request);
      return request.future;
    }
    if (fail) {
      throw const SellerApiException(
        'Dashboard unavailable',
        SellerApiFailure.unknown,
      );
    }
    return dashboard(start, end);
  }

  static SellerDashboard dashboard(String? start, String? end) =>
      SellerDashboard.fromJson({
        'startDate': '${start ?? '2026-08-12'}T00:00:00+05:30',
        'endDate': '${end ?? '2026-09-11'}T15:00:00+05:30',
        'dateRange': 'API range',
        'overAll': {
          'total_sales': {
            'current': start == '2026-01-01' ? 5004.02 : 0,
            'formatted_total': start == '2026-01-01' ? r'$5,004.02' : r'$0.00',
          },
        },
      });

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Session extends Cubit<SellerSessionState> implements SellerSessionCubit {
  _Session() : super(const SellerSessionState());

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<SellerDashboardCubit> _pump(
  WidgetTester tester,
  _Repository repository, {
  double textScale = 1,
}) async {
  final cubit = SellerDashboardCubit(
    repository: repository,
    now: () => DateTime(2026, 9, 11),
  );
  final session = _Session();
  addTearDown(cubit.close);
  addTearDown(session.close);
  await cubit.load();
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<SellerSessionCubit>.value(value: session),
        BlocProvider<SellerDashboardCubit>.value(value: cubit),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: const Scaffold(body: SellerDashboardPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

void main() {
  test('initial dashboard preserves the backend default', () async {
    final repository = _Repository();
    final cubit = SellerDashboardCubit(repository: repository);
    addTearDown(cubit.close);
    await cubit.load();
    expect(repository.requests, [(start: null, end: null)]);
    expect(cubit.state.preset, SellerDashboardPreset.defaultRange);
  });

  final presets = <SellerDashboardPreset, String>{
    SellerDashboardPreset.today: '2026-09-11/2026-09-11',
    SellerDashboardPreset.last7Days: '2026-09-05/2026-09-11',
    SellerDashboardPreset.last30Days: '2026-08-13/2026-09-11',
    SellerDashboardPreset.thisMonth: '2026-09-01/2026-09-11',
    SellerDashboardPreset.lastMonth: '2026-08-01/2026-08-31',
    SellerDashboardPreset.last6Months: '2026-03-11/2026-09-11',
    SellerDashboardPreset.thisYear: '2026-01-01/2026-09-11',
    SellerDashboardPreset.lastYear: '2025-01-01/2025-12-31',
  };
  for (final entry in presets.entries) {
    test(
      '${entry.key} sends its dates and survives refresh or editor return',
      () async {
        final repository = _Repository();
        final cubit = SellerDashboardCubit(
          repository: repository,
          now: () => DateTime(2026, 9, 11),
        );
        addTearDown(cubit.close);
        await cubit.selectPreset(entry.key);
        await cubit.load();
        expect(repository.requests.map((r) => '${r.start}/${r.end}'), [
          entry.value,
          entry.value,
        ]);
        expect(cubit.state.preset, entry.key);
      },
    );
  }

  test(
    'custom dates survive refresh and can reset to backend default',
    () async {
      final repository = _Repository();
      final cubit = SellerDashboardCubit(repository: repository);
      addTearDown(cubit.close);
      await cubit.load(start: '2025-02-01', end: '2025-02-28');
      await cubit.load();
      expect(cubit.state.preset, SellerDashboardPreset.custom);
      expect(repository.requests.last, (
        start: '2025-02-01',
        end: '2025-02-28',
      ));
      await cubit.selectPreset(SellerDashboardPreset.defaultRange);
      expect(repository.requests.last, (start: null, end: null));
    },
  );

  test(
    'calendar ranges handle year boundaries, leap days and month end',
    () async {
      final repository = _Repository();
      var now = DateTime(2026, 1, 3);
      final cubit = SellerDashboardCubit(
        repository: repository,
        now: () => now,
      );
      addTearDown(cubit.close);
      await cubit.selectPreset(SellerDashboardPreset.last7Days);
      expect(repository.requests.last, (
        start: '2025-12-28',
        end: '2026-01-03',
      ));
      await cubit.selectPreset(SellerDashboardPreset.lastMonth);
      expect(repository.requests.last, (
        start: '2025-12-01',
        end: '2025-12-31',
      ));
      now = DateTime(2024, 3, 31);
      await cubit.load();
      expect(repository.requests.last, (
        start: '2024-02-01',
        end: '2024-02-29',
      ));
      now = DateTime(2024, 8, 31);
      await cubit.selectPreset(SellerDashboardPreset.last6Months);
      expect(repository.requests.last, (
        start: '2024-02-29',
        end: '2024-08-31',
      ));
      await cubit.selectPreset(SellerDashboardPreset.today);
      now = DateTime(2024, 9, 1);
      await cubit.load();
      expect(repository.requests.last, (
        start: '2024-09-01',
        end: '2024-09-01',
      ));
    },
  );

  test(
    'a slower previous response cannot overwrite the latest preset',
    () async {
      final repository = _Repository()..defer = true;
      final cubit = SellerDashboardCubit(
        repository: repository,
        now: () => DateTime(2026, 9, 11),
      );
      addTearDown(cubit.close);
      final old = cubit.load();
      final latest = cubit.selectPreset(SellerDashboardPreset.thisYear);
      repository.pending[1].complete(
        _Repository.dashboard('2026-01-01', '2026-09-11'),
      );
      await latest;
      repository.pending[0].completeError(
        const SellerApiException('old error', SellerApiFailure.unknown),
      );
      await old;
      expect(cubit.state.status, SellerDashboardStatus.loaded);
      expect(cubit.state.preset, SellerDashboardPreset.thisYear);
      expect(cubit.state.dashboard!.kpi('total_sales').current, 5004.02);
    },
  );

  test('failure and retry retain the selected dates', () async {
    final repository = _Repository()..fail = true;
    final cubit = SellerDashboardCubit(
      repository: repository,
      now: () => DateTime(2026, 9, 11),
    );
    addTearDown(cubit.close);
    await cubit.selectPreset(SellerDashboardPreset.thisMonth);
    expect(cubit.state.status, SellerDashboardStatus.failed);
    expect(cubit.state.preset, SellerDashboardPreset.thisMonth);
    repository.fail = false;
    await cubit.load();
    expect(repository.requests.last, (start: '2026-09-01', end: '2026-09-11'));
    expect(cubit.state.status, SellerDashboardStatus.loaded);
  });

  for (final width in [390.0, 1024.0]) {
    testWidgets(
      'date filter above payout, select and refresh at width $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 932);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = _Repository();
        await _pump(tester, repository);
        final filter = find.byKey(const Key('sellerDashboardDateFilter'));
        expect(
          tester.getBottomLeft(filter).dy,
          lessThan(tester.getTopLeft(find.text('Awaiting payout')).dy),
        );
        expect(find.text('Aug 12, 2026 - Sep 11, 2026'), findsOneWidget);
        await tester.tap(find.byKey(const Key('sellerDashboardPreset')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('This Year').last);
        await tester.tap(find.text('This Year').last);
        await tester.pumpAndSettle();
        expect(repository.requests.last, (
          start: '2026-01-01',
          end: '2026-09-11',
        ));
        expect(find.text('Jan 1, 2026 - Sep 11, 2026'), findsOneWidget);
        final refresh = tester.widget<RefreshIndicator>(
          find.byType(RefreshIndicator),
        );
        await refresh.onRefresh();
        await tester.pumpAndSettle();
        expect(repository.requests.last, (
          start: '2026-01-01',
          end: '2026-09-11',
        ));
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final width in [320.0, 390.0, 1024.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('date selector fits width $width with text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 932);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: SellerDashboardDateFilter(
                  state: SellerDashboardState(
                    preset: SellerDashboardPreset.last6Months,
                    dashboard: _Repository.dashboard(
                      '2026-03-11',
                      '2026-09-11',
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final range = tester.getRect(
          find.byKey(const Key('sellerDashboardSelectedDates')),
        );
        final menu = tester.getRect(
          find.byKey(const Key('sellerDashboardPreset')),
        );
        expect(range.left, greaterThanOrEqualTo(0));
        expect(range.right, lessThanOrEqualTo(width));
        expect(menu.right, lessThanOrEqualTo(width));
        expect(range.overlaps(menu), isFalse);
        expect(range.center.dy, closeTo(menu.center.dy, 0.5));
        expect(range.right, lessThan(menu.left));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('custom range confirmation reloads and keeps its dates', (
    tester,
  ) async {
    final repository = _Repository();
    final cubit = await _pump(tester, repository);
    await tester.tap(find.byKey(const Key('sellerDashboardPreset')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Custom range').last);
    await tester.tap(find.text('Custom range').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repository.requests.last, (start: '2026-08-12', end: '2026-09-11'));
    expect(cubit.state.preset, SellerDashboardPreset.custom);
    await cubit.load();
    expect(repository.requests.last, (start: '2026-08-12', end: '2026-09-11'));
  });

  testWidgets('canceling custom date picker sends no request', (tester) async {
    final repository = _Repository();
    await _pump(tester, repository);
    await tester.tap(find.byKey(const Key('sellerDashboardPreset')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Custom range').last);
    await tester.tap(find.text('Custom range').last);
    await tester.pumpAndSettle();
    expect(find.byType(DateRangePickerDialog), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(repository.requests, [(start: null, end: null)]);
    expect(find.text('Default range'), findsOneWidget);
  });
}
