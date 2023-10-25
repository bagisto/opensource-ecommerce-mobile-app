
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




import 'package:bagisto_app_demo/screens/product_screen/event/product_base_event.dart';

class OnClickProductLoaderEvent extends ProductScreenBaseEvent{
  final bool? isReqToShowLoader;
  OnClickProductLoaderEvent({this.isReqToShowLoader});
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}