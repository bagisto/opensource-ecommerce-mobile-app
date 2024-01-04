/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../screens/cart_screen/cart_model/cart_data_model.dart';
import '../categories_data_model/categories_product_model.dart';

part 'orders_list_data_model.g.dart';

@JsonSerializable()
class OrdersListModel extends GraphQlBaseModel {
  List<Data>? data;
  PaginatorInfo? paginatorInfo;

  OrdersListModel({this.data, this.paginatorInfo});

  factory OrdersListModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersListModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrdersListModelToJson(this);
}

@JsonSerializable()
class Data {
  int? id;
  String? incrementId;
  String? status;
  String? channelName;
  int? isGuest;
  String? customerEmail;
  String? customerFirstName;
  String? customerLastName;
  String? shippingMethod;
  String? shippingTitle;
  String? paymentTitle;
  String? shippingDescription;
  String? couponCode;
  int? isGift;
  int? totalItemCount;
  int? totalQtyOrdered;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? orderCurrencyCode;
  var grandTotal;
  var formatedGrandTotal;
  var baseGrandTotal;
  var formatedBaseGrandTotal;
  var grandTotalInvoiced;
  var formatedGrandTotalInvoiced;
  var baseGrandTotalInvoiced;
  int? formatedBaseGrandTotalInvoiced;
  int? grandTotalRefunded;
  int? formatedGrandTotalRefunded;
  int? baseGrandTotalRefunded;
  int? formatedBaseGrandTotalRefunded;
  var subTotal;
  var formatedSubTotal;
  var baseSubTotal;
  var formatedBaseSubTotal;
  var subTotalInvoiced;
  var formatedSubTotalInvoiced;
  var baseSubTotalInvoiced;
  var formatedBaseSubTotalInvoiced;
  int? subTotalRefunded;
  int? formatedSubTotalRefunded;
  int? discountPercent;
  var discountAmount;
  var formatedDiscountAmount;
  var baseDiscountAmount;
  var formatedBaseDiscountAmount;
  var discountInvoiced;
  var formatedDiscountInvoiced;
  var baseDiscountInvoiced;
  int? formatedBaseDiscountInvoiced;
  int? discountRefunded;
  int? formatedDiscountRefunded;
  int? baseDiscountRefunded;
  int? formatedBaseDiscountRefunded;
  int? taxAmount;
  int? formatedTaxAmount;
  int? baseTaxAmount;
  int? formatedBaseTaxAmount;
  int? taxAmountInvoiced;
  int? formatedTaxAmountInvoiced;
  int? baseTaxAmountInvoiced;
  int? formatedBaseTaxAmountInvoiced;
  int? taxAmountRefunded;
  int? formatedTaxAmountRefunded;
  int? baseTaxAmountRefunded;
  int? formatedBaseTaxAmountRefunded;
  int? shippingAmount;
  int? formatedShippingAmount;
  int? baseShippingAmount;
  int? formatedBaseShippingAmount;
  int? shippingInvoiced;
  int? formatedShippingInvoiced;
  int? baseShippingInvoiced;
  int? formatedBaseShippingInvoiced;
  int? shippingRefunded;
  int? formatedShippingRefunded;
  int? baseShippingRefunded;
  int? formatedBaseShippingRefunded;
  var customerId;

  // Customer? customer;
  // Channel? channel;
  ShippingAddress? shippingAddress;
  ShippingAddress? billingAddress;
  List<Items>? items;
  String? createdAt;
  FormattedPrice? formattedPrice;

  // List<Null> invoices;
  // List<Null> shipments;

