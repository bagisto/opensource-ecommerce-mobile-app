
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
part 'download_product_Image_model.g.dart';

@JsonSerializable()
class DownloadLinkDataModel extends BaseModel{
  String? string;
  DownloadLinkProduct? download;

  DownloadLinkDataModel({
    this.string,
    this.download,
  });

  factory DownloadLinkDataModel.fromJson(Map<String, dynamic> json) => _$DownloadLinkDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DownloadLinkDataModelToJson(this);
}

@JsonSerializable()
class DownloadLinkProduct {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "productName")
  String? productName;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "url")
  dynamic url;
  @JsonKey(name: "file")
  String? file;
  @JsonKey(name: "fileName")
  String? fileName;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "downloadBought")
  int? downloadBought;
  @JsonKey(name: "downloadUsed")
  int? downloadUsed;
  @JsonKey(name: "status")
  bool? status;
  @JsonKey(name: "customerId")
  String? customerId;
  @JsonKey(name: "orderId")
  String? orderId;
  @JsonKey(name: "orderItemId")
  String? orderItemId;
  @JsonKey(name: "createdAt")
  String? createdAt;
  @JsonKey(name: "updatedAt")
  String? updatedAt;

  DownloadLinkProduct({
    this.id,
    this.productName,
    this.name,
    this.url,
    this.file,
    this.fileName,
    this.type,
    this.downloadBought,
    this.downloadUsed,
    this.status,
    this.customerId,
    this.orderId,
    this.orderItemId,
    this.createdAt,
    this.updatedAt,
  });

  factory DownloadLinkProduct.fromJson(Map<String, dynamic> json) => _$DownloadLinkProductFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadLinkProductToJson(this);
}
