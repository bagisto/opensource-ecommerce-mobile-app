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

import 'package:bagisto_app_demo/models/account_models/account_info_details.dart';
import 'package:bagisto_app_demo/screens/account/state/account_info_base_state.dart';




class AccountInfoDetailState extends AccountInfoBaseState {

 AccountStatus? status;
  String? error;
  String? successMsg;
  AccountInfoDetails? accountInfoDetails;


 AccountInfoDetailState.success({this.accountInfoDetails,this.successMsg}) : status = AccountStatus.success;

 AccountInfoDetailState.fail({this.error}) : status = AccountStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (accountInfoDetails !=null) accountInfoDetails! else ""];
}
