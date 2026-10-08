/// Phone number rule used by the Bagisto storefront (`PhoneNumber` rule):
/// digits only, with an optional leading `+`. No fixed length.
final RegExp _phonePattern = RegExp(r'^\+?\d+$');

/// Whether [value] is a phone number the storefront accepts.
bool isValidPhoneNumber(String value) => _phonePattern.hasMatch(value.trim());
