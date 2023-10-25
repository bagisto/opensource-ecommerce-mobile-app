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
import 'package:equatable/equatable.dart';

abstract class SignUpBaseEvent extends Equatable{}
class FetchSignUpEvent extends SignUpBaseEvent {
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? confirmPassword;

  FetchSignUpEvent(
      {this.email,
        this.firstName,
        this.lastName,
        this.password,
        this.confirmPassword});

  @override
  // TODO: implement props
  List<Object> get props => [];
}


// class FetchSignInEvent extends SignUpBaseEvent {
//   String? email;
//   String? password;
//
//   FetchSignInEvent({this.email, this.password});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [];
// }
