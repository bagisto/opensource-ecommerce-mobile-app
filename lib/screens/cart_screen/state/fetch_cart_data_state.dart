/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import '../../../models/add_to_cart_model/add_to_cart_model.dart';
import '../../../models/cart_model/cart_data_model.dart';
import 'cart_screen_base_state.dart';

class FetchCartDataState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  CartModel? cartDetailsModel;
  int? index;

  FetchCartDataState.success({this.cartDetailsModel, this.index})
      : status = CartStatus.success;

  FetchCartDataState.fail({this.error}) : status = CartStatus.fail;

  List<Object?> get props =>
      [(cartDetailsModel != null) ? cartDetailsModel! : ""];
}

class MoveToCartState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  int? id;
  AddToCartModel? response;

  MoveToCartState.success({
    this.response,
    this.id,
  }) : status = CartStatus.success;

  MoveToCartState.fail({this.error}) : status = CartStatus.fail;

  List<Object?> get props => [];
}

class UpdateCartState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  AddToCartModel? cartDetailsModel;
  List<Map<dynamic, String>>? item;

  UpdateCartState.success({this.cartDetailsModel, this.item})
      : status = CartStatus.success;

  UpdateCartState.fail({this.error}) : status = CartStatus.fail;

  List<Object?> get props =>
      [(cartDetailsModel != null) ? cartDetailsModel! : ""];
}
