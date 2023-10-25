

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




import 'checkout_shipping_base_event.dart';

class CheckOutFetchShippingEvent extends CheckOutShippingBaseEvent{
  String? billingCompanyName;
  String? billingFirstName;
      String? billingLastName;
  String? billingAddress;
      String? billingEmail;
  String? billingAddress2;
      String? billingCountry;
  String? billingState;
      String? billingCity;
  String? billingPostCode;
      String? billingPhone;
  String? shippingCompanyName;
      String? shippingFirstName;
  String? shippingLastName;
      String? shippingAddress;
  String? shippingEmail;
      String? shippingAddress2;
  String? shippingCountry;
      String? shippingState;
  String? shippingCity;
      String? shippingPostCode;
  String? shippingPhone;

  CheckOutFetchShippingEvent(
      {this.billingCompanyName,
        this.billingFirstName,
      this.billingLastName,
      this.billingAddress,
      this.billingEmail,
      this.billingAddress2,
      this.billingCountry,
      this.billingState,
      this.billingCity,
      this.billingPostCode,
      this.billingPhone,
      this.shippingCompanyName,
      this.shippingFirstName,
      this.shippingLastName,
      this.shippingAddress,
      this.shippingEmail,
      this.shippingAddress2,
      this.shippingCountry,
      this.shippingState,
      this.shippingCity,
      this.shippingPostCode,
      this.shippingPhone});

  @override
  // TODO: implement props
  List<Object> get props => [];

}