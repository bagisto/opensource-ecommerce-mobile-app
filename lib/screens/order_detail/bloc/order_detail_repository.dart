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


import 'package:bagisto_app_demo/data_model/order_model/order_detail_model.dart';
import '../../../utils/index.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';

abstract class OrderDetailRepository{
  Future<OrderDetail> getOrderDetails(int orderId);
  Future<BaseModel> cancelOrder(int id);
  Future<AddToCartModel?> reOrderCustomerOrder(String? id);
}
class OrderDetailRepositoryImp implements OrderDetailRepository {
  @override
  Future<OrderDetail> getOrderDetails(int orderId) async {
    OrderDetail? orderDetailModel;
    try{
      orderDetailModel=await ApiClient().getOrderDetail(orderId);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return orderDetailModel!;
  }


  @override
  Future<BaseModel> cancelOrder(int id)async{
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().cancelOrder(id);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }

  @override
  Future<AddToCartModel?> reOrderCustomerOrder(String? id) async {
    AddToCartModel? baseModel;
    try {
      baseModel = await ApiClient().reOrderCustomerOrder(id);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }
}
