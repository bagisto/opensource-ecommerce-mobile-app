import 'package:bagisto_flutter/features/account/presentation/helpers/address_book_navigation_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('refreshes address book when address form returns true', () async {
    var refreshCalls = 0;

    await refreshAddressBookAfterForm(
      openForm: () async => true,
      onSaved: () => refreshCalls += 1,
    );

    expect(refreshCalls, 1);
  });

  test(
    'does not refresh address book when address form returns false or null',
    () async {
      var refreshCalls = 0;

      await refreshAddressBookAfterForm(
        openForm: () async => false,
        onSaved: () => refreshCalls += 1,
      );
      await refreshAddressBookAfterForm(
        openForm: () async => null,
        onSaved: () => refreshCalls += 1,
      );

      expect(refreshCalls, 0);
    },
  );
}
