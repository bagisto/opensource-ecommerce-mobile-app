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

import '../../screens/cart_screen/cart_model/cart_data_model.dart';

part 'orders_list_data_model.g.dart';

@JsonSerializable()
class OrdersListModel extends BaseModel {
  List<Data>? data;
  PaginatorInfo? paginatorInfo;

  OrdersListModel({this.data, this.paginatorInfo});

  factory OrdersListModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersListModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrdersListModelToJson(this);
}

@JsonSerializable()
class PaginatorInfo {
  // int? count;
  int? currentPage;
  int? lastPage;
  // int? total;

  PaginatorInfo({this.currentPage, this.lastPage});
  factory PaginatorInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginatorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatorInfoToJson(this);
}

@JsonSerializable()
class Data {
  int? id;
  String? status;
  int? totalQtyOrdered;
  String? createdAt;
  FormattedPrice? formattedPrice;

  Data(
      {this.id,
      this.status,
      this.totalQtyOrdered,
      this.createdAt,
      this.formattedPrice});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class OrderListProduct {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? urlKey;
  dynamic price;
  String? formatedPrice;
  String? shortDescription;
  String? description;
  List<Images>? images;
  BaseImage? baseImage;
  Reviews? reviews;
  bool? inStock;
  bool? isSaved;
  bool? isWishlisted;
  bool? isItemInCart;
  bool? showQuantityChanger;

  OrderListProduct(
      {this.id,
      this.sku,
      this.type,
      this.name,
      this.urlKey,
      this.price,
      this.formatedPrice,
      this.shortDescription,
      this.description,
      this.images,
      this.baseImage,
      this.reviews,
      this.inStock,
      this.isSaved,
      this.isWishlisted,
      this.isItemInCart,
      this.showQuantityChanger});

  factory OrderListProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderListProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListProductToJson(this);
}

@JsonSerializable()
class Images {
  int? id;
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

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

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

  factory BaseImage.fromJson(Map<String, dynamic> json) =>
      _$BaseImageFromJson(json);

  Map<String, dynamic> toJson() => _$BaseImageToJson(this);
}

@JsonSerializable()
class Reviews {
  int? total;
  int? totalRating;
  int? averageRating;

  Reviews({this.total, this.totalRating, this.averageRating});

  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}
