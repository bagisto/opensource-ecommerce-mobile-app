/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import '../../../data_model/account_models/account_update_model.dart';
import '../utils/index.dart';

abstract class AccountInfoRepository {
  Future<AccountInfoModel> callAccountDetailsApi();

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
      String? avatar,
      bool subscribedToNewsLetter);

  Future<BaseModel> callDeleteAccountApi(String password);
}

class AccountInfoRepositoryImp implements AccountInfoRepository {
  @override
  Future<AccountInfoModel> callAccountDetailsApi() async {
    AccountInfoModel? accountInfoDetails;
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
      String? avatar,
      bool subscribedToNewsLetter) async {
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
          avatar,
          subscribedToNewsLetter);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return accountUpdate!;
  }

  @override
  Future<BaseModel> callDeleteAccountApi(String password) async {
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().deleteCustomerAccount(password);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }
}
