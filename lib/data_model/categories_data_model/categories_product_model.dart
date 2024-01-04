
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
import '../../screens/cart_screen/cart_model/cart_data_model.dart';
import '../graphql_base_model.dart';
import '../product_model/product_screen_model.dart';
part 'categories_product_model.g.dart';

@JsonSerializable()
class CategoriesProductModel extends GraphQlBaseModel{
  PaginatorInfo? paginatorInfo;
  List<Data>? data;

  CategoriesProductModel({this.data});

  factory CategoriesProductModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesProductModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CategoriesProductModelToJson(this);
}
@JsonSerializable()
 class PaginatorInfo{
  int?  count;
  int? currentPage;
  int? lastPage;
  int? total;


  PaginatorInfo({this.count,this.currentPage,this.lastPage,this.total});
  factory PaginatorInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginatorInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaginatorInfoToJson(this);

 }



@JsonSerializable()
class Data {
  String? id;
  String? type;
  bool? isInWishlist;
  bool? isInSale;
  dynamic attributeFamilyId;
  PriceHtml? priceHtml;
  String? sku;
  List<ProductFlats>? productFlats;
  List<Categories>? categories;
  List<Inventories>? inventories;
  List<CacheBaseImage>? cacheBaseImage;
  List<Images>? images;
  List<Reviews>? reviews;
  CartModel? cart;
  List<AdditionalData>? additionalData;
  dynamic parentId;
  List<Variants>? variants;
  dynamic parent;
  AttributeFamily? attributeFamily;
  List<AttributeValues>? attributeValues;
  List<SuperAttributes>? superAttributes;
  List<CacheBaseImage>? cacheGalleryImages;
  List<dynamic>? videos;
  List<dynamic>? orderedInventories;
  List<dynamic>? groupedProducts;
  List<dynamic>? downloadableSamples;
  List<dynamic>? downloadableLinks;
  List<dynamic>? bundleOptions;
  List<dynamic>? customerGroupPrices;
  List<dynamic>? relatedProducts;

  Data({this.isInSale,this.id, this.type, this.isInWishlist,this.attributeFamilyId, this.priceHtml, this.sku,  this.productFlats, this.categories, this.inventories,
    this.cacheBaseImage, this.images, this.reviews,this.cart, this.additionalData, this.videos, this.variants,
  this.superAttributes, this.parent, this.orderedInventories, this.groupedProducts, this.downloadableSamples,
  this.downloadableLinks, this.customerGroupPrices, this.bundleOptions, this.attributeValues, this.attributeFamily,
  this.parentId, this.cacheGalleryImages, this.relatedProducts});

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);
}
@JsonSerializable()
class PriceHtml {
  String? id;
  String? type;
  String? html;
  String? regular;
  String? special;
  String? minPrice;
  String? priceHtml;
  String? priceWithoutHtml;
  String? regularPrice;
  String? formattedRegularPrice;
  String? finalPrice;
  String? formattedFinalPrice;
  String? currencyCode;
  BundlePrice? bundlePrice;

  PriceHtml({this.id, this.type, this.html, this.regular, this.special, this.finalPrice, this.formattedFinalPrice,
  this.regularPrice, this.priceWithoutHtml, this.priceHtml, this.minPrice, this.formattedRegularPrice,
  this.currencyCode, this.bundlePrice});

  factory PriceHtml.fromJson(Map<String, dynamic> json) =>
      _$PriceHtmlFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PriceHtmlToJson(this);
}
@JsonSerializable()
class ProductFlats {
  String? id;
  String? sku;
  String? productNumber;
  String? name;
  String? description;
  String? shortDescription;
  String? urlKey;
  @JsonKey(name:"new")
  bool? isNew;
  bool? featured;
  bool? status;
  bool? visibleIndividually;
  double? price;
  dynamic specialPrice;
  double? weight;
  int? color;
  String? colorLabel;
  int? size;
  String? sizeLabel;
  String? locale;
  String? channel;
  String? productId;
  double? minPrice;
  double? maxPrice;
  String? metaTitle;
  String? metaKeywords;
  String? metaDescription;
  int? width;
  dynamic height;
  List<Variants>? variants;
  String? createdAt;
  String? updatedAt;
  ProductData? product;


