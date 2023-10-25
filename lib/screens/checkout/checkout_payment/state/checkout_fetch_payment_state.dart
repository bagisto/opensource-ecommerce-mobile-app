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


import '../../../../models/checkout_models/checkout_save_shipping_model.dart';
import 'checkout_payment_base_state.dart';


class CheckOutFetchPaymentState extends CheckOutPaymentBaseState {

  CheckOutPaymentStatus? status;
  String? error;
  PaymentMethods? checkOutShipping;
  int?index;

  CheckOutFetchPaymentState.success({this.checkOutShipping,this.index}) : status = CheckOutPaymentStatus.success;
  CheckOutFetchPaymentState.fail({this.error}) : status = CheckOutPaymentStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (checkOutShipping !=null) checkOutShipping! else ""];
}
