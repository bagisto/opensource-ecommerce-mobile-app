
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names


import 'package:bagisto_app_demo/screens/compare/event/compare_screen_base_event.dart';


class OnClickCompareLoaderEvent extends CompareScreenBaseEvent{
  final bool? isReqToShowLoader;
  OnClickCompareLoaderEvent({this.isReqToShowLoader});
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}