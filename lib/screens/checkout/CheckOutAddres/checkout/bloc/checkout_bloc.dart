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


import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/events/checkout_address_event.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/events/checkout_base_event.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/repository/checkout_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/state/checkout_address_state.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/state/checkout_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/state/checkout_loader_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class CheckOutBloc extends Bloc<CheckOutBaseEvent, CheckOutBaseState> {
  CheckOutRepository? repository;

  CheckOutBloc({@required this.repository}) : super(CheckOutLoaderState()){
    on<CheckOutBaseEvent> (mapEventToState);
  }

void mapEventToState(CheckOutBaseEvent event,Emitter<CheckOutBaseState> emit) async {
    if (event is CheckOutAddressEvent) {
      try {
        AddressModel addressModel = await repository!.callCheckoutAddressApi();

        emit (CheckOutAddressState.success(addressModel: addressModel));
      } catch (e) {
        emit (CheckOutAddressState.fail(error: e.toString()));
      }
    }

  }

}
