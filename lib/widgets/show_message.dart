/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../utils/string_constants.dart';

class ShowMessage {
  static successNotification(String msg, BuildContext context) {
    return showSimpleNotification(Text(StringConstants.success.localized(),
      style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.white),),
        context: context,
        background: const Color.fromRGBO(140, 194, 74, 5),
        leading: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        ),
        slideDismissDirection: DismissDirection.up,
        subtitle: Text(msg,style: const TextStyle(color: Colors.white),));
  }
  static errorNotification(String msg, BuildContext context) {
    return showSimpleNotification(Text(StringConstants.failed.localized(), style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.white)),
        context: context,
        background: Colors.red,
        leading: const Icon(
          Icons.cancel_outlined,
          color: Colors.white,
        ),
        slideDismissDirection: DismissDirection.up,
        subtitle: Text(msg,style: const TextStyle(color: Colors.white),));
  }
  static warningNotification(String msg, BuildContext context, {String? title}) {
    return showSimpleNotification(Text(title ?? StringConstants.warning.localized(),style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.white)),
        context: context,
        background: Colors.amber,
        leading: const Icon(
          Icons.warning_amber,
          color: Colors.white,
        ),
        slideDismissDirection: DismissDirection.up,
        subtitle: Text(msg,style: const TextStyle(color: Colors.white),));
  }

  static showNotification(
      String? title, String? message, Color? color, Icon icon) {
    return showSimpleNotification(
        Text(
          title!,
          style: const TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        background: color,
        leading: icon,
        slideDismissDirection: DismissDirection.up,
        subtitle: Text(
          message ?? StringConstants.somethingWrong.localized(),
          style: const TextStyle(color: Colors.white),
        ));
  }
}
