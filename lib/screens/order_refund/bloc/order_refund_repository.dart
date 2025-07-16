/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print


import 'package:bagisto_app_demo/screens/order_refund/utils/index.dart';

abstract class OrderRefundRepository{
  Future<OrderRefundModel> getRefundList(int orderId);
}
class OrderRefundRepositoryImp implements OrderRefundRepository {
  @override
  Future<OrderRefundModel> getRefundList(int orderId) async {
    OrderRefundModel? refundData;
    try{
      refundData=await ApiClient().getRefundList(orderId);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return refundData!;
  }



}
