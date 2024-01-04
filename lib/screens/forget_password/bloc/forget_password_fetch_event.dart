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

import 'forget_password_base_event.dart';

class ForgetPasswordFetchEvent extends ForgetPasswordBaseEvent {
  String? email;
  ForgetPasswordFetchEvent({this.email,});
  List<Object> get props => [];
}
