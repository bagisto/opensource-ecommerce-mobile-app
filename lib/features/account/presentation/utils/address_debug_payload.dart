import '../../data/models/account_models.dart';

Map<String, dynamic> buildEditAddressDebugPayload(CustomerAddress address) {
  return {
    'addressId': address.numericId,
    'id': address.id,
    'firstName': address.firstName,
    'lastName': address.lastName,
    'email': address.email,
    'companyName': address.companyName,
    'vatId': address.vatId,
    'address': address.address,
    'city': address.city,
    'state': address.state,
    'country': address.country,
    'postcode': address.zipCode,
    'phone': address.phone,
    'defaultAddress': address.isDefault,
    'useForShipping': address.useForShipping,
    'addressType': address.addressType,
    'createdAt': address.createdAt,
  };
}
