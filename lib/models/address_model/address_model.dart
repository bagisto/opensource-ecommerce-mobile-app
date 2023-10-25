/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'country_model.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel extends GraphQlBaseModel {
  @JsonKey(name: "addresses")
  List<AddressData>? addressData = [];
  CountriesData? countryData;
  AddressModel({this.addressData});
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

@JsonSerializable()
class AddressData {
  String? id;
  String? firstName;
  String? lastName;
  String? companyName;
  String? vatId;
  String? address1;
  String? country;
  String? countryName;
  String? stateName;
  String? state;
  String? city;
  String? postcode;
  String? phone;
  @JsonKey(name: "is_default")
  bool? isDefault = false;
  String? createdAt;
  String? updatedAt;

  AddressData(
      {this.id,
      this.firstName,
      this.lastName,
      this.companyName,
      this.vatId,
      this.address1,
      this.country,
      this.countryName,
        this.stateName,
      this.state,
      this.city,
      this.postcode,
      this.phone,
      this.isDefault,
      this.createdAt,
      this.updatedAt});
  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);
}
