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

import 'package:bagisto_app_demo/screens/account/state/account_info_base_state.dart';

import '../../../base_model/graphql_base_model.dart';




class AccountInfoDeleteState extends AccountInfoBaseState {

  AccountStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;


  AccountInfoDeleteState.success({this.baseModel,this.successMsg}) : status = AccountStatus.success;

  AccountInfoDeleteState.fail({this.error}) : status = AccountStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (baseModel !=null) baseModel! else ""];
}
