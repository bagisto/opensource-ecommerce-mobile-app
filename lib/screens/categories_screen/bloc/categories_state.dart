/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/categories_data_model/filter_product_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../home_page/data_model/new_product_data.dart';

abstract class CategoriesBaseState extends Equatable {}

enum CategoriesStatus { success, fail }

class ShowLoaderCategoryState extends CategoriesBaseState {
  @override
  List<Object> get props => [];
}

class OnClickSubCategoriesLoaderState extends CategoriesBaseState {
  final bool? isReqToShowLoader;

  OnClickSubCategoriesLoaderState({this.isReqToShowLoader});

  @override
  List<Object> get props => [isReqToShowLoader!];
}
class FilterFetchState extends CategoriesBaseState {
  final CategoriesStatus? status;
  final String? error;
  final GetFilterAttribute? filterModel;

  FilterFetchState.success({this.error, this.filterModel})
      : status = CategoriesStatus.success;

  FilterFetchState.fail({this.filterModel, this.error}) : status = CategoriesStatus.fail;

  @override
  List<Object> get props => [if (filterModel != null) filterModel! else ""];
}

class FetchSubCategoryState extends CategoriesBaseState {

  CategoriesStatus? status;
  String? error;
  NewProductsModel? categoriesData;

  FetchSubCategoryState.success({this.categoriesData}) : status = CategoriesStatus.success;

  FetchSubCategoryState.fail({this.error}) : status = CategoriesStatus.fail;

  @override
  List<Object> get props => [if (categoriesData !=null) categoriesData! else ""];
}

class AddToCompareSubCategoryState extends CategoriesBaseState{
  CategoriesStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  AddToCompareSubCategoryState.success({ this.successMsg,this.baseModel}):status=CategoriesStatus.success;
  AddToCompareSubCategoryState.fail({this.error}):status=CategoriesStatus.fail;

  @override
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}

class AddToCartSubCategoriesState extends CategoriesBaseState{
  CategoriesStatus? status;
  String? error;
  String? successMsg;
  AddToCartModel? response;
  AddToCartSubCategoriesState.success({this.response, this.successMsg}):status=CategoriesStatus.success;
  AddToCartSubCategoriesState.fail({this.error}):status=CategoriesStatus.fail;

  @override
  List<Object> get props => [status!,successMsg!,error??"",response!];

}

class FetchDeleteAddItemCategoryState extends CategoriesBaseState{
  CategoriesStatus? status;
  String? successMsg="";
  String? error="";
  AddWishListModel? response;
  String? productDeletedId;
  FetchDeleteAddItemCategoryState.success({this.response, this.productDeletedId,this.successMsg}):status=CategoriesStatus.success;
  FetchDeleteAddItemCategoryState.fail({this.error}):status=CategoriesStatus.fail;

  @override
  List<Object> get props => [productDeletedId ?? "",status!,successMsg!,error!];

}


class RemoveWishlistState extends CategoriesBaseState{
  CategoriesStatus? status;
  String? successMsg="";
  String? error="";
  GraphQlBaseModel? response;
  String? productDeletedId;
  RemoveWishlistState.success({this.response, this.productDeletedId,this.successMsg}):status=CategoriesStatus.success;
  RemoveWishlistState.fail({this.error}):status=CategoriesStatus.fail;

  @override
  List<Object> get props => [productDeletedId ?? 0,status!,successMsg ?? "",error ?? ""];

}