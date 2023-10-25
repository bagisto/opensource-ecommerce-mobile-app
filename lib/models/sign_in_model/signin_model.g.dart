// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInModel _$SignInModelFromJson(Map<String, dynamic> json) => SignInModel(
      token: json['accessToken'] as String?,
      data: json['customer'] == null
          ? null
          : Data.fromJson(json['customer'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$SignInModelToJson(SignInModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'accessToken': instance.token,
      'customer': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      phone: json['phone'],
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'name': instance.name,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth,
      'phone': instance.phone,
      'group': instance.group,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
