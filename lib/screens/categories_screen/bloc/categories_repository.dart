/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/screens/categories_screen/utils/index.dart';

abstract class CategoriesRepository {
  Future<NewProductsModel?> callCategoriesData(
      {List<Map<String, dynamic>>? filters, int? page});
  Future<AddWishListModel?> callWishListDeleteItem(var wishListProductId);
  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity);
  Future<BaseModel> callAddToCompareListApi(int productId);
  Future<AddToCartModel> removeItemFromWishlist(var wishListProductId);
  Future<GetFilterAttribute> getFilterProducts(String categorySlug);
}

class CategoriesRepo implements CategoriesRepository {
  @override
  Future<NewProductsModel?> callCategoriesData(
      {List<Map<String, dynamic>>? filters, int? page}) async {
    NewProductsModel? categoriesData;
    try {
      categoriesData =
          await ApiClient().getAllProducts(filters: filters, page: page);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return categoriesData;
  }

  @override
  Future<GetFilterAttribute> getFilterProducts(String categorySlug) async {
    GetFilterAttribute? filterAttribute;
    try {
      filterAttribute = await ApiClient().getFilterAttributes(categorySlug);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return filterAttribute!;
  }

  @override
  Future<AddWishListModel?> callWishListDeleteItem(
      var wishListProductId) async {
    AddWishListModel? addWishListModel;
    try {
      addWishListModel =
          await ApiClient().addToWishlist(wishListProductId ?? "");
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return addWishListModel;
  }

  @override
  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity) async {
    AddToCartModel? graphQlBaseModel;

    graphQlBaseModel = await ApiClient()
        .addToCart(quantity, productId.toString(), [], [], [], [], null, null);

    return graphQlBaseModel!;
  }

  @override
  Future<BaseModel> callAddToCompareListApi(int productId) async {
    BaseModel? baseModel;
    baseModel = await ApiClient().addToCompare(productId.toString());
    return baseModel!;
  }

  @override
  Future<AddToCartModel> removeItemFromWishlist(var wishListProductId) async {
    AddToCartModel? removeFromWishlist;
    try {
      removeFromWishlist =
          await ApiClient().removeFromWishlist(wishListProductId);
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return removeFromWishlist!;
  }
}
