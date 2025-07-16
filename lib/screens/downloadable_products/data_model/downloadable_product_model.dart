/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:json_annotation/json_annotation.dart';

import '../../../data_model/graphql_base_model.dart';
import '../../home_page/data_model/new_product_data.dart';

part 'downloadable_product_model.g.dart';

@JsonSerializable()
class DownloadableProductModel extends BaseModel {
  @JsonKey(name: "data")
  List<DownloadableLinkPurchases>? downloadableLinkPurchases;
  PaginatorInfo? paginatorInfo;

  DownloadableProductModel(
      {this.downloadableLinkPurchases, this.paginatorInfo});

  factory DownloadableProductModel.fromJson(Map<String, dynamic> json) {
    return _$DownloadableProductModelFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$DownloadableProductModelToJson(this);
}

@JsonSerializable()
class DownloadableLinkPurchases {
  String? id;
  String? productName;
  // String? name;
  int? downloadBought;
  int? downloadUsed;
  String? orderId;
  String? createdAt;
  Order? order;
  OrderItem? orderItem;

  DownloadableLinkPurchases(
      {this.id,
      this.productName,
      this.downloadBought,
      this.downloadUsed,
      this.orderId,
      this.createdAt,
      this.order,
      this.orderItem});

  factory DownloadableLinkPurchases.fromJson(Map<String, dynamic> json) {
    return _$DownloadableLinkPurchasesFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DownloadableLinkPurchasesToJson(this);
}

// @JsonSerializable()
// class Customer {
//   String? id;
// String? firstName;
// String? lastName;
// String? name;
// dynamic gender;
// dynamic dateOfBirth;
//   String? email;
//   dynamic phone;
//   String? password;
//   String? apiToken;
//   int? customerGroupId;
//   bool? subscribedToNewsLetter;
//   bool? isVerified;
//   String? token;
//   dynamic notes;
//   bool? status;

//   Customer(
//       {this.id,
//       this.firstName,
//       this.lastName,
//       this.name,
//       this.gender,
//       this.dateOfBirth,
//       this.email,
//       this.phone,
//       this.password,
//       this.apiToken,
//       this.customerGroupId,
//       this.subscribedToNewsLetter,
//       this.isVerified,
//       this.token,
//       this.notes,
//       this.status});

//   factory Customer.fromJson(Map<String, dynamic> json) {
//     return _$CustomerFromJson(json);
//   }
//   Map<String, dynamic> toJson() => _$CustomerToJson(this);
// }

@JsonSerializable()
class Order {
  int? id;
  String? status;

  Order({
    this.id,
    this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return _$OrderFromJson(json);
  }
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderItem {
  String? id;
  String? name;
  NewProducts? product;

  OrderItem({this.id, this.name, this.product});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return _$OrderItemFromJson(json);
  }
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
