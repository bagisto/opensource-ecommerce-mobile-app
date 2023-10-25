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



import 'package:bagisto_app_demo/screens/checkout/guest_add_address/event/guest_address_base_event.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/event/guest_address_country_event.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/repository/guest_address_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/state/guest_address_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/state/guest_address_country_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/address_model/country_model.dart';
import '../state/guest_initial_state.dart';

class GuestAddressBloc extends Bloc<GuestAddressBaseEvent, GuestAddressBaseState> {
  GuestAddressRepository? repository;

  GuestAddressBloc({@required this.repository}) : super(GuestAddressInitialState()){
    on<GuestAddressBaseEvent>(mapEventToState);
  }

void mapEventToState(GuestAddressBaseEvent event,Emitter<GuestAddressBaseState> emit) async {
    if(event is GuestAddressCountryEvent){
      try {
        CountriesData countryData = await repository!.callCountriesData();

        emit (GuestAddressCountryState.success(countryData: countryData));
        // }
      } catch (e) {
        emit (GuestAddressCountryState.fail(error: e.toString()));
      }
    }


  }


}
