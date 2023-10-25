

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



import 'fetch_homepage_event.dart';

class AddToCartEvent extends HomePageEvent{

  var productId;
  var quantity;
// Map<String,dynamic> params = {};
   String? message;
  AddToCartEvent(this.productId,/*this.params,*/this.quantity,this.message);
  // TODO: implement props
  List<Object> get props => [productId,message??""];

}