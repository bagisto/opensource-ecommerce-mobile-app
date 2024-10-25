/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import '../../../data_model/account_models/account_update_model.dart';
import '../utils/index.dart';

abstract class AccountInfoBaseState {}

enum AccountStatus { success, fail }

class InitialAccountState extends AccountInfoBaseState {
  List<Object> get props => [];
}

class AccountInfoDeleteState extends AccountInfoBaseState {
  AccountStatus? status;
  String? error;
  String? successMsg;
  BaseModel? baseModel;

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
  AccountInfoModel? accountInfoDetails;

  AccountInfoDetailState.success({this.accountInfoDetails, this.successMsg})
      : status = AccountStatus.success;

  AccountInfoDetailState.fail({this.error}) : status = AccountStatus.fail;
  List<Object> get props =>
      [if (accountInfoDetails != null) accountInfoDetails! else ""];
}
