/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/sign_in_model/signin_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fetch_sign_in_event.dart';
import 'sign_in_base_event.dart';
import 'sign_in_repository.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInBaseEvent, SignInBaseState> {
  SignInRepository? repository;

  SignInBloc({@required this.repository}) : super(InitialState()) {
    on<SignInBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      SignInBaseEvent event, Emitter<SignInBaseState> emit) async {
    if (event is FetchSignInEvent) {
      try {
        SignInModel signInModel = await repository!
            .callSignInApi(event.email ?? "", event.password ?? "");
        if (signInModel.status == true) {
          emit(FetchSignInState.success(
              signInModel: signInModel, successMsg: signInModel.error ?? ""));
        } else {
          emit(FetchSignInState.fail(error: signInModel.success ?? ""));
        }
      } catch (e) {
        emit(FetchSignInState.fail(error: e.toString()));
      }
    } else if (event is SocialLoginEvent) {
      try {
        SignInModel? signUpResponseModel = await repository!.socialLogin(
            event.email ?? "",
            event.firstName ?? "",
            event.lastName ?? "",
            event.phone ?? "",event.signUpType ?? "");
        if (signUpResponseModel?.status == true) {
          emit(SocialLoginState.success(signInModel: signUpResponseModel));
        } else {
          emit(
              SocialLoginState.fail(error: signUpResponseModel?.success ?? ""));
        }
      } catch (e) {
        emit(SocialLoginState.fail(error: e.toString()));
      }
    }
  }
}
