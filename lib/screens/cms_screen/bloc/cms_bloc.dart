/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:flutter_bloc/flutter_bloc.dart';
import '../data_model/cms_details.dart';
import 'cms_event.dart';
import 'cms_repository.dart';
import 'cms_state.dart';

class CmsBloc extends Bloc<CmsBaseEvent, CmsBaseState> {
  CmsRepository? repository;

  CmsBloc(this.repository) : super(CmsInitialState()) {
    on<CmsBaseEvent>(mapEventToState);
  }

  void mapEventToState(CmsBaseEvent event, Emitter<CmsBaseState> emit) async {
    if (event is FetchCmsDataEvent) {
      try {
        CmsPage? cmsData = await repository?.callCmsData(event.id ?? "");
        if(cmsData != null){
          emit(FetchCmsDataState.success(cmsData: cmsData));
        }
        else{
          emit(FetchCmsDataState.fail(error: cmsData?.success ?? ""));
        }
      } catch (e) {
        emit(FetchCmsDataState.fail(error: e.toString()));
      }
    }
  }
}
