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


import 'package:bagisto_app_demo/data_model/order_model/order_detail_model.dart';
import '../../../utils/index.dart';

abstract class OrderDetailRepository{
  Future<OrderDetail> getOrderDetails(int orderId);
  Future<GraphQlBaseModel> cancelOrder(int id);
}
class OrderDetailRepositoryImp implements OrderDetailRepository {
  @override
  Future<OrderDetail> getOrderDetails(int orderId) async {
    OrderDetail? orderDetailModel;
    try{
      orderDetailModel=await ApiClient().getOrderDetail(orderId);
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return orderDetailModel!;
  }


  @override
  Future<GraphQlBaseModel> cancelOrder(int id)async{
    GraphQlBaseModel? baseModel;
    baseModel = await ApiClient().cancelOrder(id);

    return baseModel!;
  }
}
