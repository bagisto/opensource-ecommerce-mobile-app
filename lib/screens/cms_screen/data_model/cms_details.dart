/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cms_details.g.dart';

@JsonSerializable()
class CmsPage extends BaseModel {
  String? id;
  List<Translations>? translations;

  CmsPage({
    this.id,
    this.translations,
  });

  factory CmsPage.fromJson(Map<String, dynamic> json) =>
      _$CmsPageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CmsPageToJson(this);
}

@JsonSerializable()
class Translations {
  String? id;
  String? name;
  String? htmlContent;
  String? locale;

  Translations({
    this.id,
    this.name,
    this.htmlContent,
    this.locale,
  });

  factory Translations.fromJson(Map<String, dynamic> json) =>
      _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationsToJson(this);
}
