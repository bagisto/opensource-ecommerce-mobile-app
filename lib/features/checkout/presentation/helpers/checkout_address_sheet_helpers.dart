import '../../data/models/checkout_model.dart';

bool shouldRefreshAddressesBeforeShowingChangeSheet({
  required bool isGuest,
  required bool addressConfirmed,
}) {
  return !isGuest && addressConfirmed;
}

Future<List<CheckoutAddress>> loadChangeAddressSheetAddresses({
  required bool isGuest,
  required List<CheckoutAddress> currentAddresses,
  required Future<List<CheckoutAddress>> Function() refreshAddresses,
}) async {
  if (isGuest) {
    return currentAddresses;
  }

  try {
    return await refreshAddresses();
  } catch (_) {
    return currentAddresses;
  }
}

String? findNewlyAddedAddressId({
  required Set<String> previousIds,
  required Iterable<String?> refreshedIds,
}) {
  for (final id in refreshedIds) {
    if (id != null && id.isNotEmpty && !previousIds.contains(id)) {
      return id;
    }
  }

  return null;
}

CheckoutAddress? findNewlyAddedSelectableAddress({
  required Set<String> previousCustomerIds,
  required Iterable<String?> refreshedCustomerIds,
  required List<CheckoutAddress> refreshedAddresses,
}) {
  final newAddressId = findNewlyAddedAddressId(
    previousIds: previousCustomerIds,
    refreshedIds: refreshedCustomerIds,
  );

  if (newAddressId == null) {
    return null;
  }

  return findCheckoutAddressById(
    addressId: newAddressId,
    addresses: refreshedAddresses,
  );
}

CheckoutAddress? findNewlyAddedCheckoutAddress({
  required Set<String> previousIds,
  required List<CheckoutAddress> refreshedAddresses,
}) {
  for (final address in refreshedAddresses) {
    if (!previousIds.contains(address.id)) {
      return address;
    }
  }

  return null;
}

CheckoutAddress? findCheckoutAddressById({
  required String? addressId,
  required List<CheckoutAddress> addresses,
}) {
  if (addressId == null || addressId.isEmpty) {
    return null;
  }

  for (final address in addresses) {
    if (address.id == addressId) {
      return address;
    }
  }

  return null;
}

Map<String, dynamic> buildSavedCheckoutAddressInput({
  required CheckoutAddress billingAddress,
  required bool useForShipping,
  CheckoutAddress? shippingAddress,
}) {
  final input = billingAddress.toBillingInput(useForShipping: useForShipping);

  if (!useForShipping && shippingAddress != null) {
    input.addAll({
      'shippingFirstName': shippingAddress.firstName,
      'shippingLastName': shippingAddress.lastName,
      'shippingEmail': shippingAddress.email ?? '',
      'shippingCompanyName': shippingAddress.companyName ?? '',
      'shippingAddress': shippingAddress.address,
      'shippingCity': shippingAddress.city,
      'shippingCountry': shippingAddress.country ?? '',
      'shippingState': shippingAddress.state ?? '',
      'shippingPostcode': shippingAddress.postcode ?? '',
      'shippingPhoneNumber': shippingAddress.phone ?? '',
    });
  }

  return input;
}

CheckoutAddress buildCheckoutAddressFromInput({
  required Map<String, dynamic> input,
  required String prefix,
}) {
  return CheckoutAddress(
    id: '',
    firstName: input['${prefix}FirstName']?.toString() ?? '',
    lastName: input['${prefix}LastName']?.toString() ?? '',
    email: input['${prefix}Email']?.toString(),
    companyName: input['${prefix}CompanyName']?.toString(),
    address: input['${prefix}Address']?.toString() ?? '',
    city: input['${prefix}City']?.toString() ?? '',
    state: input['${prefix}State']?.toString(),
    country: input['${prefix}Country']?.toString(),
    postcode: input['${prefix}Postcode']?.toString(),
    phone: input['${prefix}PhoneNumber']?.toString(),
  );
}
