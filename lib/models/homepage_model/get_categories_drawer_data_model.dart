
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/base_model/graphql_base_error_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_categories_drawer_data_model.g.dart';

@JsonSerializable()
class GetDrawerCategoriesData extends GraphQlBaseErrorModel{
  List<HomeCategories>? data;
// Data? data;
  GetDrawerCategoriesData({this.data});

  factory GetDrawerCategoriesData.fromJson(Map<String, dynamic> json) =>
      _$GetDrawerCategoriesDataFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$GetDrawerCategoriesDataToJson(this);
}

// @JsonSerializable()
// class Data {
//   List<HomeCategories>? homeCategories;
//
//   Data({this.homeCategories});
//
//   factory Data.fromJson(Map<String, dynamic> json) =>
//       _$DataFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() =>
//       _$DataToJson(this);
//
// }

@JsonSerializable()
class HomeCategories {
  String? id;
  String? name;
  String? description;
  String? categoryIconUrl;
  String? slug;
  String? urlPath;
  String? imageUrl;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  int? position;
  bool? status;
  int? productCount;
  String? displayMode;
  String? parentId;
  List<FilterableAttributes>? filterableAttributes;
  List<Translations>? translations;
  List<Children>? children;
  String? createdAt;
  String? updatedAt;

  HomeCategories(
      {this.id,
        this.name,
        this.description,
        this.categoryIconUrl,
        this.slug,
        this.urlPath,
        this.imageUrl,
        this.metaTitle,
        this.metaDescription,
        this.metaKeywords,
        this.position,
        this.status,
        this.productCount,
        this.displayMode,
        this.parentId,
        this.filterableAttributes,
        this.translations,
        this.children,
        this.createdAt,
        this.updatedAt});


  factory HomeCategories.fromJson(Map<String, dynamic> json) =>
      _$HomeCategoriesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HomeCategoriesToJson(this);


}

@JsonSerializable()
class FilterableAttributes {
  String? id;
  String? adminName;
  String? code;
  String? type;
  int? position;

  FilterableAttributes(
      {this.id, this.adminName, this.code, this.type, this.position});


  factory FilterableAttributes.fromJson(Map<String, dynamic> json) =>
      _$FilterableAttributesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FilterableAttributesToJson(this);
}

@JsonSerializable()
class Translations {
  String? id;
  String? name;
  String? description;
  String? localeId;
  String? locale;

  Translations(
      {this.id, this.name, this.description, this.localeId, this.locale});


  factory Translations.fromJson(Map<String, dynamic> json) =>
      _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TranslationsToJson(this);
}

@JsonSerializable()
class Children {
  String? id;
  String? name;
  String? description;
  String? slug;
  String? imageUrl;
  List<Children>? children;

  Children({this.id, this.name, this.description, this.slug,this.imageUrl, this.children});

  factory Children.fromJson(Map<String, dynamic> json) =>
      _$ChildrenFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChildrenToJson(this);
}
