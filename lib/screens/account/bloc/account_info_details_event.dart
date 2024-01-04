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

import 'package:equatable/equatable.dart';

abstract class AccountInfoBaseEvent extends Equatable {}

class AccountInfoDetailsEvent extends AccountInfoBaseEvent {
  @override
  List<Object> get props => [];
}

class AccountInfoDeleteEvent extends AccountInfoBaseEvent {
  String? password;

  AccountInfoDeleteEvent({this.password});

  @override
  List<Object> get props => [];
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
        this.avatar});

  @override
  List<Object> get props => [];
}