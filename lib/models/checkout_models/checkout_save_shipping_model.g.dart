// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_save_shipping_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethods _$PaymentMethodsFromJson(Map<String, dynamic> json) =>
    PaymentMethods(
      success: json['success'] as String?,
      cartTotal: json['cartTotal'] as String?,
      cartCount: json['cartCount'] as int?,
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => PaymentMethodsList.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..responseStatus = json['responseStatus'] as bool?
      ..cart = json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>);

Map<String, dynamic> _$PaymentMethodsToJson(PaymentMethods instance) =>
    <String, dynamic>{
      'responseStatus': instance.responseStatus,
      'success': instance.success,
      'cartTotal': instance.cartTotal,
      'cartCount': instance.cartCount,
      'paymentMethods': instance.paymentMethods,
      'cart': instance.cart,
    };

PaymentMethodsList _$PaymentMethodsListFromJson(Map<String, dynamic> json) =>
    PaymentMethodsList(
      method: json['method'] as String?,
      methodTitle: json['methodTitle'] as String?,
      description: json['description'] as String?,
      sort: json['sort'] as int?,
    );

Map<String, dynamic> _$PaymentMethodsListToJson(PaymentMethodsList instance) =>
    <String, dynamic>{
      'method': instance.method,
      'methodTitle': instance.methodTitle,
      'description': instance.description,
      'sort': instance.sort,
    };
