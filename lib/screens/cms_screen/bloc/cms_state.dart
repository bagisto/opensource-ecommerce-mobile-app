
import '../data_model/cms_details.dart';

abstract class CmsBaseState {}

enum CmsStatus { success, fail }

class CmsInitialState extends CmsBaseState {}

class FetchCmsDataState extends CmsBaseState {
  CmsStatus? status;
  String? error;
  CmsPage? cmsData;

  FetchCmsDataState.success({this.cmsData}) : status = CmsStatus.success;
  FetchCmsDataState.fail({this.error}) : status = CmsStatus.fail;

}