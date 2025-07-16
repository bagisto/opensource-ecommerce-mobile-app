/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../data_model/product_model/product_screen_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';

part 'new_product_data.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class NewProductsModel extends HiveObject {
  @HiveField(0)
  PaginatorInfo? paginatorInfo;
  @HiveField(1)
  List<NewProducts>? data;

  NewProductsModel({this.data});

  factory NewProductsModel.fromJson(Map<String, dynamic> json) =>
      _$NewProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewProductsModelToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class NewProducts extends HiveObject {
  @HiveField(0)
  dynamic id;
  @HiveField(1)
  dynamic productId;
  // @HiveField(2)
  // int? totalQtyOrdered;
  @HiveField(3)
  dynamic redirectId;
  @HiveField(4)
  String? name;
  // @HiveField(5)
  // String? imageUrl;
  // @HiveField(6)
  // bool? isOwner;
  // @HiveField(7)
  // int? totalQty;
  // @HiveField(8)
  // String? sku;
  // @HiveField(9)
  // String? rating;
  @HiveField(10)
  dynamic price;
  // @HiveField(26)
  // dynamic specialPrice;
  @HiveField(11)
  String? type;
  @HiveField(12)
  String? url;
  @HiveField(13)
  bool? isNew;
  @HiveField(27)
  bool? isInSale;
  // @HiveField(14)
  // String? condition;
  @HiveField(15)
  String? description;
  @HiveField(16)
  String? shortDescription;
  @HiveField(17)
  bool? isInWishlist;
  // @HiveField(18)
  // bool? isApproved;
  // @HiveField(19)
  // int? quantity;
  @HiveField(20)
  PriceHtml? priceHtml;
  @HiveField(21)
  List<Images>? images;
  @HiveField(22)
  List<Reviews>? reviews;
  @HiveField(24)
  @JsonKey(name: "productFlats")
  List<ProductFlats>? productFlats;
  // @HiveField(25)
  // String? attributeFamilyId;
  // @HiveField(29)
  // dynamic parentId;
  List<Variants>? variants;
  // dynamic parent;
  // AttributeFamily? attributeFamily;
  // List<AttributeValues>? attributeValues;
  List<SuperAttributes>? superAttributes;
  // List<Categories>? categories;
  @HiveField(30)
  bool? isSaleable;
  @HiveField(28)
  // List<Inventories>? inventories;
  // List<dynamic>? videos;
  // List<dynamic>? orderedInventories;
  List<GroupedProducts>? groupedProducts;
  List<DownloadableSamples>? downloadableSamples;
  List<DownloadableLinks>? downloadableLinks;
  List<BundleOptions>? bundleOptions;
  // List<dynamic>? customerGroupPrices;
  CartModel? cart;
  String? shareURL;
  @JsonKey(name: "configutableData")
  ConfigurableData? configurableData;
  List<AdditionalData>? additionalData;
  String? urlKey;
  String? averageRating;
  dynamic percentageRating;
  List<CustomizableOptions>? customizableOptions;
  List<BookingProduct>? booking;
  NewProducts(
      {this.isInSale,
      this.type,
      this.url,
      this.price,
      this.isNew,
      this.id,
      this.productId,
      this.redirectId,
      this.name,
      this.description,
      this.shortDescription,
      this.isInWishlist,
      this.priceHtml,
      this.images,
      this.productFlats,
      this.isSaleable,
      this.reviews,

      // this.categories,

      this.bundleOptions,
      this.downloadableLinks,
      this.downloadableSamples,
      this.groupedProducts,
      this.superAttributes,
      this.variants,
      // this.videos,
      this.additionalData,
      this.cart,
      this.shareURL,
      this.configurableData,
      this.urlKey,
      this.averageRating,
      this.percentageRating,
      this.customizableOptions,
      this.booking});

  factory NewProducts.fromJson(Map<String, dynamic> json) =>
      _$NewProductsFromJson(json);

  Map<String, dynamic> toJson() => _$NewProductsToJson(this);
}

@JsonSerializable()
class PaginatorInfo {
  int? count;
  int? currentPage;
  int? lastPage;
  int? total;

  PaginatorInfo({this.count, this.currentPage, this.lastPage, this.total});
  factory PaginatorInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginatorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatorInfoToJson(this);
}

