
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
import '../../screens/home_page/data_model/new_product_data.dart';
import '../graphql_base_error_model.dart';
import '../graphql_base_model.dart';

part 'product_screen_model.g.dart';

@JsonSerializable()
class ProductScreenModel extends GraphQlBaseModel{
  Data? data;

  ProductScreenModel({this.data});

  factory ProductScreenModel.fromJson(Map<String, dynamic> json) =>
      _$ProductScreenModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ProductScreenModelToJson(this);
}

@JsonSerializable()
class Data {
  ProductData? product;

  Data({this.product});

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);

}

@JsonSerializable()
class ProductData extends GraphQlBaseErrorModel{
  String? shareURL;
  List<AdditionalData>? additionalData;
  PriceHtml? priceHtml;
  String? id;
  String? type;
  bool? isInWishlist;
  bool? isInSale;
  dynamic attributeFamilyId;
  @JsonKey(name: "configutableData")
  ConfigurableData? configurableData;
  String? sku;
  String? parentId;
  List<ProductFlats>? productFlats;
  List<Variants>? variants;
  // String? parent;
  AttributeFamily? attributeFamily;
  List<AttributeValues>? attributeValues;
  List<Attributes>? superAttributes;
  List<Categories>? categories;
  List<Inventories>? inventories;
  List<Images>? images;
  List<Reviews>? reviews;
  List<GroupedProducts>? groupedProducts;
  List<DownloadableProduct>? downloadableSamples;
  List<DownloadableProduct>? downloadableLinks;
  List<BundleOptions>? bundleOptions;
  List<CustomerGroupPrices>? customerGroupPrices;
  // String? booking;
  CartModel? cart;
  String?averageRating;
 dynamic percentageRating;


  ProductData({this.averageRating,this.additionalData,this.isInSale,this.id, this.priceHtml,this.type, this.isInWishlist,this.attributeFamilyId, this.sku, this.parentId, this.productFlats, this.variants,
    this.attributeFamily, this.attributeValues, this.superAttributes, this.categories, this.inventories, this.images, this.reviews,
    this.groupedProducts, this.downloadableSamples, this.downloadableLinks, this.bundleOptions, this.customerGroupPrices, this.cart,this.shareURL,
    this.configurableData, this.percentageRating});

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ProductDataToJson(this);
}

@JsonSerializable()
class AdditionalData{
  String? id;
  String? color;
  String? label;
  String? value;
  @JsonKey(name: "admin_name")
  String? adminName;
  String? type;


  AdditionalData({this.id,this.color,this.label,this.value,this.adminName,this.type});

  factory AdditionalData.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AdditionalDataToJson(this);
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
  dynamic price;
  dynamic specialPrice;
  dynamic minPrice;
  dynamic maxPrice;
  String? specialPriceFrom;
  String? specialPriceTo;
  dynamic weight;
  int? color;
  String? colorLabel;
  int? size;
  String? sizeLabel;
  String? locale;
  String? channel;
  String? productId;
  String? metaTitle;
  String? metaKeywords;
  String? metaDescription;
  int? width;
  dynamic height;
  String? createdAt;
  String? updatedAt;

  ProductFlats({this.id, this.sku,this.minPrice,this.maxPrice, this.productNumber, this.name, this.description, this.shortDescription, this.urlKey, this.isNew, this.featured, this.status, this.visibleIndividually,this.specialPrice, this.specialPriceFrom, this.specialPriceTo, this.weight,
    this.color, this.colorLabel, this.size, this.sizeLabel, this.locale, this.channel, this.productId,   this.metaTitle, this.metaKeywords,
    this.metaDescription, this.width, this.height,  this.createdAt, this.updatedAt, this.price});



  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
      _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductFlatsToJson(this);
}

@JsonSerializable()
class AttributeFamily {
  String? id;
  String? code;
  String? name;
  bool? status;
  bool? isUserDefined;

  AttributeFamily({this.id, this.code, this.name, this.status, this.isUserDefined});

  factory AttributeFamily.fromJson(Map<String, dynamic> json) =>
      _$AttributeFamilyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributeFamilyToJson(this);

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
  Attribute? attribute;

  AttributeValues({this.id, this.productId, this.attributeId, this.locale, this.channel, this.textValue, this.booleanValue, this.integerValue,
    this.attribute});

  factory AttributeValues.fromJson(Map<String, dynamic> json) =>
      _$AttributeValuesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributeValuesToJson(this);
}

@JsonSerializable()
class Attribute {
  String? id;
  String? code;
  String? adminName;
  String? type;

  Attribute({this.id, this.code, this.adminName, this.type});


  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributeToJson(this);
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
  String? title;
  String? label;
  String? productDownloadableSampleId;
  String? productDownloadableLinkId;
  String? productBundleOptionId;


  Translations({this.id, this.name, this.label,this.description, this.localeId, this.locale,this.title,this.productDownloadableLinkId,
    this.productDownloadableSampleId,this.productBundleOptionId});


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

  Inventories({this.id, this.qty, this.productId, this.inventorySourceId, this.vendorId, this.inventorySource});


