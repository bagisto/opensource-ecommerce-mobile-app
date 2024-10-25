/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */




import 'package:bagisto_app_demo/screens/add_edit_address/utils/index.dart';

import '../../address_list/data_model/update_address_model.dart';


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
                event.isDefault ?? false, event.email ?? appStoragePref.getCustomerEmail());

        if (updateAddressModel?.status == true) {
          emit(
            FetchEditAddressState.success(
              updateAddressModel: updateAddressModel,
            ),
          );
        } else {
          emit(
            FetchEditAddressState.fail(
              error: updateAddressModel?.graphqlErrors ?? "",
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
        BaseModel? baseModel = await repository?.callCreateAddress(
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
            event.isDefault ?? false, event.email ?? appStoragePref.getCustomerEmail());

        if (baseModel?.status == true) {
          emit(FetchAddAddressState.success(baseModel: baseModel));
        } else {
          emit(FetchAddAddressState.fail(error: baseModel?.graphqlErrors));
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
