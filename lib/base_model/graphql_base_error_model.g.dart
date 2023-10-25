// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_base_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphQlBaseErrorModel _$GraphQlBaseErrorModelFromJson(
        Map<String, dynamic> json) =>
    GraphQlBaseErrorModel(
      success: json['success'] as String?,
      responseStatus: json['responseStatus'] as bool?,
    );

Map<String, dynamic> _$GraphQlBaseErrorModelToJson(
        GraphQlBaseErrorModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'responseStatus': instance.responseStatus,
    };
