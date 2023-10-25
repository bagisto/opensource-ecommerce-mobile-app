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
import 'package:bagisto_app_demo/models/wishlist_model/wishlist_model.dart';
import 'package:bagisto_app_demo/screens/wishList/state/wishlist_base_state.dart';

class AddToCartWishlistState extends WishListBaseState{
  WishListStatus? status;
  String? error;
  String? successMsg;
  AddToCartModel? response;
var cartProductId;
  AddToCartWishlistState.success({this.response, this.successMsg,this.cartProductId}):status=WishListStatus.success;
  AddToCartWishlistState.fail({this.error}):status=WishListStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [];

}
class ShareWishlistState extends WishListBaseState{
  WishListStatus? status;
  String? error;
  String? successMsg;
  ShareWishlistData? response;
   bool ? shared;
  ShareWishlistState.success({this.response, this.successMsg,this.shared}):status=WishListStatus.success;
  ShareWishlistState.fail({this.error}):status=WishListStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [];

}