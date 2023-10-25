

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_language_model.g.dart';



@JsonSerializable()
class CurrencyLanguageList extends GraphQlBaseModel {
  List<Locales>? locales;
  Locales? defaultLocale;
  List<Currencies>? currencies;
  Currencies? baseCurrency;



  CurrencyLanguageList(
      {this.locales,
        this.defaultLocale,
        this.currencies,
        this.baseCurrency,
      });

  factory CurrencyLanguageList.fromJson(Map<String, dynamic> json) =>
      _$CurrencyLanguageListFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CurrencyLanguageListToJson(this);
}
@JsonSerializable()
class Locales {
  String? id;
  String? name;
  String? code;
  String? direction;


  Locales(
      {this.id,
        this.name,
        this.code,
        this.direction,
       });

  factory Locales.fromJson(Map<String, dynamic> json) =>
      _$LocalesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LocalesToJson(this);
}
@JsonSerializable()
class Currencies {
  String? id;
  String? name;
  String? code;
  String? symbol;


  Currencies(
      {this.id,
        this.name,
        this.code,
        this.symbol,
       });

  factory Currencies.fromJson(Map<String, dynamic> json) =>
      _$CurrenciesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CurrenciesToJson(this);
}




