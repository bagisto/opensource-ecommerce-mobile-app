

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



import 'checkout_payment_base_event.dart';

class CheckOutPaymentEvent extends CheckOutPaymentBaseEvent{
  String? shippingMethod;
  CheckOutPaymentEvent({this.shippingMethod});
  @override
  // TODO: implement props
  List<Object> get props => [];

}