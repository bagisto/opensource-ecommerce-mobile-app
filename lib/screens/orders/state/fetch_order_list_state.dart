/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/models/order_model/OrdersListModel.dart';
import 'package:bagisto_app_demo/screens/orders/state/order_list_base_state.dart';


class FetchOrderListState extends OrderListBaseState {

  OrderStatus? status;
  String? error;
  OrdersListModel? ordersListModel;

  FetchOrderListState.success({this.ordersListModel}) : status = OrderStatus.success;
  FetchOrderListState.fail({this.error}) : status = OrderStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (ordersListModel !=null) ordersListModel! else ""];
}
