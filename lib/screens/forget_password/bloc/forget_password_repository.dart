/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print


import 'package:bagisto_app_demo/screens/forget_password/utils/index.dart';

abstract class ForgetPasswordRepository{
  Future<BaseModel>callForgetPasswordApi(String email);
}
class ForgetPasswordRepositoryImp implements ForgetPasswordRepository {
  @override
  Future<BaseModel> callForgetPasswordApi(String email) async {

    BaseModel? baseModel;
    try{
      baseModel = await ApiClient().forgotPassword(email);
    }
    catch(e, stacktrace){

      debugPrint("Error --> $e");
      debugPrint("StackTrace --> $stacktrace");

    }
    return baseModel!;
  }

}