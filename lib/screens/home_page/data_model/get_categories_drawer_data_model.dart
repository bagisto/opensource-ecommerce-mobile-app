/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_categories_drawer_data_model.g.dart';

@HiveType(typeId: 9)
@JsonSerializable()
class GetDrawerCategoriesData extends HiveObject {
  String? success;
  bool? responseStatus;
  @HiveField(0)
  List<HomeCategories>? data;
  GetDrawerCategoriesData({this.data, this.success, this.responseStatus});

  factory GetDrawerCategoriesData.fromJson(Map<String, dynamic> json) =>
      _$GetDrawerCategoriesDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetDrawerCategoriesDataToJson(this);
}

@HiveType(typeId: 10)
@JsonSerializable()
class HomeCategories extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;

  @HiveField(4)
  String? slug;

  String? bannerUrl;
  String? logoUrl;
  List<Children>? children;

  HomeCategories({
    this.id,
    this.name,
    this.description,
    this.slug,
    this.bannerUrl,
    this.logoUrl,
    this.children,
  });

  factory HomeCategories.fromJson(Map<String, dynamic> json) =>
      _$HomeCategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCategoriesToJson(this);
}

// @JsonSerializable()
// class FilterableAttributes {
//   String? id;
//   String? adminName;
//   String? code;
//   String? type;
//   int? position;

//   FilterableAttributes(
//       {this.id, this.adminName, this.code, this.type, this.position});

//   factory FilterableAttributes.fromJson(Map<String, dynamic> json) =>
//       _$FilterableAttributesFromJson(json);

//   Map<String, dynamic> toJson() => _$FilterableAttributesToJson(this);
// }

// @JsonSerializable()
// class Translations {
//   String? id;
//   String? name;
//   String? description;
//   String? localeId;
//   String? locale;

//   Translations(
//       {this.id, this.name, this.description, this.localeId, this.locale});

//   factory Translations.fromJson(Map<String, dynamic> json) =>
//       _$TranslationsFromJson(json);

//   Map<String, dynamic> toJson() => _$TranslationsToJson(this);
// }

@JsonSerializable()
class Children {
  String? id;
  String? name;
  String? slug;
  String? bannerUrl;
  String? logoUrl;
  Children({
    this.id,
    this.name,
    this.slug,
    this.bannerUrl,
    this.logoUrl,
  });

  factory Children.fromJson(Map<String, dynamic> json) =>
      _$ChildrenFromJson(json);

  Map<String, dynamic> toJson() => _$ChildrenToJson(this);
}
