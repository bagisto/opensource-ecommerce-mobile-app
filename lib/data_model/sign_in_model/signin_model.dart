/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signin_model.g.dart';

@JsonSerializable()
class SignInModel extends GraphQlBaseModel {
  SignInModel({
    /*  this.error,*/
    this.token,
    // required this.message,
    this.data,
  });

  // String?error;
  @JsonKey(name:'accessToken')
  String? token;

  // late final String message;
  @JsonKey(name: 'customer')
  Data? data;

  factory SignInModel.fromJson(Map<String, dynamic> json) =>
      _$SignInModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignInModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.group,
    this.createdAt,
    this.updatedAt,
    this.imageUrl
  });

  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? name;
  String? gender;
  String? dateOfBirth;
  var phone;
  Group? group;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Group {
  Group({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
