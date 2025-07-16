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

import '../../../data_model/graphql_base_model.dart';

part 'cms_model.g.dart';

@JsonSerializable()
class CmsData extends BaseModel {
  List<Data>? data;

  CmsData({
    this.data,
  });

  factory CmsData.fromJson(Map<String, dynamic> json) =>
      _$CmsDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CmsDataToJson(this);
}

@JsonSerializable()
class Data {
  String? id;

  List<Translations>? translations;

  Data({
    this.id,
    this.translations,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Translations {
  String? id;
  String? pageTitle;
  String? name;
  String? locale;
  String? urlKey;

  Translations({
    this.id,
    this.locale,
    this.name,
    this.pageTitle,
    this.urlKey
  });

  factory Translations.fromJson(Map<String, dynamic> json) =>
      _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationsToJson(this);
}
