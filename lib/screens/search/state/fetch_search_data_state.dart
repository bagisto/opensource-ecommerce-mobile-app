/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable, file_names


import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../models/homepage_model/get_categories_drawer_data_model.dart';
import 'search_base_state.dart';

///screens.search products event

class FetchSearchDataState extends SearchBaseState {
  //T data;
  Status status;
  String? error;
  CategoriesProductModel? products;

  FetchSearchDataState.success({this.products}) : status = Status.success;

  FetchSearchDataState.fail({this.error}) : status = Status.fail;

  @override
  // TODO: implement props
  List<Object> get props => [products!];
}
class FetchCategoriesPageDataState extends SearchBaseState {

  Status status;
  String? error;
  GetDrawerCategoriesData? getCategoriesData;
  int?index;

  FetchCategoriesPageDataState.success({this.getCategoriesData,this.index}) : status = Status.success;

  FetchCategoriesPageDataState.fail({this.error}) : status = Status.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (getCategoriesData !=null) getCategoriesData! else ""];
}

