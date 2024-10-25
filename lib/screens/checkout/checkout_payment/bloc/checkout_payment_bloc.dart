/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';

import '../../data_model/checkout_save_shipping_model.dart';


class CheckOutPaymentBloc
    extends Bloc<CheckOutPaymentBaseEvent, CheckOutPaymentBaseState> {
  CheckOutPaymentRepository? repository;

  CheckOutPaymentBloc(this.repository)
      : super(CheckOutPaymentInitialState()) {
    on<CheckOutPaymentBaseEvent>(mapEventToState);
  }

  void mapEventToState(CheckOutPaymentBaseEvent event,
      Emitter<CheckOutPaymentBaseState> emit) async {
    if (event is CheckOutPaymentEvent) {
      try {
        String shippingMethod = (event.shippingMethod ?? "").isNotEmpty
            ? event.shippingMethod! : "flatrate_flatrate";
        PaymentMethods? checkOutShipping =
            await repository?.saveCheckOutPayment(shippingMethod);

        emit(CheckOutFetchPaymentState.success(
            checkOutShipping: checkOutShipping));
      } catch (e) {
        emit(CheckOutFetchPaymentState.fail(error: e.toString()));
      }
    }
  }
}
