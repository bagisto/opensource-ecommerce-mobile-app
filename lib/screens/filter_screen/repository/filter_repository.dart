// ignore_for_file: file_names, avoid_print

import '../../../api/api_client.dart';
import '../../../models/categories_data_model/filter_product_model.dart';

abstract class FilterRepository{

  Future<GetFilterAttribute> getFilterProducts(String categorySlug);

}
class FilterRepositoryImp implements FilterRepository {
  @override
  Future<GetFilterAttribute> getFilterProducts(String categorySlug) async {
    GetFilterAttribute? filterAttribute;
    try{
      filterAttribute=await ApiClient().getFilterProducts(categorySlug);
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return filterAttribute!;
  }
}
