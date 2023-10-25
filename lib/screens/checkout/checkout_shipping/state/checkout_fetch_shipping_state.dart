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

import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/state/checkout_shipping_base_state.dart';

import '../../../../models/checkout_models/checkout_save_address_model.dart';



class CheckOutFetchShippingState extends CheckOutShippingBaseState {

  CheckOutShippingStatus? status;
  String? error;
  SaveCheckoutAddresses? checkOutSaveAddressModel;

  CheckOutFetchShippingState.success({this.checkOutSaveAddressModel,}) : status = CheckOutShippingStatus.success;
  CheckOutFetchShippingState.fail({this.error}) : status = CheckOutShippingStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (checkOutSaveAddressModel !=null) checkOutSaveAddressModel! else ""];
}
