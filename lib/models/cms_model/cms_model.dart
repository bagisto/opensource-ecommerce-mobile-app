/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
import '../../base_model/graphql_base_model.dart';

part 'cms_model.g.dart';

@JsonSerializable()
class CmsData extends GraphQlBaseModel{
  List<Data>? data;
  CmsData({this.data});

  factory CmsData.fromJson(Map<String, dynamic> json) =>
      _$CmsDataFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CmsDataToJson(this);
}


@JsonSerializable()
class Data {
  String? id;
  List<Translations>? translations;

  Data({this.id, this.translations});

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);
}
@JsonSerializable()
class Translations {
  String? id;
  String? urlKey;
  String? metaDescription;
  String? metaTitle;
  String? pageTitle;
  String? metaKeywords;
  String? htmlContent;
  String? locale;
  String? cmsPageId;

  Translations(
      {this.id,
        this.urlKey,
        this.metaDescription,
        this.metaTitle,
        this.pageTitle,
        this.metaKeywords,
        this.htmlContent,
        this.locale,
        this.cmsPageId});

  factory Translations.fromJson(Map<String, dynamic> json) =>
      _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TranslationsToJson(this);
}
