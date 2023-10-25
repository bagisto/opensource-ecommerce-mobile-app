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

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/sign_in_model/signin_model.dart';
import '../events/fetch_sign_up_event.dart';
import '../repository/sign_up_repository.dart';
import '../state/fetch_sign_up_state.dart';
import '../state/sign_up_base_state.dart';
import '../state/sign_up_initial_state.dart';

class SignUpBloc extends Bloc<SignUpBaseEvent, SignUpBaseState> {
  SignUpRepository? repository;

  SignUpBloc({@required this.repository}) : super(InitialSignUpState()) {
    on<SignUpBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      SignUpBaseEvent event, Emitter<SignUpBaseState> emit) async {
    if (event is FetchSignUpEvent) {
      try {
        SignInModel? signUpResponseModel =
        await repository!.callSignUpApi(
          event.email ?? "",
          event.firstName ?? "",
          event.lastName ?? "",
          event.password ?? "",
          event.confirmPassword ?? "",

        );

        if (signUpResponseModel?.status == true) {
          emit(FetchSignUpState.success(signUpModel: signUpResponseModel));
        } else {
          emit(FetchSignUpState.fail(error: signUpResponseModel?.success??""));
        }
      } catch (e) {
        emit(FetchSignUpState.fail(error: e.toString()));
      }
    }
  }
}
