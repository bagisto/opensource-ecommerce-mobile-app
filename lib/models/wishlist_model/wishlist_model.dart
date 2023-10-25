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

import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/models/categories_data_model/categories_product_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../cart_model/cart_data_model.dart';
part 'wishlist_model.g.dart';

@JsonSerializable()
class WishListData extends GraphQlBaseModel{
  PaginatorInfo ? paginatorInfo;
  List<Data>? data;

  WishListData({this.data,this.paginatorInfo});

  factory WishListData.fromJson(Map<String, dynamic> json) =>
      _$WishListDataFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$WishListDataToJson(this);
}


@JsonSerializable()
class Data {
  String? id;
  String? channelId;
  String? productId;
  String? customerId;
  String? itemOptions;
  String? additional;
  String? movedToCart;
  String? timeOfMoving;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  Product? product;
  CartModel? cart;

  Data(
      {this.id,
        this.channelId,
        this.productId,
        this.customerId,
        this.itemOptions,
        this.additional,
        this.movedToCart,
        this.timeOfMoving,
        this.createdAt,
        this.updatedAt,
        this.customer,
        this.product,this.cart});


  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);
}
@JsonSerializable()
class Customer {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? email;
  String? phone;
  String? password;
  String? apiToken;
  int? customerGroupId;
  bool? subscribedToNewsLetter;
  bool? isVerified;
  String? token;
  String? notes;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
        this.firstName,
        this.lastName,
        this.name,
        this.gender,
        this.dateOfBirth,
        this.email,
        this.phone,
        this.password,
        this.apiToken,
        this.customerGroupId,
        this.subscribedToNewsLetter,
        this.isVerified,
        this.token,
        this.notes,
        this.status,
        this.createdAt,
        this.updatedAt});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CustomerToJson(this);
}
@JsonSerializable()
class Product {
  List<Images>? images;
  String? id;
  String? sku;
  String? name;
  String? description;
  String? shortDescription;
  String? type;
  var attributeFamilyId;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  PriceHtml? priceHtml;

  Product(
      {
  this.images,
        this.id,
  this.name,
  this.description,
        this.type,
        this.attributeFamilyId,
        this.sku,
        this.parentId,
        this.createdAt,
        this.updatedAt,
     this.priceHtml});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductToJson(this);
}
@JsonSerializable()
class Images {
  String? id;
  String? type;
  String? path;
  String? url;
  String? productId;

  Images({this.id, this.type, this.path, this.url, this.productId});


  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ImagesToJson(this);
}
@JsonSerializable()
class ProductFlats {
  String? id;
  String? sku;
  String? productNumber;
  String? name;
  String? description;
  String? shortDescription;
  String? locale;
  String? channel;

  ProductFlats(
      {this.id,
        this.sku,
        this.productNumber,
        this.name,
        this.description,
        this.shortDescription,
        this.locale,
        this.channel});

  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
      _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductFlatsToJson(this);

}


@JsonSerializable()
class ShareWishlistData  extends GraphQlBaseModel {
  bool ?isWishlistShared;
  String ?wishlistSharedLink;
  ShareWishlistData({this.isWishlistShared, this.wishlistSharedLink,});


  factory ShareWishlistData.fromJson(Map<String, dynamic> json) =>
      _$ShareWishlistDataFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ShareWishlistDataToJson(this);
}
