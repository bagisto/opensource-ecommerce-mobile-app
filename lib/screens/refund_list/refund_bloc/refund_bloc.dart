
import 'package:bagisto_app_demo/screens/refund_list/refund_bloc/refund_event.dart';
import 'package:bagisto_app_demo/screens/refund_list/refund_bloc/refund_repository.dart';
import 'package:bagisto_app_demo/screens/refund_list/refund_bloc/refund_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/order_model/order_refund_model.dart';


class RefundListBloc extends Bloc<RefundListBaseEvent, RefundListBaseState> {
  RefundListRepository? repository;

  RefundListBloc({@required this.repository}) : super(RefundListInitialState()) {on<RefundListBaseEvent>(mapEventToState);
  }

  void mapEventToState(RefundListBaseEvent event, Emitter<RefundListBaseState> emit) async {
    if (event is RefundListFetchDataEvent) {
      try {
        OrderRefundModel model = await repository!.getRefundList(event.page, event.orderId);
        if (model.status == true) {
          emit(RefundListFetchDataState.success(refundModel : model));
        } else {
          emit(RefundListFetchDataState.fail(error: model.success));
        }
      } catch (e) {
        emit(RefundListFetchDataState.fail(error: e.toString()));
      }
    }
  }
}