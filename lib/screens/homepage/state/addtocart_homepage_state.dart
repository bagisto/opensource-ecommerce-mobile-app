/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables


import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';

import 'hoempage_base_state.dart';



class AddToCartState extends HomePageBaseState{
  Status? status;
  String? error;
  String? successMsg;
  AddToCartModel? graphQlBaseModel;
// var cartProductId;
  AddToCartState.success({this.graphQlBaseModel, this.successMsg}):status=Status.success;
  AddToCartState.fail({this.error}):status=Status.fail;

  // TODO: implement props
  List<Object> get props => [status??"",successMsg??"",error??""];

}