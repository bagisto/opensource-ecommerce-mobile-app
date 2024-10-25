/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/sign_in/utils/index.dart';

abstract class SignInBaseState{}

enum SignInStatus { success, fail }

class InitialState extends SignInBaseState {
  // TODO: implement props
  List<Object> get props => [];
}


class FetchSignInState extends SignInBaseState {
  SignInStatus? status;
  String? error;
  String? successMsg;
  SignInModel? signInModel;
  bool fingerPrint;

  FetchSignInState.success({this.signInModel, this.successMsg, required this.fingerPrint})
      : status = SignInStatus.success;

  FetchSignInState.fail({this.error, required this.fingerPrint}) : status = SignInStatus.fail;

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
