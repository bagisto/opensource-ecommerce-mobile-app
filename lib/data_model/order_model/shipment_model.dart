
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'order_detail_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shipment_model.g.dart';

@JsonSerializable()
class ShipmentModel extends GraphQlBaseModel{
  @JsonKey(name: "data")
  List<ViewShipments>? viewShipments;

  ShipmentModel({this.viewShipments});

  factory ShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShipmentModelToJson(this);
}

@JsonSerializable()
class ViewShipments {
  int? id;
  dynamic status;
  int? totalQty;
  int? totalWeight;
  dynamic carrierCode;
  String? carrierTitle;
  String? trackNumber;
  int? emailSent;
  int? customerId;
  String? customerType;
  int? orderId;
  int? orderAddressId;
  String? createdAt;
  String? updatedAt;
  int? inventorySourceId;
  String? inventorySourceName;
  Order? order;
  List<ItemsModel>? items;
  InventorySource? inventorySource;
  Customer? customer;

  ViewShipments(
      {this.id,
        this.status,
        this.totalQty,
        this.totalWeight,
        this.carrierCode,
        this.carrierTitle,
        this.trackNumber,
        this.emailSent,
        this.customerId,
        this.customerType,
        this.orderId,
        this.orderAddressId,
        this.createdAt,
        this.updatedAt,
        this.inventorySourceId,
        this.inventorySourceName,
        this.order,
        this.items,
        this.inventorySource,
        this.customer});

  factory ViewShipments.fromJson(Map<String, dynamic> json) =>
      _$ViewShipmentsFromJson(json);

  Map<String, dynamic> toJson() => _$ViewShipmentsToJson(this);
}

@JsonSerializable()
class Order {
  int? id;
  String? incrementId;
  String? status;
  String? channelName;
  int? isGuest;
  String? customerEmail;
  String? customerFirstName;
  String? customerLastName;
  dynamic customerCompanyName;
  dynamic customerVatId;
  String? shippingMethod;
  String? shippingTitle;
  String? shippingDescription;
  dynamic couponCode;
  int? isGift;
  int? totalItemCount;
  int? totalQtyOrdered;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? orderCurrencyCode;
  double? grandTotal;
  double? baseGrandTotal;
  double? grandTotalInvoiced;
  double? baseGrandTotalInvoiced;
  double? grandTotalRefunded;
  double? baseGrandTotalRefunded;
  double? subTotal;
  double? baseSubTotal;
  double? subTotalInvoiced;
  double? baseSubTotalInvoiced;
  double? subTotalRefunded;
  double? baseSubTotalRefunded;
  double? discountPercent;
  double? discountAmount;
  double? baseDiscountAmount;
  double? discountInvoiced;
  double? baseDiscountInvoiced;
  double? discountRefunded;
  double? baseDiscountRefunded;
  double? taxAmount;
  double? baseTaxAmount;
  double? taxAmountInvoiced;
  double? baseTaxAmountInvoiced;
  double? taxAmountRefunded;
  double? baseTaxAmountRefunded;
  double? shippingAmount;
  double? baseShippingAmount;
  double? shippingInvoiced;
  double? baseShippingInvoiced;
  double? shippingRefunded;
  double? baseShippingRefunded;
  int? customerId;
  String? customerType;
  int? channelId;
  String? channelType;
  String? cartId;
  String? appliedCartRuleIds;
  int? shippingDiscountAmount;
  int? baseShippingDiscountAmount;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.id,
        this.incrementId,
        this.status,
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
        this.updatedAt});

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class ItemsModel {
  int? id;
  String? name;
  dynamic description;
  String? sku;
  int? qty;
  int? weight;
  double? price;
  double? basePrice;
  double? total;
  double? baseTotal;
  String? productId;
  String? productType;
  String? orderItemId;
  String? shipmentId;
  Additional? additional;
  String? createdAt;
  String? updatedAt;
  OrderProduct? product;

  ItemsModel(
      {this.id,
        this.name,
        this.description,
        this.sku,
        this.qty,
        this.weight,
        this.price,
        this.basePrice,
        this.total,
        this.baseTotal,
        this.productId,
        this.productType,
        this.orderItemId,
        this.shipmentId,
        this.additional,
        this.createdAt,
        this.updatedAt, this.product});

  factory ItemsModel.fromJson(Map<String, dynamic> json) =>
      _$ItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsModelToJson(this);
}

@JsonSerializable()
class InventorySource {
  String? id;
  String? code;
  String? name;
  dynamic description;
  String? contactName;
  String? contactEmail;
  String? contactNumber;
  dynamic contactFax;
  String? country;
  String? state;
  String? city;
  String? street;
  String? postcode;
  int? priority;
  dynamic latitude;
  dynamic longitude;

  InventorySource(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.contactName,
        this.contactEmail,
        this.contactNumber,
        this.contactFax,
        this.country,
        this.state,
        this.city,
        this.street,
        this.postcode,
        this.priority,
        this.latitude,
        this.longitude});

  factory InventorySource.fromJson(Map<String, dynamic> json) =>
      _$InventorySourceFromJson(json);

  Map<String, dynamic> toJson() => _$InventorySourceToJson(this);
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
  dynamic notes;
  bool? status;
  CustomerGroup? customerGroup;
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
        this.customerGroup,
        this.createdAt,
        this.updatedAt});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class CustomerGroup {
  String? id;
  String? name;
  String? code;
  bool? isUserDefined;
  dynamic createdAt;
  dynamic updatedAt;

  CustomerGroup(
      {this.id,
        this.name,
        this.code,
        this.isUserDefined,
        this.createdAt,
        this.updatedAt});

  factory CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerGroupToJson(this);
}
