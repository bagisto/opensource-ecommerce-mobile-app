
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

import '../../../models/homepage_model/new_product_data.dart';
import 'fetch_homepage_event.dart';

// ignore: must_be_immutable
class FetchAddWishlistHomepageEvent extends HomePageEvent{
  NewProducts? datum;
  var productId;
  FetchAddWishlistHomepageEvent(this.productId,this.datum);
  // TODO: implement props
  List<Object?> get props => [productId,datum];

}

class FetchDeleteAddItemEvent extends HomePageEvent{
  NewProducts? datum;
  var productId;
  FetchDeleteAddItemEvent(this.productId,this.datum);
  // TODO: implement props
  List<Object> get props => [];

}
