/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/home_page/data_model/new_product_data.dart';

abstract class ProductScreenBaseEvent {}

class OnClickProductLoaderEvent extends ProductScreenBaseEvent {
  final bool? isReqToShowLoader;

  OnClickProductLoaderEvent({this.isReqToShowLoader});
}

class FetchProductEvent extends ProductScreenBaseEvent {
  String sku;
  FetchProductEvent(this.sku);
}

class AddToWishListProductEvent extends ProductScreenBaseEvent {
  NewProducts? productData;
  String? productId;

  AddToWishListProductEvent(this.productId, this.productData);
}

class RemoveFromWishlistEvent extends ProductScreenBaseEvent {
  NewProducts? productData;
  String? productId;

  RemoveFromWishlistEvent(this.productId, this.productData);
}

class AddToCompareListEvent extends ProductScreenBaseEvent {
  String? productId;
  final String? message;

  AddToCompareListEvent(this.productId, this.message);
}

class AddToCartProductEvent extends ProductScreenBaseEvent {
  List downloadLinks = [];
  List groupedParams = [];
  List bundleParams = [];
  List configurableParams = [];
  Map<String, dynamic>? bookingParams;
  String? configurableId;
  String? productId;
  int quantity;
  final String? message;
  List<Map<String, dynamic>>? customizableOptions;
  List? customizableFiles;

  AddToCartProductEvent(
      this.quantity,
      this.productId,
      this.downloadLinks,
      this.groupedParams,
      this.bundleParams,
      this.configurableParams,
      this.configurableId,
      this.message,
      this.bookingParams,
      [this.customizableOptions, this.customizableFiles]);
}

class DownloadProductSampleEvent extends ProductScreenBaseEvent {
  String? type;
  String? id;
  String? fileName;

  DownloadProductSampleEvent(this.type, this.id, this.fileName);
}

class GetSlotEvent extends ProductScreenBaseEvent {
  final int bookingId;
  final String selectedDate;

  GetSlotEvent(this.bookingId, this.selectedDate);
}
