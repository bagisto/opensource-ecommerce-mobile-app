import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('permissionType all grants everything', () {
    final permissions = SellerPermissions.all();

    expect(permissions.can('sales.orders.invoice'), isTrue);
    expect(permissions.can('anything.at.all'), isTrue);
  });

  test('custom type grants only the listed keys', () {
    const permissions = SellerPermissions(
      type: 'custom',
      keys: {'dashboard', 'sales.orders', 'sales.orders.view'},
    );

    expect(permissions.can('sales.orders.view'), isTrue);
    expect(permissions.can('sales.orders.invoice'), isFalse);
  });

  test('canAny is true when at least one key is granted', () {
    const permissions = SellerPermissions(
      type: 'custom',
      keys: {'sales.orders'},
    );

    expect(
      permissions.canAny(const ['product_catalog.products', 'sales.orders']),
      isTrue,
    );
    expect(permissions.canAny(const ['settings.users']), isFalse);
  });

  test('none grants nothing', () {
    expect(SellerPermissions.none().can('dashboard'), isFalse);
  });
}
