/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

abstract class AccountInfoBaseEvent {}

class AccountInfoDetailsEvent extends AccountInfoBaseEvent {}

class AccountInfoDeleteEvent extends AccountInfoBaseEvent {
  String? password;

  AccountInfoDeleteEvent({this.password});
}

class AccountInfoUpdateEvent extends AccountInfoBaseEvent {
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? phone;
  String? dob;
  String? password;
  String? confirmPassword;
  String? oldPassword;
  String? avatar;
  bool? subscribedToNewsLetter;

  AccountInfoUpdateEvent(
      {this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.dob,
      this.phone,
      this.password,
      this.confirmPassword,
      this.oldPassword,
      this.avatar,
      this.subscribedToNewsLetter});
}
