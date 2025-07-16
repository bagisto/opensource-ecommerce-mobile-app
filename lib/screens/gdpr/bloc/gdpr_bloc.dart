/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:developer';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_pdf_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_search_model.dart';
import 'package:bagisto_app_demo/screens/gdpr/bloc/gdpr_event.dart';
import 'package:bagisto_app_demo/screens/gdpr/bloc/gdpr_state.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'gdpr_repository.dart';

class GdprBloc extends Bloc<GdprEvent, GdprState> {
  final GdprRequestRepository? repository;

  GdprBloc(this.repository) : super(GdprInitialState()) {
    on<GdprEvent>(mapEventToState);
  }

  void mapEventToState(GdprEvent event, Emitter<GdprState> emit) async {
    if (event is FetchGdprRequestsList) {
      try {
        emit(GdprLoadingState());
        GdprRequestModel? gdprRequests = await repository?.fetchGdprRequests();
        emit(FetchGdprRequestsState.success(requests: gdprRequests));
      } catch (e) {
        emit(FetchGdprRequestsState.fail(error: e.toString()));
      }
    }
    if (event is CreateGdprRequest) {
      try {
        emit(GdprLoadingState());
        BaseModel? response = await repository?.createGdprRequest(
          event.type,
          event.message,
        );

        emit(CreateGdprRequestState.success(
            message: response?.message, type: event.type));
      } catch (e) {
        debugPrint("Error creating GDPR request: $e");
        emit(CreateGdprRequestState.fail(error: e.toString()));
      }
    }
    if (event is RevokeGdprRequest) {
      try {
        emit(GdprLoadingState());
        BaseModel? response = await repository?.revokeGdprRequest(event.id);

        emit(RevokeGdprRequestState.success(message: response?.message));
      } catch (e) {
        debugPrint("Error revoking GDPR request: $e");
        emit(RevokeGdprRequestState.fail(error: e.toString()));
      }
    }

    if (event is GdprSearchRequest) {
      try {
        emit(GdprLoadingState());
        GdprSearchModal? gdprRequests =
            await repository?.gdprSearchRequest(event.id);

        if (gdprRequests != null) {
          emit(GdprSearchRequestState.success(request: gdprRequests));
        } else {
          emit(GdprSearchRequestState.fail(error: "GDPR request data is null"));
        }
      } catch (e) {
        emit(GdprSearchRequestState.fail(error: e.toString()));
      }
    }
    if (event is GdprPdfRequest) {
      try {
        emit(GdprLoadingState());
        GdprPdfModel? response = await repository?.downloadGdprData();

        emit(GdprPdfRequestState.success(pdfModel: response));
      } catch (e) {
        debugPrint("Error creating GDPR PDF request: $e");
        emit(GdprPdfRequestState.fail(error: e.toString()));
      }
    }
  }
}
