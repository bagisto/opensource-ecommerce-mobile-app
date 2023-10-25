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

import '../../../models/address_model/country_model.dart';
import 'fetch_edit_address_state.dart';


class AddressCountryState extends AddEditAddressBaseState {

  AddEditStatus? status;
  String? error;
  String? successMsg;
  CountriesData? countryData;

  AddressCountryState.success({this.countryData,this.successMsg}) : status = AddEditStatus.success;
  AddressCountryState.fail({this.error}) : status = AddEditStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (countryData !=null) countryData! else ""];
}
