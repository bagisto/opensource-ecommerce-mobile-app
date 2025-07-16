/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:json_annotation/json_annotation.dart';

import '../../../data_model/graphql_base_model.dart';
import '../../product_screen/data_model/product_details_model.dart';

part 'cart_data_model.g.dart';

@JsonSerializable()
class CartModel extends BaseModel {
  String? id;
  String? couponCode;
  int? itemsCount;
  int? itemsQty;
  double? grandTotal;
  dynamic taxTotal;
  FormattedPrice? formattedPrice;
  List<Items>? items;
  ShippingAddress? shippingAddress;
  ShippingAddress? billingAddress;
  SelectedShippingRate? selectedShippingRate;
  Payment? payment;
  List<AppliedTaxRate>? appliedTaxRates;

  CartModel(
      {this.items,
      this.id,
      this.couponCode,
      this.itemsCount,
      this.itemsQty,
      this.taxTotal,
      this.appliedTaxRates,
      this.formattedPrice,
      this.shippingAddress,
      this.billingAddress,
      this.selectedShippingRate,
      this.payment,
      this.grandTotal});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return _$CartModelFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}

@JsonSerializable()
class AppliedTaxRate {
  @JsonKey(name: "taxName")
  String taxName;
  @JsonKey(name: "totalAmount")
  String totalAmount;

  AppliedTaxRate({
    required this.taxName,
    required this.totalAmount,
  });

  factory AppliedTaxRate.fromJson(Map<String, dynamic> json) =>
      _$AppliedTaxRateFromJson(json);

  Map<String, dynamic> toJson() => _$AppliedTaxRateToJson(this);
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
class Items {
  String? id;
  String? type;
  String? name;
  // String? appliedTaxRate;
  int? quantity;
  double? price;
  // String? productId;
  dynamic additional;
  Product? product;
  FormattedPrice? formattedPrice;

  Items(
      {this.id,
      this.quantity,
      this.type,
      this.name,
      this.additional,
      this.product,
      this.formattedPrice,
      this.price});

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class ShippingAddress {
  String? id;
  @JsonKey(name: "address")
  String? address1;
  String? postcode;
  String? city;
  String? state;
  String? country;
  String? phone;

  ShippingAddress({
    this.id,
    this.address1,
    this.postcode,
    this.city,
    this.state,
    this.country,
    this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return _$ShippingAddressFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}

@JsonSerializable()
class SelectedShippingRate {
  String? id;
  String? methodTitle;
  FormattedPrice? formattedPrice;

  SelectedShippingRate({this.id, this.methodTitle, this.formattedPrice});

  factory SelectedShippingRate.fromJson(Map<String, dynamic> json) {
    return _$SelectedShippingRateFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SelectedShippingRateToJson(this);
}

@JsonSerializable()
class FormattedPrice {
  dynamic price;
  dynamic total;
  dynamic baseTotal;
  dynamic discountAmount;
  dynamic taxAmount;
  String? grandTotal;
  String? subTotal;
  String? shippingAmount;
  dynamic taxTotal;
  String? adjustmentFee;
  String? adjustmentRefund;

  FormattedPrice(
    this.grandTotal,
    this.subTotal,
    this.discountAmount,
    this.taxAmount,
    this.shippingAmount,
    this.price,
    this.total,
    this.taxTotal,
    this.baseTotal,
    this.adjustmentFee,
    this.adjustmentRefund,
  );

  factory FormattedPrice.fromJson(Map<String, dynamic> json) {
    return _$FormattedPriceFromJson(json);
  }
  Map<String, dynamic> toJson() => _$FormattedPriceToJson(this);
}
