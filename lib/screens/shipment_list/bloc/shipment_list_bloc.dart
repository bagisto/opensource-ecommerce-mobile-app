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



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/order_model/shipment_model.dart';
import '../event/shipment_list_event.dart';
import '../repository/shipment_list_repository.dart';
import '../state/shipment_list_state.dart';

class ShipmentListBloc extends Bloc<ShipmentListBaseEvent, ShipmentListBaseState> {
  ShipmentListRepository? repository;

  ShipmentListBloc({@required this.repository}) : super(ShipmentListInitialState()) {on<ShipmentListBaseEvent>(mapEventToState);
  }

  void mapEventToState(ShipmentListBaseEvent event, Emitter<ShipmentListBaseState> emit) async {
    if (event is ShipmentListFetchDataEvent) {
      try {
        ShipmentModel orderDetailModel = await repository!.getShipmentList(event.page, event.orderId ?? 1);
        if (orderDetailModel.status == true) {
          emit(ShipmentListFetchDataState.success(shipmentModel : orderDetailModel));
        } else {
          emit(ShipmentListFetchDataState.fail(error: orderDetailModel.success));
        }
      } catch (e) {
        emit(ShipmentListFetchDataState.fail(error: e.toString()));
      }
    }
  }
}
