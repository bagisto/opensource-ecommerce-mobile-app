/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../product_screen/data_model/product_details_model.dart';

part 'compare_product_model.g.dart';

@JsonSerializable()
class CompareProductsData extends BaseModel {
  List<CompareProducts>? data;

  CompareProductsData({this.data});

  factory CompareProductsData.fromJson(Map<String, dynamic> json) =>
      _$CompareProductsDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CompareProductsDataToJson(this);
}

@JsonSerializable()
class CompareProducts {
  String? id;
  String? productId;
  Product? product;

  CompareProducts({
    this.id,
    this.productId,
    this.product,
  });

  factory CompareProducts.fromJson(Map<String, dynamic> json) =>
      _$CompareProductsFromJson(json);

  Map<String, dynamic> toJson() => _$CompareProductsToJson(this);
}
