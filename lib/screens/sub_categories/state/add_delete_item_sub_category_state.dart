


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
import 'package:bagisto_app_demo/screens/sub_categories/state/sub_categories_base_state.dart';

import '../../../base_model/graphql_base_model.dart';

class FetchDeleteAddItemCategoryState extends SubCategoriesBaseState{
  CategoriesStatus? status;
  String? successMsg="";
  String? error="";
  AddWishListModel? response;
  var producDeletedId;
  FetchDeleteAddItemCategoryState.success({this.response, this.producDeletedId,this.successMsg}):status=CategoriesStatus.success;
  FetchDeleteAddItemCategoryState.fail({this.error}):status=CategoriesStatus.fail;

  @override
  List<Object> get props => [producDeletedId,status!,successMsg!,error!];

}


class RemoveWishlistState extends SubCategoriesBaseState{
  CategoriesStatus? status;
  String? successMsg="";
  String? error="";
  GraphQlBaseModel? response;
  var producDeletedId;
  RemoveWishlistState.success({this.response, this.producDeletedId,this.successMsg}):status=CategoriesStatus.success;
  RemoveWishlistState.fail({this.error}):status=CategoriesStatus.fail;

  @override
  List<Object> get props => [producDeletedId,status!,successMsg!,error!];

}