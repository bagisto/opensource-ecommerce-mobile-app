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


import 'package:bagisto_app_demo/models/checkout_models/save_payment_model.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/event/checkout_review_base_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/event/checkout_review_save_payment_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/repository/checkout_review_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/state/checkout_review_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/state/checkout_review_initial_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/state/checkout_review_save_payment_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutReviewBloc extends Bloc<CheckOutReviewBaseEvent, CheckOutReviewBaseState> {
  CheckOutReviewRepository? repository;

  CheckOutReviewBloc({@required this.repository}) : super(CheckOutReviewInitialState()){
    on<CheckOutReviewBaseEvent>(mapEventToState);
  }

void mapEventToState(CheckOutReviewBaseEvent event,Emitter<CheckOutReviewBaseState> emit) async {
    if (event is CheckOutReviewSavePaymentEvent) {
      try {
        SavePayment savePaymentModel = await repository!.savePaymentReview(event.paymentMethod??"");

        emit (CheckOutReviewSavePaymentState.success(savePaymentModel: savePaymentModel));
      } catch (e) {
        emit (CheckOutReviewSavePaymentState.fail(error: e.toString()));
      }
    }

  }

}
