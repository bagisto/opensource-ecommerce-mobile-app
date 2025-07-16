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

import 'order_detail_model.dart';

part 'shipment_model.g.dart';

@JsonSerializable()
class ShipmentModel extends BaseModel {
  @JsonKey(name: "data")
  List<ViewShipments>? viewShipments;

  ShipmentModel({this.viewShipments});

  factory ShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShipmentModelToJson(this);
}

@JsonSerializable()
class ViewShipments {
  int? id;
  String? trackNumber;
  List<ItemsModel>? items;

  ViewShipments({
    this.id,
    this.trackNumber,
    this.items,
  });

  factory ViewShipments.fromJson(Map<String, dynamic> json) =>
      _$ViewShipmentsFromJson(json);

  Map<String, dynamic> toJson() => _$ViewShipmentsToJson(this);
}

@JsonSerializable()
class ItemsModel {
  int? id;
  String? name;
  // dynamic description;
  String? sku;
  int? qty;
  // int? weight;
  // double? price;
  // double? basePrice;
  // double? total;
  // double? baseTotal;
  // String? productId;
  // String? productType;
  // String? orderItemId;
  // String? shipmentId;
  // Additional? additional;
  // dynamic additional;
  // String? createdAt;
  // String? updatedAt;
  // OrderProduct? product;

  ItemsModel({
    this.id,
    this.name,
    this.sku,
    this.qty,
    // this.price,
    // this.total,

    // this.shipmentId,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) =>
      _$ItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsModelToJson(this);
}
