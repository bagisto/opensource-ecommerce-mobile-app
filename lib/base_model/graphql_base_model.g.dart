// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphQlBaseModel _$GraphQlBaseModelFromJson(Map<String, dynamic> json) =>
    GraphQlBaseModel(
      success: json['success'] as String?,
      message: json['message'] as String?,
      cartCount: json['cartCount'] as int?,
      status: json['status'] as bool?,
    )..error = json['error'];

Map<String, dynamic> _$GraphQlBaseModelToJson(GraphQlBaseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
    };
