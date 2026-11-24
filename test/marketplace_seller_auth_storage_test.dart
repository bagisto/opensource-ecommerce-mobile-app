import 'package:bagisto_flutter/features/auth/domain/services/auth_storage.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_auth_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('stores and reads a seller session', () async {
    await SellerAuthStorage.saveSession(
      token: 'seller-token',
      name: 'Acme',
      email: 'seller@example.com',
      slug: 'acme-store',
      sellerId: 7,
    );

    expect(await SellerAuthStorage.getToken(), 'seller-token');
    expect(await SellerAuthStorage.getName(), 'Acme');
    expect(await SellerAuthStorage.getEmail(), 'seller@example.com');
    expect(await SellerAuthStorage.getSlug(), 'acme-store');
    expect(await SellerAuthStorage.getSellerId(), 7);
    expect(await SellerAuthStorage.isLoggedIn(), isTrue);
  });

  test('stores permissions', () async {
    await SellerAuthStorage.savePermissions(
      permissionType: 'custom',
      permissions: const ['dashboard', 'sales.orders'],
    );

    expect(await SellerAuthStorage.getPermissionType(), 'custom');
    expect(await SellerAuthStorage.getPermissions(), const [
      'dashboard',
      'sales.orders',
    ]);
  });

  test(
    'clearing the seller session leaves the customer session intact',
    () async {
      await AuthStorage.saveToken('customer-token');
      await SellerAuthStorage.saveSession(
        token: 'seller-token',
        name: 'Acme',
        email: 'seller@example.com',
      );

      await SellerAuthStorage.clear();

      expect(await SellerAuthStorage.getToken(), isNull);
      expect(await SellerAuthStorage.isLoggedIn(), isFalse);
      expect(await AuthStorage.getToken(), 'customer-token');
    },
  );

  test(
    'clearing the customer session leaves the seller session intact',
    () async {
      await AuthStorage.saveToken('customer-token');
      await SellerAuthStorage.saveSession(
        token: 'seller-token',
        name: 'Acme',
        email: 'seller@example.com',
      );

      await AuthStorage.clearAuth();

      expect(await SellerAuthStorage.getToken(), 'seller-token');
    },
  );
}
