
// ignore_for_file: overridden_fields

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
import 'package:json_annotation/json_annotation.dart';
import '../../../data_model/graphql_base_error_model.dart';


part 'add_review_model.g.dart';

@JsonSerializable()
class AddReviewModel extends GraphQlBaseErrorModel{
  @override
  String? success;
  Review? review;

  AddReviewModel({this.success, this.review});
  factory AddReviewModel.fromJson(Map<String, dynamic> json) => _$AddReviewModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddReviewModelToJson(this);
}

@JsonSerializable()
class Review {
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
  Product? product;

  Review({this.id, this.title, this.rating, this.comment, this.status, this.createdAt, this.updatedAt, this.productId, this.customerId, this.customerName, this.product});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class Product {
  String? id;
  String? type;
  var attributeFamilyId;
  String? sku;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  List<ProductFlats>? productFlats;

  Product({this.id, this.type, this.attributeFamilyId, this.sku, this.parentId, this.createdAt, this.updatedAt, this.productFlats});
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
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
  int? height;
  String? createdAt;
  String? updatedAt;

  ProductFlats({this.id, this.sku, this.name, this.description, this.shortDescription, this.urlKey, this.featured,
    this.status, this.visibleIndividually, this.price, this.color, this.colorLabel, this.size,
    this.sizeLabel, this.locale, this.channel, this.productId,  this.minPrice, this.maxPrice, this.metaTitle,
    this.metaKeywords, this.metaDescription, this.width, this.height,  this.createdAt, this.updatedAt});

  factory ProductFlats.fromJson(Map<String, dynamic> json) => _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFlatsToJson(this);
}



