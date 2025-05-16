/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// file_names, constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'graphql_base_model.g.dart';

/// BaseModel class having some general variables which will use by other model classes.
@JsonSerializable()
class BaseModel {
  bool? success;
  String?graphqlErrors;
  bool? status;
  // List<Error>? errors;
  String? message;
  int? cartCount;
  dynamic error;

  BaseModel({this.success, this.message, this.cartCount, this.status, this.graphqlErrors});

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}


