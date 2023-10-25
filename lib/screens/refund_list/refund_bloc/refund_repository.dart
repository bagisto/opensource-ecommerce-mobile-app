import 'package:flutter/foundation.dart';

import '../../../../api/api_client.dart';
import '../../../../models/order_model/order_refund_model.dart';

abstract class RefundListRepository{
  Future<OrderRefundModel> getRefundList(int page, int orderId);
}
class RefundListRepositoryImp implements RefundListRepository {
  @override
  Future<OrderRefundModel> getRefundList(int page, int orderId) async {
    OrderRefundModel? refundModel;
    try{
      refundModel = await ApiClient().getRefundList(page, orderId);
    }
    catch(error,stacktrace){
      if (kDebugMode) {
        print("Error --> $error");
      }
      if (kDebugMode) {
        print("StackTrace --> $stacktrace");
      }
    }
    return refundModel!;
  }

}