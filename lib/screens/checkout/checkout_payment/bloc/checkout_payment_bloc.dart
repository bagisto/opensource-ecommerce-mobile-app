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


import 'package:bagisto_app_demo/screens/checkout/checkout_payment/event/checkout_fetch_payment_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/event/checkout_payment_base_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/repository/checkout_payment_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/state/checkout_fetch_payment_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/state/checkout_payment_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/state/checkout_payment_initial_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/checkout_models/checkout_save_shipping_model.dart';


class CheckOutPaymentBloc extends Bloc<CheckOutPaymentBaseEvent, CheckOutPaymentBaseState> {
  CheckOutPaymentRepository? repository;

  CheckOutPaymentBloc({@required this.repository}) : super(CheckOutPaymentInitialState()){
    on<CheckOutPaymentBaseEvent> (mapEventToState);
  }

void mapEventToState(CheckOutPaymentBaseEvent event,Emitter<CheckOutPaymentBaseState> emit) async {
    if (event is CheckOutPaymentEvent) {
      try {
        String shippingMethod = (event.shippingMethod ?? "").isNotEmpty ? event.shippingMethod! : "flatrate_flatrate";
        PaymentMethods checkOutShipping = await repository!.saveCheckOutPayment(shippingMethod);
        emit (CheckOutFetchPaymentState.success(checkOutShipping: checkOutShipping));
      } catch (e) {
        emit (CheckOutFetchPaymentState.fail(error: e.toString()));
      }
    }

  }

}
