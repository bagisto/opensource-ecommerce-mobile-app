
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


abstract class WishListBaseEvent {}

class FetchWishListEvent extends WishListBaseEvent {
}

class OnClickWishListLoaderEvent extends WishListBaseEvent{
  final bool? isReqToShowLoader;
  OnClickWishListLoaderEvent({this.isReqToShowLoader});
}

class FetchDeleteAddItemEvent extends WishListBaseEvent{
  final dynamic productId;
  FetchDeleteAddItemEvent(this.productId);
}

class RemoveAllWishlistEvent extends WishListBaseEvent {
  final String? message;
  RemoveAllWishlistEvent( this.message);
  List<Object> get props => [ message ?? ""];

}

class AddToCartWishlistEvent extends WishListBaseEvent{
   final dynamic productId;

  AddToCartWishlistEvent(this.productId,);

}