  ProductFlats({this.id, this.sku, this.productNumber, this.name, this.description, this.shortDescription, this.urlKey,this.isNew,
    this.featured, this.status, this.visibleIndividually, this.price, this.weight, this.color, this.colorLabel, this.size, this.sizeLabel, this.locale,
    this.channel, this.productId,  this.minPrice, this.maxPrice, this.metaTitle, this.metaKeywords, this.metaDescription, this.width, this.height,
    this.variants, this.createdAt, this.updatedAt,this.product,this.specialPrice});

  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
      _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductFlatsToJson(this);
}
@JsonSerializable()
class Variants {
  String? id;
  String? sku;
  String? name;
  String? description;
  String? shortDescription;
  String? urlKey;
  bool? status;
  dynamic price;
  String? locale;
  String? channel;
  String? productId;
  dynamic parentId;

  Variants({this.id, this.sku, this.name, this.description, this.shortDescription, this.urlKey,  this.status, this.price, this.locale, this.channel, this.productId, this.parentId});

  factory Variants.fromJson(Map<String, dynamic> json) =>
      _$VariantsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VariantsToJson(this);

}
@JsonSerializable()
class Categories {
  String? id;
  String? name;
  String? description;
  String? slug;
  String? urlPath;
  String? imageUrl;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  dynamic position;
  bool? status;
  String? displayMode;
  String? parentId;
  List<FilterableAttributes>? filterableAttributes;
  List<Translations>? translations;
  String? createdAt;
  String? updatedAt;

  Categories({this.id, this.name, this.description, this.slug, this.urlPath, this.imageUrl, this.metaTitle, this.metaDescription, this.metaKeywords, this.position, this.status, this.displayMode, this.parentId, this.filterableAttributes, this.translations, this.createdAt, this.updatedAt});
  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CategoriesToJson(this);
}
@JsonSerializable()
class FilterableAttributes {
  String? id;
  String? adminName;
  String? code;
  String? type;
  int? position;

  FilterableAttributes({this.id, this.adminName, this.code, this.type, this.position});
  factory FilterableAttributes.fromJson(Map<String, dynamic> json) =>
      _$FilterableAttributesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FilterableAttributesToJson(this);
}
@JsonSerializable()
class Translations {
  String? id;
  String? name;
  String? description;
  String? localeId;
  String? locale;
  String? label;
  String? title;
  String? attributeOptionId;

  Translations({this.id, this.name, this.description, this.localeId, this.locale, this.attributeOptionId, this.label, this.title});



  factory Translations.fromJson(Map<String, dynamic> json) =>
      _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TranslationsToJson(this);
}
@JsonSerializable()
class Inventories {
  String? id;
  int? qty;
  String? productId;
  String? inventorySourceId;
  int? vendorId;
  InventorySource? inventorySource;

  Inventories({this.id, this.qty, this.productId, this.inventorySourceId, this.vendorId});

  factory Inventories.fromJson(Map<String, dynamic> json) =>
      _$InventoriesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InventoriesToJson(this);
}
@JsonSerializable()
class CacheBaseImage {
  String? smallImageUrl;
  String? mediumImageUrl;
  String? largeImageUrl;
  String? originalImageUrl;

  CacheBaseImage({this.smallImageUrl, this.mediumImageUrl, this.largeImageUrl, this.originalImageUrl});
  factory CacheBaseImage.fromJson(Map<String, dynamic> json) =>
      _$CacheBaseImageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CacheBaseImageToJson(this);
}

@JsonSerializable()
class Reviews {
  String? id;
  String? title;
  int? rating;
  String? comment;
  String? status;
  String? productId;
  String? customerId;
  String? customerName;
  String? createdAt;
  String? updatedAt;

  Reviews({this.id, this.title, this.rating, this.comment, this.status, this.productId, this.customerId, this.customerName, this.createdAt, this.updatedAt});


  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ReviewsToJson(this);
}

@JsonSerializable()
class BundlePrice {
  String? finalPriceFrom;
  String? formattedFinalPriceFrom;
  String? regularPriceFrom;
  String? formattedRegularPriceFrom;
  String? finalPriceTo;
  String? formattedFinalPriceTo;
  String? regularPriceTo;
  String? formattedRegularPriceTo;

  BundlePrice({this.finalPriceFrom, this.formattedFinalPriceFrom, this.regularPriceFrom, this.formattedRegularPriceFrom, this.finalPriceTo, this.formattedFinalPriceTo, this.regularPriceTo, this.formattedRegularPriceTo});

  factory BundlePrice.fromJson(Map<String, dynamic> json) => _$BundlePriceFromJson(json);

  Map<String, dynamic> toJson() => _$BundlePriceToJson(this);
}