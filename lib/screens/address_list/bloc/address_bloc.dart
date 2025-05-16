/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/address_list/utils/index.dart';

import '../data_model/default_address_model.dart';

class AddressBloc extends Bloc<AddressBaseEvent, AddressBaseState> {
  AddressRepository? repository;

  AddressBloc(this.repository) : super(InitialAddressState()) {
    on<AddressBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      AddressBaseEvent event, Emitter<AddressBaseState> emit) async {
    if (event is FetchAddressEvent) {
      try {
        AddressModel? addressModel = await repository?.callAddressApi();
        emit(FetchAddressState.success(addressModel: addressModel));
      } catch (e) {
        emit(FetchAddressState.fail(error: e.toString()));
      }
    } else if (event is RemoveAddressEvent) {
      try {
        BaseModel? baseModel = await repository?.callRemoveAddressApi(event.id);
        emit(RemoveAddressState.success(
            response: baseModel, customerDeletedId: event.id));
      } catch (e) {
        emit(RemoveAddressState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is SetDefaultAddressEvent) {
      emit(ShowLoaderState());
      try {
        SetDefaultAddress? baseModel =
            await repository?.setDefaultAddress(event.id);
        if (baseModel?.success == true) {
          emit(SetDefaultAddressState.success(addressModel: baseModel));
        } else {
          emit(SetDefaultAddressState.fail(
              message: baseModel?.message ?? baseModel?.graphqlErrors));
        }
      } catch (e) {
        emit(SetDefaultAddressState.fail(
            message: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
