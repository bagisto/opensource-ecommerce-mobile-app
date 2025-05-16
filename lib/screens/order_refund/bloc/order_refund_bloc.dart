/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/order_refund/utils/index.dart';

class OrderRefundBloc extends Bloc<OrderRefundBaseEvent, OrderRefundBaseState> {
  OrderRefundRepositoryImp? repository;
  BuildContext? context;

  OrderRefundBloc({@required this.repository})
      : super(OrderRefundInitialState()) {
    on<OrderRefundBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      OrderRefundBaseEvent event, Emitter<OrderRefundBaseState> emit) async {
    if (event is OrderRefundFetchDataEvent) {
      try {
        OrderRefundModel refundData =
            await repository!.getRefundList(event.orderId);
        emit(
          OrderRefundListDataState.success(refundData: refundData),
        );
      } catch (e) {
        emit(OrderRefundListDataState.fail(error: e.toString()));
      }
    }
  }
}
