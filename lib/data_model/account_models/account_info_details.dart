/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:json_annotation/json_annotation.dart';

import '../../screens/home_page/data_model/new_product_data.dart';
import '../graphql_base_model.dart';
part 'account_info_details.g.dart';

@JsonSerializable()
class AccountInfoDetails extends GraphQlBaseModel{
  @JsonKey(name: "customer")
  Data? data;

  AccountInfoDetails({this.data});

  factory AccountInfoDetails.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$AccountInfoDetailsToJson(this);
}
@JsonSerializable()
class Data {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? name;
  String? gender;
  String? imageUrl;
  String? dateOfBirth;
  String? phone;
  bool? status;
  Group? group;
  Seller? seller;

  Data(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.name,
        this.gender,
        this.imageUrl,
        this.dateOfBirth,
        this.phone,
        this.status,
        this.group,
        this.seller
      });

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);
}
@JsonSerializable()
class Group {
  int? id;
  String? name;

  Group({this.id, this.name});
  factory Group.fromJson(Map<String, dynamic> json) =>
      _$GroupFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GroupToJson(this);

}