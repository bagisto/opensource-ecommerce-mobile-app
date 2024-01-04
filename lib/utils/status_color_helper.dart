/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'mobikul_theme.dart';

mixin OrderStatusBGColorHelper {
  getOrderBgColor(String state) {
    switch (state.toLowerCase()) {
      case StringConstants.completed:
        return AppColors.orderCompleteColor;
      case StringConstants.pending:
        return AppColors.orderPendingColor;
      case StringConstants.processing:
        return AppColors.orderProcessingColor;
      case StringConstants.orderHold:
        return AppColors.orderHoldColor;
      case StringConstants.canceled:
        return AppColors.orderCanceledColor;
      case StringConstants.statusNew:
        return AppColors.orderNewColor;
      case StringConstants.closed:
        return AppColors.orderClosedColor;
      case StringConstants.paid:
        return AppColors.orderPaidColor;
      case StringConstants.refunded:
        return AppColors.orderRefundedColor;
      case StringConstants.requested:
        return AppColors.orderRequestedColor;
      default:
        return MobikulTheme.accentColor;
    }
  }
}

class ReviewColorHelper {
  static Color getColor(double rating) {
    if (rating <= 1.0) {
      return AppColors.oneStarReview;
    } else if (rating <= 2) {
      return AppColors.twoStarReview;
    } else if (rating <= 3) {
      return AppColors.threeStarReview;
    } else if (rating <= 4) {
      return AppColors.fourStarReview;
    } else {
      return AppColors.fiveStarReview;
    }
  }
}
