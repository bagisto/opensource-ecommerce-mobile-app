import '../../../data_model/currency_language_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';

// ignore_for_file: must_be_immutable
abstract class DrawerPageBaseState {}

enum DrawerStatus { success, fail }

class InitialState extends DrawerPageBaseState {

}

class FetchDrawerPageDataState extends DrawerPageBaseState {
  DrawerStatus? status;
  String? error;
  GetDrawerCategoriesData? getCategoriesDrawerData;
  int? index;

  FetchDrawerPageDataState.success({this.getCategoriesDrawerData, this.index})
      : status = DrawerStatus.success;

  FetchDrawerPageDataState.fail({this.error}) : status = DrawerStatus.fail;


}

class FetchLanguageCurrencyState extends DrawerPageBaseState {
  DrawerStatus? status;
  String? error;
  CurrencyLanguageList? currencyLanguageList;

  FetchLanguageCurrencyState.success({this.currencyLanguageList,})
      : status = DrawerStatus.success;

  FetchLanguageCurrencyState.fail({this.error}) : status = DrawerStatus.fail;


}

class FetchCMSDataState extends DrawerPageBaseState {
  DrawerStatus? status;
  String? error;
  CmsData? cmsData;

  FetchCMSDataState.success({this.cmsData}) : status = DrawerStatus.success;

  FetchCMSDataState.fail({this.error}) : status = DrawerStatus.fail;
}