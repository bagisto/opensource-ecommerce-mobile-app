/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import '../../home_page/data_model/new_product_data.dart';

abstract class CategoryBaseEvent extends Equatable{}

class AddToCartSubCategoriesEvent extends CategoryBaseEvent{

  String? productId;
  int quantity;
  String? message;
  AddToCartSubCategoriesEvent(this.productId,this.quantity,this.message);

  @override
  List<Object> get props => [productId ?? "", quantity,message ??""];

}

class FetchSubCategoryEvent extends CategoryBaseEvent {
  List<Map<String, dynamic>> filters;
  int? page;

  FetchSubCategoryEvent(this.filters, this.page);

  @override
  List<Object> get props => [];
}

class FetchDeleteAddItemCategoryEvent extends CategoryBaseEvent{
  NewProducts? datum;
  String? productId;
  FetchDeleteAddItemCategoryEvent(this.productId,this.datum);

  @override
  List<Object> get props => [productId??"",datum??""];

}


class FetchDeleteItemEvent extends CategoryBaseEvent{
  NewProducts? datum;
  String? productId;
  FetchDeleteItemEvent(this.productId,this.datum);
  @override
  List<Object> get props => [];

}

class AddToCompareSubCategoryEvent extends CategoryBaseEvent {
  String? productId;

  final String? message;

  AddToCompareSubCategoryEvent(this.productId, this.message);

  @override
  List<Object> get props => [productId ?? "", message ?? ""];

}

class OnClickSubCategoriesLoaderEvent extends CategoryBaseEvent {
  final bool? isReqToShowLoader;

  OnClickSubCategoriesLoaderEvent({this.isReqToShowLoader});

  @override
  List<Object> get props => throw UnimplementedError();
}

class FilterFetchEvent extends CategoryBaseEvent {
  final String? categorySlug;

  FilterFetchEvent(this.categorySlug);

  @override
  List<Object> get props => [];
}