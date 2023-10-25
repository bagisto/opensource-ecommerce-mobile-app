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


import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base_model/graphql_base_model.dart';
import '../event/forget_password_base_event.dart';
import '../event/forget_password_fetch_event.dart';
import '../repository/forget_password_repository.dart';
import '../state/forget_password_base_state.dart';
import '../state/forget_password_fetch_state.dart';
import '../state/forget_password_initial_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordBaseEvent, ForgetPasswordBaseState> {
  ForgetPasswordRepository? repository;

  ForgetPasswordBloc({@required this.repository})
      : super(ForgetPassWordInitialState()){
    on<ForgetPasswordBaseEvent>(mapEventToState);
  }

  void mapEventToState(ForgetPasswordBaseEvent event,Emitter <ForgetPasswordBaseState> emit) async {
    if (event is ForgetPasswordFetchEvent) {
      try {

        GraphQlBaseModel baseModel = await repository!.callForgetPasswordApi(
          event.email ?? "",);
        emit (ForgetPasswordFetchState.success(
            baseModel: baseModel, successMsg: baseModel.message ?? ""));
      } catch (e) {
        emit (ForgetPasswordFetchState.fail(error: e.toString()));
      }
    }
  }
}