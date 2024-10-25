/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */





import 'package:bagisto_app_demo/screens/checkout/data_model/save_payment_model.dart';
import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';


class CheckOutReviewBloc
    extends Bloc<CheckOutReviewBaseEvent, CheckOutReviewBaseState> {
  CheckOutReviewRepository? repository;

  CheckOutReviewBloc(this.repository)
      : super(CheckOutReviewInitialState()) {
    on<CheckOutReviewBaseEvent>(mapEventToState);
  }

  void mapEventToState(CheckOutReviewBaseEvent event,
      Emitter<CheckOutReviewBaseState> emit) async {
    if (event is CheckOutReviewSavePaymentEvent) {
      try {
        SavePayment? savePaymentModel =
            await repository?.savePaymentReview(event.paymentMethod ?? "");

        emit(CheckOutReviewSavePaymentState.success(
            savePaymentModel: savePaymentModel));
      } catch (e) {
        emit(CheckOutReviewSavePaymentState.fail(error: e.toString()));
      }
    }
  }
}
