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
import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';


abstract class ForgetPasswordRepository{
  Future<GraphQlBaseModel>callForgetPasswordApi(String email);
}
class ForgetPasswordRepositoryImp implements ForgetPasswordRepository {
  @override
  Future<GraphQlBaseModel> callForgetPasswordApi(String email) async {

    GraphQlBaseModel? baseModel;
    try{
      baseModel = await ApiClient().forgotPassword(email);
    }
    catch(e, stacktrace){

      print("Error --> $e");
      print("StackTrace --> $stacktrace");

    }
    return baseModel!;
  }

}