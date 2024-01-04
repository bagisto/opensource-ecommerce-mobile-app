/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bagisto_app_demo/screens/order_detail/utils/index.dart';

class OrderDetailBloc extends Bloc<OrderDetailBaseEvent, OrderDetailBaseState> {
  OrderDetailRepository? repository;
  BuildContext? context;

  OrderDetailBloc({@required this.repository})
      : super(OrderDetailInitialState()) {
    on<OrderDetailBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      OrderDetailBaseEvent event, Emitter<OrderDetailBaseState> emit) async {
    if (event is OrderDetailFetchDataEvent) {
      try {
        OrderDetail orderDetailModel =
        await repository!.getOrderDetails(event.orderId ?? 1);
        if (orderDetailModel.responseStatus == true) {
          emit(
            OrderDetailFetchDataState.success(
                orderDetailModel: orderDetailModel),
          );
        } else {
          emit(OrderDetailFetchDataState.fail(error: orderDetailModel.success));
        }
      } catch (e) {
        emit(OrderDetailFetchDataState.fail(error: e.toString()));
      }
    } else if (event is CancelOrderEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.cancelOrder(event.id??0);
        if (baseModel.status == true) {
          emit(CancelOrderState.success(
              baseModel: baseModel,
              successMsg: baseModel.success));
        } else {
          emit(CancelOrderState.fail(error: baseModel.error));
        }
      } catch (e) {
        emit(CancelOrderState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }else if(event is OnClickOrderLoadingEvent){
      emit (OnClickLoadingState(isReqToShowLoader: event.isReqToShowLoader));
    }
  }
}
