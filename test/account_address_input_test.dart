import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'buildCustomerAddressMutationInput omits useForShipping for account add edit flow',
    () {
      final input = buildCustomerAddressMutationInput(
        addressId: 42,
        firstName: 'Jane',
        lastName: 'Doe',
        address: '221B Baker Street',
        city: 'London',
        state: 'LDN',
        country: 'GB',
        postcode: 'NW16XE',
        phone: '+441234567890',
        email: 'jane@example.com',
        defaultAddress: true,
      );

      expect(input['addressId'], 42);
      expect(input['defaultAddress'], isTrue);
      expect(input['email'], 'jane@example.com');
      expect(input.containsKey('useForShipping'), isFalse);
    },
  );

  test(
    'buildSetDefaultCustomerAddressMutationInput includes full address payload and omits useForShipping',
    () {
      final input = buildSetDefaultCustomerAddressMutationInput(
        address: const CustomerAddress(
          id: 'gid://bagisto/Address/42',
          numericId: 42,
          firstName: 'Jane',
          lastName: 'Doe',
          email: 'jane@example.com',
          address: '221B Baker Street',
          city: 'London',
          state: 'LDN',
          country: 'GB',
          zipCode: 'NW16XE',
          phone: '+441234567890',
          isDefault: false,
          useForShipping: false,
        ),
      );

      expect(input['addressId'], 42);
      expect(input['firstName'], 'Jane');
      expect(input['lastName'], 'Doe');
      expect(input['address1'], '221B Baker Street');
      expect(input['city'], 'London');
      expect(input['state'], 'LDN');
      expect(input['country'], 'GB');
      expect(input['postcode'], 'NW16XE');
      expect(input['phone'], '+441234567890');
      expect(input['email'], 'jane@example.com');
      expect(input['defaultAddress'], isTrue);
      expect(input.containsKey('useForShipping'), isFalse);
    },
  );
}
