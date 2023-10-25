

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

import '../cart_model/cart_data_model.dart';
part 'advertisement_data.g.dart';
//
// @JsonSerializable()
// class AdvertisementData {
//   // @JsonKey(name: "advertisements")
//  Advertisements? data;
//
//   AdvertisementData({this.data});
//
//
//   factory AdvertisementData.fromJson(Map<String, dynamic> json) =>
//       _$AdvertisementDataFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() =>
//       _$AdvertisementDataToJson(this);
// }
// @JsonSerializable()
// class Data {
//   List<Advertisements>? advertisements;
//
//   Data({this.advertisements});
//
//
//   factory Data.fromJson(Map<String, dynamic> json) =>
//       _$DataFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() =>
//       _$DataToJson(this);
// }

@JsonSerializable()
class Advertisements {
  List<AdvertisementSlug>? advertisementFour;
  List<AdvertisementSlug>? advertisementThree;
  List<AdvertisementSlug>? advertisementTwo;
  CartModel? cart;
  Advertisements(
      {this.advertisementFour, this.advertisementThree, this.advertisementTwo,this.cart});


  factory Advertisements.fromJson(Map<String, dynamic> json) =>
      _$AdvertisementsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AdvertisementsToJson(this);
}

@JsonSerializable()
class AdvertisementSlug{
  String? image;
  String? slug;

  AdvertisementSlug({this.image,this.slug});

  factory AdvertisementSlug.fromJson(Map<String, dynamic> json) =>
      _$AdvertisementSlugFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AdvertisementSlugToJson(this);
}
