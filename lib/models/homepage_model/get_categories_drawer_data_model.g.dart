// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_categories_drawer_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDrawerCategoriesData _$GetDrawerCategoriesDataFromJson(
        Map<String, dynamic> json) =>
    GetDrawerCategoriesData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => HomeCategories.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as String?
      ..responseStatus = json['responseStatus'] as bool?;

Map<String, dynamic> _$GetDrawerCategoriesDataToJson(
        GetDrawerCategoriesData instance) =>
    <String, dynamic>{
      'success': instance.success,
      'responseStatus': instance.responseStatus,
      'data': instance.data,
    };

HomeCategories _$HomeCategoriesFromJson(Map<String, dynamic> json) =>
    HomeCategories(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      categoryIconUrl: json['categoryIconUrl'] as String?,
      slug: json['slug'] as String?,
      urlPath: json['urlPath'] as String?,
      imageUrl: json['imageUrl'] as String?,
      metaTitle: json['metaTitle'] as String?,
      metaDescription: json['metaDescription'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      position: json['position'] as int?,
      status: json['status'] as bool?,
      productCount: json['productCount'] as int?,
      displayMode: json['displayMode'] as String?,
      parentId: json['parentId'] as String?,
      filterableAttributes: (json['filterableAttributes'] as List<dynamic>?)
          ?.map((e) => FilterableAttributes.fromJson(e as Map<String, dynamic>))
          .toList(),
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translations.fromJson(e as Map<String, dynamic>))
          .toList(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Children.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$HomeCategoriesToJson(HomeCategories instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryIconUrl': instance.categoryIconUrl,
      'slug': instance.slug,
      'urlPath': instance.urlPath,
      'imageUrl': instance.imageUrl,
      'metaTitle': instance.metaTitle,
      'metaDescription': instance.metaDescription,
      'metaKeywords': instance.metaKeywords,
      'position': instance.position,
      'status': instance.status,
      'productCount': instance.productCount,
      'displayMode': instance.displayMode,
      'parentId': instance.parentId,
      'filterableAttributes': instance.filterableAttributes,
      'translations': instance.translations,
      'children': instance.children,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

FilterableAttributes _$FilterableAttributesFromJson(
        Map<String, dynamic> json) =>
    FilterableAttributes(
      id: json['id'] as String?,
      adminName: json['adminName'] as String?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      position: json['position'] as int?,
    );

Map<String, dynamic> _$FilterableAttributesToJson(
        FilterableAttributes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adminName': instance.adminName,
      'code': instance.code,
      'type': instance.type,
      'position': instance.position,
    };

Translations _$TranslationsFromJson(Map<String, dynamic> json) => Translations(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      localeId: json['localeId'] as String?,
      locale: json['locale'] as String?,
    );

Map<String, dynamic> _$TranslationsToJson(Translations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'localeId': instance.localeId,
      'locale': instance.locale,
    };

Children _$ChildrenFromJson(Map<String, dynamic> json) => Children(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      imageUrl: json['imageUrl'] as String?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Children.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChildrenToJson(Children instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'slug': instance.slug,
      'imageUrl': instance.imageUrl,
      'children': instance.children,
    };
