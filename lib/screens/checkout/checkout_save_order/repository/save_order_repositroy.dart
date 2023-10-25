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

import '../../../../api/api_client.dart';
import '../../../../models/checkout_models/save_order_model.dart';

abstract class SaveOrderRepository{
  Future<SaveOrderModel>savePaymentReview();

}
class SaveOrderRepositoryImp implements SaveOrderRepository {
  @override
  Future<SaveOrderModel> savePaymentReview() async {
    SaveOrderModel? saveOrderModel;
    try {
      saveOrderModel = await ApiClient().placeOrder();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return saveOrderModel!;
  }
}


