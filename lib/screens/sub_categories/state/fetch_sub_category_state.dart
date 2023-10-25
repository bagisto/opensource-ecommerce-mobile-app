/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/screens/sub_categories/state/sub_categories_base_state.dart';
import '../../../models/categories_data_model/categories_product_model.dart';


class FetchSubCategoryState extends SubCategoriesBaseState {

  CategoriesStatus? status;
  String? error;
  CategoriesProductModel? categoriesData;

  FetchSubCategoryState.success({this.categoriesData}) : status = CategoriesStatus.success;

  FetchSubCategoryState.fail({this.error}) : status = CategoriesStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (categoriesData !=null) categoriesData! else ""];
}
