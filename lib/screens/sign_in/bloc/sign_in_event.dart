/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable


abstract class SignInBaseEvent /*extends Equatable*/{}

class FetchSignInEvent extends SignInBaseEvent {
  String? email;
  String? password;
  bool fingerPrint;

  FetchSignInEvent({this.email, this.password, required this.fingerPrint});

  List<Object> get props => [];
}

class SocialLoginEvent extends SignInBaseEvent {
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? signUpType;

  SocialLoginEvent(
      {this.email, this.firstName, this.lastName, this.phone, this.signUpType});

  List<Object> get props => [];
}
