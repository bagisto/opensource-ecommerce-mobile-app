/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_error_model.dart';
import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../screens/cart_screen/cart_model/cart_data_model.dart';
import '../product_model/product_screen_model.dart';
part 'order_detail_model.g.dart';

@JsonSerializable()
class OrderDetailModel extends GraphQlBaseModel {
  Data? data;

  OrderDetailModel({this.data});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailModelToJson(this);
}

@JsonSerializable()
class Data {
  OrderDetail? orderDetail;

  Data({this.orderDetail});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class OrderDetail extends GraphQlBaseErrorModel {
  FormattedPrice? formattedPrice;
  int? id;
  String? incrementId;
  String? status;
  String? channelName;
  int? isGuest;
  String? customerEmail;
  String? customerFirstName;
  String? customerLastName;
  String? customerCompanyName;
  String? customerVatId;
  String? shippingMethod;
  String? shippingTitle;
  String? shippingDescription;
  String? couponCode;
  int? isGift;
  int? totalItemCount;
  int? totalQtyOrdered;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? orderCurrencyCode;
  var grandTotal;
  var baseGrandTotal;
  var grandTotalInvoiced;
  var baseGrandTotalInvoiced;
  var grandTotalRefunded;
  var baseGrandTotalRefunded;
  var subTotal;
  var baseSubTotal;
  var subTotalInvoiced;
  var baseSubTotalInvoiced;
  var subTotalRefunded;
  var baseSubTotalRefunded;
  var discountPercent;
  var discountAmount;
  var baseDiscountAmount;
  var discountInvoiced;
  var baseDiscountInvoiced;
  var discountRefunded;
  var baseDiscountRefunded;
  var taxAmount;
  var baseTaxAmount;
  var taxAmountInvoiced;
  var baseTaxAmountInvoiced;
  var taxAmountRefunded;
  var baseTaxAmountRefunded;
  var shippingAmount;
  var baseShippingAmount;
  var shippingInvoiced;
  var baseShippingInvoiced;
  var shippingRefunded;
  var baseShippingRefunded;
  var customerId;
  String? customerType;
  int? channelId;
  String? channelType;
  String? cartId;
  String? appliedCartRuleIds;
  int? shippingDiscountAmount;
  int? baseShippingDiscountAmount;
  String? createdAt;
  String? updatedAt;
  BillingAddress? billingAddress;
  BillingAddress? shippingAddress;
  List<Items>? items;
  Payment? payment;

  // List<String>? shipments;

  OrderDetail(
      {this.id,
      this.incrementId,
      this.channelName,
      this.isGuest,
      this.customerEmail,
      this.customerFirstName,
      this.customerLastName,
      this.customerCompanyName,
      this.customerVatId,
      this.shippingMethod,
      this.shippingTitle,
      this.shippingDescription,
      this.couponCode,
      this.isGift,
      this.totalItemCount,
      this.totalQtyOrdered,
      this.baseCurrencyCode,
      this.channelCurrencyCode,
      this.orderCurrencyCode,
      this.grandTotal,
      this.baseGrandTotal,
      this.grandTotalInvoiced,
      this.baseGrandTotalInvoiced,
      this.grandTotalRefunded,
      this.baseGrandTotalRefunded,
      this.subTotal,
      this.baseSubTotal,
      this.subTotalInvoiced,
      this.baseSubTotalInvoiced,
      this.subTotalRefunded,
      this.baseSubTotalRefunded,
      this.discountPercent,
      this.discountAmount,
      this.baseDiscountAmount,
      this.discountInvoiced,
      this.baseDiscountInvoiced,
      this.discountRefunded,
      this.baseDiscountRefunded,
      this.taxAmount,
      this.baseTaxAmount,
      this.taxAmountInvoiced,
      this.baseTaxAmountInvoiced,
      this.taxAmountRefunded,
      this.baseTaxAmountRefunded,
      this.shippingAmount,
      this.baseShippingAmount,
      this.shippingInvoiced,
      this.baseShippingInvoiced,
      this.shippingRefunded,
      this.baseShippingRefunded,
      this.customerId,
      this.customerType,
      this.channelId,
      this.channelType,
      this.cartId,
      this.appliedCartRuleIds,
      this.shippingDiscountAmount,
      this.baseShippingDiscountAmount,
      this.createdAt,
      this.updatedAt,
      this.billingAddress,
      this.shippingAddress,
      this.items,
      this.payment,
      this.formattedPrice});

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}

@JsonSerializable()
class Payment {
  String? id;
  String? method;
  String? methodTitle;

