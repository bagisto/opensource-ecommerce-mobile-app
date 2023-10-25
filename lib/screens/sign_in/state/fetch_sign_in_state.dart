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

import 'package:bagisto_app_demo/models/sign_in_model/signin_model.dart';
import 'package:bagisto_app_demo/screens/sign_in/state/sign_in_base_state.dart';

class FetchSignInState extends SignInBaseState {
  SignInStatus? status;
  String? error;
  String? successMsg;
  SignInModel? signInModel;

  FetchSignInState.success({this.signInModel, this.successMsg})
      : status = SignInStatus.success;

  FetchSignInState.fail({this.error}) : status = SignInStatus.fail;

  // TODO: implement props
  List<Object> get props =>
      [if (signInModel != null) signInModel! else "", error ?? ""];
}

class SocialLoginState extends SignInBaseState {
  SignInStatus? status;
  String? error;
  String? successMsg;
  SignInModel? signInModel;

  SocialLoginState.success({this.signInModel, this.successMsg})
      : status = SignInStatus.success;

  SocialLoginState.fail({this.error}) : status = SignInStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (signInModel != null) signInModel! else ""];
}
