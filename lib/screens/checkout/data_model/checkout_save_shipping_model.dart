
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
import '../../cart_screen/cart_model/cart_data_model.dart';

part 'checkout_save_shipping_model.g.dart';

class CheckoutSaveShippingModel {
  Data? data;

  CheckoutSaveShippingModel({this.data});


}

class Data {
  PaymentMethods? paymentMethods;
  Data({this.paymentMethods});


}

@JsonSerializable()
class PaymentMethods extends GraphQlBaseErrorModel{
  @override
  String? success;
  String? cartTotal;
  int? cartCount;
  @JsonKey(name:"paymentMethods")
  List<PaymentMethodsList>? paymentMethods;
  CartModel? cart;

  PaymentMethods(
      {this.success, this.cartTotal, this.cartCount, this.paymentMethods,});

  factory PaymentMethods.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaymentMethodsToJson(this);

}
@JsonSerializable()
class PaymentMethodsList {
  String? method;
  String? methodTitle;
  String? description;
  int? sort;

  PaymentMethodsList({this.method, this.methodTitle, this.description, this.sort});

  factory PaymentMethodsList.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodsListFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodsListToJson(this);

}
