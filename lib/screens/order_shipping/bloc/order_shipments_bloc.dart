/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/order_shipping/utils/index.dart';

class OrderShipmentsBloc
    extends Bloc<OrderShipmentsBaseEvent, OrderShipmentsBaseState> {
  OrderShipmentsRepositoryImp? repository;
  BuildContext? context;

  OrderShipmentsBloc({@required this.repository})
      : super(OrderShipmentsInitialState()) {
    on<OrderShipmentsBaseEvent>(mapEventToState);
  }

  void mapEventToState(OrderShipmentsBaseEvent event,
      Emitter<OrderShipmentsBaseState> emit) async {
    if (event is OrderShipmentsFetchDataEvent) {
      try {
        ShipmentModel shipmentData =
            await repository!.getShipmentsList(event.orderId);
        emit(
          OrderShipmentsListDataState.success(shipmentData: shipmentData),
        );
      } catch (e) {
        emit(OrderShipmentsListDataState.fail(error: e.toString()));
      }
    }
  }
}
