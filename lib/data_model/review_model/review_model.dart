/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:bagisto_app_demo/data_model/categories_data_model/categories_product_model.dart';
import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel extends GraphQlBaseModel {
  PaginatorInfo? paginatorInfo;
  List<ReviewData>? data;

  ReviewModel({this.data, this.paginatorInfo});

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class ReviewData {
  String? id;
  String? title;
  int? rating;
  String? comment;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? productId;
  String? customerId;
  String? customerName;
  ProductData? product;

  ReviewData(
      {this.id,
      this.title,
      this.rating,
      this.comment,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.customerId,
      this.customerName,
      this.product});

  factory ReviewData.fromJson(Map<String, dynamic> json) =>
      _$ReviewDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewDataToJson(this);
}

@JsonSerializable()
class ProductData {
  String? id;
  String? type;
  var attributeFamilyId;
  String? sku;
  String? urlKey;
  String? createdAt;
  String? updatedAt;
  List<ProductFlats>? productFlats;
  List<Images>? images;

  ProductData(
      {this.id,
      this.type,
      this.attributeFamilyId,
      this.sku,
      this.createdAt,
      this.updatedAt,
      this.productFlats, this.urlKey, this.images});

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}

@JsonSerializable()
class Images {
  String? path;
  String? url;

  Images({this.url, this.path});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class ProductFlats {
  String? id;
  String? sku;
  String? name;
  String? description;
  String? shortDescription;
  String? urlKey;
  bool? featured;
  bool? status;
  bool? visibleIndividually;
  var price;
  var cost;
  var specialPrice;
  var specialPriceFrom;
  var specialPriceTo;
  var weight;
  int? color;
  String? colorLabel;
  int? size;
  String? sizeLabel;
  String? locale;
  String? channel;
  String? productId;
  var minPrice;
  var maxPrice;
  String? metaTitle;
  String? metaKeywords;
  String? metaDescription;
  int? width;
  String? createdAt;
  String? updatedAt;

  ProductFlats(
      {this.id,
      this.sku,
      this.name,
      this.description,
      this.shortDescription,
      this.urlKey,
      this.featured,
      this.status,
      this.visibleIndividually,
      this.price,
      this.cost,
      this.specialPrice,
      this.specialPriceFrom,
      this.specialPriceTo,
      this.weight,
      this.color,
      this.colorLabel,
      this.size,
      this.sizeLabel,
      this.locale,
      this.channel,
      this.productId,
      this.minPrice,
      this.maxPrice,
      this.metaTitle,
      this.metaKeywords,
      this.metaDescription,
      this.width,
      this.createdAt,
      this.updatedAt});

  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
      _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFlatsToJson(this);
}
