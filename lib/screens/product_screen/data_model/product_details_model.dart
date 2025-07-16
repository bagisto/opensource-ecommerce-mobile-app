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

import '../../../data_model/product_model/product_screen_model.dart';

part 'product_details_model.g.dart';

@JsonSerializable()
class Product {
  String? id;
  String? type;
  String? name;
  String? sku;
  // String? parentId;
  bool? isInWishlist;
  bool? isSaleable;
  PriceHtml? priceHtml;
  List<Images>? images;
  String? averageRating;
  String? urlKey;
  String? description;
  List<ProductCustomizableOptions>? customizableOptions;

  Product({
    this.id,
    this.type,
    this.sku,
    this.isInWishlist,
    this.isSaleable,
    this.priceHtml,
    this.images,
    this.averageRating,
    this.name,
    this.urlKey,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class PriceHtml {
  String? id;
  String? priceHtml;
  String? finalPrice;

  PriceHtml({
    this.id,
    this.priceHtml,
    this.finalPrice,
  });

  factory PriceHtml.fromJson(Map<String, dynamic> json) =>
      _$PriceHtmlFromJson(json);

  Map<String, dynamic> toJson() => _$PriceHtmlToJson(this);
}

@JsonSerializable()
class ProductCustomizableOptions {
  final int? id;

  ProductCustomizableOptions({this.id});

  factory ProductCustomizableOptions.fromJson(Map<String, dynamic> json) =>
      _$ProductCustomizableOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCustomizableOptionsToJson(this);
}
