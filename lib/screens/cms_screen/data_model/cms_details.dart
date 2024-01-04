/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cms_details.g.dart';


@JsonSerializable()
class CmsPage extends GraphQlBaseModel{
  String? id;
  dynamic layout;
  String? createdAt;
  String? updatedAt;
  List<Translations>? translations;
  List<dynamic>? channels;

  CmsPage({this.id, this.translations, this.channels, this.createdAt, this.layout, this.updatedAt});

  factory CmsPage.fromJson(Map<String, dynamic> json) =>
      _$CmsPageFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CmsPageToJson(this);
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
  String? name;
  String? description;
  String? localeId;

  Translations(
      {this.id,
        this.urlKey,
        this.metaDescription,
        this.metaTitle,
        this.pageTitle,
        this.metaKeywords,
        this.htmlContent,
        this.locale,
        this.cmsPageId, this.name, this.description, this.localeId});

  factory Translations.fromJson(Map<String, dynamic> json) =>
      _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TranslationsToJson(this);
}