  Data(
      {this.id,
      this.incrementId,
      this.status,
      this.customerId,
      this.channelName,
      this.isGuest,
      this.customerEmail,
      this.customerFirstName,
      this.customerLastName,
      this.shippingMethod,
      this.shippingTitle,
      this.paymentTitle,
      this.shippingDescription,
      this.couponCode,
      this.isGift,
      this.totalItemCount,
      this.totalQtyOrdered,
      this.baseCurrencyCode,
      this.channelCurrencyCode,
      this.orderCurrencyCode,
      this.grandTotal,
      this.formatedGrandTotal,
      this.baseGrandTotal,
      this.formatedBaseGrandTotal,
      this.grandTotalInvoiced,
      this.formatedGrandTotalInvoiced,
      this.baseGrandTotalInvoiced,
      this.formatedBaseGrandTotalInvoiced,
      this.grandTotalRefunded,
      this.formatedGrandTotalRefunded,
      this.baseGrandTotalRefunded,
      this.formatedBaseGrandTotalRefunded,
      this.subTotal,
      this.formatedSubTotal,
      this.baseSubTotal,
      this.formatedBaseSubTotal,
      this.subTotalInvoiced,
      this.formatedSubTotalInvoiced,
      this.baseSubTotalInvoiced,
      this.formatedBaseSubTotalInvoiced,
      this.subTotalRefunded,
      this.formatedSubTotalRefunded,
      this.discountPercent,
      this.discountAmount,
      this.formatedDiscountAmount,
      this.baseDiscountAmount,
      this.formatedBaseDiscountAmount,
      this.discountInvoiced,
      this.formatedDiscountInvoiced,
      this.baseDiscountInvoiced,
      this.formatedBaseDiscountInvoiced,
      this.discountRefunded,
      this.formatedDiscountRefunded,
      this.baseDiscountRefunded,
      this.formatedBaseDiscountRefunded,
      this.taxAmount,
      this.formatedTaxAmount,
      this.baseTaxAmount,
      this.formatedBaseTaxAmount,
      this.taxAmountInvoiced,
      this.formatedTaxAmountInvoiced,
      this.baseTaxAmountInvoiced,
      this.formatedBaseTaxAmountInvoiced,
      this.taxAmountRefunded,
      this.formatedTaxAmountRefunded,
      this.baseTaxAmountRefunded,
      this.formatedBaseTaxAmountRefunded,
      this.shippingAmount,
      this.formatedShippingAmount,
      this.baseShippingAmount,
      this.formatedBaseShippingAmount,
      this.shippingInvoiced,
      this.formatedShippingInvoiced,
      this.baseShippingInvoiced,
      this.formatedBaseShippingInvoiced,
      this.shippingRefunded,
      this.formatedShippingRefunded,
      this.baseShippingRefunded,
      this.formatedBaseShippingRefunded,
      /* this.customer,
        this.channel,*/
      this.shippingAddress,
      this.billingAddress,
      this.items,
      this.createdAt,
      this.formattedPrice});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

// @JsonSerializable()
// class Customer {
//   int? id;
//   String? email;
//   String? firstName;
//   String? lastName;
//   String? name;
//   String? gender;
//   String? dateOfBirth;
//   String? phone;
//   int? status;
//   Group? group;
//
//
//   Customer(
//       {this.id,
//         this.email,
//         this.firstName,
//         this.lastName,
//         this.name,
//         this.gender,
//         this.dateOfBirth,
//         this.phone,
//         this.status,
//         this.group,
//        });
//   factory Customer.fromJson(Map<String, dynamic> json) =>
//       _$CustomerFromJson(json);
//
//   Map<String, dynamic> toJson() =>
//       _$CustomerToJson(this);
//
// }

@JsonSerializable()
class Group {
  int? id;
  String? name;

  Group({this.id, this.name});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class DefaultLocale {
  int? id;
  String? code;
  String? name;

  DefaultLocale({this.id, this.code, this.name});

  factory DefaultLocale.fromJson(Map<String, dynamic> json) =>
      _$DefaultLocaleFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultLocaleToJson(this);
}

@JsonSerializable()
class RootCategory {
  int? id;
  String? name;
  String? slug;
  String? displayMode;
  String? description;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  int? status;

  RootCategory({
    this.id,
    this.name,
    this.slug,
    this.displayMode,
    this.description,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.status,
  });

  factory RootCategory.fromJson(Map<String, dynamic> json) =>
      _$RootCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$RootCategoryToJson(this);
}

@JsonSerializable()
class ShippingAddress {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? address1;
  String? country;
  String? countryName;
  String? state;
  String? city;
  String? postcode;
  String? phone;

