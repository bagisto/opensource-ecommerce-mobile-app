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

part 'order_invoices_model.g.dart';

@JsonSerializable()
class InvoicesModel extends BaseModel {
  @JsonKey(name: "data")
  List<ViewInvoices>? viewInvoices;

  InvoicesModel({this.viewInvoices});

  factory InvoicesModel.fromJson(Map<String, dynamic> json) =>
      _$InvoicesModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InvoicesModelToJson(this);
}

@JsonSerializable()
class ViewInvoices {
  int? id;
  List<InvoicesItems>? items;
  FormattedPrice? formattedPrice;

  ViewInvoices({this.id, this.formattedPrice, this.items});

  factory ViewInvoices.fromJson(Map<String, dynamic> json) =>
      _$ViewInvoicesFromJson(json);

  Map<String, dynamic> toJson() => _$ViewInvoicesToJson(this);
}

@JsonSerializable()
class InvoicesItems {
  String? id;
  String? sku;
  String? name;
  int? qty;
  // String? productId;
  // OrderProduct? product;
  FormattedPrice? formattedPrice;

  InvoicesItems({
    this.id,
    this.sku,
    this.name,
    this.qty,
    // this.productId,
    this.formattedPrice,
  });

  factory InvoicesItems.fromJson(Map<String, dynamic> json) =>
      _$InvoicesItemsFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesItemsToJson(this);
}