@HiveType(typeId: 5)
@JsonSerializable()
class Reviews extends HiveObject {
  String? id;
  String? title;
  @HiveField(0)
  int? rating;
  String? comment;
  // String? status;
  // String? productId;
  // String? customerId;
  String? customerName;
  String? createdAt;
  // String? updatedAt;

  Reviews({
    this.id,
    this.title,
    this.rating,
    this.comment,
    this.customerName,
    this.createdAt,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}

@JsonSerializable()
class DownloadableSamples extends HiveObject {
  String? id;
  // String? url;
  // String? file;
  String? fileName;
  // String? type;
  // String? fileUrl;
  // int? sortOrder;
  // String? productId;
  // String? createdAt;
  // String? updatedAt;
  List<Translations>? translations;

  DownloadableSamples({this.id, this.fileName, this.translations});

  factory DownloadableSamples.fromJson(Map<String, dynamic> json) =>
      _$DownloadableSamplesFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadableSamplesToJson(this);
}

@HiveType(typeId: 20)
@JsonSerializable()
class PriceHtml extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? type;
  // @HiveField(2)
  // String? html;
  // @HiveField(3)
  // String? regular;
  // @HiveField(4)
  // String? special;
  // @HiveField(5)
  // String? minPrice;
  @HiveField(6)
  String? priceHtml;
  // @HiveField(7)
  // String? priceWithoutHtml;
  @HiveField(8)
  String? regularPrice;
  @HiveField(9)
  String? formattedRegularPrice;
  @HiveField(10)
  String? finalPrice;
  @HiveField(11)
  String? formattedFinalPrice;
  // @HiveField(12)
  // String? currencyCode;
  // BundlePrice? bundlePrice;

  PriceHtml(
      {this.id,
      this.type,
      this.finalPrice,
      this.formattedFinalPrice,
      this.formattedRegularPrice,
      this.priceHtml,
      this.regularPrice});

  factory PriceHtml.fromJson(Map<String, dynamic> json) =>
      _$PriceHtmlFromJson(json);

  Map<String, dynamic> toJson() => _$PriceHtmlToJson(this);
}

@HiveType(typeId: 8)
@JsonSerializable()
class ProductFlats extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? sku;
  @HiveField(2)
  String? productNumber;
  @HiveField(3)
  String? name;
  // @HiveField(4)
  // String? urlKey;
  @HiveField(5)
  @JsonKey(name: "new")
  bool? isNew;
  @HiveField(6)
  String? locale;
  // @HiveField(7)
  // bool? isWishListed;
  // @HiveField(8)
  // String? shortDescription;
  // @HiveField(9)
  // String? description;

  ProductFlats({
    this.id,
    this.locale,
    this.sku,
    this.name,
    this.isNew,
    this.productNumber,
  });

  factory ProductFlats.fromJson(Map<String, dynamic> json) =>
      _$ProductFlatsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFlatsToJson(this);
}

@HiveType(typeId: 4)
@JsonSerializable()
class Images extends HiveObject {
  @HiveField(0)
  dynamic id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? path;
  @HiveField(3)
  String? url;
  @HiveField(4)
  dynamic productId;

  Images({this.id, this.type, this.path, this.url, this.productId});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class AttributeFamily {
  String? id;
  String? code;
  String? name;
  bool? status;
  bool? isUserDefined;

  AttributeFamily(
      {this.id, this.code, this.name, this.status, this.isUserDefined});

  factory AttributeFamily.fromJson(Map<String, dynamic> json) =>
      _$AttributeFamilyFromJson(json);

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

  AttributeValues(
      {this.id,
      this.productId,
      this.attributeId,
      this.locale,
      this.channel,
      this.textValue,
      this.booleanValue,
      this.integerValue,
      this.floatValue,
      this.dateTimeValue,
      this.dateValue,
      this.jsonValue});

  factory AttributeValues.fromJson(Map<String, dynamic> json) =>
      _$AttributeValuesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeValuesToJson(this);
}

@JsonSerializable()
class SuperAttributes {
  String? id;
  String? code;
  String? adminName;
  String? type;
  dynamic position;

  SuperAttributes(
      {this.id, this.code, this.adminName, this.type, this.position});

  factory SuperAttributes.fromJson(Map<String, dynamic> json) =>
      _$SuperAttributesFromJson(json);

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

  AdditionalData(
      {this.id, this.code, this.label, this.value, this.adminName, this.type});

