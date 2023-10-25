// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_save_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckOutSaveAddressDataModel _$CheckOutSaveAddressDataModelFromJson(
        Map<String, dynamic> json) =>
    CheckOutSaveAddressDataModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$CheckOutSaveAddressDataModelToJson(
        CheckOutSaveAddressDataModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      saveCheckoutAddresses: json['saveCheckoutAddresses'] == null
          ? null
          : SaveCheckoutAddresses.fromJson(
              json['saveCheckoutAddresses'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'saveCheckoutAddresses': instance.saveCheckoutAddresses,
    };

SaveCheckoutAddresses _$SaveCheckoutAddressesFromJson(
        Map<String, dynamic> json) =>
    SaveCheckoutAddresses(
      success: json['success'] as String?,
      cartTotal: json['cartTotal'] as String?,
      cartCount: json['cartCount'] as int?,
      shippingMethods: (json['shippingMethods'] as List<dynamic>?)
          ?.map((e) => ShippingMethods.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: json['paymentMethods'] == null
          ? null
          : Payment.fromJson(json['paymentMethods'] as Map<String, dynamic>),
      jumpToSection: json['jumpToSection'] as String?,
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
    )..responseStatus = json['responseStatus'] as bool?;

Map<String, dynamic> _$SaveCheckoutAddressesToJson(
        SaveCheckoutAddresses instance) =>
    <String, dynamic>{
      'responseStatus': instance.responseStatus,
      'success': instance.success,
      'cartTotal': instance.cartTotal,
      'cartCount': instance.cartCount,
      'shippingMethods': instance.shippingMethods,
      'paymentMethods': instance.paymentMethods,
      'jumpToSection': instance.jumpToSection,
      'cart': instance.cart,
    };

ShippingMethods _$ShippingMethodsFromJson(Map<String, dynamic> json) =>
    ShippingMethods(
      title: json['title'] as String?,
      methods: json['methods'] == null
          ? null
          : Methods.fromJson(json['methods'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShippingMethodsToJson(ShippingMethods instance) =>
    <String, dynamic>{
      'title': instance.title,
      'methods': instance.methods,
    };

Methods _$MethodsFromJson(Map<String, dynamic> json) => Methods(
      code: json['code'] as String?,
      label: json['label'] as String?,
      price: json['price'] as int?,
      formattedPrice: json['formattedPrice'] as String?,
      basePrice: json['basePrice'] as int?,
      formattedBasePrice: json['formattedBasePrice'] as String?,
    );

Map<String, dynamic> _$MethodsToJson(Methods instance) => <String, dynamic>{
      'code': instance.code,
      'label': instance.label,
      'price': instance.price,
      'formattedPrice': instance.formattedPrice,
      'basePrice': instance.basePrice,
      'formattedBasePrice': instance.formattedBasePrice,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as int?,
      method: json['method'] as String?,
      methodTitle: json['methodTitle'] as String?,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'methodTitle': instance.methodTitle,
    };
