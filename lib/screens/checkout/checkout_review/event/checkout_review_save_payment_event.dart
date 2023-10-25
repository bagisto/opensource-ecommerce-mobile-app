

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





import 'package:bagisto_app_demo/screens/checkout/checkout_review/event/checkout_review_base_event.dart';

class CheckOutReviewSavePaymentEvent extends CheckOutReviewBaseEvent{
  String? paymentMethod;
  CheckOutReviewSavePaymentEvent({this.paymentMethod});
  @override
  // TODO: implement props
  List<Object> get props => [];

}