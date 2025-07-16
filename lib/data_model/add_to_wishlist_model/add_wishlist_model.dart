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

part 'add_wishlist_model.g.dart';

@JsonSerializable()
class AddWishListModel extends BaseModel {
  Data? data;
  AddWishListModel({this.data});
  factory AddWishListModel.fromJson(Map<String, dynamic> json) {
    return _$AddWishListModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$AddWishListModelToJson(this);
}

@JsonSerializable()
class Data {
  int? id;
  WishlistProduct? product;

  Data({this.id, this.product});

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class WishlistProduct {
  String? id;
  // String? sku;
  // String? type;
  // String? name;
  // String? urlKey;
  // PriceHtml? priceHtml;
  // dynamic price;
  @JsonKey(name: "formatedPrice")
  // String? formattedPrice;
  // String? shortDescription;
  // String? description;
  // List<Images>? images;
  // BaseImage? baseImage;
  // List<Reviews>? reviews;
  // bool? inStock;
  // bool? isSaved;
  // bool? isInWishlist;
  // bool? isItemInCart;
  // bool? showQuantityChanger;

  WishlistProduct({
    this.id,
  });

  factory WishlistProduct.fromJson(Map<String, dynamic> json) {
    return _$WishlistProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WishlistProductToJson(this);
}

@JsonSerializable()
class PriceHtml {
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
  // String? path;
  // String? url;
  // String? originalImageUrl;
  // String? smallImageUrl;
  // String? mediumImageUrl;
  // String? largeImageUrl;

  Images({
    this.id,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return _$ImagesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class BaseImage {
  // String? smallImageUrl;
  // String? mediumImageUrl;
  // String? largeImageUrl;
  // String? originalImageUrl;

  BaseImage();

  factory BaseImage.fromJson(Map<String, dynamic> json) {
    return _$BaseImageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BaseImageToJson(this);
}

@JsonSerializable()
class Reviews {
  // String? id;
  // String? title;
  // String? comment;
  // String? status;
  // String? productId;
  // int? rating;

  Reviews();

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return _$ReviewsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}
