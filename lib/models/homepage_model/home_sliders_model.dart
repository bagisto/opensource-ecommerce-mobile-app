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
part 'home_sliders_model.g.dart';

@JsonSerializable()
class HomeSlidersData {
  List<HomeSliders>? data;

  HomeSlidersData({this.data});

  factory HomeSlidersData.fromJson(Map<String, dynamic> json) =>
      _$HomeSlidersDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeSlidersDataToJson(this);
}

@JsonSerializable()
class Data {
  List<HomeSliders>? homeSliders;

  Data({this.homeSliders});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class HomeSliders {
  String? id;
  String? imageUrl;
  String? title;
  String? path;
  String? content;
  String? channelId;
  String? locale;
  String? sliderPath;
  String? imgPath;

  HomeSliders({
    this.id,
    this.imageUrl,
    this.title,
    this.path,
    this.content,
    this.channelId,
    this.locale,
    this.sliderPath,
    this.imgPath,
  });

  factory HomeSliders.fromJson(Map<String, dynamic> json) =>
      _$HomeSlidersFromJson(json);

  Map<String, dynamic> toJson() => _$HomeSlidersToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
