/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../data_model/save_payment_model.dart';

abstract class CheckOutReviewBaseState {}

enum CheckOutReviewStatus { success, fail }

class CheckOutReviewInitialState extends CheckOutReviewBaseState {

}

class CheckOutReviewSavePaymentState extends CheckOutReviewBaseState {

  CheckOutReviewStatus? status;
  String? error;
  SavePayment? savePaymentModel;

  CheckOutReviewSavePaymentState.success({this.savePaymentModel,}) : status = CheckOutReviewStatus.success;
  CheckOutReviewSavePaymentState.fail({this.error}) : status = CheckOutReviewStatus.fail;

}
