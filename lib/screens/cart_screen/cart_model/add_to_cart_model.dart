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
import 'package:json_annotation/json_annotation.dart';
import 'cart_data_model.dart';
part 'add_to_cart_model.g.dart';
@JsonSerializable()
class AddToCartModel extends BaseModel {
  CartModel? cart;
  AddToCartModel({this.cart});
  factory AddToCartModel.fromJson(Map<String, dynamic> json) {
    return _$AddToCartModelFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$AddToCartModelToJson(this);
}


