import 'package:flutter/material.dart';
import '../../../services/api_client.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';

abstract class DrawerSubCategoryRepository {
  Future<GetDrawerCategoriesData?> getDrawerSubCategories({int? id});
}

class DrawerSubCategoryRepo implements DrawerSubCategoryRepository {
  @override
  Future<GetDrawerCategoriesData?> getDrawerSubCategories({int? id}) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData = await ApiClient().homeCategories(id: id);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return getDrawerCategoriesData;
  }
}
