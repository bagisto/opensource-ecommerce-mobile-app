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

import 'package:bagisto_app_demo/models/address_model/address_model.dart';


import 'address_base_state.dart';


class FetchAddressState extends AddressBaseState {

  AddressStatus? status;
  String? error;
  String? successMsg;
  AddressModel? addressModel;


  FetchAddressState.success({this.addressModel,this.successMsg}) : status = AddressStatus.success;

  FetchAddressState.fail({this.error}) : status = AddressStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (addressModel !=null) addressModel! else ""];
}
