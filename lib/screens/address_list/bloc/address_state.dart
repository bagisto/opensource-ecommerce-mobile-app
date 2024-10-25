/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */




import 'package:bagisto_app_demo/screens/address_list/utils/index.dart';

import '../data_model/default_address_model.dart';

abstract class AddressBaseState {}

enum AddressStatus { success, fail }

class InitialAddressState extends AddressBaseState {
}

class ShowLoaderState extends AddressBaseState {}

class RemoveAddressState extends AddressBaseState{
  AddressStatus? status;
  String? successMsg;
  String? error;
  BaseModel? response;
  String? customerDeletedId;
  RemoveAddressState.success({this.response, this.customerDeletedId,this.successMsg}):status=AddressStatus.success;
  RemoveAddressState.fail({this.error}):status=AddressStatus.fail;

}

class FetchAddressState extends AddressBaseState {
  AddressStatus? status;
  String? error;
  String? successMsg;
  AddressModel? addressModel;

  FetchAddressState.success({this.addressModel, this.successMsg})
      : status = AddressStatus.success;

  FetchAddressState.fail({this.error}) : status = AddressStatus.fail;
}

class SetDefaultAddressState extends AddressBaseState {
  AddressStatus? status;
  String? message;
  SetDefaultAddress? addressModel;

  SetDefaultAddressState.success({this.addressModel, this.message})
      : status = AddressStatus.success;

  SetDefaultAddressState.fail({this.message}) : status = AddressStatus.fail;
}
