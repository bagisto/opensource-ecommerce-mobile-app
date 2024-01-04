import 'package:flutter/material.dart';
import '../../../data_model/categories_data_model/filter_product_model.dart';
import '../../../services/api_client.dart';

abstract class FilterRepository{
  Future<GetFilterAttribute> getFilterProducts(String categorySlug);
}
class FilterRepositoryImp implements FilterRepository {
  @override
  Future<GetFilterAttribute> getFilterProducts(String categorySlug) async {
    GetFilterAttribute? filterAttribute;
    try{
      filterAttribute = await ApiClient().getFilterAttributes(categorySlug);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return filterAttribute!;
  }
}
