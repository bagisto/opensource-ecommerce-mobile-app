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
import 'package:bagisto_app_demo/models/account_models/account_info_details.dart';

import '../../../models/account_models/account_update_model.dart';

abstract class AccountInfoRepository{
  Future<AccountInfoDetails>callAccountDetailsApi();
  Future<AccountUpdate>callAccountUpdateApi(String firstName,String lastName,String email,String gender,String dob,String phone,
      String oldPassword,String password,String confirmPassword,String avatar);
  Future<GraphQlBaseModel> callDeleteAccountApi(String password);
}
class AccountInfoRepositoryImp implements AccountInfoRepository {

  @override
  Future<AccountInfoDetails> callAccountDetailsApi() async {

    AccountInfoDetails? accountInfoDetails;
    try{
      accountInfoDetails = await ApiClient().getCustomerData();
    }catch(error, stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return accountInfoDetails!;
  }


  @override
  Future<AccountUpdate> callAccountUpdateApi(String firstName,String lastName,String email,String gender,String dob,String phone,
      String oldPassword,String password,String confirmPassword,String avatar) async {

    AccountUpdate? accountUpdate;
    try{
      accountUpdate = await ApiClient().updateCustomerData(firstName,lastName,email,gender,dob,phone,password,confirmPassword,oldPassword,avatar);
    }catch(error, stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return accountUpdate!;
  }


  @override
  Future<GraphQlBaseModel> callDeleteAccountApi(String password) async {

    GraphQlBaseModel? baseModel;
    try{
      baseModel = await ApiClient().deleteCustomerAccount(password);
    }catch(error, stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }

}
