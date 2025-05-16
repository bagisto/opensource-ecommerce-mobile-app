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

part 'download_product_model.g.dart';

@JsonSerializable()
class Download {
  String? id;
  String? name;
  bool? status;

  Download({
    this.id,
    this.name,
    this.status,
  });

  factory Download.fromJson(Map<String, dynamic> json) {
    return _$DownloadFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DownloadToJson(this);
}
