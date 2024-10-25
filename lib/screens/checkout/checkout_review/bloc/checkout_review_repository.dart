/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import '../../data_model/save_payment_model.dart';
import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';

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
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return savePaymentModel!;
  }
}