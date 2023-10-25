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

import 'package:flutter/cupertino.dart';

import '../../../api/api_client.dart';
import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../models/homepage_model/get_categories_drawer_data_model.dart';


abstract class SearchRepository {
  Future<CategoriesProductModel> callSearchAPi(String searchQuery,String order,String sort);
  Future<GetDrawerCategoriesData>getCategoriesList();

}

class SearchRepositoryImp implements SearchRepository {
  @override
  Future<CategoriesProductModel> callSearchAPi(String searchQuery,String order,String sort) async {
    CategoriesProductModel? searchData;

    try {
      searchData = await ApiClient().getCategoriesProduct("",searchQuery,order,sort/*,0,500*/,1,[]);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return searchData!;
  }

  @override
  Future<GetDrawerCategoriesData> getCategoriesList() async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData = await ApiClient().getDrawerCategoriesList();
    }catch (error, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return getDrawerCategoriesData!;
  }
}
