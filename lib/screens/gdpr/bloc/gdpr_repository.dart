import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_pdf_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_search_model.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'dart:developer';

abstract class GdprRequestRepository {
  Future<GdprRequestModel?> fetchGdprRequests();
  Future<BaseModel?> createGdprRequest(Enum type, String message);
  Future<BaseModel?> revokeGdprRequest(int id);
  Future<GdprSearchModal?> gdprSearchRequest(int id);
  Future<GdprPdfModel?> downloadGdprData();
  // Future<bool> submitGdprRequest(Map<String, dynamic> requestData);
}

class GdprRequestRepo implements GdprRequestRepository {
  @override
  Future<GdprRequestModel?> fetchGdprRequests() async {
    GdprRequestModel? gdprRequestModel;
    try {
      gdprRequestModel = await ApiClient().getGdprRequests();
    } catch (error, stacktrace) {
      debugPrint("Error fetching GDPR requests: $error");
      debugPrint("StackTrace: $stacktrace");
    }
    return gdprRequestModel;
  }

  @override
  Future<BaseModel?> createGdprRequest(Enum type, String message) async {
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().createGdprRequest(type, message);
    } catch (error, stacktrace) {
      debugPrint("Error creating GDPR request: $error");
      debugPrint("StackTrace: $stacktrace");
    }
    return baseModel;
  }

  @override
  Future<BaseModel?> revokeGdprRequest(int id) async {
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().revokeGdprRequest(id);
    } catch (error, stacktrace) {
      debugPrint("Error revoking GDPR request: $error");
      debugPrint("StackTrace: $stacktrace");
    }
    return baseModel;
  }

  @override
  Future<GdprSearchModal?> gdprSearchRequest(int id) async {
    GdprSearchModal? gdprRequestModel;
    try {
      gdprRequestModel = await ApiClient().gdprSearchRequest(id);
    } catch (error, stacktrace) {
      debugPrint("Error searching GDPR request: $error");
      debugPrint("StackTrace: $stacktrace");
    }
    return gdprRequestModel;
  }

  @override
  Future<GdprPdfModel?> downloadGdprData() async {
    GdprPdfModel? gdprPdfModel;
    try {
      gdprPdfModel = await ApiClient().downloadGdprData();
    } catch (error, stacktrace) {
      debugPrint("Error downloading GDPR data: $error");
      debugPrint("StackTrace: $stacktrace");
    }
    return gdprPdfModel;
  }
}
