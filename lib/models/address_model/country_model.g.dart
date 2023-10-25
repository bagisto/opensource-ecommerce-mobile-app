// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountriesData _$CountriesDataFromJson(Map<String, dynamic> json) =>
    CountriesData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountriesDataToJson(CountriesData instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translations.fromJson(e as Map<String, dynamic>))
          .toList(),
      states: (json['states'] as List<dynamic>?)
          ?.map((e) => States.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'translations': instance.translations,
      'states': instance.states,
    };

Translations _$TranslationsFromJson(Map<String, dynamic> json) => Translations(
      id: json['id'] as String?,
      locale: json['locale'] as String?,
      name: json['name'] as String?,
      countryId: json['countryId'] as String?,
      defaultName: json['defaultName'] as String?,
      countryStateId: json['countryStateId'] as String?,
    );

Map<String, dynamic> _$TranslationsToJson(Translations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'locale': instance.locale,
      'name': instance.name,
      'countryId': instance.countryId,
      'defaultName': instance.defaultName,
      'countryStateId': instance.countryStateId,
    };

States _$StatesFromJson(Map<String, dynamic> json) => States(
      id: json['id'] as String?,
      countryCode: json['countryCode'] as String?,
      code: json['code'] as String?,
      defaultName: json['defaultName'] as String?,
      countryId: json['countryId'] as String?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translations.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatesToJson(States instance) => <String, dynamic>{
      'id': instance.id,
      'countryCode': instance.countryCode,
      'code': instance.code,
      'defaultName': instance.defaultName,
      'countryId': instance.countryId,
      'translations': instance.translations,
    };
