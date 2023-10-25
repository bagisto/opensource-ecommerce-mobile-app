
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:bagisto_app_demo/screens/wishList/events/wishlist_base_event.dart';

class FetchDeleteAddItemEvent extends WishListBaseEvent{
  var productId;
  FetchDeleteAddItemEvent(this.productId);
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class RemoveAllWishlistEvent extends WishListBaseEvent {
  final String? message;
  RemoveAllWishlistEvent( this.message);
  // TODO: implement props
  @override
  List<Object> get props => [ message ?? ""];

}