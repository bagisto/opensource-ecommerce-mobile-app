/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

abstract class CheckOutShippingBaseEvent extends Equatable{}

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
  int? billingId;
  int? shippingId;

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
        this.shippingPhone, this.billingId, this.shippingId});

  @override
  // TODO: implement props
  List<Object> get props => [];

}