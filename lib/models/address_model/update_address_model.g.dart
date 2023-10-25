// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAddressModel _$UpdateAddressModelFromJson(Map<String, dynamic> json) =>
    UpdateAddressModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$UpdateAddressModelToJson(UpdateAddressModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      companyName: json['companyName'] as String?,
      vatId: json['vatId'] as String?,
      address1: (json['address1'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      country: json['country'] as String?,
      countryName: json['countryName'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      postcode: json['postcode'] as String?,
      phone: json['phone'] as String?,
      isDefault: json['isDefault'] as bool?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'companyName': instance.companyName,
      'vatId': instance.vatId,
      'address1': instance.address1,
      'country': instance.country,
      'countryName': instance.countryName,
      'state': instance.state,
      'city': instance.city,
      'postcode': instance.postcode,
      'phone': instance.phone,
      'isDefault': instance.isDefault,
    };
