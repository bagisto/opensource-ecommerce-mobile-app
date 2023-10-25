
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/models/categories_data_model/categories_product_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'new_product_data.g.dart';
@HiveType(typeId:0)
@JsonSerializable()
class NewProductsModel extends GraphQlBaseModel{
  @HiveField(0)
  List<NewProducts>? data;

  NewProductsModel({this.data});

  factory NewProductsModel.fromJson(Map<String, dynamic> json) =>
      _$NewProductsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$NewProductsModelToJson(this);
}

@HiveType(typeId:1)
@JsonSerializable()
class NewProducts extends HiveObject{
 @HiveField(0)
  String? id;
 @HiveField(1)
 String? productId;
 @HiveField(2)
 String? sku;
 @HiveField(3)
 String? name;
 @HiveField(4)
 String? description;
 @HiveField(5)
 String? shortDescription;
 @HiveField(6)
 String? rating;
 @HiveField(7)
 String? type;
 @HiveField(8)
 String? url;
 @HiveField(9)
 String? price;
 @HiveField(10)
 bool? isInWishlist;
 @HiveField(11)
 bool? isNew;
 @HiveField(12)
 PriceHtml? priceHtml;
 @HiveField(13)
 List<Images>? images;
 @HiveField(14)
 List<Reviews>? reviews;
 List<DownloadableLinks>? downloadableLinks;
  List<DownloadableSamples>? downloadableSamples;
 @HiveField(15)
  @JsonKey(name:"productFlats")
  List<ProductFlats>? productFlats;

  NewProducts( {this.type,this.productId,this.url,this.id,this.sku,this.name,this.description,this.shortDescription,this.downloadableLinks, this.isInWishlist,this.priceHtml, this.images,this.productFlats,this.price,this.rating,this.isNew});

  factory NewProducts.fromJson(Map<String, dynamic> json) =>
      _$NewProductsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NewProductsToJson(this);
}

@JsonSerializable()
class DownloadableLinks {
  String? id;
  String? title;
  double? price;
  String? url;
  String? file;
  String? fileUrl;
  String? fileName;
  String? type;
  String? sampleUrl;
  String? sampleFile;
  String? sampleFileName;
  String? sampleType;
  int? sortOrder;
  String? productId;
  int? downloads;
  List<Translations>? translations;

  DownloadableLinks({this.id, this.title, this.price, this.url, this.file, this.fileUrl, this.fileName, this.type, this.sampleUrl, this.sampleFile, this.sampleFileName, this.sampleType, this.sortOrder, this.productId, this.downloads, this.translations});

  factory DownloadableLinks.fromJson(Map<String, dynamic> json) =>
      _$DownloadableLinksFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadableLinksToJson(this);

}
@HiveType(typeId: 4)
@JsonSerializable()
class Reviews extends HiveObject{
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  int? rating;
  @HiveField(3)
  String? comment;
  @HiveField(4)
  String? status;
  @HiveField(5)
  String? productId;
  @HiveField(6)
  String? customerId;
  @HiveField(7)
  String? customerName;
  @HiveField(8)
  String? createdAt;
  @HiveField(9)
  String? updatedAt;

  Reviews({this.id, this.title, this.rating, this.comment, this.status, this.productId, this.customerId, this.customerName, this.createdAt, this.updatedAt});


  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ReviewsToJson(this);
}
@JsonSerializable()
class DownloadableSamples {
  String? id;
  String? url;
  String? file;
  String? fileUrl;
  String? fileName;
  String? type;

  DownloadableSamples({this.id, this.url, this.file, this.fileName, this.type, this.fileUrl});

  factory DownloadableSamples.fromJson(Map<String, dynamic> json) =>
      _$DownloadableSamplesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DownloadableSamplesToJson(this);
}
@HiveType(typeId: 2)
@JsonSerializable()
class PriceHtml extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? html;
  @HiveField(3)
  String? regular;
  @HiveField(4)
  String? special;

  PriceHtml({this.id, this.type, this.html, this.regular, this.special});

  factory PriceHtml.fromJson(Map<String, dynamic> json) =>
      _$PriceHtmlFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PriceHtmlToJson(this);
}
@HiveType(typeId: 5)
@JsonSerializable()
class ProductFlats extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? sku;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? urlKey;
  @HiveField(4)
  @JsonKey(name:"new")
  bool? isNew;
  @HiveField(5)
  bool? isWishListed;
  @HiveField(6)
  String ? locale;

  ProductFlats({this.id, this.sku, this.name, this.urlKey,this.isNew,this.isWishListed,this.locale});

  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
      _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductFlatsToJson(this);
}
@HiveType(typeId: 3)
@JsonSerializable()
class Images extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? path;
  @HiveField(3)
  String? url;
  @HiveField(4)
  String? productId;

  Images({this.id, this.type, this.path, this.url, this.productId});

  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ImagesToJson(this);
}
