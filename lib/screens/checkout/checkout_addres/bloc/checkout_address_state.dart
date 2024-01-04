/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */



import '../../../address_list/data_model/address_model.dart';

abstract class CheckOutBaseState {}

enum CheckOutStatus { success, fail }

class CheckOutLoaderState extends CheckOutBaseState {

}


class CheckOutAddressState extends CheckOutBaseState {

  CheckOutStatus? status;
  String? error;
  AddressModel? addressModel;
  int?index;

  CheckOutAddressState.success({this.addressModel,this.index}) : status = CheckOutStatus.success;
  CheckOutAddressState.fail({this.error}) : status = CheckOutStatus.fail;

}
