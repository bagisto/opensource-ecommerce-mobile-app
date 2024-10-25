/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */




import 'package:bagisto_app_demo/screens/address_list/utils/index.dart';

import '../data_model/default_address_model.dart';

abstract class AddressRepository {
  Future<AddressModel> callAddressApi();

  Future<BaseModel> callRemoveAddressApi(String? customerId);

  Future<SetDefaultAddress?> setDefaultAddress(String addressId);
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
  Future<BaseModel> callRemoveAddressApi(String? id) async {
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().deleteAddress(id);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }

  @override
  Future<SetDefaultAddress?> setDefaultAddress(String addressId) async {
    SetDefaultAddress? baseModel;
    try {
      baseModel = await ApiClient().setDefaultAddress(addressId);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }
}
