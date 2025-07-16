/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/product_model/booking_slots_modal.dart';

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

import '../data_model/download_sample_model.dart';

abstract class ProductBaseState {}

enum ProductStatus { success, fail }

class ProductInitialState extends ProductBaseState {}

class OnClickProductLoaderState extends ProductBaseState {
  final bool? isReqToShowLoader;

  OnClickProductLoaderState({this.isReqToShowLoader});
}

class FetchProductState extends ProductBaseState {
  ProductStatus? status;
  String? error;
  NewProducts? productData;

  FetchProductState.success({this.productData})
      : status = ProductStatus.success;

  FetchProductState.fail({this.error}) : status = ProductStatus.fail;
}

class AddToWishListProductState extends ProductBaseState {
  ProductStatus? status;
  String? successMsg = "";
  String? error = "";
  AddWishListModel? response;
  String? productDeletedId;
  AddToWishListProductState.success(
      {this.response, this.productDeletedId, this.successMsg})
      : status = ProductStatus.success;
  AddToWishListProductState.fail({this.error}) : status = ProductStatus.fail;
}

class DownloadProductSampleState extends ProductBaseState {
  ProductStatus? status;
  String? error;
  DownloadSampleModel? model;
  String? fileName;

  DownloadProductSampleState.success({this.model, this.fileName})
      : status = ProductStatus.success;

  DownloadProductSampleState.fail({this.error}) : status = ProductStatus.fail;
}

class RemoveFromWishlistState extends ProductBaseState {
  ProductStatus? status;
  String? successMsg = "";
  String? error = "";
  AddToCartModel? response;
  String? productDeletedId;
  RemoveFromWishlistState.success(
      {this.response, this.productDeletedId, this.successMsg})
      : status = ProductStatus.success;
  RemoveFromWishlistState.fail({this.error}) : status = ProductStatus.fail;
}

class AddToCompareListState extends ProductBaseState {
  ProductStatus? status;
  String? error;
  String? successMsg;
  BaseModel? baseModel;
  AddToCompareListState.success({this.successMsg, this.baseModel})
      : status = ProductStatus.success;
  AddToCompareListState.fail({this.error}) : status = ProductStatus.fail;
}

class AddToCartProductState extends ProductBaseState {
  ProductStatus? status;
  String? error;
  String? successMsg;
  AddToCartModel? response;
  AddToCartProductState.success({this.response, this.successMsg})
      : status = ProductStatus.success;
  AddToCartProductState.fail({this.error}) : status = ProductStatus.fail;
}

class GetSlotState extends ProductBaseState {
  ProductStatus? status;
  String? error;
  String? successMsg;
  BookingSlotsData? slotModel;
  GetSlotState.success({this.slotModel, this.successMsg})
      : status = ProductStatus.success;

  GetSlotState.fail({this.error}) : status = ProductStatus.fail;
}
