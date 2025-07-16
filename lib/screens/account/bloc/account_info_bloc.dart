/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import '../../../data_model/account_models/account_update_model.dart';
import '../utils/index.dart';

class AccountInfoBloc extends Bloc<AccountInfoBaseEvent, AccountInfoBaseState> {
  AccountInfoRepository? repository;

  AccountInfoBloc({@required this.repository}) : super(InitialAccountState()){
    on<AccountInfoBaseEvent>(mapEventToState);
  }

  void mapEventToState(AccountInfoBaseEvent event,Emitter <AccountInfoBaseState> emit) async {
    if (event is AccountInfoDetailsEvent) {
      try {
        AccountInfoModel accountInfoDetails = await repository!.callAccountDetailsApi();
        emit (AccountInfoDetailState.success(accountInfoDetails: accountInfoDetails));
      } catch (e) {
        emit (AccountInfoDetailState.fail(error: e.toString()));
      }
    }else if(event is AccountInfoUpdateEvent){
      try{
        AccountUpdate accountUpdate=await repository!.callAccountUpdateApi(event.firstName??"", event.lastName??"", event.email??"", event.gender??"",event.dob??"",event.phone??"",event.oldPassword??"",
            event.password??"",event.confirmPassword??"",event.avatar,event.subscribedToNewsLetter?? false);
        emit (AccountInfoUpdateState.success(accountUpdate: accountUpdate,successMsg: accountUpdate.message));
      }catch(e){
        emit (AccountInfoUpdateState.fail(error: e.toString()));
      }
    }else if(event is AccountInfoDeleteEvent){
      try{
        BaseModel? baseModel = await repository?.callDeleteAccountApi(event.password??"");
        if(baseModel?.success == true){
          emit (AccountInfoDeleteState.success(baseModel: baseModel,successMsg: baseModel?.message));
        }
        else{
          emit (AccountInfoDeleteState.fail(error: baseModel?.message ?? baseModel?.graphqlErrors));
        }
      }catch(e){
        emit (AccountInfoDeleteState.fail(error: e.toString()));
      }
    }

  }


}

