// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavePaymentModel _$SavePaymentModelFromJson(Map<String, dynamic> json) =>
    SavePaymentModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SavePaymentModelToJson(SavePaymentModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      savePayment: json['savePayment'] == null
          ? null
          : SavePayment.fromJson(json['savePayment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'savePayment': instance.savePayment,
    };

SavePayment _$SavePaymentFromJson(Map<String, dynamic> json) => SavePayment(
      success: json['success'] as String?,
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
      jumpToSection: json['jumpToSection'] as String?,
    );

Map<String, dynamic> _$SavePaymentToJson(SavePayment instance) =>
    <String, dynamic>{
      'success': instance.success,
      'jumpToSection': instance.jumpToSection,
      'cart': instance.cart,
    };
