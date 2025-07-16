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
        if (signInModel.success == true) {
          emit(FetchSignInState.success(
              signInModel: signInModel, successMsg: signInModel.message ?? "", fingerPrint: event.fingerPrint));
        } else {

          emit(FetchSignInState.fail(error: signInModel.graphqlErrors ?? "", fingerPrint: event.fingerPrint));
        }
      } catch (e) {
        emit(FetchSignInState.fail(error: e.toString(), fingerPrint: event.fingerPrint));
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
              SocialLoginState.fail(error: signUpResponseModel?.graphqlErrors ?? ""));
        }
      } catch (e) {
        emit(SocialLoginState.fail(error: e.toString()));
      }
    }
  }
}
