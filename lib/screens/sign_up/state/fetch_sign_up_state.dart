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

import 'package:bagisto_app_demo/screens/sign_up/state/sign_up_base_state.dart';

import '../../../models/sign_in_model/signin_model.dart';

class FetchSignUpState extends SignUpBaseState {

  SignUpStatus? status;
  String? error;
  String? successMsg;
  SignInModel? signUpModel;


  FetchSignUpState.success({this.signUpModel,this.successMsg}) : status = SignUpStatus.success;

  FetchSignUpState.fail({this.error}) : status = SignUpStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (signUpModel !=null) signUpModel! else ""];
}





class FetchSignInState extends SignUpBaseState {

  SignUpStatus? status;
  String? error;
  String? successMsg;
  SignInModel? signInModel;


  FetchSignInState.success({this.signInModel,this.successMsg}) : status = SignUpStatus.success;

  FetchSignInState.fail({this.error}) : status = SignUpStatus.fail;


  // TODO: implement props
  List<Object> get props => [if (signInModel !=null) signInModel! else "",error??""];
}

