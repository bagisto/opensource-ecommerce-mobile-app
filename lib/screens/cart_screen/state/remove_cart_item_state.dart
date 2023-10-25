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

import '../../../base_model/graphql_base_model.dart';
import 'cart_screen_base_state.dart';

class RemoveCartItemState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  GraphQlBaseModel? removeCartProductModel;
  var productDeletedId;

  RemoveCartItemState.success(
      {this.removeCartProductModel, this.productDeletedId})
      : status = CartStatus.success;

  RemoveCartItemState.fail({this.error}) : status = CartStatus.fail;

  // TODO: implement props
  List<Object> get props => [
        if (removeCartProductModel != null) removeCartProductModel! else "",
        productDeletedId
      ];
}

class RemoveAllCartItemState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  GraphQlBaseModel? removeAllCartProductModel;

  RemoveAllCartItemState.success({this.removeAllCartProductModel})
      : status = CartStatus.success;

  RemoveAllCartItemState.fail({this.error}) : status = CartStatus.fail;

  List<Object> get props => [
        if (removeAllCartProductModel != null)
          removeAllCartProductModel!
        else
          ""
      ];
}
