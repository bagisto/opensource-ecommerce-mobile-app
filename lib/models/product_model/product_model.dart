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

part 'product_model.g.dart';

@JsonSerializable()
class ProductData {
  Data? data;
int?cartCount;
  ProductData({this.data,this.cartCount});

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductDataToJson(this);
}
@JsonSerializable()
class Data {
  int? id;
  String? sku;
  String? type;
  String? name;
  String? urlKey;
  dynamic price;
  @JsonKey(name: "formated_price")
  String? formatedPrice;
  @JsonKey(name: "short_description")
  String? shortDescription;
  String? description;
  List<Images>? images;
  Reviews? reviews;
  @JsonKey(name: "in_stock")
  bool? inStock;
  bool? isSaved;
  @JsonKey(name: "is_wishlisted")
  bool? isWishlisted;
  bool? isItemInCart;
  bool? showQuantityChanger;
  int? cartCount;
  @JsonKey(name: "grouped_products")
  List<Data>? groupedProducts = [];
  @JsonKey(name: "downloadable_links")
  List<DownloadableProduct>? downloadableLinks = [];
  @JsonKey(name: "downloadable_samples")
  List<DownloadableProduct>? downloadableSamples = [];
  @JsonKey(name: "variants")
  List<Variants>? variants = [];
  @JsonKey(name: "super_attributes")
  List<CustomOptions>? customOptions = [];
  @JsonKey(name: "bundle_options")
  Bundles? bundleOption;
  Data(
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
        this.cartCount,
        this.groupedProducts,
        this.downloadableLinks,
        this.downloadableSamples,
        this.customOptions,
        this.variants,
        this.bundleOption});
  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);

}

@JsonSerializable()
class Bundles {

  @JsonKey(name: "options")
  List<BundleOptions>? bundleOptions = [];


  Bundles(
      {this.bundleOptions
      });

  factory Bundles.fromJson(Map<String, dynamic> json) =>
      _$BundlesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BundlesToJson(this);
}

@JsonSerializable()
class Images {
  int? id;
  String? path;
  String? url;


  Images(
      {this.id,
        this.path,
        this.url,
      });

  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ImagesToJson(this);
}


@JsonSerializable()
class Reviews {
  int? total;
  @JsonKey(name: "total_rating")
  dynamic totalRating;
  @JsonKey(name: "average_rating")
  dynamic averageRating;
  dynamic percentage;

  Reviews({this.total, this.totalRating, this.averageRating,this.percentage });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return _$ReviewsFromJson(json);
  }

  Map<String, dynamic> toJson() =>
      _$ReviewsToJson(this);
}


@JsonSerializable()
class DownloadableProduct {
  int? id;
  String? url;
  String? file;
  @JsonKey(name: "file_name")
  String? fileName;
  int? downloads;
  String? price;
  @JsonKey(name: "product_id")
  int? productId;
  @JsonKey(name: "file_url")
  String? fileUrl;
  String? title;
  @JsonKey(name: "sample_file_url")
  String? sampleFileUrl;
  @JsonKey(name: "sample_download_url")
  String? sampleDownloadUrl;
  String? downloadUrl;

  DownloadableProduct(
      {this.id,
        this.url,
        this.file,
        this.fileName,
        this.downloads,
        this.price,
        this.productId,
        this.fileUrl,
        this.title,
        this.sampleFileUrl,
        this.sampleDownloadUrl,this.downloadUrl});

  factory DownloadableProduct.fromJson(Map<String, dynamic> json) =>
      _$DownloadableProductFromJson(json);

}

@JsonSerializable()
class Variants {
  int? id;
  String? sku;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? parentId;
  var attributeFamilyId;
  String? additional;
  String? price;
  String? shortDescription;
  String? description;
  String? name;
  String? urlKey;
  String? new1;
  var featured;
  String? visibleIndividually;
  int? status;
  String? guestCheckout;
  String? productNumber;
  int? messageOnTshirt;
  String? metaTitle;
  String? metaKeywords;
  String? metaDescription;
  String? specialPrice;
  String? specialPriceFrom;
  String? specialPriceTo;
  String? length;
  String? width;
  String? height;
  String? weight;
  List<Inventories>? inventories;
  List<String>? customerGroupPrices = [];
  AttributeFamily? attributeFamily;
  Map<String,dynamic>? map = {};

