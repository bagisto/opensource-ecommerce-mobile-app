
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