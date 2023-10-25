


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

import 'package:bagisto_app_demo/models/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/screens/product_screen/state/product_base_state.dart';

import '../../../base_model/graphql_base_model.dart';

class AddToWishListProductState extends ProductBaseState{
  ProductStatus? status;
  String? successMsg="";
  String? error="";
  AddWishListModel? response;
  var producDeletedId;
  AddToWishListProductState.success({this.response, this.producDeletedId,this.successMsg}):status=ProductStatus.success;
  AddToWishListProductState.fail({this.error}):status=ProductStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [producDeletedId,status!,successMsg!,error!];

}



class RemoveFromWishlistState extends ProductBaseState{
  ProductStatus? status;
  String? successMsg="";
  String? error="";
  GraphQlBaseModel? response;
  var producDeletedId;
  RemoveFromWishlistState.success({this.response, this.producDeletedId,this.successMsg}):status=ProductStatus.success;
  RemoveFromWishlistState.fail({this.error}):status=ProductStatus.fail;

  // TODO: implement props
  @override
  List<Object> get props => [producDeletedId,status!,successMsg!,error!];

}