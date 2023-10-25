// ignore_for_file: must_be_immutable

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/screens/sub_categories/state/sub_categories_base_state.dart';

import '../../../models/categories_data_model/filter_product_model.dart';



class OnClickSubCategoriesLoaderState extends SubCategoriesBaseState {
  final bool? isReqToShowLoader;

  OnClickSubCategoriesLoaderState({this.isReqToShowLoader});

  @override
  List<Object> get props => [isReqToShowLoader!];
}
class FilterFetchState extends SubCategoriesBaseState {
  CategoriesStatus? status;
  String? error;
  GetFilterAttribute? filterModel;

  FilterFetchState.success({this.filterModel})
      : status = CategoriesStatus.success;

  FilterFetchState.fail({this.error}) : status = CategoriesStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (filterModel != null) filterModel! else ""];
}