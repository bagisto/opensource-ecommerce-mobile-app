/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';

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
