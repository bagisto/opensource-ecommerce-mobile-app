/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/orders/utils/index.dart';


abstract class OrderListBaseState extends Equatable {}

enum OrderStatus { success, fail }

class OrderInitialState extends OrderListBaseState {
  @override
  List<Object> get props => [];
}

class FetchOrderListState extends OrderListBaseState {

 final OrderStatus? status;
  final String? error;
  final OrdersListModel? ordersListModel;

  FetchOrderListState.success({this.ordersListModel,this.error, }) : status = OrderStatus.success;
  FetchOrderListState.fail( {this.error,this.ordersListModel,}) : status = OrderStatus.fail;

  @override
  List<Object> get props => [if (ordersListModel !=null) ordersListModel! else ""];
}
