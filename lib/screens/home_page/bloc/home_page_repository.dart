/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/home_page/utils/index.dart';

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../data_model/theme_customization.dart';

abstract class HomePageRepository {
  Future<AddToCartModel?> callAddToCartAPi(int productId, int quantity);
  Future<AddWishListModel?> addItemToWishlist(String? wishListProductId);
  Future<BaseModel?> callLogoutApi();
  Future<BaseModel?> callAddToCompareListApi(String? productId);
  Future<ThemeCustomDataModel?> getThemeCustomizationData();
  Future<CartModel?> cartCountApi();
  Future<CmsData?> callCmsData(String id);
  Future<AddToCartModel?> removeItemFromWishlist(String? wishListProductId);
  Future<AccountInfoModel?> callAccountDetailsApi();
  Future<NewProductsModel?> getAllProducts(
      {List<Map<String, dynamic>>? filters});
  Future<GetDrawerCategoriesData?> getHomeCategoriesList(
      {List<Map<String, dynamic>>? filters});
  Future<BaseModel?> subscribeNewsletter(String email);
}

class HomePageRepositoryImp implements HomePageRepository {
  @override
  Future<GetDrawerCategoriesData?> getHomeCategoriesList(
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
  Future<AddToCartModel?> callAddToCartAPi(int productId, int quantity) async {
    AddToCartModel? addToCartModel;
    addToCartModel = await ApiClient()
        .addToCart(quantity, productId.toString(), [], [], [], [], null, null);

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

  ///Log Out Api
  @override
  Future<BaseModel?> callLogoutApi() async {
    BaseModel? response;
    try {
      response = await ApiClient().customerLogout();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return response;
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
  Future<ThemeCustomDataModel?> getThemeCustomizationData() async {
    ThemeCustomDataModel? homeSlidersData;
    try {
      homeSlidersData = await ApiClient().getThemeCustomizationData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return homeSlidersData;
  }

  @override
  Future<CartModel?> cartCountApi() async {
    CartModel? cartDetails;
    try {
      cartDetails = await ApiClient().getCartCount();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return cartDetails;
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

  @override
  Future<AccountInfoModel?> callAccountDetailsApi() async {
    AccountInfoModel? accountInfoDetails;
    try {
      accountInfoDetails = await ApiClient().getCustomerData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return accountInfoDetails;
  }

  //todo
  @override
  Future<NewProductsModel?> getAllProducts(
      {List<Map<String, dynamic>>? filters}) async {
    NewProductsModel? newProductsData;
    try {
      newProductsData = await ApiClient().getAllProducts(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return newProductsData;
  }

  @override
  Future<CmsData?> callCmsData(String id) async {
    CmsData? cmsData;
    try {
      cmsData = await ApiClient().getCmsPagesData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return cmsData;
  }

  @override
  Future<BaseModel?> subscribeNewsletter(String email) async{
    BaseModel? model;
    try {
      model = await ApiClient().subscribeNewsletter(email);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return model;
  }
}
