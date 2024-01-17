/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../../data_model/currency_language_model.dart';
import '../../../services/api_client.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';
import 'package:flutter/material.dart';

abstract class DrawerPageRepository {
  Future<GetDrawerCategoriesData> getDrawerCategoriesList(int? id);
  Future<CurrencyLanguageList> getLanguageCurrencyList();
  Future<CmsData?> callCmsData(String id);
}

class DrawerPageRepositoryImp implements DrawerPageRepository {
  @override
  Future<GetDrawerCategoriesData> getDrawerCategoriesList(int? id) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      getDrawerCategoriesData = await ApiClient().homeCategories(id: id);
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
