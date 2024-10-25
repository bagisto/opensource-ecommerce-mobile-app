/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/drawer_sub_categories/utils/index.dart';
import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../home_page/data_model/new_product_data.dart';

abstract class DrawerSubCategoriesState{}

enum Status {success, fail}

class DrawerSubCategoryInitialState extends DrawerSubCategoriesState {}

class FetchDrawerSubCategoryState extends DrawerSubCategoriesState {
  Status? status;
  String? error;
  GetDrawerCategoriesData? getCategoriesData;

  FetchDrawerSubCategoryState.success({this.getCategoriesData}) : status = Status.success;

  FetchDrawerSubCategoryState.fail({this.error}) : status = Status.fail;
}

class FetchCategoryProductsState extends DrawerSubCategoriesState {
  Status? status;
  String? error;
  NewProductsModel? categoriesData;

  FetchCategoryProductsState.success({this.categoriesData}) : status = Status.success;

  FetchCategoryProductsState.fail({this.error}) : status = Status.fail;
}

class AddWishlistState extends DrawerSubCategoriesState {
  Status? status;
  String? message = "";
  AddWishListModel? response;

  AddWishlistState.success({this.response, this.message}) : status = Status.success;
  AddWishlistState.fail({this.message}) : status = Status.fail;
}

class RemoveWishlistState extends DrawerSubCategoriesState {
  Status? status;
  String? message = "";
  AddToCartModel? response;

  RemoveWishlistState.success(
      {this.response, this.message}) : status = Status.success;
  RemoveWishlistState.fail({this.message}) : status = Status.fail;
}

class AddToCompareState extends DrawerSubCategoriesState {
  Status? status;
  String? successMsg;
  BaseModel? baseModel;

  AddToCompareState.success({this.successMsg, this.baseModel})
      : status = Status.success;
  AddToCompareState.fail({this.successMsg}) : status = Status.fail;
}

class AddToCartState extends DrawerSubCategoriesState {
  Status? status;
  String? successMsg;
  AddToCartModel? graphQlBaseModel;

  AddToCartState.success({this.graphQlBaseModel, this.successMsg})
      : status = Status.success;
  AddToCartState.fail({this.successMsg}) : status = Status.fail;
}
