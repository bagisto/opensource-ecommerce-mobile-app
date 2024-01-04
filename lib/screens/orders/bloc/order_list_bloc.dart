/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:bagisto_app_demo/screens/orders/utils/index.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListBaseState> {
  OrderListRepository? repository;

  OrderListBloc({this.repository})
      : super(OrderInitialState()) {
    on<OrderListEvent>(mapEventToState);
  }

  void mapEventToState(
      OrderListEvent event, Emitter<OrderListBaseState> emit) async {
    if (event is FetchOrderListEvent) {
      try {
        OrdersListModel? ordersListModel = await repository?.getOrderList(
            event.id, event.startDate, event.endDate, event.status, event.total, event.page);
        emit(FetchOrderListState.success(ordersListModel: ordersListModel));
      } catch (e) {
        emit(FetchOrderListState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
