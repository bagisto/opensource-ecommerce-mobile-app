/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print

import 'package:bagisto_app_demo/api/api_client.dart';
import '../../../models/sign_in_model/signin_model.dart';

abstract class SignUpRepository {
  Future<SignInModel?> callSignUpApi(
      String email,
      String firstName,
      String lastName,
      String password,
      String confirmPassword,
      );

}

class SignUpRepositoryImp implements SignUpRepository {
  @override
  Future<SignInModel?> callSignUpApi(
      String email,
      String firstName,
      String lastName,
      String password,
      String confirmPassword,
      ) async {
    SignInModel? signUpResponseModel;

    try {
      signUpResponseModel = await ApiClient().getSignUpData(
        email,
        firstName,
        lastName,
        password,
        confirmPassword,
      );
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return signUpResponseModel;
  }



}
