// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveOrderModel _$SaveOrderModelFromJson(Map<String, dynamic> json) =>
    SaveOrderModel(
      success: json['success'] as String?,
      redirectUrl: json['redirectUrl'] as String?,
      selectedMethod: json['selectedMethod'] as String?,
      order: json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>),
    )
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$SaveOrderModelToJson(SaveOrderModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'success': instance.success,
      'redirectUrl': instance.redirectUrl,
      'selectedMethod': instance.selectedMethod,
      'order': instance.order,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int?,
      customerEmail: json['customerEmail'] as String?,
      customerFirstName: json['customerFirstName'] as String?,
      customerLastName: json['customerLastName'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'customerEmail': instance.customerEmail,
      'customerFirstName': instance.customerFirstName,
      'customerLastName': instance.customerLastName,
    };
