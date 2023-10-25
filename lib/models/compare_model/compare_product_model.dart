
// ignore_for_file: prefer_typing_uninitialized_variables

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:json_annotation/json_annotation.dart';

import '../cart_model/cart_data_model.dart';
import '../product_model/product_screen_model.dart';

part 'compare_product_model.g.dart';

@JsonSerializable()
class CompareProductsData {
  List<CompareProducts>? data;

  CompareProductsData({this.data});

  factory CompareProductsData.fromJson(Map<String, dynamic> json){
    return _$CompareProductsDataFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$CompareProductsDataToJson(this);

}

// class Data {
//   List<CompareProducts>? compareProducts;
//
//   Data({this.compareProducts});
//
// }

@JsonSerializable()
class CompareProducts {
  String? id;
  String? productFlatId;
  String? customerId;
  String? createdAt;
  String? updatedAt;
  ProductFlat? productFlat;
  CartModel? cart;

  CompareProducts({this.id, this.productFlatId, this.customerId, this.createdAt, this.updatedAt, this.productFlat,this.cart});

  factory CompareProducts.fromJson(Map<String, dynamic> json){
    return _$CompareProductsFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$CompareProductsToJson(this);
}

@JsonSerializable()
class ProductFlat {
  Product? product;
  String? id;
  String? sku;
  String? name;
  String? description;
  String? shortDescription;
  String? urlKey;
  @JsonKey(name:"new")
  bool? newProduct;
  bool? featured;
  bool? status;
  bool? visibleIndividually;
  String? thumbnail;
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
  String? parentId;
var minPrice;
  var maxPrice;
  String? metaTitle;
  String? metaKeywords;
  String? metaDescription;
  var width;
  var height;
  String? depth;
  String? createdAt;
  String? updatedAt;

  ProductFlat({this.product,this.id, this.sku, this.name, this.description, this.shortDescription, this.urlKey, this.newProduct, this.featured, this.status, this.visibleIndividually, this.thumbnail, this.price, this.cost, this.specialPrice, this.specialPriceFrom, this.specialPriceTo, this.weight, this.color, this.colorLabel, this.size, this.sizeLabel, this.locale, this.channel, this.productId, this.parentId, this.minPrice, this.maxPrice, this.metaTitle, this.metaKeywords, this.metaDescription, this.width, this.height, this.depth, this.createdAt, this.updatedAt});


  factory ProductFlat.fromJson(Map<String, dynamic> json){
    return _$ProductFlatFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$ProductFlatToJson(this);
}
