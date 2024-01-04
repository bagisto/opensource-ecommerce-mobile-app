/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:flutter/material.dart';

class AppSizes {
  static const double spacingSmall = 4.0;
  static const double spacingNormal = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingWide = 20;
  static const double buttonHeight = 48;
  static const double buttonWidth = 270;
  static const double itemHeight = 45.0;
  static const double size24 = 24.0;
  static const double size16 = 16.0;
  static const double size12 = 12.0;
  static const double size8 = 8.0;
  static const double size4 = 4.0;

  static double screenHeight = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single).size.height;
  static double screenWidth = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single).size.width;

}

class AppColors {

  //Order status Color
  static const Color orderCompleteColor = Color(0xFF66BB6A);
  static const Color orderPendingColor = Color(0xFFfead4c);
  static const Color orderProcessingColor = Color(0xFF3F51B5);
  static const Color orderHoldColor = Color(0XFFF9A825);
  static const Color orderCanceledColor = Color(0xFFE53935);
  static const Color orderNewColor = Color(0xFF448AFF);
  static const Color orderClosedColor = Color(0xFFe44c53);
  static const Color orderPaidColor = Color(0xFF66BB6A);
  static const Color orderRefundedColor = Color(0xFFE53935);
  static const Color orderRequestedColor = Color(0xFFefad4c);

  //Review color
  static const Color oneStarReview = Color(0xFFE51A1A);
  static const Color twoStarReview = Color(0xFFE91E63);
  static const Color threeStarReview = Color(0xFFFFA100);
  static const Color fourStarReview = Color(0xFFFFCC00);
  static const Color fiveStarReview = Color(0xFF6BC700);

}

