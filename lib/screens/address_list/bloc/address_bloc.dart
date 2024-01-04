/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../../data_model/graphql_base_model.dart';
import '../../cart_screen/cart_index.dart';
import '../data_model/address_model.dart';
import 'address_repository.dart';
import 'ferch_address_state.dart';
import 'fetch_address_event.dart';

class AddressBloc extends Bloc<AddressBaseEvent, AddressBaseState> {
  AddressRepository? repository;

  AddressBloc(this.repository) : super(InitialAddressState()){
    on<AddressBaseEvent> (mapEventToState);
  }

void mapEventToState(AddressBaseEvent event,Emitter<AddressBaseState> emit) async {
    if (event is FetchAddressEvent) {
      try {
        AddressModel? addressModel = await repository?.callAddressApi();
          emit (FetchAddressState.success(addressModel: addressModel));
      } catch (e) {
        emit (FetchAddressState.fail(error: e.toString()));
      }
    }else  if (event is RemoveAddressEvent) {
      try {
        GraphQlBaseModel? baseModel = await repository?.callRemoveAddressApi(event.id);
        emit(RemoveAddressState.success(response: baseModel,customerDeletedId: event.id));
      } catch (e) {
        emit(RemoveAddressState.fail(error: e.toString()));
      }
    }

  }


}