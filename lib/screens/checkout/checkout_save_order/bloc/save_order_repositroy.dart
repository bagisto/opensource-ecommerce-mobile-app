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

import '../../data_model/save_order_model.dart';

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
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return saveOrderModel!;
  }
}


