import 'package:bagisto_flutter/core/currency/currency_formatter.dart';
import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/widgets/seller_aftersales_widgets.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/ui/seller_ui.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/presentation/pages/seller_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Repository implements SellerDashboardRepository {
  _Repository(this.categories);
  final List<dynamic> categories;
  int requests = 0;

  @override
  Future<SellerDashboard> load({String? start, String? end}) async {
    requests++;
    return SellerDashboard.fromJson({
      'topCategories': categories,
      'topProducts': [
        {'id': 1, 'name': 'Existing product', 'sku': 'sku-1'},
      ],
      'stockThreshold': [
        {
          'id': 2,
          'name': 'Low stock product',
          'sku': 'sku-2',
          'total_quantity': 1,
        },
      ],
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Session extends Cubit<SellerSessionState> implements SellerSessionCubit {
  _Session(SellerPermissions permissions)
    : super(SellerSessionState(permissions: permissions));

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<_Repository> _pump(
  WidgetTester tester,
  List<dynamic> categories, {
  void Function(BuildContext, SellerDashboardProduct)? onOpenLowStockProduct,
  void Function(int)? onOpenTab,
  SellerPermissions permissions = const SellerPermissions(
    type: 'all',
    keys: {},
  ),
}) async {
  SharedPreferences.setMockInitialValues({'app_currency_code': 'USD'});
  CurrencyFormatter.initialize(await SharedPreferences.getInstance());
  final repository = _Repository(categories);
  final cubit = SellerDashboardCubit(repository: repository);
  final session = _Session(permissions);
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
          body: SellerDashboardPage(
            onOpenLowStockProduct: onOpenLowStockProduct,
            onOpenTab: onOpenTab,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  for (final width in [390.0, 1024.0]) {
    testWidgets('stock threshold View all opens products at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      int? openedTab;
      var openedEditor = false;
      final repository = await _pump(
        tester,
        [],
        onOpenTab: (index) => openedTab = index,
        onOpenLowStockProduct: (_, _) => openedEditor = true,
      );
      await tester.scrollUntilVisible(
        find.text('Stock Threshold'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      final header = find.ancestor(
        of: find.text('Stock Threshold'),
        matching: find.byType(SellerSectionHeader),
      );
      final action = find.descendant(
        of: header,
        matching: find.text('View all'),
      );
      expect(action, findsOneWidget);
      expect(
        tester.getRect(action).left,
        greaterThan(tester.getRect(find.text('Stock Threshold')).right),
      );
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      await tester.tap(action);
      expect(openedTab, 1);
      expect(openedEditor, isFalse);
      expect(repository.requests, 1);
      expect(find.text('Running low'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('stock threshold View all requires catalogue permission', (
    tester,
  ) async {
    await _pump(
      tester,
      [],
      permissions: const SellerPermissions(type: 'custom', keys: {}),
      onOpenTab: (_) => fail('Product navigation must not be available'),
    );
    await tester.scrollUntilVisible(
      find.text('Stock Threshold'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    final header = tester.widget<SellerSectionHeader>(
      find.ancestor(
        of: find.text('Stock Threshold'),
        matching: find.byType(SellerSectionHeader),
      ),
    );
    expect(header.action, isNull);
  });

  testWidgets(
    'running low tap passes its product and leaves top products alone',
    (tester) async {
      SellerDashboardProduct? opened;
      final repository = await _pump(
        tester,
        [],
        onOpenLowStockProduct: (context, product) {
          opened = product;
        },
      );
      await tester.scrollUntilVisible(
        find.text('Existing product'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Existing product'));
      expect(opened, isNull);
      await tester.scrollUntilVisible(
        find.text('Low stock product'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Low stock product'));
      expect(opened?.id, 2);
      expect(opened?.sku, 'sku-2');
      expect(repository.requests, 1);
    },
  );

  for (final keys in <Set<String>>[
    {},
    {'catalog.products'},
    {'catalog.products.edit'},
  ]) {
    testWidgets(
      'running low edit requires catalogue and edit permissions: $keys',
      (tester) async {
        var opened = false;
        await _pump(
          tester,
          [],
          permissions: SellerPermissions(type: 'custom', keys: keys),
          onOpenLowStockProduct: (_, _) => opened = true,
        );
        await tester.scrollUntilVisible(
          find.text('Low stock product'),
          250,
          scrollable: find.byType(Scrollable).first,
        );
        final card = tester.widget<SellerListCard>(
          find.ancestor(
            of: find.text('Low stock product'),
            matching: find.byType(SellerListCard),
          ),
        );
        expect(card.onTap, isNull);
        await tester.tap(find.text('Low stock product'));
        expect(opened, isFalse);
      },
    );
  }

  for (final width in [390.0, 1024.0]) {
    testWidgets('category revenue and proportional bars at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = await _pump(tester, [
        {'translation_name': 'Electronics', 'revenue': '1170.0000'},
        {
          'translation_name': '',
          'hierarchy': 'Home / Lighting',
          'revenue': 585,
        },
      ]);
      await tester.scrollUntilVisible(
        find.text('Top categories'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text(r'$1,170.00'), findsOneWidget);
      expect(find.text('Home / Lighting'), findsOneWidget);
      expect(find.text(r'$585.00'), findsOneWidget);
      final bars = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .toList();
      expect(bars.map((bar) => bar.value), [1.0, 0.5]);
      expect(bars.map((bar) => bar.minHeight), everyElement(4.0));
      expect(
        bars.map((bar) => bar.borderRadius),
        everyElement(BorderRadius.circular(2)),
      );
      expect(bars.map((bar) => bar.color), everyElement(AppColors.primary500));
      expect(
        find.ancestor(
          of: find.text('Electronics'),
          matching: find.byType(SellerListCard),
        ),
        findsOneWidget,
      );
      final amount = find.text(r'$1,170.00');
      expect(tester.widget<Text>(amount).style?.color, AppColors.successGreen);
      expect(
        tester.getTopRight(amount).dx,
        closeTo(
          tester.getTopRight(find.byType(LinearProgressIndicator).first).dx,
          0.5,
        ),
      );
      expect(
        tester.getTopLeft(find.byType(LinearProgressIndicator).first).dy,
        greaterThan(tester.getBottomLeft(amount).dy),
      );
      expect(repository.requests, 1);
      expect(tester.takeException(), isNull);
      expect(
        tester.getTopLeft(find.text('Top categories')).dy,
        greaterThan(tester.getTopLeft(find.text('Top products')).dy),
      );
    });
  }

  testWidgets('empty categories add no section', (tester) async {
    await _pump(tester, []);
    await tester.scrollUntilVisible(
      find.text('Low stock product'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Top categories'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('zero and invalid revenues do not create invalid bars', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const longName =
        'Home and garden supplies with a long category name that must wrap';
    await _pump(tester, [
      {'translation_name': longName, 'revenue': 0},
      {'hierarchy': 'Missing revenue', 'revenue': null},
      {'translation_name': 'Invalid revenue', 'revenue': 'NaN'},
      'invalid row',
    ]);
    await tester.scrollUntilVisible(
      find.text('Top categories'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text(longName), findsOneWidget);
    expect(find.text(r'$0.00'), findsNWidgets(3));
    expect(
      tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .map((bar) => bar.value),
      [0.0, 0.0, 0.0],
    );
    expect(tester.takeException(), isNull);
  });
}
