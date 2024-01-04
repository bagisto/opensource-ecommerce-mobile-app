/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/account_models/account_info_details.dart';
import 'package:bagisto_app_demo/data_model/account_models/account_update_model.dart';
import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';

abstract class AccountInfoBaseState {}

enum AccountStatus { success, fail }

class InitialAccountState extends AccountInfoBaseState {
  List<Object> get props => [];
}

class AccountInfoDeleteState extends AccountInfoBaseState {
  AccountStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;

  AccountInfoDeleteState.success({this.baseModel, this.successMsg})
      : status = AccountStatus.success;

  AccountInfoDeleteState.fail({this.error}) : status = AccountStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (baseModel != null) baseModel! else ""];
}

class AccountInfoUpdateState extends AccountInfoBaseState {
  AccountStatus? status;
  String? error;
  String? successMsg;
  AccountUpdate? accountUpdate;

  AccountInfoUpdateState.success({this.accountUpdate, this.successMsg})
      : status = AccountStatus.success;

  AccountInfoUpdateState.fail({this.error}) : status = AccountStatus.fail;
  List<Object> get props => [if (accountUpdate != null) accountUpdate! else ""];
}

class AccountInfoDetailState extends AccountInfoBaseState {
  AccountStatus? status;
  String? error;
  String? successMsg;
  AccountInfoDetails? accountInfoDetails;

  AccountInfoDetailState.success({this.accountInfoDetails, this.successMsg})
      : status = AccountStatus.success;

  AccountInfoDetailState.fail({this.error}) : status = AccountStatus.fail;
  List<Object> get props =>
      [if (accountInfoDetails != null) accountInfoDetails! else ""];
}
