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

import 'package:json_annotation/json_annotation.dart';

import '../../base_model/graphql_base_model.dart';

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
  });

  String? id;
  String? email;
  @JsonKey(name: "first_name")
  String? firstName;
  @JsonKey(name: "last_name")
  String? lastName;
  String? name;
  String? gender;
  @JsonKey(name: "date_of_birth")
  String? dateOfBirth;

  // ignore: prefer_typing_uninitialized_variables
  var phone;
  // bool? status;
  Group? group;
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
