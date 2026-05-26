import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/presentation/helpers/account_dashboard_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveDashboardDefaultAddress', () {
    test('returns null when address list is empty', () {
      expect(resolveDashboardDefaultAddress(const []), isNull);
    });

    test('returns the default address when one exists', () {
      const addresses = [
        CustomerAddress(
          firstName: 'First',
          lastName: 'Address',
          address: 'Street 1',
          city: 'Noida',
          state: 'UP',
          country: 'IN',
          zipCode: '201301',
        ),
        CustomerAddress(
          firstName: 'Default',
          lastName: 'Address',
          address: 'Street 2',
          city: 'Delhi',
          state: 'DL',
          country: 'IN',
          zipCode: '110001',
          isDefault: true,
        ),
      ];

      expect(resolveDashboardDefaultAddress(addresses)?.firstName, 'Default');
    });

    test('falls back to the first address when none is default', () {
      const addresses = [
        CustomerAddress(
          firstName: 'First',
          lastName: 'Address',
          address: 'Street 1',
          city: 'Noida',
          state: 'UP',
          country: 'IN',
          zipCode: '201301',
        ),
        CustomerAddress(
          firstName: 'Second',
          lastName: 'Address',
          address: 'Street 2',
          city: 'Delhi',
          state: 'DL',
          country: 'IN',
          zipCode: '110001',
        ),
      ];

      expect(resolveDashboardDefaultAddress(addresses)?.firstName, 'First');
    });
  });

  test('refreshes dashboard after address book returns', () async {
    var refreshCalls = 0;

    await refreshAccountDashboardAfterAddressBook<void>(
      openAddressBook: () async {},
      onReturn: () => refreshCalls += 1,
    );

    expect(refreshCalls, 1);
  });
}
