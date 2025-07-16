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
  Future<SaveOrderModel>savePaymentReview({Map<String, dynamic>? serverPayload});

}
class SaveOrderRepositoryImp implements SaveOrderRepository {
  @override
  Future<SaveOrderModel> savePaymentReview({Map<String, dynamic>? serverPayload}) async {
    SaveOrderModel? saveOrderModel;
    try {
      saveOrderModel = await ApiClient().placeOrder(serverPayload: serverPayload);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return saveOrderModel!;
  }
}


