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



import '../../../base_model/graphql_base_model.dart';
import 'hoempage_base_state.dart';


class AddToCompareHomepageState extends HomePageBaseState{
  Status? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  AddToCompareHomepageState.success({ this.successMsg,this.baseModel}):status=Status.success;
  AddToCompareHomepageState.fail({this.error}):status=Status.fail;

  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}