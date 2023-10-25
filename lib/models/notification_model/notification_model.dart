
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

import '../../base_model/graphql_base_model.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class NotificationListModel extends GraphQlBaseModel {
  List<Data>? data;

  NotificationListModel({this.data});

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationListModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$NotificationListModelToJson(this);
}



@JsonSerializable()
class Data {
  String? id;
  String? image;
  String? imageUrl;
  String? type;
  String? productCategoryId;
  bool? status;
  String? createdAt;
  String? updatedAt;
  List<Translations>? translations;

  Data(
      {this.id,
        this.image,
        this.imageUrl,
        this.type,
        this.productCategoryId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.translations,
        });

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataToJson(this);
}
@JsonSerializable()
class Translations {
  String? id;
  String? title;
  String? content;
  String? locale;
  String? channel;
  String? pushNotificationId;

  Translations({this.id,
    this.title,
    this.content,
    this.locale,
    this.channel,
    this.pushNotificationId});

  factory Translations.fromJson(Map<String, dynamic> json) =>
      _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TranslationsToJson(this);
}