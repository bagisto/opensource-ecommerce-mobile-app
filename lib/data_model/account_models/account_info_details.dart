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

part 'account_info_details.g.dart';

@JsonSerializable()
class AccountInfoModel {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  // String? name;
  String? imageUrl;
  String? dateOfBirth;
  String? phone;
  bool? subscribedToNewsLetter;

  AccountInfoModel(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      // this.name,
      this.imageUrl,
      this.dateOfBirth,
      this.phone,
      this.subscribedToNewsLetter});

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoModelToJson(this);
}