  factory AdditionalData.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDataFromJson(json);

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

  BundlePrice(
      {this.finalPriceFrom,
      this.formattedFinalPriceFrom,
      this.regularPriceFrom,
      this.formattedRegularPriceFrom,
      this.finalPriceTo,
      this.formattedFinalPriceTo,
      this.regularPriceTo,
      this.formattedRegularPriceTo});

  factory BundlePrice.fromJson(Map<String, dynamic> json) =>
      _$BundlePriceFromJson(json);

  Map<String, dynamic> toJson() => _$BundlePriceToJson(this);
}

@JsonSerializable()
class ConfigurableData {
  // List<dynamic>? variantVideos;
  String? chooseText;
  List<Attributes>? attributes;
  List<Index>? index;
  List<VariantPrices>? variantPrices;
  // List<VariantImages>? variantImages;
  RegularPrice? regularPrice;

  ConfigurableData(
      {this.chooseText,
      this.attributes,
      this.index,
      this.variantPrices,
      // this.variantImages,
      // this.variantVideos,
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

  Map<String, dynamic> toJson() => _$VariantImagesToJson(this);
}

@JsonSerializable()
class VariantPrices {
  String? id;
  RegularPrice? regularPrice;
  RegularPrice? finalPrice;

  VariantPrices({this.id, this.regularPrice, this.finalPrice});

  factory VariantPrices.fromJson(Map<String, dynamic> json) =>
      _$VariantPricesFromJson(json);

  Map<String, dynamic> toJson() => _$VariantPricesToJson(this);
}

@JsonSerializable()
class Index {
  String? id;
  List<AttributeOptionIds>? attributeOptionIds;

  Index({this.id, this.attributeOptionIds});

  factory Index.fromJson(Map<String, dynamic> json) => _$IndexFromJson(json);

  Map<String, dynamic> toJson() => _$IndexToJson(this);
}

@JsonSerializable()
class AttributeOptionIds {
  String? attributeId;
  String? attributeOptionId;

  AttributeOptionIds({this.attributeId, this.attributeOptionId});

  factory AttributeOptionIds.fromJson(Map<String, dynamic> json) =>
      _$AttributeOptionIdsFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeOptionIdsToJson(this);
}

@JsonSerializable()
class RegularPrice {
  dynamic price;
  String? formattedPrice;

  RegularPrice({this.price, this.formattedPrice});
  factory RegularPrice.fromJson(Map<String, dynamic> json) =>
      _$RegularPriceFromJson(json);

  Map<String, dynamic> toJson() => _$RegularPriceToJson(this);
}

@JsonSerializable()
class GroupedProducts {
  String? id;
  int? qty;
  int? sortOrder;
  String? productId;
  String? associatedProductId;
  AssociatedProduct? associatedProduct;

  GroupedProducts(
      {this.id,
      this.qty,
      this.sortOrder,
      this.productId,
      this.associatedProductId,
      this.associatedProduct});

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

  DownloadableLinks(
      {this.id,
      this.title,
      this.price,
      this.url,
      this.file,
      this.fileName,
      this.type,
      this.sampleUrl,
      this.sampleFile,
      this.sampleFileName,
      this.sampleType,
      this.sortOrder,
      this.productId,
      this.downloads,
      this.translations,
      this.fileUrl,
      this.sampleFileUrl});

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

  BundleOptions(
      {this.id,
      this.type,
      this.isRequired,
      this.sortOrder,
      this.productId,
      this.bundleOptionProducts,
      this.translations});
  factory BundleOptions.fromJson(Map<String, dynamic> json) =>
      _$BundleOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$BundleOptionsToJson(this);
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

  BundleOptionProducts(
      {this.id,
      this.qty,
      this.isUserDefined,
      this.sortOrder,
      this.isDefault,
      this.productBundleOptionId,
      this.productId,
      this.product});

  factory BundleOptionProducts.fromJson(Map<String, dynamic> json) =>
      _$BundleOptionProductsFromJson(json);

  Map<String, dynamic> toJson() => _$BundleOptionProductsToJson(this);
}

@JsonSerializable()
class AssociatedProduct {
  String? id;
  String? type;
  String? attributeFamilyId;
  String? sku;
  String? name;
  PriceHtml? priceHtml;
  dynamic parentId;

  AssociatedProduct(
      {this.id,
      this.type,
      this.attributeFamilyId,
      this.sku,
      this.priceHtml,
      this.parentId});

  factory AssociatedProduct.fromJson(Map<String, dynamic> json) =>
      _$AssociatedProductFromJson(json);

  Map<String, dynamic> toJson() => _$AssociatedProductToJson(this);
}

@JsonSerializable()
class CustomizableOptions {
  final int? id;
  final dynamic label;
  final dynamic productId;
  final dynamic type;
  final bool? isRequired;
  final dynamic maxCharacters;
  final dynamic supportedFileExtensions;
  final int? sortOrder;
  final Product? product;
  final Translations? translations;
  final List<CustomizableOptionPrices>? customizableOptionPrices;

  CustomizableOptions({
    this.id,
    this.label,
    this.productId,
    this.type,
    this.isRequired,
    this.maxCharacters,
    this.supportedFileExtensions,
    this.sortOrder,
    this.product,
    this.translations,
    this.customizableOptionPrices,
  });

  factory CustomizableOptions.fromJson(Map<String, dynamic> json) =>
      _$CustomizableOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$CustomizableOptionsToJson(this);
}

// @JsonSerializable()
// class Product {
//   final String? id;
//
//   Product({this.id});
//
//   factory Product.fromJson(Map<String, dynamic> json) =>
//       _$ProductFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ProductToJson(this);
// }

// @JsonSerializable()
// class Translations {
//   final int? id;
//   final String? locale;
//   final String? label;
//   final String? productCustomizableOptionId;
//
//   Translations({
//     this.id,
//     this.locale,
//     this.label,
//     this.productCustomizableOptionId,
//   });
//
//   factory Translations.fromJson(Map<String, dynamic> json) =>
//       _$TranslationsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$TranslationsToJson(this);
// }

@JsonSerializable()
class CustomizableOptionPrices {
  final int? id;
  final bool? isDefault;
  final bool? isUserDefined;
  final String? label;
  final double? price;
  final String? productCustomizableOptionId;
  final int? qty;
  final int? sortOrder;

  CustomizableOptionPrices({
    this.id,
    this.isDefault,
    this.isUserDefined,
    this.label,
    this.price,
    this.productCustomizableOptionId,
    this.qty,
    this.sortOrder,
  });

  factory CustomizableOptionPrices.fromJson(Map<String, dynamic> json) =>
      _$CustomizableOptionPricesFromJson(json);

  Map<String, dynamic> toJson() => _$CustomizableOptionPricesToJson(this);
}

//booking option

@JsonSerializable()
class BookingProduct {
  String? id;
  String? type;
  int? qty;
  String? location;
  bool? showLocation;
  dynamic availableEveryWeek;
  String? availableFrom;
  String? availableTo;
  String? productId;
  Product? product;
  DefaultBookingProductSlots? defaultSlot;
  AppointmentBookingProductSlots? appointmentSlot;
  final List<EventTicket>? eventTickets;
  dynamic rentalSlot;
  @JsonKey(name: "tableSlot")
  final TableSlot? tableSlot;

  BookingProduct({
    this.id,
    this.type,
    this.qty,
    this.location,
    this.showLocation,
    this.availableEveryWeek,
    this.availableFrom,
    this.availableTo,
    this.productId,
    this.product,
    this.defaultSlot,
    this.appointmentSlot,
    this.eventTickets,
    this.rentalSlot,
    this.tableSlot,
  });

  factory BookingProduct.fromJson(Map<String, dynamic> json) =>
      _$BookingProductFromJson(json);

  Map<String, dynamic> toJson() => _$BookingProductToJson(this);
}

@JsonSerializable()
class Product {
  String? id;

  Product({this.id});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class DefaultBookingProductSlots {
  String? id;
  String? bookingType;
  int? duration;
  int? breakTime;
  @JsonKey(name: "slotManyDays")
  final List<SlotManyDay>? slotManyDays;
  @JsonKey(name: "slotOneDay")
  final List<List<SlotOneDay>>? slotOneDay;

  DefaultBookingProductSlots({
    this.id,
    this.bookingType,
    this.duration,
    this.breakTime,
    this.slotManyDays,
    this.slotOneDay,
  });

  factory DefaultBookingProductSlots.fromJson(Map<String, dynamic> json) =>
      _$DefaultBookingProductSlotsFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultBookingProductSlotsToJson(this);
}

@JsonSerializable()
class AppointmentBookingProductSlots {
  String? id;
  int? duration;
  int? breakTime;
  bool? sameSlotAllDays;
  @JsonKey(name: "slotManyDays")
  final List<SlotManyDay>? slotManyDays;
  @JsonKey(name: "slotOneDay")
  final List<List<SlotOneDay>>? slotOneDay;

  AppointmentBookingProductSlots({
    this.id,
    this.duration,
    this.breakTime,
    this.sameSlotAllDays,
    this.slotManyDays,
    this.slotOneDay,
  });

  factory AppointmentBookingProductSlots.fromJson(Map<String, dynamic> json) =>
      _$AppointmentBookingProductSlotsFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentBookingProductSlotsToJson(this);
}

@JsonSerializable()
class BookingDaySlots {
  String? id;
  String? day;
  String? from;
  String? to;

  BookingDaySlots({
    this.id,
    this.day,
    this.from,
    this.to,
  });

  factory BookingDaySlots.fromJson(Map<String, dynamic> json) =>
      _$BookingDaySlotsFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDaySlotsToJson(this);
}

@JsonSerializable()
class EventTicket {
  @JsonKey(name: "__typename")
  final String? typename;

  @JsonKey(name: "id")
  final String? id;

  @JsonKey(name: "price")
  final int? price;

  @JsonKey(name: "qty")
  final int? qty;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "description")
  final String? description;

  @JsonKey(name: "specialPrice")
  final int? specialPrice;

  @JsonKey(name: "specialPriceFrom")
  final DateTime? specialPriceFrom;

  @JsonKey(name: "specialPriceTo")
  final DateTime? specialPriceTo;

  @JsonKey(name: "translations")
  final List<Translations>? translations;

  EventTicket({
    this.typename,
    this.id,
    this.price,
    this.qty,
    this.name,
    this.description,
    this.specialPrice,
    this.specialPriceFrom,
    this.specialPriceTo,
    this.translations,
  });

  factory EventTicket.fromJson(Map<String, dynamic> json) =>
      _$EventTicketFromJson(json);

  Map<String, dynamic> toJson() => _$EventTicketToJson(this);
}

@JsonSerializable()
class TableSlot {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "priceType")
  final String? priceType;
  @JsonKey(name: "guestLimit")
  final int? guestLimit;
  @JsonKey(name: "duration")
  final int? duration;
  @JsonKey(name: "breakTime")
  final int? breakTime;
  @JsonKey(name: "preventSchedulingBefore")
  final bool? preventSchedulingBefore;
  @JsonKey(name: "sameSlotAllDays")
  final bool? sameSlotAllDays;
  @JsonKey(name: "slotManyDays")
  final List<SlotManyDay>? slotManyDays;
  @JsonKey(name: "slotOneDay")
  final List<List<SlotOneDay>>? slotOneDay;

  TableSlot({
    this.id,
    this.priceType,
    this.guestLimit,
    this.duration,
    this.breakTime,
    this.preventSchedulingBefore,
    this.sameSlotAllDays,
    this.slotManyDays,
    this.slotOneDay,
  });

  factory TableSlot.fromJson(Map<String, dynamic> json) =>
      _$TableSlotFromJson(json);

  Map<String, dynamic> toJson() => _$TableSlotToJson(this);
}

@JsonSerializable()
class SlotManyDay {
  @JsonKey(name: "to")
  final String? to;
  @JsonKey(name: "from")
  final String? from;

  SlotManyDay({
    this.to,
    this.from,
  });

  factory SlotManyDay.fromJson(Map<String, dynamic> json) =>
      _$SlotManyDayFromJson(json);

  Map<String, dynamic> toJson() => _$SlotManyDayToJson(this);
}

@JsonSerializable()
class SlotOneDay {
  @JsonKey(name: "id")
  final dynamic id;
  @JsonKey(name: "to")
  final dynamic to;
  @JsonKey(name: "from")
  final dynamic from;

  SlotOneDay({
    this.id,
    this.to,
    this.from,
  });

  factory SlotOneDay.fromJson(Map<String, dynamic> json) =>
      _$SlotOneDayFromJson(json);

  Map<String, dynamic> toJson() => _$SlotOneDayToJson(this);
}
