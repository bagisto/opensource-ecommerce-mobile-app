
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */



import '../../../data_model/graphql_base_model.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../data_model/wishlist_model.dart';

abstract class WishListBaseState {}

enum WishListStatus { success, fail }

class FetchDataState extends WishListBaseState {
  WishListStatus? status;
  String? error;
  WishListData? wishListProducts;

  FetchDataState.success({this.wishListProducts}) : status = WishListStatus.success;

  FetchDataState.fail({this.error}) : status = WishListStatus.fail;
}

class AddToCartWishlistState extends WishListBaseState{
  WishListStatus? status;
  String? error;
  String? successMsg;
  AddToCartModel? response;
  var cartProductId;
  AddToCartWishlistState.success({this.response, this.successMsg,this.cartProductId}):status=WishListStatus.success;
  AddToCartWishlistState.fail({this.error}):status=WishListStatus.fail;

}

class OnClickWishListLoaderState extends WishListBaseState {
  final bool? isReqToShowLoader;
  OnClickWishListLoaderState({this.isReqToShowLoader});

}

class ShowLoaderWishListState extends WishListBaseState {
}

class FetchDeleteAddItemState extends WishListBaseState{
  WishListStatus? status;
  String? successMsg;
  String? error;
  GraphQlBaseModel? response;
  var producDeletedId;
  FetchDeleteAddItemState.success({this.response, this.producDeletedId,this.successMsg}):status=WishListStatus.success;
  FetchDeleteAddItemState.fail({this.error}):status=WishListStatus.fail;

}


class RemoveAllWishlistProductState extends WishListBaseState{
  WishListStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  RemoveAllWishlistProductState.success({ this.successMsg,this.baseModel}):status=WishListStatus.success;
  RemoveAllWishlistProductState.fail({this.error}):status=WishListStatus.fail;

}