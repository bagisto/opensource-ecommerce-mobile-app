// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfoDetails _$AccountInfoDetailsFromJson(Map<String, dynamic> json) =>
    AccountInfoDetails(
      data: json['customer'] == null
          ? null
          : Data.fromJson(json['customer'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$AccountInfoDetailsToJson(AccountInfoDetails instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'customer': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      imageUrl: json['imageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as bool?,
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'gender': instance.gender,
      'imageUrl': instance.imageUrl,
      'dateOfBirth': instance.dateOfBirth,
      'phone': instance.phone,
      'status': instance.status,
      'group': instance.group,
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };