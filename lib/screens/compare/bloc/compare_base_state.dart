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
import '../data_model/compare_product_model.dart';

abstract class CompareScreenBaseState {}

enum CompareStatusStatus { success, fail }

class AddToCartCompareState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? error;
  String? successMsg;
  AddToCartModel? response;
  String? cartProductId;
  AddToCartCompareState.success({this.response, this.successMsg,this.cartProductId}):status=CompareStatusStatus.success;
  AddToCartCompareState.fail({this.error}):status=CompareStatusStatus.fail;

}

class AddToWishlistCompareState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? successMsg="";
  String? error="";
  AddWishListModel? response;
  String? productDeletedId;

  AddToWishlistCompareState.success({this.response, this.productDeletedId,this.successMsg}):status=CompareStatusStatus.success;
  AddToWishlistCompareState.fail({this.error}):status=CompareStatusStatus.fail;


}

class RemoveFromWishlistState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? successMsg="";
  String? error="";
  GraphQlBaseModel? response;
  String? productDeletedId;
  RemoveFromWishlistState.success({this.response, this.productDeletedId,this.successMsg}):status=CompareStatusStatus.success;
  RemoveFromWishlistState.fail({this.error}):status=CompareStatusStatus.fail;


}

class RemoveFromCompareState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  String? productDeletedId;
  RemoveFromCompareState.success({ this.successMsg,this.baseModel,this.productDeletedId}):status=CompareStatusStatus.success;
  RemoveFromCompareState.fail({this.error}):status=CompareStatusStatus.fail;

}

class RemoveAllCompareProductState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  RemoveAllCompareProductState.success({ this.successMsg,this.baseModel}):status=CompareStatusStatus.success;
  RemoveAllCompareProductState.fail({this.error}):status=CompareStatusStatus.fail;

}

class CompareScreenFetchDataState extends CompareScreenBaseState {

  CompareStatusStatus? status;
  String? error;
  CompareProductsData? compareScreenModel;

  CompareScreenFetchDataState.success({this.compareScreenModel}) : status = CompareStatusStatus.success;

  CompareScreenFetchDataState.fail({this.error}) : status = CompareStatusStatus.fail;

}

class CompareScreenInitialState extends CompareScreenBaseState {
}

class OnClickCompareLoaderState extends CompareScreenBaseState {
  final bool? isReqToShowLoader;

  OnClickCompareLoaderState({this.isReqToShowLoader});

}
