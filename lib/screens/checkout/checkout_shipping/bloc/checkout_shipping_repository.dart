/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';
import '../../data_model/checkout_save_address_model.dart';

abstract class CheckOutShippingRepository{
  Future<SaveCheckoutAddresses>saveCheckOutShipping(
      String? billingCompanyName,
      String? billingFirstName,
      String? billingLastName,
      String? billingAddress,
      String? billingEmail,
      String? billingAddress2,
      String? billingCountry,
      String? billingState,
      String? billingCity,
      String? billingPostCode,
      String? billingPhone,
      String? shippingCompanyName,
      String? shippingFirstName,
      String? shippingLastName,
      String? shippingAddress,
      String? shippingEmail,
      String? shippingAddress2,
      String? shippingCountry,
      String? shippingState,
      String? shippingCity,
      String? shippingPostCode,
      String? shippingPhone, int id,
      {int? billingId,
      int? shippingId, bool useForShipping});

}
class CheckOutShippingRepositoryImp implements CheckOutShippingRepository {
  @override
  Future<SaveCheckoutAddresses> saveCheckOutShipping(
      String? billingCompanyName,
      String? billingFirstName,
      String? billingLastName,
      String? billingAddress,
      String? billingEmail,
      String? billingAddress2,
      String? billingCountry,
      String? billingState,
      String? billingCity,
      String? billingPostCode,
      String? billingPhone,
      String? shippingCompanyName,
      String? shippingFirstName,
      String? shippingLastName,
      String? shippingAddress,
      String? shippingEmail,
      String? shippingAddress2,
      String? shippingCountry,
      String? shippingState,
      String? shippingCity,
      String? shippingPostCode,
      String? shippingPhone, int id, {
        int? billingId,
        int? shippingId, bool useForShipping = true}) async {
    SaveCheckoutAddresses? checkOutSaveAddressModel;
    try {
      checkOutSaveAddressModel = await ApiClient().checkoutSaveAddress(
        billingCompanyName,
        billingFirstName,
        billingLastName,
        billingAddress,
        billingEmail,
        billingAddress2,
        billingCountry,
        billingState,
        billingCity,
        billingPostCode,
        billingPhone,
        shippingCompanyName,
        shippingFirstName,
        shippingLastName,
        shippingAddress,
        shippingEmail,
        shippingAddress2,
        shippingCountry,
        shippingState,
        shippingCity,
        shippingPostCode,
        shippingPhone, id, useForShipping: useForShipping);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return checkOutSaveAddressModel!;
  }
}