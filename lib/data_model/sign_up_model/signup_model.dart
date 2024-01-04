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

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signup_model.g.dart';

@JsonSerializable()
class SignUpResponseModel extends GraphQlBaseModel{
  String? token;
  Data? data;
  // dynamic error;

  SignUpResponseModel({this.token,  this.data/*,this.error,*/});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$SignUpResponseModelToJson(this);
}
@JsonSerializable()
class Data {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String?name;
  Group? group;

  Data(
      {
        this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.name,
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
