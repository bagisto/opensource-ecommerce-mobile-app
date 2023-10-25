

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable
import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/screens/wishList/state/wishlist_base_state.dart';

class FetchDeleteAddItemState extends WishListBaseState{
  WishListStatus? status;
  String? successMsg;
  String? error;
  GraphQlBaseModel? response;
  var producDeletedId;
  FetchDeleteAddItemState.success({this.response, this.producDeletedId,this.successMsg}):status=WishListStatus.success;
  FetchDeleteAddItemState.fail({this.error}):status=WishListStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [producDeletedId,status!];

}


class RemoveAllWishlistProductState extends WishListBaseState{
  WishListStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  RemoveAllWishlistProductState.success({ this.successMsg,this.baseModel}):status=WishListStatus.success;
  RemoveAllWishlistProductState.fail({this.error}):status=WishListStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}