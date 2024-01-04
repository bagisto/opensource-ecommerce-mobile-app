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
part 'country_model.g.dart';

@JsonSerializable()
class CountriesData {
  List<Data>? data;

  CountriesData({this.data});

  factory CountriesData.fromJson(Map<String, dynamic> json) => _$CountriesDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountriesDataToJson(this);
}

// @JsonSerializable()
// class Data {
//   List<Countries>? countries;
//
//   Data({this.countries});
//
//   factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$DataToJson(this);
// }
@JsonSerializable()
class Data {
  String? id;
  String? code;
  String? name;
  List<Translations>? translations;
  List<States>? states;

  Data({this.id, this.code, this.name, this.translations, this.states});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
@JsonSerializable()
class Translations {
  String? id;
  String? locale;
  String? name;
  String? title;
  String? countryId;
  String? defaultName;
  String? countryStateId;

  Translations({this.id,this.title, this.locale, this.name, this.countryId,this.defaultName,this.countryStateId});
  factory Translations.fromJson(Map<String, dynamic> json) => _$TranslationsFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationsToJson(this);

}

@JsonSerializable()
class States {
  String? id;
  String? countryCode;
  String? code;
  String? defaultName;
  String? countryId;
  List<Translations>? translations;

  States(
      {this.id,
        this.countryCode,
        this.code,
        this.defaultName,
        this.countryId,
        this.translations});

  factory States.fromJson(Map<String, dynamic> json) => _$StatesFromJson(json);

  Map<String, dynamic> toJson() => _$StatesToJson(this);
}


