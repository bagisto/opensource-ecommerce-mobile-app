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

import 'package:bagisto_app_demo/models/address_model/update_address_model.dart';

import 'package:equatable/equatable.dart';

abstract class AddEditAddressBaseState extends Equatable {}
enum AddEditStatus { success, fail }

class InitialAddEditAddressState extends AddEditAddressBaseState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchEditAddressState extends AddEditAddressBaseState {

  AddEditStatus? status;
  String? error;
  String? successMsg;
  UpdateAddressModel? updateAddressModel;


  FetchEditAddressState.success({this.updateAddressModel,this.successMsg}) : status = AddEditStatus.success;
  FetchEditAddressState.fail({this.error}) : status = AddEditStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (updateAddressModel !=null) updateAddressModel! else ""];
}
