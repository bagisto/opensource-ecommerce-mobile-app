/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import '../screens/account/utils/index.dart';

class ErrorMessage {
  static errorMsg(String errorMsg) {
    return Center(
        child: Text(errorMsg,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )));
  }
}
