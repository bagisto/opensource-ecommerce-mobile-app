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
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base_model/graphql_base_model.dart';
import '../events/address_base_event.dart';
import '../events/fetch_address_event.dart';
import '../events/remove_address_event.dart';
import '../repository/address_repository.dart';
import '../state/address_base_state.dart';
import '../state/ferch_address_state.dart';
import '../state/initial_address_state.dart';
import '../state/remove_address_state.dart';

class AddressBloc extends Bloc<AddressBaseEvent, AddressBaseState> {
  AddressRepository? repository;

  AddressBloc({@required this.repository}) : super(InitialAddressState()){
    on<AddressBaseEvent> (mapEventToState);
  }

void mapEventToState(AddressBaseEvent event,Emitter<AddressBaseState> emit) async {
    if (event is FetchAddressEvent) {
      try {
        AddressModel addressModel = await repository!.callAddressApi();

          emit (FetchAddressState.success(addressModel: addressModel));
      } catch (e) {
        emit (FetchAddressState.fail(error: e.toString()));
      }
    }else  if (event is RemoveAddressEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.callRemoveAddressApi(event.id);
        emit (RemoveAddressState.success(response: baseModel,customerDeletedId: event.id));

      } catch (e) {
        emit (RemoveAddressState.fail(error: e.toString()));
      }
    }

  }


}