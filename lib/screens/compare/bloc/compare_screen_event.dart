
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


import '../data_model/compare_product_model.dart';

abstract class CompareScreenBaseEvent{}

class OnClickCompareLoaderEvent extends CompareScreenBaseEvent{
  final bool? isReqToShowLoader;
  OnClickCompareLoaderEvent({this.isReqToShowLoader});

}

class AddToCartCompareEvent extends CompareScreenBaseEvent{
  String? productId;
  int quantity;
  String? message;
  AddToCartCompareEvent(this.productId,this.quantity,this.message);

}

class AddToWishlistCompareEvent extends CompareScreenBaseEvent{
  CompareProducts? data;
  String? productId;
  AddToWishlistCompareEvent(this.productId,this.data);

}

class FetchDeleteWishlistItemEvent extends CompareScreenBaseEvent{
  CompareProducts? datum;
  int productId;
  FetchDeleteWishlistItemEvent(this.productId,this.datum);

}

class RemoveFromCompareListEvent extends CompareScreenBaseEvent {
  String? productId;
  final String? message;

  RemoveFromCompareListEvent(this.productId, this.message);

}

class RemoveAllCompareListEvent extends CompareScreenBaseEvent {
  final String? message;

  RemoveAllCompareListEvent( this.message);
}

class CompareScreenFetchEvent extends CompareScreenBaseEvent {
  CompareScreenFetchEvent();
}