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

import 'package:bagisto_app_demo/models/checkout_models/save_payment_model.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/state/checkout_review_base_state.dart';



class CheckOutReviewSavePaymentState extends CheckOutReviewBaseState {

  CheckOutReviewStatus? status;
  String? error;
  SavePayment? savePaymentModel;

  CheckOutReviewSavePaymentState.success({this.savePaymentModel,}) : status = CheckOutReviewStatus.success;
  CheckOutReviewSavePaymentState.fail({this.error}) : status = CheckOutReviewStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (savePaymentModel !=null) savePaymentModel! else ""];
}
