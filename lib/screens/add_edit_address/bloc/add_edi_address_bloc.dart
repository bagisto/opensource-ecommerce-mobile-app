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

import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/models/address_model/update_address_model.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/events/add_edit_address_base_event.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/events/address_country_event.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/events/fetch_add_address_event.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/events/fetch_edit_address_event.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/state/address_country_state.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/state/fetch_add_address_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/address_model/country_model.dart';
import '../repository/add_edit_address_repository.dart';
import '../state/fetch_edit_address_state.dart';

class AddEditAddressBloc
    extends Bloc<AddEditAddressBaseEvent, AddEditAddressBaseState> {
  AddEditAddressRepository? repository;

  AddEditAddressBloc({@required this.repository})
      : super(InitialAddEditAddressState()) {
    on<AddEditAddressBaseEvent>(mapEventToState);
  }

  void mapEventToState(AddEditAddressBaseEvent event,
      Emitter<AddEditAddressBaseState> emit) async {
    if (event is FetchEditAddressEvent) {
      try {
        UpdateAddressModel updateAddressModel =
            await repository!.callEditAddressApi(
          event.addressId ?? 9,
          event.companyName ?? "",
          event.firstName ?? "",
          event.lastName ?? "",
          event.address ?? "",
          event.country ?? "",
          event.state ?? "",
          event.city ?? "",
          event.postCode ?? "",
          event.phone ?? "",
          event.vatId ?? "",
        );

        if (updateAddressModel.status == true) {
          emit(
            FetchEditAddressState.success(
              updateAddressModel: updateAddressModel,
            ),
          );
        } else {
          emit(
            FetchEditAddressState.fail(
              error: updateAddressModel.success ?? "",
            ),
          );
        }
      } catch (e) {
        emit(FetchEditAddressState.fail(
            error: "e.toString()===>${e.toString()}"));
      }
    } else if (event is FetchAddAddressEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.callCreateAddress(
            event.companyName ?? "",
            event.firstName ?? "",
            event.lastName ?? "",
            event.address ?? "",
            event.country ?? "",
            event.state ?? "",
            event.city ?? "",
            event.postCode ?? "",
            event.phone ?? "",
            event.vatId ?? "");

        if (baseModel.status == true) {
          emit(FetchAddAddressState.success(baseModel: baseModel));
        } else {
          emit(FetchAddAddressState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(FetchAddAddressState.fail(error: e.toString()));
      }
    } else if (event is AddressCountryEvent) {
      try {
        CountriesData countryData = await repository!.callCountriesData();

        emit(AddressCountryState.success(countryData: countryData));
      } catch (e) {
        emit(AddressCountryState.fail(error: e.toString()));
      }
    }
  }
}
