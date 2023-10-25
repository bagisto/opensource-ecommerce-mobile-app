
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:bagisto_app_demo/screens/compare/event/compare_screen_base_event.dart';

class AddToCartCompareEvent extends CompareScreenBaseEvent{
  var productId;
  int quantity;
  String? message;
  AddToCartCompareEvent(this.productId,this.quantity,this.message);
  // TODO: implement props
  List<Object> get props => [productId!, quantity,message!];

}