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

import '../../cart_screen/cart_model/cart_data_model.dart';
part 'save_payment_model.g.dart';

@JsonSerializable()
class SavePaymentModel {
  Data? data;
  SavePaymentModel({this.data});

  factory SavePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$SavePaymentModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SavePaymentModelToJson(this);
}
@JsonSerializable()
class Data {
  SavePayment? savePayment;

  Data({this.savePayment});
  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);

}

@JsonSerializable()
class SavePayment {
  String? success;
  String? jumpToSection;
  CartModel? cart;
  SavePayment({this.success,this.cart,this.jumpToSection});

  factory SavePayment.fromJson(Map<String, dynamic> json) =>
      _$SavePaymentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SavePaymentToJson(this);
}

