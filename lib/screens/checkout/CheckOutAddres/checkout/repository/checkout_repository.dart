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

import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import '../../../../../api/api_client.dart';

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
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return addressModel!;
  }
}