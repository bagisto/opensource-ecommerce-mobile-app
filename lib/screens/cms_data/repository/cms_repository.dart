/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print


import 'package:bagisto_app_demo/models/cms_model/cms_model.dart';
import '../../../api/api_client.dart';

abstract class CmsRepository{
  Future<CmsData> callCmsData(String id);
}
class CmsRepositoryImp implements CmsRepository {
  @override
  Future<CmsData> callCmsData(String id) async {
    CmsData? cmsData;

    try{
      cmsData=await ApiClient().getCmsData( );
    }
    catch(error,stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return cmsData!;
  }
}
