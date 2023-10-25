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

import 'package:bagisto_app_demo/models/sign_in_model/signin_model.dart';
import 'package:bagisto_app_demo/screens/sign_in/state/sign_in_initial_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/fetch_sign_in_event.dart';
import '../repository/sign_in_repository.dart';
import '../state/fetch_sign_in_state.dart';
import '../state/sign_in_base_state.dart';

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
        // }
      } catch (e) {
        emit(FetchSignInState.fail(error: e.toString()));
      }
    } else if (event is SocialLoginEvent) {
      try {
        SignInModel? signUpResponseModel = await repository!.socialLogin(
            event.email ?? "",
            event.firstName ?? "",
            event.lastName ?? "",
            event.phone ?? "");

        // if (signInModel.token !=null) {
        if (signUpResponseModel?.status == true) {
          emit(SocialLoginState.success(signInModel: signUpResponseModel));
        } else {
          emit(
              SocialLoginState.fail(error: signUpResponseModel?.success ?? ""));
        }
        // }
      } catch (e) {
        emit(SocialLoginState.fail(error: e.toString()));
      }
    }
  }
}
