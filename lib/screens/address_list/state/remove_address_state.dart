
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

import '../../../base_model/graphql_base_model.dart';
import 'address_base_state.dart';

class RemoveAddressState extends AddressBaseState{
  AddressStatus? status;
  String? successMsg;
  String? error;
  GraphQlBaseModel? response;
  var customerDeletedId;
  RemoveAddressState.success({this.response, this.customerDeletedId,this.successMsg}):status=AddressStatus.success;
  RemoveAddressState.fail({this.error}):status=AddressStatus.fail;

  // TODO: implement props
  List<Object> get props => [/*customerDeletedId,status!*/];

}