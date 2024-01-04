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

import '../../../data_model/graphql_base_model.dart';
import '../../../services/api_client.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../data_model/wishlist_model.dart';

abstract class WishListRepository {
  Future<WishListData?> callWishListApi();
  Future<GraphQlBaseModel?> callWishListDeleteItem(var wishListProductId);
  Future<AddToCartModel?> callAddToCartAPi(int productId);
  Future<GraphQlBaseModel?> removeAllWishListProducts();
}

class WishListRepositoryImp implements WishListRepository {
  @override
  Future<WishListData?> callWishListApi() async {
    WishListData? wishListData;
    try {
      wishListData = await ApiClient().getWishList();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return wishListData;
  }

  @override
  Future<GraphQlBaseModel?> callWishListDeleteItem(
      var wishListProductId) async {
    GraphQlBaseModel? removeFromWishlist;
    try {
      removeFromWishlist =
          await ApiClient().removeFromWishlist(wishListProductId);
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return removeFromWishlist;
  }

  @override
  Future<AddToCartModel?> callAddToCartAPi(int productId) async {
    AddToCartModel? baseModel;
    try {
      baseModel = await ApiClient().moveFromWishlistToCart(
        productId,
      );
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return baseModel;
  }

  @override
  Future<GraphQlBaseModel?> removeAllWishListProducts() async {
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient().removeAllWishlistProducts();

    return baseModel;
  }
}
