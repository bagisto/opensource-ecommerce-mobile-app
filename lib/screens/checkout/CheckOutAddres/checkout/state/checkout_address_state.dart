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
import 'checkout_base_state.dart';


class CheckOutAddressState extends CheckOutBaseState {

  CheckOutStatus? status;
  String? error;
  AddressModel? addressModel;
  int?index;

  CheckOutAddressState.success({this.addressModel,this.index}) : status = CheckOutStatus.success;
  CheckOutAddressState.fail({this.error}) : status = CheckOutStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (addressModel !=null) addressModel! else ""];
}
