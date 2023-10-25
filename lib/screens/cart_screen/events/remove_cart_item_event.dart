

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

import 'cart_screen_base_event.dart';

class RemoveCartItemEvent extends CartScreenBaseEvent{
  int? cartItemId;
  RemoveCartItemEvent({this.cartItemId});
  // TODO: implement props
  List<Object> get props => [cartItemId??0];

}
class RemoveAllCartItemEvent extends CartScreenBaseEvent{
  RemoveAllCartItemEvent();
  // TODO: implement props
  List<Object> get props => [];

}