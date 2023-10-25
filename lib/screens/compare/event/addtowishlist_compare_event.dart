
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:bagisto_app_demo/screens/compare/event/compare_screen_base_event.dart';

import '../../../models/compare_model/compare_product_model.dart';

// ignore: must_be_immutable
class AddtoWishlistCompareEvent extends CompareScreenBaseEvent{
  CompareProducts? datum;
  var productId;
  AddtoWishlistCompareEvent(this.productId,this.datum);
  // TODO: implement props
  List<Object> get props => [productId,datum!];

}

class FetchDeleteWishlistItemEvent extends CompareScreenBaseEvent{
  CompareProducts? datum;
  int productId;
  FetchDeleteWishlistItemEvent(this.productId,this.datum);
  // TODO: implement props
  List<Object> get props => [];

}
