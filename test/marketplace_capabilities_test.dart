import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_capabilities.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// What the server answers `sellerCapabilities` with, live on 2026-08-19.
const _payload = {
  'sellerId': 38,
  'isStaff': false,
  'permissions': [
    'dashboard',
    'catalog',
    'catalog.products',
    'catalog.products.edit',
  ],
  'features': {
    'marketplaceActive': true,
    'subscriptions': false,
    'canCreateProduct': true,
    'canAssignProduct': true,
    'canCancelOrder': true,
    'canViewCustomers': true,
    'canCreateInvoice': true,
    'canCreateShipment': true,
    'canJoinPromotions': true,
    'promotionJoinAutoApprove': true,
    'productApprovalRequired': true,
    'sellersShownPublicly': true,
    'minimumOrderAmount': true,
  },
  'plan': null,
};

void main() {
  test('the permissions are this account\'s, not the whole catalogue', () {
    // The app read `sellerAclPermissions`, which lists every key a role *may*
    // hold — so a staff member limited to orders was shown the whole menu.
    final capabilities = SellerCapabilities.fromJson(_payload);

    expect(capabilities.permissions.can('catalog.products.edit'), isTrue);
    expect(capabilities.permissions.can('settings.roles'), isFalse);
    expect(capabilities.sellerId, 38);
    expect(capabilities.isStaff, isFalse);
  });

  test('subscriptions off is what hides the plan screen', () {
    // The only other signal was a 404 from the plans endpoint, which is also
    // what a seller who simply holds no subscription gets.
    final capabilities = SellerCapabilities.fromJson(_payload);

    expect(capabilities.features.subscriptions, isFalse);
    expect(capabilities.plan, isNull);
  });

  test('a switch the server did not send keeps its entry', () {
    // An older marketplace build answers with fewer flags; losing menu entries
    // to a missing field would be worse than showing them.
    final capabilities = SellerCapabilities.fromJson({
      'permissions': const <String>[],
      'features': const {'subscriptions': true},
    });

    expect(capabilities.features.subscriptions, isTrue);
    expect(capabilities.features.canCreateProduct, isTrue);
    expect(capabilities.features.canViewCustomers, isTrue);
  });

  test('a plan that is used up says so', () {
    final capabilities = SellerCapabilities.fromJson({
      'permissions': const <String>[],
      'plan': const {
        'planId': 2,
        'name': 'Starter',
        'maxProducts': 10,
        'productsUsed': 10,
        'daysRemaining': 4,
        'productTypes': ['simple', 'virtual'],
      },
    });

    expect(capabilities.plan!.productsExhausted, isTrue);
    expect(capabilities.plan!.allowsType('simple'), isTrue);
    expect(capabilities.plan!.allowsType('bundle'), isFalse);
    expect(capabilities.plan!.daysRemaining, 4);
  });

  test('an unlimited plan is never exhausted', () {
    final capabilities = SellerCapabilities.fromJson({
      'permissions': const <String>[],
      'plan': const {'planId': 1, 'productsUsed': 900},
    });

    expect(capabilities.plan!.productsExhausted, isFalse);
    expect(capabilities.plan!.allowsType('bundle'), isTrue);
  });

  test('the dashboard reads what needs doing', () {
    // The panel's "Things to do" tile, which the dashboard query never
    // selected — the four counts arrive snake_cased inside their own panel.
    final dashboard = SellerDashboard.fromJson(const {
      'dateRange': '',
      'todo': {
        'unshipped_orders': 1,
        'low_stock': 7,
        'pending_approval': 14,
        'unread_messages': 1,
      },
    });

    expect(dashboard.todo.unshippedOrders, 1);
    expect(dashboard.todo.lowStock, 7);
    expect(dashboard.todo.pendingApproval, 14);
    expect(dashboard.todo.unreadMessages, 1);
    expect(dashboard.todo.isClear, isFalse);
  });

  test('nothing waiting reads as caught up, not as four zeroes', () {
    final dashboard = SellerDashboard.fromJson(const {
      'dateRange': '',
      'todo': {
        'unshipped_orders': 0,
        'low_stock': 0,
        'pending_approval': 0,
        'unread_messages': 0,
      },
    });

    expect(dashboard.todo.isClear, isTrue);
  });

  test('a dashboard with no todo panel still builds', () {
    final dashboard = SellerDashboard.fromJson(const {'dateRange': ''});

    expect(dashboard.todo.isClear, isTrue);
  });

  testWidgets('the permission alone does not open a switched-off feature', (
    tester,
  ) async {
    // The seller holds `customers`, but the operator has turned customer
    // visibility off — the screen behind the entry answers nothing useful.
    const permissions = SellerPermissions(
      type: 'custom',
      keys: {'customers', 'catalog.products.assign'},
    );
    final features = SellerFeatures.fromJson(const {
      'canViewCustomers': false,
      'canAssignProduct': false,
    });

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              if (permissions.can('customers') && features.canViewCustomers)
                const Text('Customers'),
              if (permissions.can('catalog.products.assign') &&
                  features.canAssignProduct)
                const Text('Sell an existing product'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Customers'), findsNothing);
    expect(find.text('Sell an existing product'), findsNothing);
  });
}
