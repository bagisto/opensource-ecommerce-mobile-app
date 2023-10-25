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


import 'package:bagisto_app_demo/screens/compare/state/compare_base_state.dart';

import '../../../base_model/graphql_base_model.dart';


class RemoveFromCompareState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  var productDeletedId;
  RemoveFromCompareState.success({ this.successMsg,this.baseModel,this.productDeletedId}):status=CompareStatusStatus.success;
  RemoveFromCompareState.fail({this.error}):status=CompareStatusStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!,productDeletedId];

}

class RemoveAllCompareProductState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  RemoveAllCompareProductState.success({ this.successMsg,this.baseModel}):status=CompareStatusStatus.success;
  RemoveAllCompareProductState.fail({this.error}):status=CompareStatusStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}