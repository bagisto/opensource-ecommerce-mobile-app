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

import '../../data_model/checkout_save_shipping_model.dart';


abstract class CheckOutPaymentRepository {
  Future<PaymentMethods> saveCheckOutPayment(String shippingMethod);
}

class CheckOutPaymentRepositoryImp implements CheckOutPaymentRepository {
  @override
  Future<PaymentMethods> saveCheckOutPayment(String shippingMethod) async {
    PaymentMethods? checkOutShipping;
    try {
      checkOutShipping = await ApiClient().saveShippingMethods(shippingMethod);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return checkOutShipping!;
  }
}
