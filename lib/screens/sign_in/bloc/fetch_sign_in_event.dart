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

import 'package:bagisto_app_demo/screens/sign_in/bloc/sign_in_base_event.dart';

class FetchSignInEvent extends SignInBaseEvent {
  String? email;
  String? password;

  FetchSignInEvent({this.email, this.password});

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
