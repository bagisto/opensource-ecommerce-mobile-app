

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

class FetchCartDataEvent extends CartScreenBaseEvent{
  // TODO: implement props
  List<Object> get props => [];

}
class MoveToCartEvent extends CartScreenBaseEvent{
int ?id;
MoveToCartEvent(this.id);
  // TODO: implement props
  List<Object> get props => [id??0];

}
class UpdateCartEvent extends CartScreenBaseEvent{
  List<Map<dynamic,String>> ? item ;
UpdateCartEvent(this.item);
  // TODO: implement props
  List<Object> get props => [item ?? {}];
}