/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:flutter/cupertino.dart';
import '../../../services/api_client.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';
import '../../home_page/data_model/new_product_data.dart';



abstract class SearchRepository {
  Future<NewProductsModel?> callSearchAPi(List<Map<String, dynamic>>? filters);
  Future<GetDrawerCategoriesData> getCategoriesList({int? id});
}

class SearchRepositoryImp implements SearchRepository {
  @override
  Future<NewProductsModel?> callSearchAPi(List<Map<String, dynamic>>? filters) async {
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
      {int? id}) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData = await ApiClient().homeCategories(id: id);
    }catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return getDrawerCategoriesData!;
  }
}
