/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../../../../services/api_client.dart';
import 'package:flutter/material.dart';

import '../../../address_list/data_model/address_model.dart';

abstract class CheckOutRepository{
  Future<AddressModel>callCheckoutAddressApi();

}
class CheckOutRepositoryImp implements CheckOutRepository {
  @override
  Future<AddressModel> callCheckoutAddressApi() async {
    AddressModel? addressModel;
    try {
      addressModel = await ApiClient().getAddressData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return addressModel!;
  }
}