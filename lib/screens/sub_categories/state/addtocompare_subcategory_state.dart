/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables


import 'package:bagisto_app_demo/screens/sub_categories/state/sub_categories_base_state.dart';
import '../../../base_model/graphql_base_model.dart';


class AddToCompareSubCategoryState extends SubCategoriesBaseState{
  CategoriesStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  AddToCompareSubCategoryState.success({ this.successMsg,this.baseModel}):status=CategoriesStatus.success;
  AddToCompareSubCategoryState.fail({this.error}):status=CategoriesStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}