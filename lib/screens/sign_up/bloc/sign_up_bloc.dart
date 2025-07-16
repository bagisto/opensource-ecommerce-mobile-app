/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/sign_up/utils/index.dart';

import '../../../data_model/sign_up_model/signup_model.dart';

class SignUpBloc extends Bloc<SignUpBaseEvent, SignUpBaseState> {
  SignUpRepository? repository;

  SignUpBloc({@required this.repository}) : super(InitialSignUpState()) {
    on<SignUpBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      SignUpBaseEvent event, Emitter<SignUpBaseState> emit) async {
    if (event is FetchSignUpEvent) {
      try {
        SignInModel? signUpResponseModel = await repository!.callSignUpApi(
          event.email ?? "",
          event.firstName ?? "",
          event.lastName ?? "",
          event.password ?? "",
          event.confirmPassword ?? "",
          event.newsLetter ?? false,
          event.agreement ?? false
        );

        if (signUpResponseModel?.status == true) {
          emit(FetchSignUpState.success(signUpModel: signUpResponseModel));

        } else {
          emit(
              FetchSignUpState.fail(error: signUpResponseModel?.graphqlErrors ?? ""));
        }
      } catch (e) {
        emit(FetchSignUpState.fail(error: e.toString()));
      }
    }
  }
}
