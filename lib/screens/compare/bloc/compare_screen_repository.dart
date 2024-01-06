/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:flutter/material.dart';

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../services/api_client.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../data_model/compare_product_model.dart';

abstract class CompareScreenRepository{
  Future<CompareProductsData> callCompareApi();
  Future<GraphQlBaseModel> removeFromCompareList(int productId);
  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity);
  Future<AddWishListModel?> callWishListAddDeleteItem(var wishListProductId);
  Future<GraphQlBaseModel> removeItemFromWishlist(var wishListProductId);
  Future<GraphQlBaseModel> removeAllCompareProducts();

}
class CompareScreenRepositoryImp implements CompareScreenRepository {
  @override
  Future<CompareProductsData> callCompareApi() async {
    CompareProductsData? compareScreenModel;
    try{
      compareScreenModel=await ApiClient().getCompareProducts();
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return compareScreenModel!;
  }

  @override
  Future<GraphQlBaseModel> removeFromCompareList(int productId)async{
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient().removeFromCompare(productId);

    return baseModel!;
  }

  @override
  Future<AddToCartModel> callAddToCartAPi(int productId,int quantity ) async {
    AddToCartModel? graphQlBaseModel;
    graphQlBaseModel = await ApiClient().addToCart(quantity,productId.toString(),[] ,[],[],[],null);

    return graphQlBaseModel!;
  }
  ///WISHLIST ITEM DELETE/ADD API CALL///
//
  @override
  Future<AddWishListModel?> callWishListAddDeleteItem(
      var wishListProductId) async {
    AddWishListModel? addWishListModel;
    try {
      addWishListModel = await ApiClient().addToWishlist(wishListProductId ?? "");
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return addWishListModel;
  }

  @override
  Future<GraphQlBaseModel> removeItemFromWishlist(var wishListProductId) async {
    GraphQlBaseModel? removeFromWishlist;
    try{
      removeFromWishlist=await ApiClient().removeFromWishlist(wishListProductId.toString());

    }catch(error, stacktrace){
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${ stacktrace.toString()}");
    }
    return removeFromWishlist!;
  }

  @override
  Future<GraphQlBaseModel> removeAllCompareProducts()async{
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient().removeAllCompareProducts();

    return baseModel!;
  }

}
