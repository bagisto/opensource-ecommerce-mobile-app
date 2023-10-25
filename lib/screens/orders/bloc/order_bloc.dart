/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/order_model/OrdersListModel.dart';
import 'package:bagisto_app_demo/screens/orders/event/fetch_order_event.dart';
import 'package:bagisto_app_demo/screens/orders/event/fetch_order_list_event.dart';
import 'package:bagisto_app_demo/screens/orders/repository/order_repository.dart';
import 'package:bagisto_app_demo/screens/orders/state/fetch_order_list_state.dart';
import 'package:bagisto_app_demo/screens/orders/state/fetch_order_list_initial_state.dart';
import 'package:bagisto_app_demo/screens/orders/state/order_list_base_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderListBloc extends Bloc<OrderListBaseEvent,OrderListBaseState> {
  OrderListRepository? repository;
  BuildContext? context;

  OrderListBloc({@required this.repository,this.context}) : super(OrderInitialState()){
    on<OrderListBaseEvent>(mapEventToState);
  }

  void mapEventToState(OrderListBaseEvent event,Emitter<OrderListBaseState> emit) async {
    if (event is FetchOrderListEvent) {
      try {
        OrdersListModel ordersListModel = await repository!.getOrderList(event.id,event.startDate,event.endDate,event.status,event.total,event.page ?? 1);
        emit (FetchOrderListState.success(ordersListModel: ordersListModel));
      } catch (e) {
        emit (FetchOrderListState.fail(error:"SomethingWrong".localized()));
      }
    }
  }
}
