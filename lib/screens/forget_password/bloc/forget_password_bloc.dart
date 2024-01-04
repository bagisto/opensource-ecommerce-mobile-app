/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/screens/forget_password/bloc/forget_password_base_event.dart';
import 'package:bagisto_app_demo/screens/forget_password/bloc/forget_password_fetch_event.dart';
import 'package:bagisto_app_demo/screens/forget_password/bloc/forget_password_fetch_state.dart';
import 'package:bagisto_app_demo/screens/forget_password/bloc/forget_password_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordBaseEvent, ForgetPasswordBaseState> {
  ForgetPasswordRepository? repository;

  ForgetPasswordBloc({@required this.repository})
      : super(ForgetPassWordInitialState()){
    on<ForgetPasswordBaseEvent>(mapEventToState);
  }

  void mapEventToState(ForgetPasswordBaseEvent event,Emitter <ForgetPasswordBaseState> emit) async {
    if (event is ForgetPasswordFetchEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.callForgetPasswordApi(event.email ?? "",);
        emit(ForgetPasswordFetchState.success(
            baseModel: baseModel, successMsg: baseModel.message ?? ""));
      } catch (e) {
        emit (ForgetPasswordFetchState.fail(error: e.toString()));
      }
    }
  }
}