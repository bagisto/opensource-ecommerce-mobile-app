/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_model/save_order_model.dart';
import 'save_order_base_event.dart';
import 'save_order_repositroy.dart';
import 'save_oredr_fetch_state.dart';


class SaveOrderBloc extends Bloc<SaveOrderBaseEvent, SaveOrderBaseState> {
  SaveOrderRepository? repository;

  SaveOrderBloc(this.repository) : super(SaveOrderInitialState()){
    on<SaveOrderBaseEvent>(mapEventToState);
  }
  void mapEventToState(SaveOrderBaseEvent event,Emitter<SaveOrderBaseState> emit) async {
    if (event is SaveOrderFetchDataEvent) {
      try {
        SaveOrderModel? saveOrderModel = await repository?.savePaymentReview();
        // if (saveOrderModel.status == false) {
        //   emit (SaveOrderFetchDataState.fail(error: saveOrderModel.message));
        //
        // } else {
        if(saveOrderModel?.success=="1") {
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
