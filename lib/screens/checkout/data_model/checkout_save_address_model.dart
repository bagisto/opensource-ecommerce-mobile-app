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

import '../../../data_model/graphql_base_error_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
part 'checkout_save_address_model.g.dart';

@JsonSerializable()
class CheckOutSaveAddressDataModel extends GraphQlBaseModel{
  Data? data;
  CheckOutSaveAddressDataModel({this.data});

  factory CheckOutSaveAddressDataModel.fromJson(Map<String, dynamic> json) =>
      _$CheckOutSaveAddressDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CheckOutSaveAddressDataModelToJson(this);

}
@JsonSerializable()
class Data {
  SaveCheckoutAddresses? saveCheckoutAddresses;

  Data({this.saveCheckoutAddresses});

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
@JsonSerializable()
class SaveCheckoutAddresses  extends GraphQlBaseErrorModel{

  @override
  String? success;
  String? cartTotal;
  int? cartCount;
  List<ShippingMethods>? shippingMethods;
  Payment? paymentMethods;
  String? jumpToSection;
  CartModel? cart;

  SaveCheckoutAddresses(
      {this.success,
        this.cartTotal,
        this.cartCount,
        this.shippingMethods,
        this.paymentMethods,
        this.jumpToSection,this.cart});

  factory SaveCheckoutAddresses.fromJson(Map<String, dynamic> json) =>
      _$SaveCheckoutAddressesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SaveCheckoutAddressesToJson(this);
}
@JsonSerializable()
class ShippingMethods {
  String? title;
  Methods? methods;

  ShippingMethods({this.title, this.methods});
  factory ShippingMethods.fromJson(Map<String, dynamic> json) =>
      _$ShippingMethodsFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingMethodsToJson(this);

}
@JsonSerializable()
class Methods {
  String? code;
  String? label;
  int? price;
  String? formattedPrice;
  int? basePrice;
  String? formattedBasePrice;

  Methods(
      {this.code,
        this.label,
        this.price,
        this.formattedPrice,
        this.basePrice,
        this.formattedBasePrice});

  factory Methods.fromJson(Map<String, dynamic> json) =>
      _$MethodsFromJson(json);

  Map<String, dynamic> toJson() => _$MethodsToJson(this);
}

@JsonSerializable()
class Payment {
  int? id;
  String ?method;
  String? methodTitle;

  Payment({this.id, this.method, this.methodTitle});

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaymentToJson(this);
}


