/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */





import 'package:bagisto_app_demo/screens/compare/utils/index.dart';

import 'contact_us_event.dart';
import 'contact_us_repository.dart';
import 'contact_us_state.dart';


class ContactUsScreenBloc
    extends Bloc<ContactUsBaseEvent, ContactUsBaseState> {
  ContactUsScreenRepository? repository;


  ContactUsScreenBloc(this.repository)
      : super(ContactUsScreenInitialState()) {
    on<ContactUsBaseEvent>(mapEventToState);
  }
  void mapEventToState(ContactUsBaseEvent event,
      Emitter<ContactUsBaseState> emit) async {

    if (event is ContactUsEvent) {
      try {
        BaseModel baseModel = await repository!.contactUsRepoScreen(event.name??'',event.email??'',event.phone??'',event.describe ??'');
        if (baseModel.success == true) {
          emit(ContactUsState.success(
              response: baseModel,
              successMsg: baseModel.message));
        } else {
          emit(ContactUsState.fail(error: baseModel.graphqlErrors));
        }
      } catch (e) {
        emit(ContactUsState.fail(
            error: "SomethingWrong".localized()));
      }
    }


  }
}
