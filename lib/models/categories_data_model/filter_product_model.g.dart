// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFilterAttribute _$GetFilterAttributeFromJson(Map<String, dynamic> json) =>
    GetFilterAttribute(
      minPrice: json['minPrice'] as int?,
      maxPrice: json['maxPrice'] as int?,
      filterAttributes: (json['filterAttributes'] as List<dynamic>?)
          ?.map((e) => FilterAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrders: (json['sortOrders'] as List<dynamic>?)
          ?.map((e) => SortOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$GetFilterAttributeToJson(GetFilterAttribute instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'filterAttributes': instance.filterAttributes,
      'sortOrders': instance.sortOrders,
    };

FilterAttribute _$FilterAttributeFromJson(Map<String, dynamic> json) =>
    FilterAttribute(
      id: json['id'] as String?,
      code: json['code'] as String?,
      adminName: json['adminName'] as String?,
      type: json['type'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilterAttributeToJson(FilterAttribute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'adminName': instance.adminName,
      'type': instance.type,
      'options': instance.options,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      id: json['id'] as String?,
      adminName: json['adminName'] as String?,
      swatchValue: json['swatchValue'] as String?,
      sortOrder: json['sortOrder'] as int?,
      isNew: json['isNew'] as bool?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': instance.id,
      'adminName': instance.adminName,
      'swatchValue': instance.swatchValue,
      'sortOrder': instance.sortOrder,
      'isNew': instance.isNew,
      'translations': instance.translations,
    };

Translation _$TranslationFromJson(Map<String, dynamic> json) => Translation(
      label: json['label'] as String?,
      locale: json['locale'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TranslationToJson(Translation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'locale': instance.locale,
    };

SortOrder _$SortOrderFromJson(Map<String, dynamic> json) => SortOrder(
      key: json['key'] as String?,
      label: json['label'] as String?,
      value: json['value'] == null
          ? null
          : Value.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SortOrderToJson(SortOrder instance) => <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'value': instance.value,
    };

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      sort: json['sort'] as String?,
      order: json['order'] as String?,
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'sort': instance.sort,
      'order': instance.order,
    };
