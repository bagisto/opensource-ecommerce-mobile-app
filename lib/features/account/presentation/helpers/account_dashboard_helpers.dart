import '../../data/models/account_models.dart';

CustomerAddress? resolveDashboardDefaultAddress(
  List<CustomerAddress> addresses,
) {
  if (addresses.isEmpty) return null;

  for (final address in addresses) {
    if (address.isDefault) {
      return address;
    }
  }

  return addresses.first;
}

Future<void> refreshAccountDashboardAfterAddressBook<T>({
  required Future<T> Function() openAddressBook,
  required void Function() onReturn,
}) async {
  await openAddressBook();
  onReturn();
}
