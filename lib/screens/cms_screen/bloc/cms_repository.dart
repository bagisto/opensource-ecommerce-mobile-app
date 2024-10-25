/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cms_screen/utils/index.dart';

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