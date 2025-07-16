/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/compare/utils/index.dart';

abstract class CompareScreenRepository {
  Future<CompareProductsData> callCompareApi(int? page, int? limit);
  Future<BaseModel> removeFromCompareList(int productId);
  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity);
  Future<AddWishListModel?> callWishListAddDeleteItem(var wishListProductId);
  Future<AddToCartModel> removeItemFromWishlist(var wishListProductId);
  Future<BaseModel> removeAllCompareProducts();
}

class CompareScreenRepositoryImp implements CompareScreenRepository {
  @override
  Future<CompareProductsData> callCompareApi(page, limit) async {
    CompareProductsData? compareScreenModel;
    try {
      compareScreenModel = await ApiClient().getCompareProducts(page, limit);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return compareScreenModel!;
  }

  @override
  Future<BaseModel> removeFromCompareList(int productId) async {
    BaseModel? baseModel;
    baseModel = await ApiClient().removeFromCompare(productId);

    return baseModel!;
  }

  @override
  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity) async {
    AddToCartModel? graphQlBaseModel;
    graphQlBaseModel = await ApiClient()
        .addToCart(quantity, productId.toString(), [], [], [], [], null, null);

    return graphQlBaseModel!;
  }

  ///WISHLIST ITEM DELETE/ADD API CALL///
//
  @override
  Future<AddWishListModel?> callWishListAddDeleteItem(
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
  Future<AddToCartModel> removeItemFromWishlist(var wishListProductId) async {
    AddToCartModel? removeFromWishlist;
    try {
      removeFromWishlist =
          await ApiClient().removeFromWishlist(wishListProductId.toString());
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return removeFromWishlist!;
  }

  @override
  Future<BaseModel> removeAllCompareProducts() async {
    BaseModel? baseModel;
    baseModel = await ApiClient().removeAllCompareProducts();

    return baseModel!;
  }
}
