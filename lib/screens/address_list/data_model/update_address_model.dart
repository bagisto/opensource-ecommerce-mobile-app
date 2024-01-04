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

import '../../../data_model/graphql_base_model.dart';
part 'update_address_model.g.dart';

@JsonSerializable()
class UpdateAddressModel extends GraphQlBaseModel{
  Data? data;
  UpdateAddressModel({ this.data});
  factory UpdateAddressModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateAddressModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$UpdateAddressModelToJson(this);

}
@JsonSerializable()
class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? companyName;
  String? vatId;
  List<String>? address1;
  String? country;
  String? countryName;
  String? state;
  String? city;
  String? postcode;
  String? phone;
  bool? isDefault;
  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.companyName,
        this.vatId,
        this.address1,
        this.country,
        this.countryName,
        this.state,
        this.city,
        this.postcode,
        this.phone,
        this.isDefault,});

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);
}
