/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../data_model/theme_customization.dart';
import 'package:bagisto_app_demo/screens/home_page/utils/index.dart';

abstract class HomePageBaseState {}

enum Status { success, fail, loading }

class OnClickLoaderState extends HomePageBaseState {
  final bool? isReqToShowLoader;

  OnClickLoaderState({this.isReqToShowLoader});
}

class ShowLoaderState extends HomePageBaseState {}

class HideLoaderState extends HomePageBaseState {}

class FetchHomeCustomDataState extends HomePageBaseState {
  Status? status;
  String? error;
  ThemeCustomDataModel? homepageSliders;
  int? index;

  FetchHomeCustomDataState.success({this.homepageSliders, this.index})
      : status = Status.success;

  FetchHomeCustomDataState.fail({this.error}) : status = Status.fail;
}

class FetchAllProductsState extends HomePageBaseState {
  Status? status;
  String? error;
  NewProductsModel? allProducts;
  int? index;

  FetchAllProductsState.success({this.allProducts, this.index})
      : status = Status.success;

  FetchAllProductsState.fail({this.error}) : status = Status.fail;
}

class FetchCartCountState extends HomePageBaseState {
  Status? status;
  String? error;
  CartModel? cartDetails;

  FetchCartCountState.success({
    this.cartDetails,
  }) : status = Status.success;

  FetchCartCountState.fail({this.error}) : status = Status.fail;
}

class CustomerDetailsState extends HomePageBaseState {
  Status? status;
  String? error;
  String? successMsg;
  AccountInfoModel? accountInfoDetails;

  CustomerDetailsState.success({this.accountInfoDetails, this.successMsg})
      : status = Status.success;

  CustomerDetailsState.fail({this.error}) : status = Status.fail;
}

class FetchAddWishlistHomepageState extends HomePageBaseState {
  Status? status;
  String? successMsg = "";
  String? error = "";
  AddWishListModel? response;
  String? productDeletedId;

  FetchAddWishlistHomepageState.success(
      {this.response, this.productDeletedId, this.successMsg})
      : status = Status.success;
  FetchAddWishlistHomepageState.fail({this.error}) : status = Status.fail;
}

class RemoveWishlistState extends HomePageBaseState {
  Status? status;
  String? successMsg = "";
  String? error = "";
  AddToCartModel? response;
  String? productDeletedId;

  RemoveWishlistState.success(
      {this.response, this.productDeletedId, this.successMsg})
      : status = Status.success;
  RemoveWishlistState.fail({this.error}) : status = Status.fail;
}

class AddToCompareHomepageState extends HomePageBaseState {
  Status? status;
  String? error;
  String? successMsg;
  BaseModel? baseModel;

  AddToCompareHomepageState.success({this.successMsg, this.baseModel})
      : status = Status.success;
  AddToCompareHomepageState.fail({this.error}) : status = Status.fail;
}

class AddToCartState extends HomePageBaseState {
  Status? status;
  String? error;
  String? successMsg;
  AddToCartModel? graphQlBaseModel;

  AddToCartState.success({this.graphQlBaseModel, this.successMsg})
      : status = Status.success;
  AddToCartState.fail({this.error}) : status = Status.fail;
}

class FetchHomeCategoriesState extends HomePageBaseState {
  Status? status;
  String? error;
  GetDrawerCategoriesData? getCategoriesData;
  int? index;

  FetchHomeCategoriesState.success({this.getCategoriesData, this.index})
      : status = Status.success;

  FetchHomeCategoriesState.fail({this.error}) : status = Status.fail;
}

class FetchCMSDataState extends HomePageBaseState {
  Status? status;
  String? error;
  CmsData? cmsData;

  FetchCMSDataState.success({this.cmsData}) : status = Status.success;

  FetchCMSDataState.fail({this.error}) : status = Status.fail;
}

class SubscribeNewsLetterState extends HomePageBaseState {
  Status? status;
  String? error;
  BaseModel? baseModel;

  SubscribeNewsLetterState.success({this.baseModel}) : status = Status.success;
  SubscribeNewsLetterState.fail({this.error, this.baseModel})
      : status = Status.fail;
}
