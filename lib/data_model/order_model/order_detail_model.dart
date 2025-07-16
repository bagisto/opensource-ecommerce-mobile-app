/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_error_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../screens/cart_screen/cart_model/cart_data_model.dart';
import '../product_model/product_screen_model.dart';

part 'order_detail_model.g.dart';

@JsonSerializable()
class OrderDetail extends GraphQlBaseErrorModel {
  FormattedPrice? formattedPrice;
  int? id;
  String? incrementId;
  String? status;
  String? shippingTitle;
  String? createdAt;
  // String? updatedAt;
  BillingAddress? billingAddress;
  BillingAddress? shippingAddress;
  List<Items>? items;
  Payment? payment;

  // List<String>? shipments;

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  OrderDetail(
      {this.id,
      this.incrementId,
      this.shippingTitle,
      this.status,
      this.createdAt,
      this.billingAddress,
      this.shippingAddress,
      this.items,
      this.payment,
      this.formattedPrice});

  @override
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
  String? id;
  String? firstName;
  String? lastName;
  String? companyName;
  @JsonKey(name: "address")
  String? address1;
  String? postcode;
  String? city;
  String? state;
  String? country;
  // String? email;
  String? phone;

  BillingAddress({
    this.id,
    this.firstName,
    this.lastName,
    this.companyName,
    this.postcode,
    this.city,
    this.state,
    this.country,
    // this.email,
    this.phone,
  });

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
  int? qtyOrdered;
  int? qtyShipped;
  int? qtyInvoiced;
  int? qtyCanceled;
  int? qtyRefunded;
  // String? productId;
  OrderProduct? product;
  FormattedPrice? formattedPrice;
  dynamic additional;

  Items(
      {this.id,
      this.sku,
      this.type,
      this.name,
      this.qtyOrdered,
      this.qtyShipped,
      this.qtyInvoiced,
      this.qtyCanceled,
      this.qtyRefunded,
      this.product,
      this.additional});

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class OrderProduct {
  String? id;
  String? sku;
  // String? name;
  List<Images>? images;

  OrderProduct({
    this.id,
    this.sku,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}

@JsonSerializable()
class SuperAttributes {
  // int? attributeId;
  // int? optionId;

  SuperAttributes();
  factory SuperAttributes.fromJson(Map<String, dynamic> json) {
    return _$SuperAttributesFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SuperAttributesToJson(this);
}

@JsonSerializable()
class Options {
  String? id;
  // String? label;
  // String? swatchType;
  // String? swatchValue;
  // bool? isSelect = false;

  Options({this.id});

  factory Options.fromJson(Map<String, dynamic> json) =>
      _$OptionsFromJson(json);

  Map<String, dynamic> toJson() => _$OptionsToJson(this);
}
