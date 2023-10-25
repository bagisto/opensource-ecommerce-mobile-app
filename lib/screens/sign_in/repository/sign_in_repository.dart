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
import 'package:bagisto_app_demo/models/sign_in_model/signin_model.dart';

abstract class SignInRepository{
  Future<SignInModel>callSignInApi(String email,String password);
  Future<SignInModel?> socialLogin(
      String email,
      String firstName,
      String lastName,
      String phone
      );

}
class SignInRepositoryImp implements SignInRepository {
  @override
  Future<SignInModel> callSignInApi(String email,String password) async {

    SignInModel? signInModel;
    try{
      signInModel = await ApiClient().getSignInData(email,password,true);
    }
    catch(e, stacktrace){

      print("Error --> $e");
      print("StackTrace --> $stacktrace");
    }
    return signInModel!;
  }
  @override
  Future<SignInModel?> socialLogin(
      String email,
      String firstName,
      String lastName,
      String phone
      ) async {
    SignInModel? signUpResponseModel;

    try {
      signUpResponseModel = await ApiClient().socialLogin(
          email,
          firstName,
          lastName,
          phone
      );
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return signUpResponseModel;
  }

}
