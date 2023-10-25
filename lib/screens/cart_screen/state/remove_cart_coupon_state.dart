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

import '../../../models/checkout_models/apply_coupon.dart';
import 'cart_screen_base_state.dart';

class RemoveCouponCartState extends CartScreenBaseState {
  CartStatus? status;
  String? error;
  ApplyCoupon? baseModel;
  String? successMsg;

  RemoveCouponCartState.success({this.baseModel, this.successMsg})
      : status = CartStatus.success;

  RemoveCouponCartState.fail({this.error}) : status = CartStatus.fail;

  List<Object> get props => [
        status!,
        if (baseModel != null) baseModel! else "",
        successMsg!,
        error ?? ""
      ];
}
