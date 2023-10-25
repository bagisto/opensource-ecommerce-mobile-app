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

import 'package:bagisto_app_demo/screens/checkout/guest_add_address/state/guest_address_base_state.dart';

import '../../../../models/address_model/country_model.dart';


class GuestAddressCountryState extends GuestAddressBaseState {

  GuestStatus? status;
  String? error;
  String? successMsg;
  CountriesData? countryData;


  GuestAddressCountryState.success({this.countryData,this.successMsg}) : status = GuestStatus.success;

  GuestAddressCountryState.fail({this.error}) : status = GuestStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (countryData !=null) countryData! else ""];
}
