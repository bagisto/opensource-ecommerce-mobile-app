import 'package:flutter/material.dart';
import '../../../services/api_client.dart';
import '../data_model/cms_details.dart';

abstract class CmsRepository{
  Future<CmsPage?> callCmsData(String id);
}
class CmsRepositoryImp implements CmsRepository {
  @override
  Future<CmsPage?> callCmsData(String id) async {
    CmsPage? cmsData;
    try{
      cmsData = await ApiClient().getCmsPageDetails(id);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return cmsData!;
  }
}