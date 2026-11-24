import 'package:bagisto_flutter/core/currency/currency_formatter.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/pages/seller_dashboard_page.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/models/seller_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Buyer Messages and Customer Feedback sit above "Things to do", as the web
/// account-health page lays them out.
class _Repository implements SellerDashboardRepository {
  _Repository(this.unread);
  final int unread;

  @override
  Future<SellerDashboard> load({String? start, String? end}) async =>
      SellerDashboard.fromJson({
        'todo': {
          'unshipped_orders': 2,
          'low_stock': 0,
          'pending_approval': 0,
          'unread_messages': unread,
        },
      });

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Session extends Cubit<SellerSessionState> implements SellerSessionCubit {
  _Session()
    : super(
        const SellerSessionState(
          permissions: SellerPermissions(type: 'all', keys: {}),
        ),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<void> _pump(
  WidgetTester tester, {
  int unread = 0,
  SellerAccountHealth? health,
}) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  SharedPreferences.setMockInitialValues({'app_currency_code': 'USD'});
  CurrencyFormatter.initialize(await SharedPreferences.getInstance());
  final cubit = SellerDashboardCubit(repository: _Repository(unread));
  final session = _Session();
  addTearDown(cubit.close);
  addTearDown(session.close);
  await cubit.load();
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<SellerDashboardCubit>.value(value: cubit),
        BlocProvider<SellerSessionCubit>.value(value: session),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SellerDashboardPage(accountHealthLoader: () async => health),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

SellerAccountHealth _health({int? count}) => SellerAccountHealth.fromJson({
  'score': 100,
  'scoreStatus': 'good',
  'overall': 'good',
  'metrics': {
    'customer_feedback': {
      'key': 'customer_feedback',
      'value': 5,
      'formatted': '5.0',
      'status': 'good',
      'meta': {'window_days': 90, 'count': ?count},
      'thresholds': {'warning': 3, 'good': 4},
    },
  },
});

void main() {
  testWidgets('both cards show above Things to do with their figures', (
    tester,
  ) async {
    await _pump(tester, unread: 3, health: _health(count: 1));

    final messages = find.byKey(const Key('sellerDashboardBuyerMessages'));
    final feedback = find.byKey(const Key('sellerDashboardCustomerFeedback'));
    expect(messages, findsOneWidget);
    expect(feedback, findsOneWidget);

    expect(
      find.descendant(of: messages, matching: find.text('Buyer Messages')),
      findsOneWidget,
    );
    expect(find.descendant(of: messages, matching: find.text('3')), findsOne);
    expect(
      find.descendant(of: messages, matching: find.text('Unread')),
      findsOneWidget,
    );

    expect(
      find.descendant(of: feedback, matching: find.text('Customer Feedback')),
      findsOneWidget,
    );
    expect(find.textContaining('5.0'), findsWidgets);
    expect(
      find.descendant(of: feedback, matching: find.text('1 review')),
      findsOneWidget,
    );

    // Above the to-do list.
    final todoTop = tester.getTopLeft(find.text('Things to do')).dy;
    expect(tester.getBottomLeft(messages).dy, lessThan(todoTop));
    expect(tester.getBottomLeft(feedback).dy, lessThan(todoTop));
  });

  testWidgets('zero unread still shows the Buyer Messages card', (
    tester,
  ) async {
    await _pump(tester, unread: 0, health: _health(count: 4));

    final messages = find.byKey(const Key('sellerDashboardBuyerMessages'));
    expect(find.descendant(of: messages, matching: find.text('0')), findsOne);
    expect(find.text('4 reviews'), findsOneWidget);
  });

  testWidgets('no review count from the server shows the score alone', (
    tester,
  ) async {
    await _pump(tester, health: _health());

    expect(
      find.byKey(const Key('sellerDashboardCustomerFeedback')),
      findsOneWidget,
    );
    expect(find.textContaining('review'), findsNothing);
  });

  testWidgets('no account health leaves only the messages card', (
    tester,
  ) async {
    await _pump(tester, unread: 1);

    expect(
      find.byKey(const Key('sellerDashboardBuyerMessages')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('sellerDashboardCustomerFeedback')),
      findsNothing,
    );
  });
}
