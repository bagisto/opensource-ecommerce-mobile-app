/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/account_models/account_info_details.dart';
import 'package:bagisto_app_demo/data_model/account_models/account_update_model.dart';
import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/services/api_client.dart';
import 'package:flutter/material.dart';

abstract class AccountInfoRepository {
  Future<AccountInfoDetails> callAccountDetailsApi();

  Future<AccountUpdate> callAccountUpdateApi(
      String firstName,
      String lastName,
      String email,
      String gender,
      String dob,
      String phone,
      String oldPassword,
      String password,
      String confirmPassword,
      String avatar);

  Future<GraphQlBaseModel> callDeleteAccountApi(String password);
}

class AccountInfoRepositoryImp implements AccountInfoRepository {
  @override
  Future<AccountInfoDetails> callAccountDetailsApi() async {
    AccountInfoDetails? accountInfoDetails;
    try {
      accountInfoDetails = await ApiClient().getCustomerData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return accountInfoDetails!;
  }

  @override
  Future<AccountUpdate> callAccountUpdateApi(
      String firstName,
      String lastName,
      String email,
      String gender,
      String dob,
      String phone,
      String oldPassword,
      String password,
      String confirmPassword,
      String avatar) async {
    AccountUpdate? accountUpdate;
    try {
      accountUpdate = await ApiClient().updateCustomerData(
          firstName,
          lastName,
          email,
          gender,
          dob,
          phone,
          password,
          confirmPassword,
          oldPassword,
          avatar);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return accountUpdate!;
  }

  @override
  Future<GraphQlBaseModel> callDeleteAccountApi(String password) async {
    GraphQlBaseModel? baseModel;
    try {
      baseModel = await ApiClient().deleteCustomerAccount(password);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }
}
