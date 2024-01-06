
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../data_model/categories_data_model/categories_product_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
part 'new_product_data.g.dart';

@HiveType(typeId: 1)
  @JsonSerializable()
  class NewProductsModel extends HiveObject{
  @HiveField(0)
  PaginatorInfo ?paginatorInfo;
  @HiveField(1)
  List<NewProducts>? data;

  NewProductsModel({this.data});

  factory NewProductsModel.fromJson(Map<String, dynamic> json) =>
  _$NewProductsModelFromJson(json);

  Map<String, dynamic> toJson() =>
  _$NewProductsModelToJson(this);
  }
@HiveType(typeId: 2)
@JsonSerializable()
class NewProducts  extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? productId;
  @HiveField(2)
  int? totalQtyOrdered;
  @HiveField(3)
  dynamic redirectId;
  @HiveField(4)
  String?  name;
  @HiveField(5)
  String? imageUrl;
  @HiveField(6)
  bool? isOwner;
  @HiveField(7)
  int? totalQty;
  @HiveField(8)
  String? sku;
  @HiveField(9)
  String? rating;
  @HiveField(10)
  dynamic price;
  @HiveField(26)
  dynamic specialPrice;
  @HiveField(11)
  String? type;
  @HiveField(12)
  String? url;
  @HiveField(13)
  bool? isNew;
  @HiveField(27)
  bool? isInSale;
  @HiveField(14)
  String? condition;
  @HiveField(15)
  String? description;
  @HiveField(16)
  String? shortDescription;
  @HiveField(17)
  bool? isInWishlist;
  @HiveField(18)
  bool? isApproved;
  @HiveField(19)
  int? quantity;
  @HiveField(20)
  PriceHtml? priceHtml;
  @HiveField(21)
  List<Images>? images;
  @HiveField(22)
  List<Reviews>? reviews;
  @HiveField(23)
  SellerProduct? product;
  @HiveField(24)
  @JsonKey(name:"productFlats")
  List<ProductFlats>? productFlats;
  @HiveField(25)
  Seller? seller;
  String? attributeFamilyId;
  dynamic parentId;
  List<Variants>? variants;
  dynamic parent;
  AttributeFamily? attributeFamily;
  List<AttributeValues>? attributeValues;
  List<SuperAttributes>? superAttributes;
  List<Categories>? categories;
  List<Inventories>? inventories;
  List<dynamic>? videos;
  List<dynamic>? orderedInventories;
  List<GroupedProducts>? groupedProducts;
  List<DownloadableSamples>? downloadableSamples;
  List<DownloadableLinks>? downloadableLinks;
  List<BundleOptions>? bundleOptions;
  List<dynamic>? customerGroupPrices;
  CartModel? cart;
  String? shareURL;
  @JsonKey(name: "configutableData")
  ConfigurableData? configurableData;
  List<AdditionalData>? additionalData;
  String? urlKey;
  String? averageRating;
  dynamic percentageRating;


  NewProducts({this.isInSale,this.specialPrice,this.type,this.rating,this.url,this.price,this.isNew,this.id,this.productId,this.totalQty,this.totalQtyOrdered,this.redirectId,this.sku,this.condition,this.name,this.description,this.shortDescription,
    this.isInWishlist,this.priceHtml, this.images,this.productFlats,this.product,this.isApproved,
    this.reviews, this.seller,this.isOwner, this.quantity, this.categories, this.imageUrl, this.parentId,
  this.attributeFamily, this.attributeFamilyId, this.attributeValues, this.bundleOptions, this.customerGroupPrices,
  this.downloadableLinks, this.downloadableSamples, this.groupedProducts, this.inventories, this.orderedInventories,
  this.parent, this.superAttributes, this.variants, this.videos, this.additionalData, this.cart, this.shareURL, this.configurableData, this.urlKey, this.averageRating, this.percentageRating});

  factory NewProducts.fromJson(Map<String, dynamic> json) =>
      _$NewProductsFromJson(json);

  Map<String, dynamic> toJson() => _$NewProductsToJson(this);
}
  @HiveType(typeId: 5)
  @JsonSerializable()
  class Reviews  extends HiveObject {
  String? id;
  String? title;
  @HiveField(0)
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
 @HiveType(typeId: 8)
  @JsonSerializable()
  class Seller  extends HiveObject {
  String? id;
  String? url;
  bool? isApproved;
  String? shopTitle;
  String? description;
  String? banner;
  String? bannerUrl;
  String? logo;
  String? logoUrl;
  String? taxVat;
  dynamic metaTitle;
  String? metaDescription;
  String? metaKeywords;
  String? address1;
  String? address2;
  String? phone;
  String? state;
  String? city;
  String? country;
  String? postcode;
  String? returnPolicy;
  String? shippingPolicy;
  String? privacyPolicy;
  String? twitter;
  String? facebook;
  String? youtube;
  String? instagram;
  String? skype;
  String? linkedIn;
  String? pinterest;
  String? customerId;
  String? createdAt;
  String? updatedAt;
  bool? commissionEnable;
  int? commissionPercentage;
  String? minOrderAmount;
  String? googleAnalyticsId;
  String? profileBackground;

  Seller(
  {this.id,
  this.url,
  this.isApproved,
  this.shopTitle,
  this.description,
  this.banner,
  this.bannerUrl,
  this.logo,
  this.logoUrl,
  this.taxVat,
  this.metaTitle,
  this.metaDescription,
  this.metaKeywords,
  this.address1,
  this.address2,
  this.phone,
  this.state,
  this.city,
  this.country,
  this.postcode,
  this.returnPolicy,
  this.shippingPolicy,
  this.privacyPolicy,
  this.twitter,
  this.facebook,
  this.youtube,
  this.instagram,
  this.skype,
  this.linkedIn,
  this.pinterest,
  this.customerId,
  this.createdAt,
  this.updatedAt,
  this.commissionEnable,
  this.commissionPercentage,
  this.minOrderAmount,
  this.googleAnalyticsId,
  this.profileBackground,});

  factory Seller.fromJson(Map<String, dynamic> json) =>
  _$SellerFromJson(json);

  Map<String, dynamic> toJson() => _$SellerToJson(this);
  }
@HiveType(typeId: 6)
  @JsonSerializable()
  class SellerProduct extends HiveObject {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? shortDescription;
  dynamic attributeFamilyId;
  bool? isInWishlist;
  List<Images>? images;
  @JsonKey(name: "configutableData")
  ConfigurableData? configurableData ;
  List<ProductFlats>? productFlats;
  List<Inventories>? inventories;
  SellerProduct({this.id,this.attributeFamilyId,this.configurableData,this.isInWishlist,this.sku,this.type,this.name,
  this.shortDescription,this.productFlats,this.inventories, this.images});

  factory SellerProduct.fromJson(Map<String, dynamic> json) =>
  _$SellerProductFromJson(json);

  Map<String, dynamic> toJson() => _$SellerProductToJson(this);
  }

@JsonSerializable()
  class DownloadableSamples  extends HiveObject {
  String? id;
  String? url;
  String? file;
  String? fileName;
  String? type;
  String? fileUrl;
  int? sortOrder;
  String? productId;
  String? createdAt;
  String? updatedAt;
  List<Translations>? translations;

  DownloadableSamples({this.id, this.url, this.file, this.fileName, this.type, this.productId,this.createdAt,
  this.fileUrl, this.updatedAt, this.sortOrder, this.translations});

  factory DownloadableSamples.fromJson(Map<String, dynamic> json) =>
  _$DownloadableSamplesFromJson(json);

  Map<String, dynamic> toJson() =>
  _$DownloadableSamplesToJson(this);
  }
@HiveType(typeId: 3)
  @JsonSerializable()
  class PriceHtml  extends HiveObject {
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
  String? minPrice;
  String? priceHtml;
  String? priceWithoutHtml;
  String? regularPrice;
  String? formattedRegularPrice;
  String? finalPrice;
  String? formattedFinalPrice;
  String? currencyCode;
  BundlePrice? bundlePrice;

  PriceHtml({this.id, this.type, this.html, this.regular, this.special, this.bundlePrice, this.currencyCode,
  this.finalPrice, this.formattedFinalPrice, this.formattedRegularPrice, this.minPrice, this.priceHtml,
  this.priceWithoutHtml, this.regularPrice});

  factory PriceHtml.fromJson(Map<String, dynamic> json) =>
  _$PriceHtmlFromJson(json);

  Map<String, dynamic> toJson() =>
  _$PriceHtmlToJson(this);
  }
 @HiveType(typeId: 7)
  @JsonSerializable()
  class ProductFlats  extends HiveObject {
  @HiveField(0)
  String? id;
  String? sku;
  String? productNumber;
  String? name;
  String? urlKey;
  @HiveField(1)
  @JsonKey(name:"new")
  bool? isNew;
  @HiveField(2)
  String ? locale;
  bool? isWishListed;
  String? shortDescription;
  String? description;

  ProductFlats({this.id,this.locale, this.sku, this.name, this.urlKey,this.isNew,this.isWishListed,
    this.productNumber, this.shortDescription, this.description});

  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
  _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() =>
  _$ProductFlatsToJson(this);
  }
 @HiveType(typeId: 4)
  @JsonSerializable()
  class Images   extends HiveObject {
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

@JsonSerializable()
class AttributeFamily{
  String? id;
  String? code;
  String? name;
  bool? status;
  bool? isUserDefined;

  AttributeFamily({this.id, this.code, this.name, this.status, this.isUserDefined});

  factory AttributeFamily.fromJson(Map<String, dynamic> json) => _$AttributeFamilyFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeFamilyToJson(this);
}

@JsonSerializable()
class AttributeValues {
  String? id;
  String? productId;
  String? attributeId;
  String? locale;
  String? channel;
  String? textValue;
  bool? booleanValue;
  int? integerValue;
  dynamic floatValue;
  dynamic dateTimeValue;
  dynamic dateValue;
  dynamic jsonValue;

  AttributeValues({this.id, this.productId, this.attributeId, this.locale, this.channel, this.textValue, this.booleanValue, this.integerValue, this.floatValue, this.dateTimeValue, this.dateValue, this.jsonValue});

  factory AttributeValues.fromJson(Map<String, dynamic> json) => _$AttributeValuesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeValuesToJson(this);
}

@JsonSerializable()
class SuperAttributes{
  String? id;
  String? code;
  String? adminName;
  String? type;
  dynamic position;

  SuperAttributes({this.id, this.code, this.adminName, this.type, this.position});

  factory SuperAttributes.fromJson(Map<String, dynamic> json) => _$SuperAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$SuperAttributesToJson(this);
}

@JsonSerializable()
class AdditionalData {
  String? id;
  String? code;
  String? label;
  String? value;
  String? adminName;
  String? type;

  AdditionalData({this.id, this.code, this.label, this.value, this.adminName, this.type});

  factory AdditionalData.fromJson(Map<String, dynamic> json) => _$AdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$AdditionalDataToJson(this);
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

@JsonSerializable()
class ConfigurableData {
  List<dynamic>? variantVideos;
  String? chooseText;
  List<Attributes>? attributes;
  List<Index>? index;
  List<VariantPrices>? variantPrices;
  List<VariantImages>? variantImages;
  RegularPrice? regularPrice;

  ConfigurableData(
      {this.chooseText,
        this.attributes,
        this.index,
        this.variantPrices,
        this.variantImages,
        this.variantVideos,
        this.regularPrice});

  factory ConfigurableData.fromJson(Map<String, dynamic> json) {
    return _$ConfigurableDataFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ConfigurableDataToJson(this);
}

@JsonSerializable()
class VariantImages {
  String? id;
  List<Images>? images;

  VariantImages({this.id, this.images});

  factory VariantImages.fromJson(Map<String, dynamic> json) =>
      _$VariantImagesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VariantImagesToJson(this);
}

@JsonSerializable()
class VariantPrices {
  String? id;
  RegularPrice? regularPrice;
  RegularPrice? finalPrice;

  VariantPrices({this.id, this.regularPrice, this.finalPrice});

  factory VariantPrices.fromJson(Map<String, dynamic> json) =>
      _$VariantPricesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VariantPricesToJson(this);

}

@JsonSerializable()
class Index {
  String? id;
  List<AttributeOptionIds>? attributeOptionIds;

  Index({this.id, this.attributeOptionIds});


  factory Index.fromJson(Map<String, dynamic> json) =>
      _$IndexFromJson(json);

  Map<String, dynamic> toJson() =>
      _$IndexToJson(this);
}

@JsonSerializable()
class AttributeOptionIds {
  String? attributeId;
  String? attributeOptionId;

  AttributeOptionIds({this.attributeId, this.attributeOptionId});

  factory AttributeOptionIds.fromJson(Map<String, dynamic> json) =>
      _$AttributeOptionIdsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributeOptionIdsToJson(this);
}

@JsonSerializable()
class RegularPrice {
  dynamic price;
  @JsonKey(name: "formatedPrice")
  String? formattedPrice;

  RegularPrice({this.price, this.formattedPrice});
  factory RegularPrice.fromJson(Map<String, dynamic> json) =>
      _$RegularPriceFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RegularPriceToJson(this);

}

@JsonSerializable()
class GroupedProducts {
  String? id;
  int? qty;
  int? sortOrder;
  String? productId;
  String? associatedProductId;
  AssociatedProduct? associatedProduct;

  GroupedProducts({this.id, this.qty, this.sortOrder, this.productId, this.associatedProductId, this.associatedProduct});

  factory GroupedProducts.fromJson(Map<String, dynamic> json) =>
      _$GroupedProductsFromJson(json);

  Map<String, dynamic> toJson() => _$GroupedProductsToJson(this);
}

@JsonSerializable()
class DownloadableLinks {
  String? id;
  String? title;
  double? price;
  String? url;
  String? file;
  String? fileName;
  String? type;
  String? sampleUrl;
  String? sampleFile;
  String? sampleFileName;
  String? sampleType;
  int? sortOrder;
  String? productId;
  int? downloads;
  String? fileUrl;
  String? sampleFileUrl;
  List<Translations>? translations;

  DownloadableLinks({this.id, this.title, this.price, this.url, this.file, this.fileName, this.type, this.sampleUrl, this.sampleFile, this.sampleFileName, this.sampleType,
    this.sortOrder, this.productId, this.downloads, this.translations, this.fileUrl, this.sampleFileUrl});

  factory DownloadableLinks.fromJson(Map<String, dynamic> json) =>
      _$DownloadableLinksFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadableLinksToJson(this);
  }

@JsonSerializable()
class BundleOptions {
  String? id;
  String? type;
  bool? isRequired;
  int? sortOrder;
  String? productId;
  List<BundleOptionProducts>? bundleOptionProducts;
  List<Translations>? translations;

  BundleOptions({this.id, this.type, this.isRequired, this.sortOrder, this.productId, this.bundleOptionProducts, this.translations});
  factory BundleOptions.fromJson(Map<String, dynamic> json) =>
      _$BundleOptionsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BundleOptionsToJson(this);
}

@JsonSerializable()
class BundleOptionProducts {
  String? id;
  int? qty;
  bool? isUserDefined;
  int? sortOrder;
  bool? isDefault;
  String? productBundleOptionId;
  String? productId;
  NewProducts? product;

  BundleOptionProducts({this.id, this.qty, this.isUserDefined, this.sortOrder, this.isDefault,
    this.productBundleOptionId, this.productId, this.product});

  factory BundleOptionProducts.fromJson(Map<String, dynamic> json) =>
      _$BundleOptionProductsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BundleOptionProductsToJson(this);
  }

@JsonSerializable()
class AssociatedProduct {
  String? id;
  String? type;
  String? attributeFamilyId;
  String? sku;
  PriceHtml? priceHtml;
  dynamic parentId;

  AssociatedProduct({this.id, this.type, this.attributeFamilyId, this.sku,this.priceHtml, this.parentId});

  factory AssociatedProduct.fromJson(Map<String, dynamic> json) =>
      _$AssociatedProductFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AssociatedProductToJson(this);
  }