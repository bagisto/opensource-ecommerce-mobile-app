/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_pdf_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_search_model.dart';
import 'package:equatable/equatable.dart';

enum GdprStatus { success, fail }

enum CreateGdprRequestStatus { success, fail }

abstract class GdprState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GdprInitialState extends GdprState {}

class GdprLoadingState extends GdprState {}

class RevokeGdprRequestLoadingState extends GdprState {}

class FetchGdprRequestsState extends GdprState {
  final GdprStatus? status;
  final GdprRequestModel? requests;
  final String? error;

  FetchGdprRequestsState._({this.requests, this.error, this.status});

  factory FetchGdprRequestsState.success({required requests}) {
    return FetchGdprRequestsState._(
        requests: requests, status: GdprStatus.success);
  }

  factory FetchGdprRequestsState.fail({required String error}) {
    return FetchGdprRequestsState._(error: error, status: GdprStatus.fail);
  }

  @override
  List<Object?> get props => [requests, error];
}

class CreateGdprRequestState extends GdprState {
  final String? message;
  final CreateGdprRequestStatus? status;
  final String? error;

  CreateGdprRequestState._({this.message, this.status, this.error});

  factory CreateGdprRequestState.success({String? message, Enum? type}) {
    return CreateGdprRequestState._(
        message: message, status: CreateGdprRequestStatus.success);
  }

  factory CreateGdprRequestState.fail({required String error}) {
    return CreateGdprRequestState._(
        error: error, status: CreateGdprRequestStatus.fail);
  }

  @override
  List<Object?> get props => [message, status, error];
}

class RevokeGdprRequestState extends GdprState {
  final String? message;
  final GdprStatus? status;
  final String? error;

  RevokeGdprRequestState._({this.message, this.status, this.error});

  factory RevokeGdprRequestState.success({String? message}) {
    return RevokeGdprRequestState._(
        message: message, status: GdprStatus.success);
  }

  factory RevokeGdprRequestState.fail({required String error}) {
    return RevokeGdprRequestState._(error: error, status: GdprStatus.fail);
  }

  @override
  List<Object?> get props => [message, status, error];
}

class GdprSearchRequestState extends GdprState {
  final GdprStatus? status;
  final GdprSearchModal? request;
  final String? error;

  GdprSearchRequestState._({this.request, this.error, this.status});

  factory GdprSearchRequestState.success({required GdprSearchModal request}) {
    return GdprSearchRequestState._(
        request: request, status: GdprStatus.success);
  }

  factory GdprSearchRequestState.fail({required String error}) {
    return GdprSearchRequestState._(error: error, status: GdprStatus.fail);
  }

  @override
  List<Object?> get props => [request, error];
}

class GdprPdfRequestState extends GdprState {
  final GdprStatus? status;
  final String? error;
  final GdprPdfModel? pdfModel;

  GdprPdfRequestState._({this.status, this.error, this.pdfModel});

  factory GdprPdfRequestState.success({GdprPdfModel? pdfModel}) {
    return GdprPdfRequestState._(
        status: GdprStatus.success, pdfModel: pdfModel);
  }

  factory GdprPdfRequestState.fail({required String error}) {
    return GdprPdfRequestState._(error: error, status: GdprStatus.fail);
  }

  @override
  List<Object?> get props => [status, error];
}
