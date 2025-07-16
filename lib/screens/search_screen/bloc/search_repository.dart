/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/search_screen/utils/index.dart';

abstract class SearchRepository {
  Future<NewProductsModel?> callSearchAPi(List<Map<String, dynamic>>? filters);
  Future<GetDrawerCategoriesData> getCategoriesList(
      {List<Map<String, dynamic>>? filters});
}

class SearchRepositoryImp implements SearchRepository {
  @override
  Future<NewProductsModel?> callSearchAPi(
      List<Map<String, dynamic>>? filters) async {
    NewProductsModel? searchData;

    try {
      searchData = await ApiClient().getAllProducts(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return searchData;
  }

  @override
  Future<GetDrawerCategoriesData> getCategoriesList(
      {List<Map<String, dynamic>>? filters}) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData =
          await ApiClient().homeCategories(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return getDrawerCategoriesData!;
  }
}
