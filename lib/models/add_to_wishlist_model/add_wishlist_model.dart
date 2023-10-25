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

import 'package:bagisto_app_demo/base_model/graphql_base_error_model.dart';
import 'package:json_annotation/json_annotation.dart';


part 'add_wishlist_model.g.dart';

@JsonSerializable()

class AddWishListModel extends GraphQlBaseErrorModel{
  Data? data;
  String? message;

  AddWishListModel({this.data, this.message});
  factory AddWishListModel.fromJson(Map<String, dynamic> json) {
    return _$AddWishListModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$AddWishListModelToJson(this);
}
@JsonSerializable()
class Data {
  int? id;
  Product? product;


  Data({this.id, this.product});

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
@JsonSerializable()
class Product {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? urlKey;
  PriceHtml? priceHtml;
  var price;
  String? formatedPrice;
  String? shortDescription;
  String? description;
  List<Images>? images;
  BaseImage? baseImage;
  List<Reviews>? reviews;
  bool? inStock;
  bool? isSaved;
  bool? isInWishlist;
  bool? isItemInCart;
  bool? showQuantityChanger;

  Product(
      {this.id,
        this.sku,
        this.type,
        this.name,
        this.urlKey,
        this.priceHtml,
        this.price,
        this.formatedPrice,
        this.shortDescription,
        this.description,
        this.images,
        this.baseImage,
        this.reviews,
        this.inStock,
        this.isSaved,
        this.isInWishlist,
        this.isItemInCart,
        this.showQuantityChanger});


  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);

}

@JsonSerializable()
class PriceHtml{
  String? regular;
  PriceHtml({this.regular});

  factory PriceHtml.fromJson(Map<String, dynamic> json) {
    return _$PriceHtmlFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PriceHtmlToJson(this);
}
@JsonSerializable()
class Images {
  String? id;
  String? path;
  String? url;
  String? originalImageUrl;
  String? smallImageUrl;
  String? mediumImageUrl;
  String? largeImageUrl;

  Images(
      {this.id,
        this.path,
        this.url,
        this.originalImageUrl,
        this.smallImageUrl,
        this.mediumImageUrl,
        this.largeImageUrl});


  factory Images.fromJson(Map<String, dynamic> json) {
    return _$ImagesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}
@JsonSerializable()
class BaseImage {
  String? smallImageUrl;
  String? mediumImageUrl;
  String? largeImageUrl;
  String? originalImageUrl;

  BaseImage(
      {this.smallImageUrl,
        this.mediumImageUrl,
        this.largeImageUrl,
        this.originalImageUrl});


  factory BaseImage.fromJson(Map<String, dynamic> json) {
    return _$BaseImageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BaseImageToJson(this);
}
@JsonSerializable()
class Reviews {
  String?id;
  String?title;
  String?comment;
  String?status;
  String?productId;
  int?rating;

  Reviews({this.id,this.title,this.comment,this.status,this.productId,this.rating});



  factory Reviews.fromJson(Map<String, dynamic> json) {
    return _$ReviewsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}

