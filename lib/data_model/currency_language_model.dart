

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:json_annotation/json_annotation.dart';

import '../screens/cms_screen/data_model/cms_model.dart';
import 'graphql_base_model.dart';
part 'currency_language_model.g.dart';

@JsonSerializable()
class CurrencyLanguageList extends GraphQlBaseModel {
  List<Locales>? locales;
  Locales? defaultLocale;
  List<Currencies>? currencies;
  Currencies? baseCurrency;
  String? id;
  String? code;
  String? name;
  String? description;
  String? theme;
  String? hostname;
  int? defaultLocaleId;
  int? baseCurrencyId;
  int? rootCategoryId;
  List<InventorySources>? inventorySources;
  RootCategory? rootCategory;
  String? logoUrl;
  String? faviconUrl;
  dynamic maintenanceModeText;
  String? allowedIps;
  bool? isMaintenanceOn;

  CurrencyLanguageList(
      {this.locales,
        this.defaultLocale,
        this.currencies,
        this.baseCurrency,
        this.description, this.name, this.id, this.code, this.theme, this.baseCurrencyId,
        this.defaultLocaleId, this.faviconUrl, this.hostname, this.inventorySources, this.logoUrl,
        this.rootCategory, this.rootCategoryId, this.allowedIps, this.isMaintenanceOn, this.maintenanceModeText
      });

  factory CurrencyLanguageList.fromJson(Map<String, dynamic> json) =>
      _$CurrencyLanguageListFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CurrencyLanguageListToJson(this);
}
@JsonSerializable()
class Locales {
  String? id;
  String? name;
  String? code;
  String? direction;
  String? createdAt;
  String? updatedAt;


  Locales(
      {this.id,
        this.name,
        this.code,
        this.direction,
        this.updatedAt, this.createdAt
       });

  factory Locales.fromJson(Map<String, dynamic> json) =>
      _$LocalesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LocalesToJson(this);
}
@JsonSerializable()
class Currencies {
  String? id;
  String? name;
  String? code;
  String? symbol;
  String? createdAt;
  String? updatedAt;
  dynamic exchangeRate;


  Currencies(
      {this.id,
        this.name,
        this.code,
        this.symbol,
        this.updatedAt, this.createdAt, this.exchangeRate
       });

  factory Currencies.fromJson(Map<String, dynamic> json) =>
      _$CurrenciesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CurrenciesToJson(this);
}

@JsonSerializable()
class RootCategory {
  String? id;
  String? name;
  String? description;
  String? slug;
  String? urlPath;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  dynamic position;
  bool? status;
  String? displayMode;
  String? parentId;
  List<dynamic>? filterableAttributes;
  List<Translations>? translations;
  dynamic categoryId;
  dynamic logoPath;
  dynamic logoUrl;
  int? lft;
  int? rgt;
  dynamic additional;
  dynamic bannerPath;
  dynamic bannerUrl;
  dynamic localeId;
  String? createdAt;
  String? updatedAt;

  RootCategory(
      {this.id,
        this.name,
        this.description,
        this.slug,
        this.urlPath,
        this.metaTitle,
        this.metaDescription,
        this.metaKeywords,
        this.position,
        this.status,
        this.displayMode,
        this.parentId,
        this.filterableAttributes,
        this.translations, this.createdAt, this.updatedAt, this.categoryId, this.logoUrl,
      this.bannerUrl, this.logoPath, this.bannerPath, this.localeId, this.additional, this.lft, this.rgt});

  factory RootCategory.fromJson(Map<String, dynamic> json) =>
      _$RootCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$RootCategoryToJson(this);
}

@JsonSerializable()
class InventorySources {
  String? id;
  String? code;
  String? name;
  String? description;
  String? contactName;
  String? contactEmail;
  String? contactNumber;
  dynamic contactFax;
  String? country;
  String? state;
  String? city;
  String? street;
  String? postcode;
  int? priority;
  dynamic latitude;
  dynamic longitude;
  bool? status;
  String? success;

  InventorySources({this.id,
    this.code,
    this.name,
    this.description,
    this.contactName,
    this.contactEmail,
    this.contactNumber,
    this.contactFax,
    this.country,
    this.state,
    this.city,
    this.street,
    this.postcode,
    this.priority,
    this.latitude,
    this.longitude,
    this.status,
    this.success});

  factory InventorySources.fromJson(Map<String, dynamic> json) =>
      _$InventorySourcesFromJson(json);

  Map<String, dynamic> toJson() => _$InventorySourcesToJson(this);
}

