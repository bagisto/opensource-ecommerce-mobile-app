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

import 'package:bagisto_app_demo/screens/account/events/account_info_base_event.dart';

class AccountInfoUpdateEvent extends AccountInfoBaseEvent {
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? phone;
  String? dob;
  String?password;
  String?confirmPassword;
  String?oldPassword;
  String?avatar;
  AccountInfoUpdateEvent({this.firstName,this.lastName,this.email,this.gender,this.dob,this.phone,this.password,this.confirmPassword,this.oldPassword,this.avatar});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
