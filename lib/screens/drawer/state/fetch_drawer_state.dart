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

import 'package:bagisto_app_demo/screens/drawer/state/drawer_base_state.dart';

import '../../../models/homepage_model/get_categories_drawer_data_model.dart';


class FetchDrawerPageDataState extends DrawerPageBaseState {

  DrawerStatus? status;
  String? error;
  GetDrawerCategoriesData? getCategoriesDrawerData;
  int?index;

  FetchDrawerPageDataState.success({this.getCategoriesDrawerData,this.index}) : status = DrawerStatus.success;

  FetchDrawerPageDataState.fail({this.error}) : status = DrawerStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (getCategoriesDrawerData !=null) getCategoriesDrawerData! else ""];
}