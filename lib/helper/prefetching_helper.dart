/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


//mobikul  pre-cache for category and subcategory

import 'package:flutter/material.dart';

import '../api/api_client.dart';

Future preCacheCategoryPage(String categorySlug,String order,String sort,int page,List filter) async {

  try{
    await ApiClient().getCategoriesProduct(categorySlug,"", order, sort,page, filter);
  }
  catch(error,stacktrace){
    debugPrint("Error --> $error");
    debugPrint("StackTrace --> $stacktrace");
  }
}

//mobikul  pre-cache for catalog products
/*
Future preCacheGetCatalogProducts(CatalogProductRequest request) async {

  try{
    Map<String, String>? sort;
    await ApiClient().getProductCollectionData(request.type??"", request.id??"", request.page??1, request.filterData??[], request.sortData);
  }
  catch(error,stacktrace){
    print("Error --> $error");
    print("StackTrace --> $stacktrace");
  }
}
*/

//mobikul  pre-cache for product page data
Future preCacheProductPage(int id) async {
  try{
    await ApiClient().getProductDetail(id);
  }
  catch(error,stacktrace){
    debugPrint("Error --> $error");
    debugPrint("StackTrace --> $stacktrace");
  }
}

//mobikul  pre-cache homepage data
Future preCacheAdvertisements() async {

  try{
    await ApiClient().getAdvertisements();
  }
  catch(error,stacktrace){
    debugPrint("Error --> $error");
    debugPrint("StackTrace --> $stacktrace");
  }
}

// mobikul  pre-cache banner data
Future preCacheBannerData() async {
  try{
    await ApiClient().getHomePageSliders();
  }
  catch(error,stacktrace){
    debugPrint("Error --> $error");
    debugPrint("StackTrace --> $stacktrace");
  }
}
