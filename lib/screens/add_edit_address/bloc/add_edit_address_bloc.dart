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

import '../../../data_model/graphql_base_model.dart';
import '../../address_list/data_model/country_model.dart';
import '../../address_list/data_model/update_address_model.dart';
import 'add_edit_address_repository.dart';
import 'address_country_event.dart';
import 'fetch_add_address_state.dart';

class AddEditAddressBloc
    extends Bloc<AddEditAddressBaseEvent, AddEditAddressBaseState> {
  AddEditAddressRepository? repository;

  AddEditAddressBloc(this.repository) : super(InitialAddEditAddressState()) {
    on<AddEditAddressBaseEvent>(mapEventToState);
  }

  void mapEventToState(AddEditAddressBaseEvent event,
      Emitter<AddEditAddressBaseState> emit) async {
    if (event is FetchEditAddressEvent) {
      try {
        UpdateAddressModel? updateAddressModel =
            await repository?.callEditAddressApi(
                event.addressId ?? 0,
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
                event.isDefault ?? false);

        if (updateAddressModel?.status == true) {
          emit(
            FetchEditAddressState.success(
              updateAddressModel: updateAddressModel,
            ),
          );
        } else {
          emit(
            FetchEditAddressState.fail(
              error: updateAddressModel?.success ?? "",
            ),
          );
        }

        // }
      } catch (e) {
        emit(FetchEditAddressState.fail(
            error: "e.toString()===>${e.toString()}"));
      }
    } else if (event is FetchAddAddressEvent) {
      try {
        GraphQlBaseModel? baseModel = await repository?.callCreateAddress(
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
            event.isDefault ?? false);

        if (baseModel?.status == true) {
          emit(FetchAddAddressState.success(baseModel: baseModel));
        } else {
          emit(FetchAddAddressState.fail(error: baseModel?.success));
        }
      } catch (e) {
        emit(FetchAddAddressState.fail(error: e.toString()));
      }
    } else if (event is AddressCountryEvent) {
      try {
        CountriesData? countryData = await repository?.callCountriesData();

        emit(AddressCountryState.success(countryData: countryData));
      } catch (e) {
        emit(AddressCountryState.fail(error: e.toString()));
      }
    }
  }
}
