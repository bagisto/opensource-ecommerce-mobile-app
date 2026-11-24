import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/pages/seller_login_page.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart';
import 'package:bagisto_flutter/marketplace/shell/marketplace_entry.dart';
import 'package:bagisto_flutter/marketplace/shell/marketplace_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubSessionCubit extends Cubit<SellerSessionState>
    implements SellerSessionCubit {
  _StubSessionCubit(super.initialState);

  @override
  String? get token => 'stub-token';

  void emitState(SellerSessionState state) => emit(state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Dashboard cubit that answers from memory, so widget tests never touch the
/// network.
class _StubDashboardCubit extends Cubit<SellerDashboardState>
    implements SellerDashboardCubit {
  _StubDashboardCubit()
    : super(
        const SellerDashboardState(
          status: SellerDashboardStatus.loaded,
          dashboard: SellerDashboard(
            dateRange: '15 Jul - 14 Aug',
            overAll: {},
            totalSales: {},
            recentOrders: {},
            stockThreshold: [],
            topProducts: [],
            topCustomers: [],
            topCategories: [],
          ),
        ),
      );

  @override
  SellerDashboardRepository get repository => throw UnimplementedError();

  @override
  Future<void> load({String? start, String? end}) async {}

  @override
  Future<void> selectPreset(SellerDashboardPreset preset) async {}

  @override
  DateTime get today => DateTime(2026, 9, 11);
}

Widget _wrap(Widget child, _StubSessionCubit cubit) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<SellerSessionCubit>.value(value: cubit, child: child),
  );
}

void main() {
  testWidgets('unauthenticated shows the login screen', (tester) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(status: SellerSessionStatus.unauthenticated),
    );

    await tester.pumpWidget(_wrap(const MarketplaceGate(), cubit));
    await tester.pumpAndSettle();

    expect(find.byType(SellerLoginPage), findsOneWidget);
  });

  testWidgets('failed login after loading shows an error snackbar', (
    tester,
  ) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(status: SellerSessionStatus.unauthenticated),
    );

    await tester.pumpWidget(_wrap(const MarketplaceGate(), cubit));
    await tester.pumpAndSettle();

    cubit.emitState(
      const SellerSessionState(status: SellerSessionStatus.loading),
    );
    await tester.pump();

    cubit.emitState(
      const SellerSessionState(
        status: SellerSessionStatus.failed,
        errorMessage: 'Invalid credentials',
      ),
    );
    await tester.pump();

    expect(find.byType(SellerLoginPage), findsOneWidget);
    expect(find.text('Invalid credentials'), findsOneWidget);
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);
  });

  testWidgets('active shows the shell', (tester) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(
        status: SellerSessionStatus.active,
        profile: SellerProfile(
          name: 'Ashif',
          email: 'seller@example.com',
          businessName: 'Acme Store',
          isApproved: true,
        ),
      ),
    );

    await tester.pumpWidget(
      _wrap(
        MarketplaceShell(dashboardCubitFactory: (_) => _StubDashboardCubit()),
        cubit,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MarketplaceShell), findsOneWidget);
    // The shop name titles the panel, and the dashboard's payout banner
    // greets the seller with it too.
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Acme Store'),
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('sellerDashboardSelectedDates')))
          .data,
      '15 Jul - 14 Aug',
    );
  });

  testWidgets('pending approval explains the wait instead of the shell', (
    tester,
  ) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(status: SellerSessionStatus.pendingApproval),
    );

    await tester.pumpWidget(_wrap(const MarketplaceGate(), cubit));
    await tester.pumpAndSettle();

    expect(find.byType(MarketplaceShell), findsNothing);
    expect(find.text('Waiting for approval'), findsOneWidget);
  });

  testWidgets('suspended shows the suspension notice', (tester) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(status: SellerSessionStatus.suspended),
    );

    await tester.pumpWidget(_wrap(const MarketplaceGate(), cubit));
    await tester.pumpAndSettle();

    expect(find.text('Shop suspended'), findsOneWidget);
  });
}
