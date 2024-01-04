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
import 'package:bagisto_app_demo/services/api_client.dart';
import 'package:flutter/material.dart';

abstract class SignInRepository {
  Future<SignInModel> callSignInApi(String email, String password);

  Future<SignInModel?> socialLogin(
      String email, String firstName, String lastName, String phone, String signUpType);
}

class SignInRepositoryImp implements SignInRepository {
  @override
  Future<SignInModel> callSignInApi(String email, String password) async {
    SignInModel? signInModel;
    try {
      signInModel = await ApiClient().getSignInData(email, password, true);
    } catch (e, stacktrace) {
      debugPrint("Error --> $e");
      debugPrint("StackTrace --> $stacktrace");
    }
    return signInModel!;
  }

  @override
  Future<SignInModel?> socialLogin(String email, String firstName,
      String lastName, String phone, String signUpType) async {
    SignInModel? signUpResponseModel;

    try {
      signUpResponseModel =
          await ApiClient().socialLogin(email, firstName, lastName, phone, signUpType);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return signUpResponseModel;
  }
}
