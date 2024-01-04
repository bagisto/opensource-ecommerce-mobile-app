/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:flutter/material.dart';
import '../../../utils/index.dart';
import 'package:bagisto_app_demo/screens/orders/utils/index.dart';

abstract class OrderListRepository {
  Future<OrdersListModel> getOrderList(String? id, String? startDate,
      String? endDate, String? status, double? total, int? page);
}

class OrderListRepositoryImp implements OrderListRepository {
  @override
  Future<OrdersListModel> getOrderList(String? id, String? startDate,
      String? endDate, String? status, double? total, int? page) async {
    OrdersListModel? ordersListModel;
    try {
      ordersListModel = await ApiClient()
          .getOrderList(id, startDate, endDate, status, total, page);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return ordersListModel!;
  }
}
