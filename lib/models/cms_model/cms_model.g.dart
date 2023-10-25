// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cms_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CmsData _$CmsDataFromJson(Map<String, dynamic> json) => CmsData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$CmsDataToJson(CmsData instance) => <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translations.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'translations': instance.translations,
    };

Translations _$TranslationsFromJson(Map<String, dynamic> json) => Translations(
      id: json['id'] as String?,
      urlKey: json['urlKey'] as String?,
      metaDescription: json['metaDescription'] as String?,
      metaTitle: json['metaTitle'] as String?,
      pageTitle: json['pageTitle'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      htmlContent: json['htmlContent'] as String?,
      locale: json['locale'] as String?,
      cmsPageId: json['cmsPageId'] as String?,
    );

Map<String, dynamic> _$TranslationsToJson(Translations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'urlKey': instance.urlKey,
      'metaDescription': instance.metaDescription,
      'metaTitle': instance.metaTitle,
      'pageTitle': instance.pageTitle,
      'metaKeywords': instance.metaKeywords,
      'htmlContent': instance.htmlContent,
      'locale': instance.locale,
      'cmsPageId': instance.cmsPageId,
    };
