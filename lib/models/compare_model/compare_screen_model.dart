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
import 'package:bagisto_app_demo/models/product_model/product_model.dart';

part 'compare_screen_model.g.dart';

@JsonSerializable()
class CompareScreenModel {
  int?cartCount;
  List<CompareData>? data;
  Links? links;
  List<Data>? addWislistData;
  Meta? meta;

  CompareScreenModel({this.cartCount,this.data, this.links, this.meta});
  factory CompareScreenModel.fromJson(Map<String, dynamic> json){
    return _$CompareScreenModelFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$CompareScreenModelToJson(this);

}

@JsonSerializable()
class CompareData {
  int? id;
  Product? product;
  Customer? customer;
  String? createdAt;
  String? updatedAt;

  CompareData({this.id, this.product, this.customer, this.createdAt, this.updatedAt});

  factory CompareData.fromJson(Map<String, dynamic> json){
    return _$CompareDataFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$CompareDataToJson(this);
}

@JsonSerializable()
class Product {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? urlKey;
  var price;
  @JsonKey(name: "formated_price")
  String? formatedPrice;
  @JsonKey(name: "short_description")
  String? shortDescription;
  String? description;
  List<Images> ?images;
  Reviews? reviews;
  bool? inStock;
  bool? isSaved;
  @JsonKey(name: "is_wishlisted")
  bool? isWishlisted;
  bool? isItemInCart;
  bool? showQuantityChanger;
  List<MoreInformation> ?moreInformation;

  Product(
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
        this.reviews,
        this.inStock,
        this.isSaved,
        this.isWishlisted,
        this.isItemInCart,
        this.showQuantityChanger,
        this.moreInformation});
  factory Product.fromJson(Map<String, dynamic> json){
    return _$ProductFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$ProductToJson(this);

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

  factory Images.fromJson(Map<String, dynamic> json){
    return _$ImagesFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$ImagesToJson(this);
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
  factory BaseImage.fromJson(Map<String, dynamic> json){
    return _$BaseImageFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$BaseImageToJson(this);
}

@JsonSerializable()
class Reviews {
  int? total;
  String? totalRating;
  String? averageRating;

  Reviews({this.total, this.totalRating, this.averageRating, });

  factory Reviews.fromJson(Map<String, dynamic> json){
    return _$ReviewsFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$ReviewsToJson(this);
}

@JsonSerializable()
class MoreInformation {
  int? id;
  String? code;
  String? label;
  String? adminName;
  String? type;

  MoreInformation(
      {this.id, this.code, this.label,  this.adminName, this.type});

  factory MoreInformation.fromJson(Map<String, dynamic> json){
    return _$MoreInformationFromJson(json);
  }

  Map<String, dynamic> toJson() =>
      _$MoreInformationToJson(this);
}

@JsonSerializable()
class Customer {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? phone;
  int? status;
  Group? group;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.name,
        this.gender,
        this.dateOfBirth,
        this.phone,
        this.status,
        this.group,
        this.createdAt,
        this.updatedAt});

  factory Customer.fromJson(Map<String, dynamic> json){
    return _$CustomerFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$CustomerToJson(this);
}

@JsonSerializable()
class Group {
  int? id;
  String? name;

  Group({this.id, this.name, });


  factory Group.fromJson(Map<String, dynamic> json){
    return _$GroupFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$GroupToJson(this);
}

@JsonSerializable()
class Links {
  String? first;
  String? last;


  Links({this.first, this.last, });


  factory Links.fromJson(Map<String, dynamic> json){
    return _$LinksFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$LinksToJson(this);
}

@JsonSerializable()
class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Links>?links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});


  factory Meta.fromJson(Map<String, dynamic> json){
    return _$MetaFromJson(json);
  }
  Map<String, dynamic> toJson() =>
      _$MetaToJson(this);
}