  ShippingAddress({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.address1,
    this.country,
    this.countryName,
    this.state,
    this.city,
    this.postcode,
    this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}

@JsonSerializable()
class Items {
  String? id;
  String? sku;
  String? type;
  String? name;
  OrderListProduct? product;
  var weight;
  var totalWeight;
  int? qtyOrdered;
  int? qtyCanceled;
  int? qtyInvoiced;
  int? qtyShipped;
  int? qtyRefunded;
  var price;
  String? formatedPrice;
  var basePrice;
  String? formatedBasePrice;
  String? productId;
  var total;
  var formatedTotal;
  var baseTotal;
  var formatedBaseTotal;
  var totalInvoiced;
  int? formatedTotalInvoiced;
  var baseTotalInvoiced;
  int? formatedBaseTotalInvoiced;
  int? amountRefunded;
  int? formatedAmountRefunded;
  int? baseAmountRefunded;
  int? formatedBaseAmountRefunded;
  int? discountPercent;
  var discountAmount;
  var formatedDiscountAmount;
  var baseDiscountAmount;
  var formatedBaseDiscountAmount;
  var discountInvoiced;
  int? formatedDiscountInvoiced;
  int? baseDiscountInvoiced;
  int? formatedBaseDiscountInvoiced;
  int? discountRefunded;
  int? formatedDiscountRefunded;
  int? baseDiscountRefunded;
  int? formatedBaseDiscountRefunded;
  int? taxPercent;
  int? taxAmount;
  int? formatedTaxAmount;
  int? baseTaxAmount;
  int? formatedBaseTaxAmount;
  int? taxAmountInvoiced;
  int? formatedTaxAmountInvoiced;
  int? baseTaxAmountInvoiced;
  int? formatedBaseTaxAmountInvoiced;
  int? taxAmountRefunded;
  int? formatedTaxAmountRefunded;
  int? baseTaxAmountRefunded;
  int? formatedBaseTaxAmountRefunded;
  int? grantTotal;
  int? formatedGrantTotal;
  int? baseGrantTotal;
  int? formatedBaseGrantTotal;
  List<String>? downloadableLinks;

  // Additional? additional;

  Items({
    this.id,
    this.sku,
    this.type,
    this.name,
    this.productId,
    this.product,
    this.weight,
    this.totalWeight,
    this.qtyOrdered,
    this.qtyCanceled,
    this.qtyInvoiced,
    this.qtyShipped,
    this.qtyRefunded,
    this.price,
    this.formatedPrice,
    this.basePrice,
    this.formatedBasePrice,
    this.total,
    this.formatedTotal,
    this.baseTotal,
    this.formatedBaseTotal,
    this.totalInvoiced,
    this.formatedTotalInvoiced,
    this.baseTotalInvoiced,
    this.formatedBaseTotalInvoiced,
    this.amountRefunded,
    this.formatedAmountRefunded,
    this.baseAmountRefunded,
    this.formatedBaseAmountRefunded,
    this.discountPercent,
    this.discountAmount,
    this.formatedDiscountAmount,
    this.baseDiscountAmount,
    this.formatedBaseDiscountAmount,
    this.discountInvoiced,
    this.formatedDiscountInvoiced,
    this.baseDiscountInvoiced,
    this.formatedBaseDiscountInvoiced,
    this.discountRefunded,
    this.formatedDiscountRefunded,
    this.baseDiscountRefunded,
    this.formatedBaseDiscountRefunded,
    this.taxPercent,
    this.taxAmount,
    this.formatedTaxAmount,
    this.baseTaxAmount,
    this.formatedBaseTaxAmount,
    this.taxAmountInvoiced,
    this.formatedTaxAmountInvoiced,
    this.baseTaxAmountInvoiced,
    this.formatedBaseTaxAmountInvoiced,
    this.taxAmountRefunded,
    this.formatedTaxAmountRefunded,
    this.baseTaxAmountRefunded,
    this.formatedBaseTaxAmountRefunded,
    this.grantTotal,
    this.formatedGrantTotal,
    this.baseGrantTotal,
    this.formatedBaseGrantTotal,
    this.downloadableLinks,
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class OrderListProduct {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? urlKey;
  var price;
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

@JsonSerializable()
class Additional {
  var token;
  String? locale;
  var quantity;
  String? channelId;
  int? productId;
  String? sToken;

  Additional(
      {this.token,
      this.locale,
      this.quantity,
      this.channelId,
      this.productId,
      this.sToken});

  factory Additional.fromJson(Map<String, dynamic> json) =>
      _$AdditionalFromJson(json);

  Map<String, dynamic> toJson() => _$AdditionalToJson(this);
}
