/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../home_page/data_model/get_categories_drawer_data_model.dart';
import '../../home_page/data_model/new_product_data.dart';

abstract class SearchBaseState {}
enum Status { success, fail }

class SearchInitialState extends SearchBaseState {
}


class FetchSearchDataState extends SearchBaseState {
  Status status;
  String? error;
  NewProductsModel? products;

  FetchSearchDataState.success({this.products}) : status = Status.success;

  FetchSearchDataState.fail({this.error}) : status = Status.fail;
}
class FetchCategoriesPageDataState extends SearchBaseState {

  Status status;
  String? error;
  GetDrawerCategoriesData? getCategoriesData;
  int?index;

  FetchCategoriesPageDataState.success({this.getCategoriesData,this.index}) : status = Status.success;

  FetchCategoriesPageDataState.fail({this.error}) : status = Status.fail;

}

class ClearSearchBarTextState extends SearchInitialState {
  ClearSearchBarTextState();
}


class CircularBarState extends SearchInitialState {
  final bool? isReqToShowLoader;

  CircularBarState({this.isReqToShowLoader});

}

class AppBarSearchTextState extends SearchInitialState {
  String? searchText;

  AppBarSearchTextState({this.searchText});
}

class AppBarState extends SearchBaseState {
  String searchQuery;

  AppBarState(this.searchQuery);
}
