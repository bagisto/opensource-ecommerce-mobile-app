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

import 'package:bagisto_app_demo/api/api_client.dart';
import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/models/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/models/currency_language_model.dart';
import 'package:bagisto_app_demo/models/homepage_model/advertisement_data.dart';
import 'package:flutter/material.dart';
import '../../../models/cms_model/cms_model.dart';
import '../../../models/homepage_model/home_sliders_model.dart';
import '../../../models/homepage_model/new_product_data.dart';

abstract class HomePageRepository {

  Future<AddToCartModel> callAddToCartAPi(int productId, int quantity);
  Future<AddWishListModel?> callWishListDeleteItem(var wishListProductId);
  Future<GraphQlBaseModel> callLogoutApi();
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId);
  Future<HomeSlidersData> homePageSlider();
  Future<Advertisements> advertisementsApi();
  Future<Advertisements> cartCountApi();
  Future<NewProductsModel?> newProductApi();
  Future<NewProductsModel?> featuredProduct();
  Future<CurrencyLanguageList> getLanguageCurrencyList();
  Future<GraphQlBaseModel>  removeItemFromWishlist(int wishListProductId);
  Future<CmsData> callCmsData(String id);
}

class HomePageRepositoryImp implements HomePageRepository {
  @override
  Future<AddToCartModel> callAddToCartAPi(
      int productId,int quantity ) async {
    AddToCartModel? addToCartModel;
    addToCartModel = await ApiClient().addToCart(quantity,productId,[] ,[],[],[],null);

    return addToCartModel!;
  }

  ///WISHLIST ITEM DELETE/ADD API CALL///
//
  @override
  Future<AddWishListModel?> callWishListDeleteItem(
      var wishListProductId) async {
    AddWishListModel? addWishListModel;
    try {
      addWishListModel = await ApiClient().addToWishlist(wishListProductId);
    } catch (error, stacktrace) {
      print("Error -->${error.toString()}");
      print("StackTrace -->${stacktrace.toString()}");
    }
    return addWishListModel;
  }

  ///Log Out Api
  @override
  Future<GraphQlBaseModel> callLogoutApi() async {
    GraphQlBaseModel? response;
    try {
      response = await ApiClient().customerLogout();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return response!;
  }

  @override
  Future<GraphQlBaseModel> callAddToCompareListApi(int productId) async {
    GraphQlBaseModel? baseModel;

    baseModel = await ApiClient()
        .addToCompare(productId, );

    return baseModel!;
  }

  @override
  Future<HomeSlidersData> homePageSlider() async {
    HomeSlidersData? homeSlidersData;
    try {
      homeSlidersData = await ApiClient().getHomePageSliders();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return homeSlidersData!;
  }

  @override
  Future<Advertisements> advertisementsApi() async {
    Advertisements? advertisementData;
    try {
      advertisementData = await ApiClient().getAdvertisements();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return advertisementData!;
  }
  @override
  Future<Advertisements> cartCountApi() async {
    Advertisements? advertisementData;
    try {
      advertisementData = await ApiClient().getCartCount();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return advertisementData!;
  }

  @override
  Future<NewProductsModel?> newProductApi() async {
    NewProductsModel? newProductsData;
    try {
      newProductsData = await ApiClient().getNewProducts();
      debugPrint("New Products Data---->${newProductsData?.toJson()}");
    } catch (error, stacktrace) {
      debugPrint("New Products Data---Error->${newProductsData?.toJson()}");
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return newProductsData;
  }


  @override
  Future<NewProductsModel?> featuredProduct() async {
    NewProductsModel? newProductsData;
    try {
      newProductsData = await ApiClient().getFeaturedProducts();
      debugPrint("New Products Data---featuredProduct->${newProductsData?.toJson()}");
    } catch (error, stacktrace) {
      debugPrint("New Products Data---Error->${newProductsData?.toJson()}");
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return newProductsData;
  }

  @override
  Future<CurrencyLanguageList> getLanguageCurrencyList() async {
    CurrencyLanguageList? currencyLanguageList;
    try {
      currencyLanguageList = await ApiClient().getLanguageCurrency();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return currencyLanguageList!;
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

  @override
  Future<CmsData> callCmsData(String id) async {
    CmsData? cmsData;

    try{
      cmsData=await ApiClient().getCmsData( );
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return cmsData!;
  }
}
