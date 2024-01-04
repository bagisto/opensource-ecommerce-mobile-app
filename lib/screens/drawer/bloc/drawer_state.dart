import 'package:equatable/equatable.dart';
import '../../../data_model/currency_language_model.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';

// ignore_for_file: must_be_immutable
abstract class DrawerPageBaseState extends Equatable {}

enum DrawerStatus { success, fail }

class InitialState extends DrawerPageBaseState {
  @override
  List<Object> get props => [];
}

class FetchDrawerPageDataState extends DrawerPageBaseState {
  DrawerStatus? status;
  String? error;
  GetDrawerCategoriesData? getCategoriesDrawerData;
  int? index;

  FetchDrawerPageDataState.success({this.getCategoriesDrawerData, this.index})
      : status = DrawerStatus.success;

  FetchDrawerPageDataState.fail({this.error}) : status = DrawerStatus.fail;

  @override
  List<Object> get props =>
      [if (getCategoriesDrawerData != null) getCategoriesDrawerData! else ""];
}

class FetchLanguageCurrencyState extends DrawerPageBaseState {
  DrawerStatus? status;
  String? error;
  CurrencyLanguageList? currencyLanguageList;

  FetchLanguageCurrencyState.success({this.currencyLanguageList,})
      : status = DrawerStatus.success;

  FetchLanguageCurrencyState.fail({this.error}) : status = DrawerStatus.fail;

  @override
  List<Object> get props =>
      [if (currencyLanguageList != null) currencyLanguageList! else ""];
}