import 'dart:io';

import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/bloc/seller_reporting_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/pages/seller_reports_page.dart';
import 'package:bagisto_flutter/marketplace/shell/marketplace_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _Session extends SellerSessionCubit {
  _Session()
    : super(
        authRepository: _NoAuth(),
        accountRepositoryBuilder: (_) => throw UnimplementedError(),
      );

  @override
  String get token => 'report-test-seller-token';
}

class _NoAuth implements SellerAuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Observer extends NavigatorObserver {
  Route<dynamic>? pushed;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed = route;
  }
}

class _Headers implements HttpHeaders {
  final values = <String, Object>{};
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    values[name.toLowerCase()] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Request implements HttpClientRequest {
  @override
  final _Headers headers = _Headers();
  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await stream.drain<void>();
  }

  @override
  Future<HttpClientResponse> close() async =>
      throw const SocketException('No live download in widget tests');
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Client implements HttpClient {
  Uri? requested;
  final request = _Request();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    expect(method, 'GET');
    requested = url;
    return request;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  for (final entity in ['sales', 'products', 'customers']) {
    testWidgets('$entity route export keeps seller token outside session scope', (
      tester,
    ) async {
      final session = _Session();
      addTearDown(session.close);
      final observer = _Observer();
      late BuildContext source;
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          home: BlocProvider<SellerSessionCubit>.value(
            value: session,
            child: Builder(
              builder: (context) {
                source = context;
                return TextButton(
                  onPressed: () =>
                      SellerRoutes.openReports(context, entity: entity),
                  child: const Text('open reports'),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('open reports'));
      // Inspect the actual route wiring before mounting its live API provider.
      final route = observer.pushed! as MaterialPageRoute<dynamic>;
      final provider =
          route.builder(source) as BlocProvider<SellerReportingCubit>;
      final reports = provider.child! as SellerReportsPage;
      expect(reports.initialEntity, entity);
      final client = _Client();
      const url =
          'https://example.test/api/seller/reporting/export?type=total-sales&start=2026-09-11&end=2026-09-11&period=day';
      await tester.pumpWidget(
        MaterialApp(
          key: const ValueKey('outside seller session'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => HttpOverrides.runZoned(
                  () => reports.onExport!(context, url),
                  createHttpClient: (_) => client,
                ),
                child: const Text('export report'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('export report'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(client.requested.toString(), url);
      expect(
        client.request.headers.values['authorization'],
        'Bearer report-test-seller-token',
      );
    });
  }
}
