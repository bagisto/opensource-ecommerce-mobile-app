/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names



import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:flutter/material.dart';

import '../../../api/api_client.dart';
import '../../../models/wishlist_model/wishlist_model.dart';

abstract class WishListRepository{
  Future<WishListData>callWishListApi();
  Future<GraphQlBaseModel>  callWishListDeleteItem(var wishListProductId);
  Future<AddToCartModel> callAddToCartAPi(int productId);
  Future<GraphQlBaseModel> removeAllWishListProducts();
  Future<ShareWishlistData> shareWishlist(bool shared);
}
class WishListRepositoryImp implements WishListRepository {


  ///WISHLIST ITEM LIST API CALL///

  @override
  Future<WishListData> callWishListApi() async {
    WishListData? wishListData;
    try {
      wishListData = await ApiClient().getWishList();
    }catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return wishListData!;
  }


  ///WISHLIST ITEM DELETE/ADD API CALL///
//
  @override
  Future<GraphQlBaseModel> callWishListDeleteItem(var wishListProductId) async {
    GraphQlBaseModel? removeFromWishlist;
    try{
      removeFromWishlist=await ApiClient().removeFromWishlist(int.parse(wishListProductId));

    }catch(error, stacktrace){
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${ stacktrace.toString()}");
    }
return removeFromWishlist!;
  }


  ///add to cart
  @override
  Future<AddToCartModel> callAddToCartAPi(int productId)async{
    AddToCartModel? baseModel;
    try{
      baseModel = await ApiClient().moveToCart(productId,);

    }catch(error, stacktrace){
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${ stacktrace.toString()}");
    }
    return baseModel!;
  }


  @override
  Future<GraphQlBaseModel> removeAllWishListProducts()async{
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient().removeAllWishlistProducts();

    return baseModel!;
  }
@override
  Future<ShareWishlistData> shareWishlist(bool shared)async{
  ShareWishlistData? baseModel;
  try{
    baseModel = await ApiClient().shareWishlist(shared);

  }catch(error, stacktrace){
    debugPrint("Error -->${error.toString()}");
    debugPrint("StackTrace -->${ stacktrace.toString()}");
  }
  return baseModel!;
  }

}