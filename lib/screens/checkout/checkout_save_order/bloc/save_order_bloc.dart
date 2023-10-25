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


import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/event/save_order_base_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/event/save_order_fetch_data_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/repository/save_order_repositroy.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/state/save_order_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/state/save_order_initial_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/state/save_oredr_fetch_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/checkout_models/save_order_model.dart';


class SaveOrderBloc extends Bloc<SaveOrderBaseEvent, SaveOrderBaseState> {
  SaveOrderRepository? repository;

  SaveOrderBloc({@required this.repository}) : super(SaveOrderInitialState()){
    on<SaveOrderBaseEvent>(mapEventToState);
  }
  void mapEventToState(SaveOrderBaseEvent event,Emitter<SaveOrderBaseState> emit) async {
    if (event is SaveOrderFetchDataEvent) {
      try {
        SaveOrderModel saveOrderModel = await repository!.savePaymentReview();
        // if (saveOrderModel.status == false) {
        //   emit (SaveOrderFetchDataState.fail(error: saveOrderModel.message));
        //
        // } else {
        if(saveOrderModel.success=="1") {
          emit (SaveOrderFetchDataState.success(saveOrderModel: saveOrderModel));
        }else{

        }
        // }
      } catch (e) {
        emit (SaveOrderFetchDataState.fail(error: e.toString()));
      }
    }

  }

}
