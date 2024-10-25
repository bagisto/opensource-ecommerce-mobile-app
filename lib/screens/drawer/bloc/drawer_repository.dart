/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import '../../cms_screen/data_model/cms_model.dart';
import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';

abstract class DrawerPageRepository {
  Future<GetDrawerCategoriesData> getDrawerCategoriesList(List<Map<String, dynamic>>? filters);
  Future<CurrencyLanguageList> getLanguageCurrencyList();
  Future<CmsData?> callCmsData(String id);
}

class DrawerPageRepositoryImp implements DrawerPageRepository {
  @override
  Future<GetDrawerCategoriesData> getDrawerCategoriesList(List<Map<String, dynamic>>? filters) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData = await ApiClient().homeCategories(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return getDrawerCategoriesData!;
  }
  @override
  Future<CurrencyLanguageList> getLanguageCurrencyList() async {
    CurrencyLanguageList? currencyLanguageList;
    try {
      currencyLanguageList = await ApiClient().getLanguageCurrency();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return currencyLanguageList!;
  }

  @override
  Future<CmsData?> callCmsData(String id) async {
    CmsData? cmsData;
    try{
      cmsData=await ApiClient().getCmsPagesData();
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return cmsData;
  }
}
