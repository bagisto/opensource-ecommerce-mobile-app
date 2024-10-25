/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/forget_password/utils/index.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordBaseEvent, ForgetPasswordBaseState> {
  ForgetPasswordRepository? repository;

  ForgetPasswordBloc({@required this.repository})
      : super(ForgetPassWordInitialState()){
    on<ForgetPasswordBaseEvent>(mapEventToState);
  }

  void mapEventToState(ForgetPasswordBaseEvent event,Emitter <ForgetPasswordBaseState> emit) async {
    if (event is ForgetPasswordFetchEvent) {
      try {
        BaseModel baseModel = await repository!.callForgetPasswordApi(event.email ?? "",);


if(baseModel.success == true) {
  emit(ForgetPasswordFetchState.success(
      baseModel: baseModel, successMsg: baseModel.message ?? ""));
}
else{

  emit (ForgetPasswordFetchState.fail(error:baseModel.graphqlErrors));
}
      } catch (e) {
        emit (ForgetPasswordFetchState.fail(error:StringConstants.somethingWrong.localized()));
      }
    }
  }
}