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


import 'package:bagisto_app_demo/models/checkout_models/save_payment_model.dart';

import '../../../../api/api_client.dart';

abstract class CheckOutReviewRepository{
  Future<SavePayment>savePaymentReview(String paymentMethod);

}
class CheckOutReviewRepositoryImp implements CheckOutReviewRepository {
  @override
  Future<SavePayment> savePaymentReview(String paymentMethod) async {
    SavePayment? savePaymentModel;
    try {
      savePaymentModel = await ApiClient().saveAndReview(paymentMethod);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return savePaymentModel!;
  }
}