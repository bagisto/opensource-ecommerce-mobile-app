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


import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/models/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:flutter/material.dart';

import '../../../api/api_client.dart';
import '../../../models/product_model/product_screen_model.dart' as product;

abstract class ProductScreenRepository{
  Future<product.Product> callProductData(int productId);
  Future<AddToCartModel> callAddToCartAPi(int quantity,int productId,List downloadLinks,List groupedParams,List bundleParams,List configurableParams,var configurableId);
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId,);
  Future<AddWishListModel?> callWishListDeleteItem(var wishListProductId);
  Future<GraphQlBaseModel> removeItemFromWishlist(var wishListProductId);
}
class ProductScreenRepositoryImp implements ProductScreenRepository {
  @override
  Future<product.Product> callProductData(int productId) async {
    product. Product? productData;
    try {
      productData = await ApiClient().getProductDetail(productId);
    }
    catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return productData!;
  }

    @override
    Future<AddToCartModel> callAddToCartAPi(int quantity,int productId,List downloadLinks,List groupedParams,List bundleParams,List configurableParams,var configurableId)async{
      AddToCartModel? addToCartModel;
      addToCartModel = await ApiClient().addToCart(quantity,productId, downloadLinks, groupedParams,bundleParams, configurableParams, configurableId??null );

      return addToCartModel!;
    }



  @override
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId) async {
    GraphQlBaseModel? baseModel;


    baseModel = await ApiClient()
        .addToCompare(productId, );

    return baseModel!;
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
