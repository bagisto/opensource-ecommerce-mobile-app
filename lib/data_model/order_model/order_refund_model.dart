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

import '../../screens/cart_screen/cart_model/cart_data_model.dart';
import 'order_detail_model.dart';

part 'order_refund_model.g.dart';

@JsonSerializable()
class OrderRefundModel extends BaseModel {
  @JsonKey(name: "data")
  List<ViewRefunds>? viewRefunds;
  OrderRefundModel({this.viewRefunds});

  factory OrderRefundModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRefundModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderRefundModelToJson(this);
}

@JsonSerializable()
class ViewRefunds {
  int? id;
  FormattedPrice? formattedPrice;
  List<RefundItems>? items;

  ViewRefunds({this.id, this.items, this.formattedPrice});

  factory ViewRefunds.fromJson(Map<String, dynamic> json) =>
      _$ViewRefundsFromJson(json);

  Map<String, dynamic> toJson() => _$ViewRefundsToJson(this);
}

@JsonSerializable()
class RefundItems {
  int? id;
  String? name;
  String? sku;
  int? qty;
  // int? discountAmount;
  // int? productId;
  // OrderProduct? product;
  FormattedPrice? formattedPrice;

  RefundItems({this.id, this.name, this.sku, this.qty, this.formattedPrice});

  factory RefundItems.fromJson(Map<String, dynamic> json) =>
      _$RefundItemsFromJson(json);

  Map<String, dynamic> toJson() => _$RefundItemsToJson(this);
}
