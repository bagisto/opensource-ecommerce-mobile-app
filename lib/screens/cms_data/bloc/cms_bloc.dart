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

import 'package:bagisto_app_demo/models/cms_model/cms_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/cms_base_event.dart';
import '../event/fetch_cms_data_event.dart';
import '../repository/cms_repository.dart';
import '../state/cms_base_state.dart';
import '../state/cms_initial_state.dart';
import '../state/fetch_cms_data_state.dart';

class CmsBloc extends Bloc<CmsBaseEvent, CmsBaseState> {
  CmsRepository? repository;
  bool isLoading = false;

  CmsBloc({@required this.repository}) : super(CmsInitialState()){
    on<CmsBaseEvent>(mapEventToState);
  }
void mapEventToState(CmsBaseEvent event,Emitter<CmsBaseState> emit ) async{
    if  (event is FetchCmsDataEvent) {
      try {
        CmsData   cmsData = await repository!.callCmsData(event.id??"");
        if (cmsData.status == true) {
          emit (FetchCmsDataState.success(cmsData: cmsData));
        }  else {
          emit( FetchCmsDataState.fail(error: cmsData.success??""));
        }
      } catch (e) {
        emit (FetchCmsDataState.fail(error: e.toString()));
      }
    }
  }


}