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


import 'package:flutter/material.dart';
import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/categories_data_model/filter_product_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../services/api_client.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../home_page/data_model/new_product_data.dart';

abstract class CategoriesRepository{
  Future<NewProductsModel?> callCategoriesData({List<Map<String, dynamic>>? filters, int? page});
  Future<AddWishListModel?> callWishListDeleteItem(var wishListProductId);
  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity);
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId);
  Future<GraphQlBaseModel> removeItemFromWishlist(var wishListProductId);
  Future<GetFilterAttribute> getFilterProducts(String categorySlug);

}
class CategoriesRepo implements CategoriesRepository {
  @override
  Future<NewProductsModel?> callCategoriesData({List<Map<String, dynamic>>? filters, int? page}) async {
    NewProductsModel? categoriesData;
    try{
      categoriesData = await ApiClient().getAllProducts(filters: filters, page: page);
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return categoriesData;
  }
  @override
  Future<GetFilterAttribute> getFilterProducts(String categorySlug) async {
    GetFilterAttribute? filterAttribute;
    try{
      filterAttribute=await ApiClient().getFilterAttributes(categorySlug);
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return filterAttribute!;
  }

  
  @override
  Future<AddWishListModel?> callWishListDeleteItem(
      var wishListProductId) async {

    AddWishListModel? addWishListModel;
    try {
      addWishListModel = await ApiClient().addToWishlist(wishListProductId??"");
    } catch (error, stacktrace) {
      print("Error -->${error.toString()}");
      print("StackTrace -->${stacktrace.toString()}");
    }
    return addWishListModel;
  }

  @override
  Future<AddToCartModel> callAddToCartAPi(
      int productId,int quantity ) async {
    AddToCartModel? graphQlBaseModel;

    graphQlBaseModel = await ApiClient().addToCart(quantity,productId.toString(),[] ,[],[],[],null);

    return graphQlBaseModel!;
  }

  @override
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId) async {
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient()
        .addToCompare(productId.toString());
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
