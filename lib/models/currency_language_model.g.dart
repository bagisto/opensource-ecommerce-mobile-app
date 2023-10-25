// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyLanguageList _$CurrencyLanguageListFromJson(
        Map<String, dynamic> json) =>
    CurrencyLanguageList(
      locales: (json['locales'] as List<dynamic>?)
          ?.map((e) => Locales.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultLocale: json['defaultLocale'] == null
          ? null
          : Locales.fromJson(json['defaultLocale'] as Map<String, dynamic>),
      currencies: (json['currencies'] as List<dynamic>?)
          ?.map((e) => Currencies.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseCurrency: json['baseCurrency'] == null
          ? null
          : Currencies.fromJson(json['baseCurrency'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$CurrencyLanguageListToJson(
        CurrencyLanguageList instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'locales': instance.locales,
      'defaultLocale': instance.defaultLocale,
      'currencies': instance.currencies,
      'baseCurrency': instance.baseCurrency,
    };

Locales _$LocalesFromJson(Map<String, dynamic> json) => Locales(
      id: json['id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      direction: json['direction'] as String?,
    );

Map<String, dynamic> _$LocalesToJson(Locales instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'direction': instance.direction,
    };

Currencies _$CurrenciesFromJson(Map<String, dynamic> json) => Currencies(
      id: json['id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      symbol: json['symbol'] as String?,
    );

Map<String, dynamic> _$CurrenciesToJson(Currencies instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'symbol': instance.symbol,
    };
