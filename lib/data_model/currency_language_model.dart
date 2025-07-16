/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:json_annotation/json_annotation.dart';

part 'currency_language_model.g.dart';

@JsonSerializable()
class CurrencyLanguageList {
  List<Locales>? locales;
  List<Currencies>? currencies;
  Currencies? baseCurrency;
  String? id;
  // String? name;
  int? rootCategoryId;

  CurrencyLanguageList({
    this.locales,
    this.id,
    this.currencies,
    this.baseCurrency,
    this.rootCategoryId,
  });

  factory CurrencyLanguageList.fromJson(Map<String, dynamic> json) =>
      _$CurrencyLanguageListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CurrencyLanguageListToJson(this);
}

@JsonSerializable()
class Locales {
  String? id;
  String? name;
  String? code;

  Locales({
    this.id,
    this.name,
    this.code,
  });

  factory Locales.fromJson(Map<String, dynamic> json) =>
      _$LocalesFromJson(json);

  Map<String, dynamic> toJson() => _$LocalesToJson(this);
}

@JsonSerializable()
class Currencies {
  String? id;
  String? name;
  String? code;
  // String? symbol;
  Currencies({
    this.id,
    this.name,
    this.code,
  });

  factory Currencies.fromJson(Map<String, dynamic> json) =>
      _$CurrenciesFromJson(json);

  Map<String, dynamic> toJson() => _$CurrenciesToJson(this);
}

/*
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

*/
