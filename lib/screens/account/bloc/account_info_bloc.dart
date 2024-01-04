/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/account_models/account_info_details.dart';
import 'package:bagisto_app_demo/data_model/account_models/account_update_model.dart';
import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_details_event.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_repository.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_detail_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountInfoBloc extends Bloc<AccountInfoBaseEvent, AccountInfoBaseState> {
  AccountInfoRepository? repository;

  AccountInfoBloc({@required this.repository}) : super(InitialAccountState()){
    on<AccountInfoBaseEvent>(mapEventToState);
  }

  void mapEventToState(AccountInfoBaseEvent event,Emitter <AccountInfoBaseState> emit) async {
    if (event is AccountInfoDetailsEvent) {
      try {
        AccountInfoDetails accountInfoDetails = await repository!.callAccountDetailsApi();
        emit (AccountInfoDetailState.success(accountInfoDetails: accountInfoDetails));
      } catch (e) {
        emit (AccountInfoDetailState.fail(error: e.toString()));
      }
    }else if(event is AccountInfoUpdateEvent){
      try{
        AccountUpdate accountUpdate=await repository!.callAccountUpdateApi(event.firstName??"", event.lastName??"", event.email??"", event.gender??"",event.dob??"",event.phone??"",event.oldPassword??"",
            event.password??"",event.confirmPassword??"",event.avatar!);
        emit (AccountInfoUpdateState.success(accountUpdate: accountUpdate,successMsg: accountUpdate.message));
      }catch(e){
        emit (AccountInfoUpdateState.fail(error: e.toString()));
      }
    }else if(event is AccountInfoDeleteEvent){
      try{
        GraphQlBaseModel? baseModel = await repository?.callDeleteAccountApi(event.password??"");
        emit (AccountInfoDeleteState.success(baseModel: baseModel,successMsg: baseModel?.message));
      }catch(e){
        emit (AccountInfoDeleteState.fail(error: e.toString()));
      }
    }

  }


}

