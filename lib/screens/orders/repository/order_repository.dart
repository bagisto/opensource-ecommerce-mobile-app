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


import 'package:bagisto_app_demo/models/order_model/OrdersListModel.dart';

import '../../../api/api_client.dart';


abstract class OrderListRepository{
  Future<OrdersListModel> getOrderList(String ? id,String ? startDate,String ? endDate,String ? status,double ? total,int page);
}
class OrderListRepositoryImp implements OrderListRepository {
  @override
  Future<OrdersListModel> getOrderList(String ? id,String ? startDate,String ? endDate,String ? status,double ? total,int page) async {
    OrdersListModel? ordersListModel;
    try{
      ordersListModel=await ApiClient().getOrderList(id,startDate,endDate,status,total,page);
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return ordersListModel!;
  }

}
