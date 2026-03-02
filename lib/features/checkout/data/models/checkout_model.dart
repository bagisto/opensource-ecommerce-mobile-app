// Checkout models matching the real Bagisto Headless Commerce GraphQL schema.

// ─── Country & State (from countries / countryStates queries) ──────────────

/// A country from the Bagisto `countries` query.
class BagistoCountry {
  final String id;
  final int numericId;
  final String code;
  final String name;

  const BagistoCountry({
    required this.id,
    required this.numericId,
    required this.code,
    required this.name,
  });

  factory BagistoCountry.fromJson(Map<String, dynamic> json) {
    return BagistoCountry(
      id: json['id']?.toString() ?? '',
      numericId: (json['_id'] as int?) ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BagistoCountry &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'BagistoCountry($code, $name)';
}

/// A state/province from the Bagisto `countryStates` query.
class BagistoCountryState {
  final String id;
  final int numericId;
  final String? code;
  final String defaultName;
  final int countryId;
  final String countryCode;

  const BagistoCountryState({
    required this.id,
    required this.numericId,
    this.code,
    required this.defaultName,
    required this.countryId,
    required this.countryCode,
  });

  factory BagistoCountryState.fromJson(Map<String, dynamic> json) {
    return BagistoCountryState(
      id: json['id']?.toString() ?? '',
      numericId: _parseInt(json['_id']),
      code: json['code'] as String?,
      defaultName: json['defaultName'] as String? ?? '',
      countryId: _parseInt(json['countryId']),
      countryCode: json['countryCode'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BagistoCountryState &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          countryCode == other.countryCode;

  @override
  int get hashCode => Object.hash(code, countryCode);

  @override
  String toString() => 'BagistoCountryState($code, $defaultName)';
}

// ─── Checkout Address (from collectionGetCheckoutAddresses) ────────────────

class CheckoutAddress {
  final String id;
  final String addressType;
  final String firstName;
  final String lastName;
  final String? companyName;
  final String address;
  final String city;
  final String? state;
  final String? country;
  final String? postcode;
  final String? email;
  final String? phone;
  final bool defaultAddress;
  final bool useForShipping;

  const CheckoutAddress({
    required this.id,
    this.addressType = '',
    this.firstName = '',
    this.lastName = '',
    this.companyName,
    this.address = '',
    this.city = '',
    this.state,
    this.country,
    this.postcode,
    this.email,
    this.phone,
    this.defaultAddress = false,
    this.useForShipping = false,
  });

  factory CheckoutAddress.fromJson(Map<String, dynamic> json) {
    return CheckoutAddress(
      id: json['id']?.toString() ?? '',
      addressType: json['addressType'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      companyName: json['companyName'] as String?,
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String?,
      country: json['country'] as String?,
      postcode: json['postcode'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      defaultAddress: json['defaultAddress'] as bool? ?? false,
      useForShipping: json['useForShipping'] as bool? ?? false,
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  String get displayName {
    if (companyName != null && companyName!.isNotEmpty) {
      return '$fullName ($companyName)';
    }
    return fullName;
  }

  String get fullAddress {
    final parts = <String>[];
    if (address.isNotEmpty) parts.add(address);
    if (city.isNotEmpty) parts.add(city);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    if (postcode != null && postcode!.isNotEmpty) parts.add(postcode!);
    return parts.join(', ');
  }

  /// Build the input map for createCheckoutAddress mutation
  Map<String, dynamic> toBillingInput({bool useForShipping = true}) {
    return {
      'billingFirstName': firstName,
      'billingLastName': lastName,
      'billingEmail': email ?? '',
      'billingCompanyName': companyName ?? '',
      'billingAddress': address,
      'billingCity': city,
      'billingCountry': country ?? '',
      'billingState': state ?? '',
      'billingPostcode': postcode ?? '',
      'billingPhoneNumber': phone ?? '',
      'useForShipping': useForShipping,
    };
  }
}

// ─── Shipping Rate (from collectionShippingRates) ──────────────────────────

class ShippingRate {
  final String id;
  final String code;
  final String label;
  final String? description;
  final String method;
  final String? methodTitle;
  final double price;
  final String? formattedPrice;
  final double basePrice;
  final String? baseFormattedPrice;
  final String? carrier;
  final String? carrierTitle;

  const ShippingRate({
    required this.id,
    required this.code,
    this.label = '',
    this.description,
    this.method = '',
    this.methodTitle,
    this.price = 0,
    this.formattedPrice,
    this.basePrice = 0,
    this.baseFormattedPrice,
    this.carrier,
    this.carrierTitle,
  });

  factory ShippingRate.fromJson(Map<String, dynamic> json) {
    return ShippingRate(
      id: json['id']?.toString() ?? '',
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String?,
      method: json['method'] as String? ?? '',
      methodTitle: json['methodTitle'] as String?,
      price: _parseDouble(json['price']),
      formattedPrice: json['formattedPrice'] as String?,
      basePrice: _parseDouble(json['basePrice']),
      baseFormattedPrice: json['baseFormattedPrice'] as String?,
      carrier: json['carrier'] as String?,
      carrierTitle: json['carrierTitle'] as String?,
    );
  }

  String get displayPrice => formattedPrice ?? '\$${price.toStringAsFixed(2)}';
  String get displayLabel => label.isNotEmpty ? label : (methodTitle ?? method);
}

// ─── Payment Method (from collectionPaymentMethods) ────────────────────────

class PaymentMethod {
  final String id;
  final String method;
  final String title;
  final String? description;
  final String? icon;
  final bool isAllowed;

  const PaymentMethod({
    required this.id,
    required this.method,
    this.title = '',
    this.description,
    this.icon,
    this.isAllowed = true,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id']?.toString() ?? '',
      method: json['method'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      isAllowed: json['isAllowed'] as bool? ?? true,
    );
  }
}

// ─── Mutation Response Models ──────────────────────────────────────────────

/// Response from createCheckoutAddress
class CheckoutAddressResponse {
  final bool success;
  final String? message;
  final String? id;
  final String? cartToken;

  const CheckoutAddressResponse({
    this.success = false,
    this.message,
    this.id,
    this.cartToken,
  });

  factory CheckoutAddressResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutAddressResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      id: json['id']?.toString(),
      cartToken: json['cartToken'] as String?,
    );
  }
}

/// Response from createCheckoutShippingMethod
class CheckoutShippingMethodResponse {
  final bool success;
  final String? id;
  final String? message;

  const CheckoutShippingMethodResponse({
    this.success = false,
    this.id,
    this.message,
  });

  factory CheckoutShippingMethodResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutShippingMethodResponse(
      success: json['success'] as bool? ?? false,
      id: json['id']?.toString(),
      message: json['message'] as String?,
    );
  }
}

/// Response from createCheckoutPaymentMethod
class CheckoutPaymentMethodResponse {
  final bool success;
  final String? message;
  final String? paymentGatewayUrl;
  final String? paymentData;

  const CheckoutPaymentMethodResponse({
    this.success = false,
    this.message,
    this.paymentGatewayUrl,
    this.paymentData,
  });

  factory CheckoutPaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentMethodResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      paymentGatewayUrl: json['paymentGatewayUrl'] as String?,
      paymentData: json['paymentData'] as String?,
    );
  }
}

/// Response from createCheckoutOrder
class CheckoutOrderResponse {
  final String? id;
  final String? orderId;
  final String? orderIncrementId;
  final bool success;
  final String? message;

  const CheckoutOrderResponse({
    this.id,
    this.orderId,
    this.orderIncrementId,
    this.success = false,
    this.message,
  });

  factory CheckoutOrderResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutOrderResponse(
      id: json['id']?.toString(),
      orderId: json['orderId']?.toString(),
      orderIncrementId: json['orderIncrementId']?.toString(),
      success: json['success'] as bool? ?? (json['orderId'] != null),
      message: json['message'] as String?,
    );
  }
}

/// Response from createApplyCoupon / createRemoveCoupon
class CouponResponse {
  final bool success;
  final String? message;
  final String? couponCode;
  final double discountAmount;
  final String? formattedDiscountAmount;
  final double grandTotal;
  final String? formattedGrandTotal;
  final double subtotal;
  final String? formattedSubtotal;
  final double taxAmount;
  final String? formattedTaxAmount;
  final double shippingAmount;
  final String? formattedShippingAmount;

  const CouponResponse({
    this.success = false,
    this.message,
    this.couponCode,
    this.discountAmount = 0,
    this.formattedDiscountAmount,
    this.grandTotal = 0,
    this.formattedGrandTotal,
    this.subtotal = 0,
    this.formattedSubtotal,
    this.taxAmount = 0,
    this.formattedTaxAmount,
    this.shippingAmount = 0,
    this.formattedShippingAmount,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      couponCode: json['couponCode'] as String?,
      discountAmount: _parseDouble(json['discountAmount']),
      formattedDiscountAmount: json['formattedDiscountAmount'] as String?,
      grandTotal: _parseDouble(json['grandTotal']),
      formattedGrandTotal: json['formattedGrandTotal'] as String?,
      subtotal: _parseDouble(json['subtotal']),
      formattedSubtotal: json['formattedSubtotal'] as String?,
      taxAmount: _parseDouble(json['taxAmount']),
      formattedTaxAmount: json['formattedTaxAmount'] as String?,
      shippingAmount: _parseDouble(json['shippingAmount']),
      formattedShippingAmount: json['formattedShippingAmount'] as String?,
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

double _parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
