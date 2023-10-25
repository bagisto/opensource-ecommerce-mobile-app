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

import 'package:bagisto_app_demo/models/homepage_model/get_categories_drawer_data_model.dart';
import '../../../api/api_client.dart';

abstract class DrawerPageRepository{
  Future<GetDrawerCategoriesData>getDrawerCategoriesList();
}
class DrawerPageRepositoryImp implements DrawerPageRepository{

  @override
  Future<GetDrawerCategoriesData> getDrawerCategoriesList() async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData = await ApiClient().getDrawerCategoriesList();
    }catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");

    }
    return getDrawerCategoriesData!;
  }
}

