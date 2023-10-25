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

import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'fetch_edit_address_state.dart';


class FetchAddAddressState extends AddEditAddressBaseState {

  AddEditStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;


  FetchAddAddressState.success({this.baseModel,this.successMsg}) : status = AddEditStatus.success;
  FetchAddAddressState.fail({this.error}) : status = AddEditStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (baseModel !=null) baseModel! else ""];
}
