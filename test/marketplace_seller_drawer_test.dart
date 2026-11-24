import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_capabilities.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/pages/seller_reviews_page.dart';
import 'package:bagisto_flutter/marketplace/shell/marketplace_shell.dart';
import 'package:bagisto_flutter/marketplace/shell/seller_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _Session extends Cubit<SellerSessionState> implements SellerSessionCubit {
  _Session(super.initialState);

  @override
  String? get token => 'test-seller-token';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Routes extends NavigatorObserver {
  Route<dynamic>? lastPushed;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastPushed = route;
  }
}

const _group = Key('sellerDrawerProductsGroup');
const _products = Key('sellerDrawerProducts');
const _assign = Key('sellerDrawerAssign');

Future<GlobalKey<ScaffoldState>> _openDrawer(
  WidgetTester tester, {
  Set<String> permissions = const {
    'catalog.products',
    'catalog.products.assign',
  },
  bool canAssign = true,
  int selectedIndex = 0,
  ValueChanged<int>? onSelect,
  NavigatorObserver? observer,
}) async {
  final session = _Session(
    SellerSessionState(
      permissions: SellerPermissions(type: 'custom', keys: permissions),
      capabilities: SellerCapabilities(
        features: SellerFeatures(canAssignProduct: canAssign),
      ),
    ),
  );
  addTearDown(session.close);
  final scaffold = GlobalKey<ScaffoldState>();
  await tester.pumpWidget(
    BlocProvider<SellerSessionCubit>.value(
      value: session,
      child: MaterialApp(
        navigatorObservers: [?observer],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          key: scaffold,
          drawer: SellerDrawer(
            selectedIndex: selectedIndex,
            onSelectTab: onSelect ?? (_) {},
          ),
        ),
      ),
    ),
  );
  scaffold.currentState!.openDrawer();
  await tester.pumpAndSettle();
  return scaffold;
}

void main() {
  testWidgets('Reviews groups both entries with no standalone duplicates', (
    tester,
  ) async {
    await _openDrawer(
      tester,
      permissions: {
        'performance.product_reviews',
        'performance.seller_reviews',
      },
    );
    final group = find.byKey(const Key('sellerDrawerReviewsGroup'));
    expect(group, findsOneWidget);
    await tester.tap(group);
    await tester.pumpAndSettle();
    for (final key in [
      'sellerDrawerProductReviews',
      'sellerDrawerShopReviews',
    ]) {
      expect(find.byKey(Key(key)), findsOneWidget);
      expect(
        find.descendant(of: group, matching: find.byKey(Key(key))),
        findsOneWidget,
      );
    }
  });

  for (final (permission, key, other, tab) in [
    (
      'performance.product_reviews',
      'sellerDrawerProductReviews',
      'sellerDrawerShopReviews',
      0,
    ),
    (
      'performance.seller_reviews',
      'sellerDrawerShopReviews',
      'sellerDrawerProductReviews',
      1,
    ),
  ]) {
    testWidgets('$key retains its permission and route selection', (
      tester,
    ) async {
      final routes = _Routes();
      await _openDrawer(tester, permissions: {permission}, observer: routes);
      await tester.tap(find.byKey(const Key('sellerDrawerReviewsGroup')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key(other)), findsNothing);
      await tester.tap(find.byKey(Key(key)));
      final route = routes.lastPushed! as MaterialPageRoute<dynamic>;
      final page = route.builder(tester.element(find.byType(Scaffold)));
      expect(page, isA<SellerReviewsPage>());
      expect((page as SellerReviewsPage).initialTab, tab);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  }

  testWidgets('Products expands to both existing destinations', (tester) async {
    final scaffold = await _openDrawer(tester);
    expect(find.byKey(_group), findsOneWidget);
    expect(find.byKey(_products), findsNothing);
    await tester.tap(find.byKey(_group));
    await tester.pumpAndSettle();
    expect(scaffold.currentState!.isDrawerOpen, isTrue);
    expect(find.byKey(_products), findsOneWidget);
    expect(find.byKey(_assign), findsOneWidget);
    expect(
      find.descendant(of: find.byKey(_group), matching: find.byKey(_assign)),
      findsOneWidget,
    );
  });

  testWidgets('All products retains tab selection and closes the drawer', (
    tester,
  ) async {
    int? selected;
    final scaffold = await _openDrawer(
      tester,
      selectedIndex: 1,
      onSelect: (index) => selected = index,
    );
    expect(find.byKey(_products), findsOneWidget);
    await tester.tap(find.byKey(_products));
    await tester.pumpAndSettle();
    expect(selected, 1);
    expect(scaffold.currentState!.isDrawerOpen, isFalse);
  });

  testWidgets('assignment-only permission still exposes assignment', (
    tester,
  ) async {
    await _openDrawer(tester, permissions: {'catalog.products.assign'});
    await tester.tap(find.byKey(_group));
    await tester.pumpAndSettle();
    expect(find.byKey(_products), findsNothing);
    expect(find.byKey(_assign), findsOneWidget);
  });

  testWidgets('assignment pushes its route without selecting another tab', (
    tester,
  ) async {
    final routes = _Routes();
    int? selected;
    await _openDrawer(
      tester,
      selectedIndex: 1,
      observer: routes,
      onSelect: (index) => selected = index,
    );
    SellerRoutes.profileCompletedLoader = (_) async => true;
    addTearDown(() => SellerRoutes.profileCompletedLoader = null);
    final previous = routes.lastPushed;
    await tester.tap(find.byKey(_assign));
    final context = tester.element(find.byType(Scaffold));
    // Let the profile lookup answer without building the pushed page, which
    // would start live API requests.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    expect(routes.lastPushed, isNot(same(previous)));
    final route = routes.lastPushed! as MaterialPageRoute<dynamic>;
    final page = route.builder(context);
    expect(page, isA<MultiBlocProvider>());
    expect(selected, isNull);
    // Check the destination without mounting it or starting live API requests.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('an incomplete profile blocks assignment with a message', (
    tester,
  ) async {
    final routes = _Routes();
    await _openDrawer(tester, selectedIndex: 1, observer: routes);
    SellerRoutes.profileCompletedLoader = (_) async => false;
    addTearDown(() => SellerRoutes.profileCompletedLoader = null);
    final previous = routes.lastPushed;
    await tester.tap(find.byKey(_assign));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('sellerAssignProfileIncomplete')),
      findsOneWidget,
    );
    expect(find.text('Please update your profile details'), findsOneWidget);
    // Only the dialog route was added, not the assign page.
    expect(routes.lastPushed, isNot(isA<MaterialPageRoute<dynamic>>()));
    expect(previous, isNotNull);
  });

  testWidgets('assignment stays hidden when the marketplace disables it', (
    tester,
  ) async {
    await _openDrawer(tester, canAssign: false, selectedIndex: 1);
    expect(find.byKey(_products), findsOneWidget);
    expect(find.byKey(_assign), findsNothing);
  });

  testWidgets('assignment stays hidden without its permission', (tester) async {
    await _openDrawer(
      tester,
      permissions: {'catalog.products'},
      selectedIndex: 1,
    );
    expect(find.byKey(_products), findsOneWidget);
    expect(find.byKey(_assign), findsNothing);
  });

  testWidgets('no accessible children means no Products group', (tester) async {
    await _openDrawer(tester, permissions: {});
    expect(find.byKey(const Key('sellerDrawerReviewsGroup')), findsNothing);
    expect(find.byKey(_group), findsNothing);
    expect(find.byKey(_products), findsNothing);
    expect(find.byKey(_assign), findsNothing);
  });
}
