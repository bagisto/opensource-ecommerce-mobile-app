import 'package:bagisto_flutter/core/currency/currency_formatter.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_capabilities.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/pages/seller_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Verbatim from the server once the operator switches Subscription Plans on
/// under a seller who holds none: HTTP 200, no `errors[]`, every panel empty
/// — and PHP writes an empty associative array as `[]`, not `{}`.
const _noPlanDashboard = <String, dynamic>{
  'id': '/theme/api-4.9/public/api/seller/dashboard',
  'profileScore': null,
  'todo': <dynamic>[],
  'overAll': <dynamic>[],
};

/// A dashboard that refuses, which is what the server answers a seller whose
/// operator has just switched plans on.
class _RefusingRepository implements SellerDashboardRepository {
  @override
  Future<SellerDashboard> load({String? start, String? end}) async {
    throw const SellerApiException(
      'You do not have permission to perform this action.',
      SellerApiFailure.forbidden,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// A session whose switches are stale — signed in before the operator turned
/// subscriptions on — until something asks it to read them again.
class _StaleSession extends Cubit<SellerSessionState>
    implements SellerSessionCubit {
  _StaleSession()
    : super(
        const SellerSessionState(
          permissions: SellerPermissions(type: 'all', keys: {}),
        ),
      );

  int reads = 0;

  @override
  Future<SellerFeatures> refreshFeatures() async {
    reads++;
    const capabilities = SellerCapabilities(
      features: SellerFeatures(subscriptions: true),
    );
    emit(state.copyWith(capabilities: capabilities));
    return capabilities.features;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  _gateTests();

  group('a refusal after the operator switches plans on', () {
    testWidgets('re-reads the switches and says a plan is needed', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900, 2200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'app_currency_code': 'USD'});
      CurrencyFormatter.initialize(await SharedPreferences.getInstance());

      final cubit = SellerDashboardCubit(repository: _RefusingRepository());
      final session = _StaleSession();
      addTearDown(cubit.close);
      addTearDown(session.close);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SellerDashboardCubit>.value(value: cubit),
            BlocProvider<SellerSessionCubit>.value(value: session),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: SellerDashboardPage()),
          ),
        ),
      );

      await cubit.load();
      await tester.pumpAndSettle();

      // The bare refusal is what the seller used to be left with; the screen
      // now reads the switches again and explains the real state.
      expect(session.reads, 1);
      expect(
        find.textContaining('You do not have permission'),
        findsNothing,
      );
      expect(find.textContaining('A plan is needed'), findsOneWidget);
      expect(find.text('See plans'), findsOneWidget);
    });
  });

  group('dashboard with no subscription', () {
    test('empty panels sent as [] do not break the parse', () {
      // A bare `as Map<String, dynamic>?` threw here, and the screen told the
      // seller the response was unreadable.
      final dashboard = SellerDashboard.fromJson(_noPlanDashboard);

      expect(dashboard.overAll, isEmpty);
      expect(dashboard.todo.unshippedOrders, 0);
      expect(dashboard.todo.lowStock, 0);
      expect(dashboard.stockThreshold, isEmpty);
      expect(dashboard.topProducts, isEmpty);
    });

    test('a populated dashboard still reads as before', () {
      final dashboard = SellerDashboard.fromJson(const {
        'dateRange': 'month',
        'todo': {
          'unshipped_orders': 8,
          'low_stock': 16,
          'pending_approval': 40,
          'unread_messages': 0,
        },
        'overAll': {
          'total_orders': {'current': 10},
        },
        'topProducts': [
          {'name': 'Mug'},
        ],
      });

      expect(dashboard.todo.unshippedOrders, 8);
      expect(dashboard.todo.lowStock, 16);
      expect(dashboard.overAll['total_orders'], isA<Map<String, dynamic>>());
      expect(dashboard.topProducts.length, 1);
    });
  });

  group('capabilities say why the dashboard is empty', () {
    SellerCapabilities parse(Map<String, dynamic> json) =>
        SellerCapabilities.fromJson(json);

    test('subscriptions on with no plan is the gated case', () {
      final capabilities = parse(const {
        'sellerId': 38,
        'features': {'subscriptions': true, 'marketplaceActive': true},
        'plan': null,
      });

      expect(capabilities.features.subscriptions, isTrue);
      expect(capabilities.plan, isNull);
    });

    test('a marketplace without subscriptions is not gated', () {
      final capabilities = parse(const {
        'sellerId': 38,
        'features': {'subscriptions': false},
        'plan': null,
      });

      expect(capabilities.features.subscriptions, isFalse);
    });
  });
}

/// The gate every closed-panel branch reads: the drawer trimmed to the shop
/// profile, the date filter hidden, and the dashboard request skipped.
void _gateTests() {
  group('planRequired', () {
    SellerCapabilities caps({required bool subscriptions, Object? plan}) =>
        SellerCapabilities.fromJson({
          'sellerId': 38,
          'features': {'subscriptions': subscriptions},
          'plan': plan,
        });

    test('subscriptions on and no plan closes the panel', () {
      expect(caps(subscriptions: true, plan: null).planRequired, isTrue);
    });

    test('subscriptions on with a plan does not', () {
      final held = caps(
        subscriptions: true,
        plan: const {'planId': 3, 'name': 'Starter'},
      );
      expect(held.plan, isNotNull);
      expect(held.planRequired, isFalse);
    });

    test('a marketplace that sells no subscriptions never closes it', () {
      expect(caps(subscriptions: false, plan: null).planRequired, isFalse);
    });
  });
}
