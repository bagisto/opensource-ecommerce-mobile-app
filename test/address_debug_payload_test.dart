import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/presentation/utils/address_debug_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'buildEditAddressDebugPayload includes saved address data and address id',
    () {
      const address = CustomerAddress(
        id: 'gid://bagisto/Address/42',
        numericId: 42,
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane@example.com',
        companyName: 'Acme Corp',
        vatId: 'VAT-42',
        address: '221B Baker Street',
        city: 'London',
        state: 'LDN',
        country: 'GB',
        zipCode: 'NW16XE',
        phone: '+441234567890',
        isDefault: true,
        useForShipping: false,
        addressType: 'billing',
        createdAt: '2026-05-25T10:00:00Z',
      );

      final payload = buildEditAddressDebugPayload(address);

      expect(payload, {
        'addressId': 42,
        'id': 'gid://bagisto/Address/42',
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane@example.com',
        'companyName': 'Acme Corp',
        'vatId': 'VAT-42',
        'address': '221B Baker Street',
        'city': 'London',
        'state': 'LDN',
        'country': 'GB',
        'postcode': 'NW16XE',
        'phone': '+441234567890',
        'defaultAddress': true,
        'useForShipping': false,
        'addressType': 'billing',
        'createdAt': '2026-05-25T10:00:00Z',
      });
    },
  );
}
