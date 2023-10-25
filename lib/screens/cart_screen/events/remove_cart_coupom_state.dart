

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

import 'dart:core';
import 'package:bagisto_app_demo/models/cart_model/cart_data_model.dart';

import 'cart_screen_base_event.dart';

class RemoveCouponCartEvent extends CartScreenBaseEvent{
  CartModel? cartDetailsModel;
  RemoveCouponCartEvent(this.cartDetailsModel);
  // TODO: implement props
  List<Object> get props => [cartDetailsModel!];

}