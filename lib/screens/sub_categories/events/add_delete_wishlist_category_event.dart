
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
import '../../../models/categories_data_model/categories_product_model.dart';
class FetchDeleteAddItemCategoryEvent extends SubCategoryBaseEvent{
  Data? datum;
  var productId;
  FetchDeleteAddItemCategoryEvent(this.productId,this.datum);
  @override
  // TODO: implement props
  List<Object> get props => [productId,datum!];

}


class FetchDeleteItemEvent extends SubCategoryBaseEvent{
  Data? datum;
  int productId;
  FetchDeleteItemEvent(this.productId,this.datum);
  @override
  // TODO: implement props
  List<Object> get props => [];

}