  Variants(
      {this.id, this.sku, this.type, this.createdAt, this.updatedAt, this.parentId, this.attributeFamilyId,
        this.additional, this.price, this.shortDescription, this.description, this.name, this.urlKey,
        this.new1, this.featured, this.visibleIndividually, this.status, this.map,
        this.guestCheckout, this.productNumber,  this.messageOnTshirt,
         this.metaTitle, this.metaKeywords, this.metaDescription,  this.specialPrice,
        this.specialPriceFrom, this.specialPriceTo, this.length, this.width, this.height, this.weight, this.inventories,
        this.customerGroupPrices, this.attributeFamily});

  factory Variants.fromJson(Map<String, dynamic> json) =>
      _$VariantsFromJson(json);
  Map<String, dynamic> toJson() =>
      _$VariantsToJson(this);
}

@JsonSerializable()
class Inventories {
  int? id;
  int? qty;
  int? productId;
  int? inventorySourceId;
  int? vendorId;

  Inventories({this.id, this.qty, this.productId, this.inventorySourceId, this.vendorId});
  factory Inventories.fromJson(Map<String, dynamic> json) =>
  _$InventoriesFromJson(json);
  // Inventories.fromJson(Map<String?, dynamic> json) {
  //   id = json['id'];
  //   qty = json['qty'];
  //   productId = json['product_id'];
  //   inventorySourceId = json['inventory_source_id'];
  //   vendorId = json['vendor_id'];
  Map<String, dynamic> toJson() =>
      _$InventoriesToJson(this);
  }
// }
@JsonSerializable()
class AttributeFamily {
  int? id;
  String? code;
  String? name;
  int? status;
  int? isUserDefined;

  AttributeFamily({this.id, this.code, this.name, this.status, this.isUserDefined});
  factory AttributeFamily.fromJson(Map<String, dynamic> json) =>
      _$AttributeFamilyFromJson(json);
  // AttributeFamily.fromJson(Map<String?, dynamic> json) {
  //   id = json['id'];
  //   code = json['code'];
  //   name = json['name'];
  //   status = json['status'];
  //   isUserDefined = json['is_user_defined'];
  // }
  Map<String, dynamic> toJson() =>
      _$AttributeFamilyToJson(this);
}
@JsonSerializable()
class CustomOptions {
  int? id;
  String? code;
  String? type;
  String? name;
  String? swatchType;
  List<Option>? options;
  String? createdAt;
  String? updatedAt;

  CustomOptions(
      {this.id,
        this.code,
        this.type,
        this.name,
        this.swatchType,
        this.options,
        this.createdAt,
        this.updatedAt});

  CustomOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    name = json['name'];
    swatchType = json['swatch_type'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options?.add(Option.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  Map<String, dynamic> toJson() =>
      _$CustomOptionsToJson(this);


}
@JsonSerializable()
class Option {
  int? id;
  String? adminName;
  String? label;
  String? swatchValue;
  bool isSelect = false;

  Option({this.id, this.adminName, this.label, this.swatchValue});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminName = json['admin_name'];
    label = json['label'];
    swatchValue = json['swatch_value'];
  }

  Map<String, dynamic> toJson() =>
      _$OptionToJson(this);

}
@JsonSerializable()
class BundleOptions {
  int? id;
  String? label;
  String? type;
  int? isRequired;
  List<Products>? products = [];
  int? sortOrder;

  BundleOptions(
      {this.id,
        this.label,
        this.type,
        this.isRequired,
        this.products,
        this.sortOrder});

  BundleOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    type = json['type'];
    isRequired = json['is_required'];
    if (json['products'] != null) {
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
    sortOrder = json['sort_order'];
  }
  Map<String, dynamic> toJson() =>
      _$BundleOptionsToJson(this);

}
@JsonSerializable()
class Products {
  int? id;
  int? qty;
  Price? price;
  String? name;
  int? productId;
  int? isDefault;
  int? sortOrder;
  bool? inStock;
  int? inventory;

  Products(
      {this.id,
        this.qty,
        this.price,
        this.name,
        this.productId,
        this.isDefault,
        this.sortOrder,
        this.inStock,
        this.inventory});


  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductsToJson(this);
}

@JsonSerializable()
class Price {
  RegularPrice? regularPrice;
  RegularPrice? finalPrice;

  Price({this.regularPrice, this.finalPrice});
  factory Price.fromJson(Map<String, dynamic> json) =>
      _$PriceFromJson(json);


  Map<String, dynamic> toJson() =>
      _$PriceToJson(this);
}
@JsonSerializable()
class RegularPrice {
  String? price;
  String? formatedPrice;
  RegularPrice({this.price, this.formatedPrice});
  factory RegularPrice.fromJson(Map<String, dynamic> json) =>
      _$RegularPriceFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RegularPriceToJson(this);



}
