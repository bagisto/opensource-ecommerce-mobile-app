/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/models/cms_model/cms_model.dart';

import 'cms_base_state.dart';


class FetchCmsDataState extends CmsBaseState {

  CmsStatus? status;
  String? error;
  CmsData? cmsData;

  FetchCmsDataState.success({this.cmsData}) : status = CmsStatus.success;

  FetchCmsDataState.fail({this.error}) : status = CmsStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (cmsData !=null) cmsData! else ""];
}
