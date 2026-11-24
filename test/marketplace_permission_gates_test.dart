@Tags(['live'])
library;

import 'dart:io';

import 'package:bagisto_flutter/core/graphql/graphql_client.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every permission the shell gates a screen on must be one the server
/// actually defines.
///
/// A key that does not exist locks its screen forever with no error anywhere:
/// `product_catalog.products` did exactly that to the Products tab, so a
/// seller could not add a product at all.
///
/// Run with:
///   SELLER_EMAIL=... SELLER_PASSWORD=... flutter test --tags live \
///     test/marketplace_permission_gates_test.dart
void main() {
  final email = Platform.environment['SELLER_EMAIL'];
  final password = Platform.environment['SELLER_PASSWORD'];
  final credentialsMissing = email == null || password == null;

  setUpAll(() => HttpOverrides.global = null);

  /// The keys `marketplace_shell.dart` gates its menu entries on.
  const gatedOn = <String>{
    'catalog.products',
    'catalog.products.assign',
    'catalog.products.barcode',
    'catalog.products.magic_ai',
    'catalog.bulk_upload.imports',
    'sales.orders',
    'sales.orders.shipment',
    'sales.rma',
    'sales.bookings',
    'sales.transactions',
    'customers',
    'communication.admin',
    'communication.customers',
    'performance.product_reviews',
    'performance.seller_reviews',
    'reporting.sales',
    'reporting.products',
    'reporting.customers',
    'marketing.product_discounts',
    'marketing.checkout_deals',
    'pricing.manage_pricing',
    'inventories.manage_inventory',
  };

  test(
    'every gated permission exists on the server',
    () async {
      final login = await SellerAuthRepository(
        client: GraphQLClientProvider.buildSellerClient(),
      ).login(email: email!, password: password!);

      final acl = await SellerAccountRepository(
        client: GraphQLClientProvider.buildSellerClient(token: login.token),
      ).aclPermissions();

      final real = acl.map((permission) => permission.key).toSet();
      expect(real, isNotEmpty);

      final unknown = gatedOn.difference(real);
      expect(
        unknown,
        isEmpty,
        reason:
            'These keys gate a screen but the server does not define them, so '
            'those screens can never open: $unknown',
      );
    },
    skip: credentialsMissing
        ? 'set SELLER_EMAIL and SELLER_PASSWORD to run this'
        : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
