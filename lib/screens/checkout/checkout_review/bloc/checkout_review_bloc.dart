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

import '../../data_model/save_payment_model.dart';
import 'checkout_review_base_event.dart';
import 'checkout_review_repository.dart';
import 'checkout_review_save_payment_state.dart';

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
