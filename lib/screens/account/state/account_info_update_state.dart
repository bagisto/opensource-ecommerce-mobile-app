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

import '../../../models/account_models/account_update_model.dart';




class AccountInfoUpdateState extends AccountInfoBaseState {

  AccountStatus? status;
  String? error;
  String? successMsg;
  AccountUpdate? accountUpdate;


  AccountInfoUpdateState.success({this.accountUpdate,this.successMsg}) : status = AccountStatus.success;

  AccountInfoUpdateState.fail({this.error}) : status = AccountStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (accountUpdate !=null) accountUpdate! else ""];
}