  factory Inventories.fromJson(Map<String, dynamic> json) =>
      _$InventoriesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InventoriesToJson(this);
}

@JsonSerializable()
class InventorySource {
  String? id;
  String? code;
  String? name;
  String? description;
  String? contactName;
  String? contactEmail;
  String? contactNumber;
  String? country;
  String? state;
  String? city;
  String? street;
  String? postcode;
  int? priority;
  bool? status;

  InventorySource({this.id, this.code, this.name, this.description, this.contactName, this.contactEmail, this.contactNumber, this.country,
    this.state, this.city, this.street, this.postcode, this.priority, this.status});


  factory InventorySource.fromJson(Map<String, dynamic> json) =>
      _$InventorySourceFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InventorySourceToJson(this);
}

@JsonSerializable()
class Images {
  String? id;
  String? type;
  String? path;
  String? url;
  String? productId;
  String? smallImageUrl;
  String? mediumImageUrl;
  String? largeImageUrl;
  String? originalImageUrl;

  Images({this.id, this.type, this.path, this.url, this.productId,this.smallImageUrl, this.mediumImageUrl, this.largeImageUrl, this.originalImageUrl});

  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ImagesToJson(this);

}

@JsonSerializable()
class CustomerGroupPrices {
  String? id;
  int? qty;
  String? valueType;
  int? value;
  String? productId;
  String? customerGroupId;
  String? createdAt;
  String? updatedAt;

  CustomerGroupPrices({this.id, this.qty, this.valueType, this.value, this.productId, this.customerGroupId, this.createdAt, this.updatedAt});


  factory CustomerGroupPrices.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupPricesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CustomerGroupPricesToJson(this);
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

  Reviews(
      {this.id,
        this.title,
        this.rating,
        this.comment,
        this.status,
        this.productId,
        this.customerId,
        this.customerName,
        this.createdAt,
        this.updatedAt});

  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ReviewsToJson(this);
}


@JsonSerializable()
class Variants{
  String? id;
  String? type;
  dynamic attributeFamilyId;
  String? sku;
  String? parentId;
  Map<String,dynamic>? map = {};

  Variants({this.id, this.type, this.attributeFamilyId, this.sku, this.parentId,this.map});



  factory Variants.fromJson(Map<String, dynamic> json) =>
      _$VariantsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VariantsToJson(this);
}

// @JsonSerializable()
// class SuperAttributes{
//
//   SuperAttributes();
//
//   factory SuperAttributes.fromJson(Map<String, dynamic> json) =>
//       _$SuperAttributesFromJson(json);
//
//   Map<String, dynamic> toJson() =>
//       _$SuperAttributesToJson(this);
// }

@JsonSerializable()
class ConfigurableData {
  String? chooseText;
  List<Attributes>? attributes;
  List<Index>? index;
  List<VariantPrices>? variantPrices;
  List<VariantImages>? variantImages;
  RegularPrice? regularPrice;

  ConfigurableData({this.chooseText, this.attributes, this.index, this.variantPrices, this.variantImages, this.regularPrice});

  factory ConfigurableData.fromJson(Map<String, dynamic> json) =>
      _$ConfigurableDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConfigurableDataToJson(this);

}

@JsonSerializable()
class Attributes {
  String? id;
  String? code;
  String? label;
  String? swatchType;
  String? type;
  List<Options>? options;

  Attributes({this.id, this.type,this.code, this.label, this.swatchType, this.options});

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributesToJson(this);
}

@JsonSerializable()
class Options {
  String? id;
  String? label;
  String? swatchType;
  String? swatchValue;
  bool? isSelect = false;

  Options({this.id, this.label, this.swatchType,this.isSelect,this.swatchValue});


  factory Options.fromJson(Map<String, dynamic> json) =>
      _$OptionsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OptionsToJson(this);
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
class DownloadableProduct {
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
  List<Translations>? translations;

  DownloadableProduct({this.id, this.title, this.price, this.url, this.file, this.fileName,
    this.type, this.sampleUrl, this.sampleFile,
    this.sampleFileName, this.sampleType, this.sortOrder,
    this.productId, this.downloads, this.translations});

  factory DownloadableProduct.fromJson(Map<String, dynamic> json) =>
      _$DownloadableProductFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DownloadableProductToJson(this);
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
  ProductData? product;

  BundleOptionProducts({this.product,this.id, this.qty, this.isUserDefined, this.sortOrder, this.isDefault, this.productBundleOptionId, this.productId});
  factory BundleOptionProducts.fromJson(Map<String, dynamic> json) =>
      _$BundleOptionProductsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BundleOptionProductsToJson(this);

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

  Map<String, dynamic> toJson() =>
      _$GroupedProductsToJson(this);
}

@JsonSerializable()
class AssociatedProduct {
  String? id;
  String? type;
  dynamic attributeFamilyId;
  String? sku;
  String? parentId;

  AssociatedProduct({this.id, this.type, this.attributeFamilyId, this.sku, this.parentId});
  factory AssociatedProduct.fromJson(Map<String, dynamic> json) =>
      _$AssociatedProductFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AssociatedProductToJson(this);

}