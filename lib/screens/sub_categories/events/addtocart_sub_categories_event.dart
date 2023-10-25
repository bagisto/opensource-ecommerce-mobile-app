
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

import 'package:bagisto_app_demo/screens/sub_categories/events/sub_categories_base_event.dart';

class AddToCartSubCategoriesEvent extends SubCategoryBaseEvent{

  var productId;
  int quantity;
// Map<String,dynamic> params = {};
  String? message;
  AddToCartSubCategoriesEvent(this.productId,this.quantity,this.message);
  @override
  // TODO: implement props
  List<Object> get props => [productId!, quantity,message!];

}