/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../home_page/data_model/new_product_data.dart';

abstract class ProductBaseState {}

enum ProductStatus { success, fail }

class ProductInitialState extends ProductBaseState {}

class OnClickProductLoaderState extends ProductBaseState {
  final bool? isReqToShowLoader;

  OnClickProductLoaderState({this.isReqToShowLoader});
}

class FetchProductState extends ProductBaseState {
  ProductStatus? status;
  String? error;
  NewProducts? productData;

  FetchProductState.success({this.productData}) : status = ProductStatus.success;

  FetchProductState.fail({this.error}) : status = ProductStatus.fail;
}

class AddToWishListProductState extends ProductBaseState{
  ProductStatus? status;
  String? successMsg="";
  String? error ="";
  AddWishListModel? response;
  String? productDeletedId;
  AddToWishListProductState.success({this.response, this.productDeletedId,this.successMsg}):status=ProductStatus.success;
  AddToWishListProductState.fail({this.error}):status=ProductStatus.fail;

}



class RemoveFromWishlistState extends ProductBaseState{
  ProductStatus? status;
  String? successMsg="";
  String? error="";
  GraphQlBaseModel? response;
  String? productDeletedId;
  RemoveFromWishlistState.success({this.response, this.productDeletedId,this.successMsg}):status=ProductStatus.success;
  RemoveFromWishlistState.fail({this.error}):status=ProductStatus.fail;

}

class AddToCompareListState extends ProductBaseState{
  ProductStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  AddToCompareListState.success({ this.successMsg,this.baseModel}):status=ProductStatus.success;
  AddToCompareListState.fail({this.error}):status=ProductStatus.fail;
}

class AddToCartProductState extends ProductBaseState{
  ProductStatus? status;
  String? error;
  String? successMsg;
  AddToCartModel? response;
  AddToCartProductState.success({this.response, this.successMsg}):status=ProductStatus.success;
  AddToCartProductState.fail({this.error}):status=ProductStatus.fail;

}

