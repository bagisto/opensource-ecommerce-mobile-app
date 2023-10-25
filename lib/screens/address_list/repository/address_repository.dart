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
import 'package:bagisto_app_demo/models/address_model/address_model.dart';

abstract class AddressRepository{
  Future<AddressModel>callAddressApi();
  Future<GraphQlBaseModel> callRemoveAddressApi(int customerId);
}
class AddressRepositoryImp implements AddressRepository {
  @override
  Future<AddressModel> callAddressApi() async {

    AddressModel? addressModel;
    try{
      addressModel = await ApiClient().getAddressData();
    }catch(error, stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
     }
     return addressModel!;
      }

  @override
  Future<GraphQlBaseModel> callRemoveAddressApi(int id) async {

    GraphQlBaseModel? baseModel;
    try{
      baseModel = await ApiClient().deleteAddress(id);
    }catch(error, stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }



}