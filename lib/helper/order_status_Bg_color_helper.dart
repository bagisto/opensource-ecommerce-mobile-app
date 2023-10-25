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


import 'package:bagisto_app_demo/configuration/mobikul_theme.dart';
import 'package:flutter/material.dart';

class OrderStatusBGColorHelper {
  getOrderBgColor(String state) {
    switch (state.toLowerCase()) {
      case "completed":
        return const Color(0xFF66BB6A);
      case "pending":
        return const Color(0xFFfead4c);
      case "processing" :
          return const Color(0xFF3F51B5);
      case "holded":
        return const Color(0XFFF9A825);
      case "canceled":
        return const Color(0xFFE53935);
      case "new" :
        return const Color(0xFF448AFF);
      case "closed" :
        return const Color(0xFFe44c53);
      default:
        return MobikulTheme.accentColor;
    }
  }
}
