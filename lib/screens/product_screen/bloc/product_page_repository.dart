/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';

abstract class ProductScreenRepository {
  Future<NewProductsModel?> getProductDetails(
      List<Map<String, dynamic>>? filters);

  Future<AddToCartModel?> callAddToCartAPi(
      int quantity,
      String productId,
      List downloadLinks,
      List groupedParams,
      List bundleParams,
      List configurableParams,
      String? configurableId);

  Future<GraphQlBaseModel?> callAddToCompareListApi(
    String productId,
  );

  Future<AddWishListModel?> callWishListDeleteItem(String wishListProductId);

  Future<GraphQlBaseModel?> removeItemFromWishlist(String wishListProductId);
}

class ProductScreenRepo implements ProductScreenRepository {
  @override
  Future<NewProductsModel?> getProductDetails(
      List<Map<String, dynamic>>? filters) async {
    NewProductsModel? productData;
    try {
      productData = await ApiClient().getAllProducts(filters: filters);
      debugPrint("productData ${productData?.toJson()}");
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return productData;
  }

  @override
  Future<AddToCartModel?> callAddToCartAPi(
      int quantity,
      String productId,
      List downloadLinks,
      List groupedParams,
      List bundleParams,
      List configurableParams,
      String? configurableId) async {
    AddToCartModel? addToCartModel;

    try {
      addToCartModel = await ApiClient().addToCart(
          quantity,
          productId,
          downloadLinks,
          groupedParams,
          bundleParams,
          configurableParams,
          configurableId);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return addToCartModel;
  }

  @override
  Future<GraphQlBaseModel?> callAddToCompareListApi(String productId) async {
    GraphQlBaseModel? baseModel;

    try {
      baseModel = await ApiClient().addToCompare(productId);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }

    return baseModel;
  }

  @override
  Future<AddWishListModel?> callWishListDeleteItem(
      String wishListProductId) async {
    AddWishListModel? addWishListModel;
    try {
      addWishListModel = await ApiClient().addToWishlist(wishListProductId);
    } catch (error, stacktrace) {
      debugPrint("Error -->$error");
      debugPrint("StackTrace -->$stacktrace");
    }
    return addWishListModel;
  }

  @override
  Future<GraphQlBaseModel?> removeItemFromWishlist(
      String wishListProductId) async {
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
}
