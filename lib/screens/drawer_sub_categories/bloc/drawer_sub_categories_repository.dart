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

abstract class DrawerSubCategoryRepository {
  Future<GetDrawerCategoriesData?> getDrawerSubCategories(
      {List<Map<String, dynamic>>? filters});
  Future<NewProductsModel?> callCategoriesData(
      {List<Map<String, dynamic>>? filters, int? page});
  Future<AddToCartModel?> callAddToCartAPi(int productId, int quantity);
  Future<AddWishListModel?> addItemToWishlist(String? wishListProductId);
  Future<BaseModel?> callAddToCompareListApi(String? productId);
  Future<AddToCartModel?> removeItemFromWishlist(String? wishListProductId);
}

class DrawerSubCategoryRepo implements DrawerSubCategoryRepository {
  @override
  Future<GetDrawerCategoriesData?> getDrawerSubCategories(
      {List<Map<String, dynamic>>? filters}) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData =
          await ApiClient().homeCategories(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return getDrawerCategoriesData;
  }

  @override
  Future<NewProductsModel?> callCategoriesData(
      {List<Map<String, dynamic>>? filters, int? page}) async {
    NewProductsModel? categoriesData;
    try {
      categoriesData = await ApiClient()
          .getAllProducts(filters: filters, page: page, limit: 3);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return categoriesData;
  }

  @override
  Future<AddToCartModel?> callAddToCartAPi(int productId, int quantity) async {
    AddToCartModel? addToCartModel;
    try {
      addToCartModel = await ApiClient().addToCart(
          quantity, productId.toString(), [], [], [], [], null, null);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return addToCartModel;
  }

  @override
  Future<AddWishListModel?> addItemToWishlist(var wishListProductId) async {
    AddWishListModel? addWishListModel;
    try {
      addWishListModel = await ApiClient().addToWishlist(wishListProductId);
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return addWishListModel;
  }

  @override
  Future<BaseModel?> callAddToCompareListApi(String? productId) async {
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().addToCompare(productId);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }

    return baseModel;
  }

  @override
  Future<AddToCartModel?> removeItemFromWishlist(
      String? wishListProductId) async {
    AddToCartModel? removeFromWishlist;
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
