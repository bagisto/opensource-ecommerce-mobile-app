import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_capabilities.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/shell/seller_drawer.dart';
import 'package:bagisto_flutter/marketplace/shell/marketplace_shell.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/pages/seller_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// A seller whose operator sells subscriptions and who holds none reaches
/// almost nothing — but Plans is how they get out of that, so the web panel
/// keeps it in the sidebar and so does this.
class _Session extends Cubit<SellerSessionState> implements SellerSessionCubit {
  _Session(SellerCapabilities capabilities, SellerPermissions permissions)
    : super(
        SellerSessionState(
          permissions: permissions,
          capabilities: capabilities,
        ),
      );

  @override
  String? get token => null;

  @override
  Future<SellerFeatures> refreshFeatures() async => state.capabilities.features;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Profile extends Cubit<SellerProfileState> implements SellerProfileCubit {
  _Profile()
    : super(
        const SellerProfileState(
          status: SellerProfileStatus.loaded,
          profile: SellerProfile(name: 'Seller', email: 'seller@example.com'),
        ),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<void> _pump(
  WidgetTester tester,
  SellerCapabilities capabilities, {
  SellerPermissions permissions = const SellerPermissions(
    type: 'all',
    keys: {},
  ),
}) async {
  tester.view.physicalSize = const Size(900, 2200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final session = _Session(capabilities, permissions);
  addTearDown(session.close);

  await tester.pumpWidget(
    BlocProvider<SellerSessionCubit>.value(
      value: session,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SellerDrawer(selectedIndex: 0, onSelectTab: (_) {}),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'seller without a plan lands on Manage Profile with Plans available',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final session = _Session(
        const SellerCapabilities(features: SellerFeatures(subscriptions: true)),
        const SellerPermissions(type: 'custom', keys: {}),
      );
      addTearDown(session.close);
      await tester.pumpWidget(
        BlocProvider<SellerSessionCubit>.value(
          value: session,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MarketplaceShell(profileCubitFactory: (_) => _Profile()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Manage Profile'), findsOneWidget);
      expect(find.byType(SellerProfilePage), findsOneWidget);
      expect(find.text('A plan is needed'), findsNothing);
      expect(find.byType(AppBar), findsOneWidget);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sellerDrawerPlanGroup')), findsOneWidget);
      expect(find.byKey(const Key('sellerDrawerDashboard')), findsNothing);
    },
  );
  testWidgets('a seller with no plan keeps Plans', (tester) async {
    await _pump(
      tester,
      const SellerCapabilities(features: SellerFeatures(subscriptions: true)),
    );

    expect(find.byKey(const Key('sellerDrawerShopProfile')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerPlanGroup')), findsOneWidget);
    // Everything behind a plan stays closed.
    expect(find.byKey(const Key('sellerDrawerDashboard')), findsNothing);

    // The group opens onto the two screens the web sidebar lists.
    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sellerDrawerPlan')), findsOneWidget);
    expect(find.byKey(const Key('sellerDrawerPlanHistory')), findsOneWidget);
    expect(find.text('Available Plans'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });

  testWidgets('a marketplace without subscriptions shows no Plans entry', (
    tester,
  ) async {
    await _pump(tester, const SellerCapabilities());

    expect(find.byKey(const Key('sellerDrawerShopProfile')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerDashboard')), findsOneWidget);
    expect(find.byKey(const Key('sellerDrawerPlanGroup')), findsNothing);
  });

  testWidgets('the plan decides the menu, section by section', (tester) async {
    // Verbatim from sellerCapabilities on .239 for a seller holding "test
    // plan": dashboard, profile and catalog, and nothing else.
    await _pump(
      tester,
      const SellerCapabilities(
        features: SellerFeatures(subscriptions: true),
        plan: SellerPlanLimits(planId: 3, name: 'test plan'),
      ),
      permissions: const SellerPermissions(
        type: 'custom',
        keys: {
          'dashboard',
          'profile',
          'catalog',
          'catalog.list_your_product',
          'catalog.products',
          'catalog.products.assign',
          'catalog.products.edit',
          'catalog.bulk_upload',
          'catalog.bulk_upload.imports',
        },
      ),
    );

    expect(find.byKey(const Key('sellerDrawerDashboard')), findsOneWidget);
    expect(find.byKey(const Key('sellerDrawerShopProfile')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerProductsGroup')), findsOneWidget);
    expect(find.byKey(const Key('sellerDrawerPlanGroup')), findsOneWidget);

    // The sections the plan withholds: both used to be drawn whatever the
    // subscription said, and every screen behind them refuses.
    expect(find.byKey(const Key('sellerDrawerInventoriesGroup')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerSettingsGroup')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerSalesGroup')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerReviewsGroup')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerInboxGroup')), findsNothing);
    expect(find.byKey(const Key('sellerDrawerCustomers')), findsNothing);
  });

  testWidgets('a seller holding a plan gets the whole menu, Plans included', (
    tester,
  ) async {
    await _pump(
      tester,
      const SellerCapabilities(
        features: SellerFeatures(subscriptions: true),
        plan: SellerPlanLimits(planId: 3, name: 'test plan'),
      ),
    );

    expect(find.byKey(const Key('sellerDrawerDashboard')), findsOneWidget);
    expect(find.byKey(const Key('sellerDrawerPlanGroup')), findsOneWidget);
  });
}
