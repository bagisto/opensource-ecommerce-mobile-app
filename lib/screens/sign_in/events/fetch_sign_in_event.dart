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

abstract class SignInBaseEvent {}

class FetchSignInEvent extends SignInBaseEvent {
  String? email;
  String? password;

  FetchSignInEvent({this.email, this.password});

  // TODO: implement props
  List<Object> get props => [];
}

class SocialLoginEvent extends SignInBaseEvent {
  String? email;
  String? firstName;
  String? lastName;
  String? phone;

  SocialLoginEvent({this.email, this.firstName, this.lastName, this.phone});

  // TODO: implement props
  List<Object> get props => [];
}
