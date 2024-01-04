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

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:equatable/equatable.dart';

abstract class ForgetPasswordBaseState extends Equatable {}

enum ForgetPasswordStatus { success, fail }


class ForgetPassWordInitialState extends ForgetPasswordBaseState {
  @override
  List<Object> get props => [];
}


class ForgetPasswordFetchState extends ForgetPasswordBaseState {

  ForgetPasswordStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;


  ForgetPasswordFetchState.success({this.baseModel,this.successMsg}) : status = ForgetPasswordStatus.success;

  ForgetPasswordFetchState.fail({this.error}) : status = ForgetPasswordStatus.fail;

  @override
  List<Object> get props => [if (baseModel !=null) baseModel! else "",error??""];
}