  Payment({this.id, this.method, this.methodTitle});

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class BillingAddress {
  int? id;
  String? customerId;
  String? cartId;
  int? orderId;
  String? firstName;
  String? lastName;
  String? gender;
  String? companyName;
  String? address1;
  String? address2;
  String? postcode;
  String? city;
  String? state;
  String? country;
  String? email;
  String? phone;
  String? vatId;
  int? defaultAddress;

  BillingAddress(
      {this.id,
      this.customerId,
      this.cartId,
      this.orderId,
      this.firstName,
      this.lastName,
      this.gender,
      this.companyName,
      this.address1,
      this.address2,
      this.postcode,
      this.city,
      this.state,
      this.country,
      this.email,
      this.phone,
      this.vatId,
      this.defaultAddress});

  factory BillingAddress.fromJson(Map<String, dynamic> json) =>
      _$BillingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$BillingAddressToJson(this);
}

@JsonSerializable()
class Items {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? couponCode;
  double? weight;
  double? totalWeight;
  int? qtyOrdered;
  int? qtyShipped;
  int? qtyInvoiced;
  int? qtyCanceled;
  int? qtyRefunded;
  int? quantity;
  var price;
  var basePrice;
  var total;
  var baseTotal;
  var totalInvoiced;
  var baseTotalInvoiced;
  var amountRefunded;
  var baseAmountRefunded;
  var discountPercent;
  var discountAmount;
  var baseDiscountAmount;
  var discountInvoiced;
  var baseDiscountInvoiced;
  var discountRefunded;
  var baseDiscountRefunded;
  var taxPercent;
  var taxAmount;
  var baseTaxAmount;
  var taxAmountInvoiced;
  var baseTaxAmountInvoiced;
  var taxAmountRefunded;
  var baseTaxAmountRefunded;
  String? productId;
  String? productType;
  String? orderId;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  OrderProduct? product;
  FormattedPrice? formattedPrice;

  // List<String>? invoiceItems;
  // List<String>? shipmentItems;
  // List<String>? refundItems;

  Items({
    this.id,
    this.sku,
    this.quantity,
    this.type,
    this.name,
    this.couponCode,
    this.weight,
    this.totalWeight,
    this.qtyOrdered,
    this.qtyShipped,
    this.qtyInvoiced,
    this.qtyCanceled,
    this.qtyRefunded,
    this.price,
    this.basePrice,
    this.total,
    this.baseTotal,
    this.totalInvoiced,
    this.baseTotalInvoiced,
    this.amountRefunded,
    this.baseAmountRefunded,
    this.discountPercent,
    this.discountAmount,
    this.baseDiscountAmount,
    this.discountInvoiced,
    this.baseDiscountInvoiced,
    this.discountRefunded,
    this.baseDiscountRefunded,
    this.taxPercent,
    this.taxAmount,
    this.baseTaxAmount,
    this.taxAmountInvoiced,
    this.baseTaxAmountInvoiced,
    this.taxAmountRefunded,
    this.baseTaxAmountRefunded,
    this.productId,
    this.productType,
    this.orderId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class OrderProduct {
  String? id;
  String? type;
  var attributeFamilyId;
  String? sku;
  String? name;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  List<Images>? images;
  List<ProductFlats>? productFlats;

  OrderProduct(
      {this.id,
      this.type,
      this.attributeFamilyId,
      this.sku,
      this.name,
      this.parentId,
      this.createdAt,
      this.updatedAt,
      this.productFlats});

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}

// @JsonSerializable()
// class Images{
//   String? id;
//   String? type;
//   String? path;
//   String? url;
//   String? productId;
//   Images({this.id,this.type,this.productId,this.path,this.url});
//
//   factory Images.fromJson(Map<String, dynamic> json) =>
//       _$ImagesFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ImagesToJson(this);
//
//
// }

@JsonSerializable()
class Child {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? couponCode;
  int? weight;
  int? totalWeight;
  int? qtyOrdered;
  int? qtyShipped;
  int? qtyInvoiced;
  int? qtyCanceled;
  int? qtyRefunded;
  int? price;
  int? basePrice;
  int? total;
  int? baseTotal;
  int? totalInvoiced;
  int? baseTotalInvoiced;

  Child({
    this.id,
    this.sku,
    this.type,
    this.name,
    this.couponCode,
    this.weight,
    this.totalWeight,
    this.qtyOrdered,
    this.qtyShipped,
    this.qtyInvoiced,
    this.qtyCanceled,
    this.qtyRefunded,
    this.price,
    this.basePrice,
    this.total,
    this.baseTotal,
    this.totalInvoiced,
    this.baseTotalInvoiced,
  });

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  Map<String, dynamic> toJson() => _$ChildToJson(this);
}
