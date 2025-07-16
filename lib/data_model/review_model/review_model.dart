/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel extends BaseModel {
  PaginatorInfo? paginatorInfo;
  List<ReviewData>? data;

  ReviewModel({this.data, this.paginatorInfo});

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class PaginatorInfo {
  int? count;
  int? currentPage;
  int? lastPage;
  int? total;

  PaginatorInfo({this.count, this.currentPage, this.lastPage, this.total});
  factory PaginatorInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginatorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatorInfoToJson(this);
}

@JsonSerializable()
class ReviewData {
  String? id;
  String? title;
  int? rating;
  String? comment;
  String? status;
  String? createdAt;
  // String? updatedAt;
  String? productId;
  // String? customerId;
  // String? customerName;
  ProductData? product;
  Customer? customer;
  ReviewData(
      {this.id,
      this.title,
      this.rating,
      this.comment,
      // this.status,
      this.createdAt,
      // this.updatedAt,
      this.productId,
      // this.customerId,
      // this.customerName,
      this.product});

  factory ReviewData.fromJson(Map<String, dynamic> json) =>
      _$ReviewDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewDataToJson(this);
}

@JsonSerializable()
class Customer {
  String? id;
  // String? firstName;
  // String? lastName;
  String? name;
  // String? gender;
  // String? email;
  Customer({
    this.id,
    this.name,
  });
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class ProductData {
  String? id;
  // String? type;
  // var attributeFamilyId;
  // String? sku;
  String? urlKey;
  // String? createdAt;
  // String? updatedAt;
  List<ProductFlats>? productFlats;
  List<Images>? images;
  String? name;

  ProductData(
      {this.id, this.productFlats, this.urlKey, this.images, this.name});

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}

@JsonSerializable()
class Images {
  // String? path;
  String? url;

  Images({this.url});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class ProductFlats {
  String? id;
  String? sku;
  String? name;
  // String? description;
  // String? shortDescription;
  // String? urlKey;
  // bool? featured;
  // bool? status;
  // bool? visibleIndividually;
  // var price;
  // var cost;
  // var specialPrice;
  // var specialPriceFrom;
  // var specialPriceTo;
  // var weight;
  // int? color;
  // String? colorLabel;
  // int? size;
  // String? sizeLabel;
  String? locale;
  // String? channel;
  // String? productId;
  // var minPrice;
  // var maxPrice;
  // String? metaTitle;
  // String? metaKeywords;
  // String? metaDescription;
  // int? width;
  // String? createdAt;
  // String? updatedAt;

  ProductFlats({
    this.id,
    this.sku,
    this.name,
    this.locale,
  });

  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
      _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFlatsToJson(this);
}
