/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print


import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/models/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:flutter/material.dart';

import '../../../api/api_client.dart';
import '../../../base_model/graphql_base_model.dart';
import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../models/categories_data_model/filter_product_model.dart';

abstract class SubCategoriesRepository{
  Future<CategoriesProductModel> callCategoriesData(String categorySlug,String order,String sort,int page,List filter);
  Future<AddWishListModel?> callWishListDeleteItem(var wishListProductId);
  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity);
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId);
  Future<GraphQlBaseModel> removeItemFromWishlist(var wishListProductId);
  Future<GetFilterAttribute> getFilterProducts(String categorySlug);

}
class SubCategoriesRepositoryImp implements SubCategoriesRepository {
  @override
  Future<CategoriesProductModel> callCategoriesData(String categorySlug,String order,String sort,int page,List filter) async {
    CategoriesProductModel? categoriesData;
    try{
      categoriesData=await ApiClient().getCategoriesProduct(categorySlug,"", order, sort,page, filter);
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return categoriesData!;
  }
  @override
  Future<GetFilterAttribute> getFilterProducts(String categorySlug) async {
    GetFilterAttribute? filterAttribute;
    try{
      filterAttribute=await ApiClient().getFilterProducts(categorySlug);
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return filterAttribute!;
  }

  ///WISHLIST ITEM DELETE/ADD API CALL///
//
  @override
  Future<AddWishListModel?> callWishListDeleteItem(
      var wishListProductId) async {

    AddWishListModel? addWishListModel;
    try {
      addWishListModel = await ApiClient().addToWishlist(int.parse(wishListProductId??""));
    } catch (error, stacktrace) {
      print("Error -->${error.toString()}");
      print("StackTrace -->${stacktrace.toString()}");
    }
    return addWishListModel;
  }

  @override
  Future<AddToCartModel> callAddToCartAPi(
      int productId,int quantity /*Map<String, dynamic> params*/) async {
    AddToCartModel? graphQlBaseModel;

    graphQlBaseModel = await ApiClient().addToCart(quantity,productId,[] ,[],[],[],null);

    return graphQlBaseModel!;
  }

  @override
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId) async {
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient()
        .addToCompare(productId, );

    return baseModel!;
  }


  @override
  Future<GraphQlBaseModel> removeItemFromWishlist(var wishListProductId) async {
    GraphQlBaseModel? removeFromWishlist;
    try{
      removeFromWishlist=await ApiClient().removeFromWishlist(wishListProductId);

    }catch(error, stacktrace){
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${ stacktrace.toString()}");
    }
    return removeFromWishlist!;
  }

}
