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


import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/event/checkout_fetch_shipping_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/event/checkout_shipping_base_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/repository/checkout_shipping_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/state/checkout_fetch_shipping_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/state/checkout_shipping_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/state/checkout_shipping_initial_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/checkout_models/checkout_save_address_model.dart';



class CheckOutShippingBloc extends Bloc<CheckOutShippingBaseEvent, CheckOutShippingBaseState> {
  CheckOutShippingRepository? repository;

  CheckOutShippingBloc({@required this.repository}) : super(CheckOutShippingInitialState()){
    on<CheckOutShippingBaseEvent> (mapEventToState);
  }



void mapEventToState(CheckOutShippingBaseEvent event,Emitter<CheckOutShippingBaseState> emit) async {
    if (event is CheckOutFetchShippingEvent) {
      try {

        SaveCheckoutAddresses checkOutSaveAddressModel = await repository!.saveCheckOutShipping(
          event.billingCompanyName,
          event.billingFirstName,
          event.billingLastName,
          event.billingAddress,
          event.billingEmail,
          event.billingAddress2,
          event.billingCountry,
          event.billingState,
          event.billingCity,
          event.billingPostCode,
          event.billingPhone,
          event.shippingCompanyName,
          event.shippingFirstName,
          event.shippingLastName,
          event.shippingAddress,
          event.shippingEmail,
          event.shippingAddress2,
          event.shippingCountry,
          event.shippingState,
          event.shippingCity,
          event.shippingPostCode,
          event.shippingPhone,
        );
        if (checkOutSaveAddressModel.responseStatus == false) {
          emit (CheckOutFetchShippingState.fail(error: checkOutSaveAddressModel.success));

        } else {
          emit (CheckOutFetchShippingState.success(checkOutSaveAddressModel: checkOutSaveAddressModel));
        }
      } catch (e) {
        emit (CheckOutFetchShippingState.fail(error: "error"));
      }
    }

  }

}
