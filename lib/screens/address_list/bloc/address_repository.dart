/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../../data_model/graphql_base_model.dart';
import '../../../services/api_client.dart';
import '../data_model/address_model.dart';
import 'package:flutter/material.dart';

abstract class AddressRepository {
  Future<AddressModel> callAddressApi();

  Future<GraphQlBaseModel> callRemoveAddressApi(String? customerId);
}

class AddressRepositoryImp implements AddressRepository {
  @override
  Future<AddressModel> callAddressApi() async {
    AddressModel? addressModel;
    try {
      addressModel = await ApiClient().getAddressData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return addressModel!;
  }

  @override
  Future<GraphQlBaseModel> callRemoveAddressApi(String? id) async {
    GraphQlBaseModel? baseModel;
    try {
      baseModel = await ApiClient().deleteAddress(id);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }
}
