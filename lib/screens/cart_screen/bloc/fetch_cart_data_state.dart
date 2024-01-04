/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import '../cart_model/add_to_cart_model.dart';
import '../cart_model/apply_coupon.dart';
import '../cart_model/cart_data_model.dart';

abstract class CartScreenBaseState {}
enum CartStatus { success, fail }

class ShowLoaderCartState extends CartScreenBaseState {}

class AddCouponState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  ApplyCoupon? baseModel;
  String? successMsg;

  AddCouponState.success({this.baseModel, this.successMsg})
      : status = CartStatus.success;

  AddCouponState.fail({this.error}) : status = CartStatus.fail;

}

class RemoveCouponCartState extends CartScreenBaseState {

  CartStatus? status;
  String? error;
  ApplyCoupon? baseModel;
  String?successMsg;

  RemoveCouponCartState.success({this.baseModel,this.successMsg}) : status = CartStatus.success;
  RemoveCouponCartState.fail({this.error}) : status = CartStatus.fail;

}


class RemoveCartItemState extends CartScreenBaseState {

  CartStatus? status;
  String? error;
  AddToCartModel? removeCartProductModel;
  var productDeletedId;

  RemoveCartItemState.success({this.removeCartProductModel,this.productDeletedId}) : status = CartStatus.success;
  RemoveCartItemState.fail({this.error}) : status = CartStatus.fail;

}
class RemoveAllCartItemState extends CartScreenBaseState {

  CartStatus? status;
  String? error;
  GraphQlBaseModel? removeAllCartProductModel;

  RemoveAllCartItemState.success({this.removeAllCartProductModel}) : status = CartStatus.success;
  RemoveAllCartItemState.fail({this.error}) : status = CartStatus.fail;

}

class FetchCartDataState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  CartModel? cartDetailsModel;
  int? index;

  FetchCartDataState.success({this.cartDetailsModel, this.index})
      : status = CartStatus.success;

  FetchCartDataState.fail({this.error}) : status = CartStatus.fail;


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

}

class UpdateCartState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  AddToCartModel? cartDetailsModel;
  List<Map<dynamic, String>>? item;

  UpdateCartState.success({this.cartDetailsModel, this.item})
      : status = CartStatus.success;

  UpdateCartState.fail({this.error}) : status = CartStatus.fail;

}
