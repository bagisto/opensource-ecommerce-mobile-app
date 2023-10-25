// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartModel _$AddToCartModelFromJson(Map<String, dynamic> json) =>
    AddToCartModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..responseStatus = json['responseStatus'] as bool?;

Map<String, dynamic> _$AddToCartModelToJson(AddToCartModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'responseStatus': instance.responseStatus,
      'status': instance.status,
      'message': instance.message,
      'cart': instance.cart,
    };
