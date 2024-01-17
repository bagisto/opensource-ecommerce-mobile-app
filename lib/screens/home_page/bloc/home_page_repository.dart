import 'package:flutter/material.dart';
import '../../../data_model/account_models/account_info_details.dart';
import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../services/api_client.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../data_model/advertisement_data.dart';
import '../data_model/get_categories_drawer_data_model.dart';
import '../data_model/new_product_data.dart';
import '../data_model/theme_customization.dart';

abstract class HomePageRepository {
  Future<AddToCartModel?> callAddToCartAPi(int productId, int quantity); //
  Future<AddWishListModel?> addItemToWishlist(String? wishListProductId);
  Future<GraphQlBaseModel?> callLogoutApi();
  Future<GraphQlBaseModel?> callAddToCompareListApi(String? productId);
  Future<ThemeCustomDataModel?> getThemeCustomizationData(); //
  Future<Advertisements?> cartCountApi();
  Future<GraphQlBaseModel?>  removeItemFromWishlist(String? wishListProductId);
  Future<AccountInfoDetails?> callAccountDetailsApi(); //
  Future<NewProductsModel?> getAllProducts(
      {List<Map<String, dynamic>>? filters});
  Future<GetDrawerCategoriesData?> getHomeCategoriesList(
      {List<Map<String, dynamic>>? filters});

}

class HomePageRepositoryImp implements HomePageRepository {

  @override
  Future<GetDrawerCategoriesData?> getHomeCategoriesList(
      {List<Map<String, dynamic>>? filters}) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData = await ApiClient().homeCategories(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return getDrawerCategoriesData;
  }

  @override
  Future<AddToCartModel?> callAddToCartAPi(
      int productId,int quantity ) async {
    AddToCartModel? addToCartModel;
    addToCartModel = await ApiClient().addToCart(quantity,productId.toString(),[] ,[],[],[],null);

    return addToCartModel;
  }


  @override
  Future<AddWishListModel?> addItemToWishlist(
      var wishListProductId) async {

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
  Future<GraphQlBaseModel?> callLogoutApi() async {
    GraphQlBaseModel? response;
    try {
      response = await ApiClient().customerLogout();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return response;
  }

  @override
  Future<GraphQlBaseModel?> callAddToCompareListApi(String? productId) async {
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
  Future<Advertisements?> cartCountApi() async {
    Advertisements? advertisementData;
    try {
      advertisementData = await ApiClient().getCartCount();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return advertisementData;
  }


  @override
  Future<GraphQlBaseModel?> removeItemFromWishlist(String? wishListProductId) async {

    GraphQlBaseModel? removeFromWishlist;
    try{
      removeFromWishlist=await ApiClient().removeFromWishlist(wishListProductId);

    }catch(error, stacktrace){
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${ stacktrace.toString()}");
    }
    return removeFromWishlist;
  }
  @override
  Future<AccountInfoDetails?> callAccountDetailsApi() async {

    AccountInfoDetails? accountInfoDetails;
    try{
      accountInfoDetails = await ApiClient().getCustomerData();
    }catch(error, stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return accountInfoDetails;
  }

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
}