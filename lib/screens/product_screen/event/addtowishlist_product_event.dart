
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

import 'package:bagisto_app_demo/screens/product_screen/event/product_base_event.dart';
import '../../../models/product_model/product_screen_model.dart';


// ignore: must_be_immutable
class AddtoWishListProductEvent extends ProductScreenBaseEvent{
  Product datum;
  var productId;
  AddtoWishListProductEvent(this.productId,this.datum);
  // TODO: implement props
  List<Object> get props => [productId,datum];

}

class RemoveFromWishlistEvent extends ProductScreenBaseEvent{
  Product? datum;
  int productId;
  RemoveFromWishlistEvent(this.productId,this.datum);
  // TODO: implement props
  List<Object> get props => [];

}
