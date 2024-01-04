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
import 'package:bagisto_app_demo/screens/home_page/data_model/new_product_data.dart';
import 'package:json_annotation/json_annotation.dart';


part 'sign_up_seller_model.g.dart';
@JsonSerializable()
class CreateSeller extends GraphQlBaseModel{
  String ? success;
  String ? accessToken;
  String ? id;
  String ? url;
  bool ? isApproved;
  String ? shopTitle;
  String ?description;
  String? banner;
  String ?bannerUrl;
  String?logo;
  String ?logoUrl;
  String ? taxVat;
  String ? metaTitle;
  String ? metaDescription;
  String ? metaKeywords;
  String ? address1;
  String ? address2;
  String ? phone;
  String ? state;
  String ? city;
  String ? country;
  String ? postcode;
  String ? returnPolicy;
  String ? shippingPolicy;
  String ? privacyPolicy;
  String ? twitter;
  String ? facebook;
  String ? youtube;
  String ? instagram;
  String ? skype;
  String ? linkedIn;
  String ? pinterest;
  String ? customerId;
  DateTime ? createdAt;
  DateTime ? updatedAt;
  String ? commissionEnable;
  String ? commissionPercentage;
  String ? minOrderAmount;
  String ? googleAnalyticsId;
  String ? profileBackground;
  Customer ? customer;

  CreateSeller({
     this.success,
     this.accessToken,
     this.id,
     this.url,
     this.isApproved,
    this.shopTitle,
    this.description,
    this.banner,
    this.bannerUrl,
    this.logo,
    this.logoUrl,
    this.taxVat,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.address1,
    this.address2,
    this.phone,
    this.state,
    this.city,
    this.country,
    this.postcode,
    this.returnPolicy,
    this.shippingPolicy,
    this.privacyPolicy,
    this.twitter,
    this.facebook,
    this.youtube,
    this.instagram,
    this.skype,
    this.linkedIn,
    this.pinterest,
     this.customerId,
     this.createdAt,
     this.updatedAt,
    this.commissionEnable,
    this.commissionPercentage,
    this.minOrderAmount,
    this.googleAnalyticsId,
    this.profileBackground,
     this.customer,
  });
  factory CreateSeller.fromJson(Map<String, dynamic> json) =>
      _$CreateSellerFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CreateSellerToJson(this);
}
@JsonSerializable()
class Customer {
  String  ?name;
  String  ?id;
  String? firstName;
  String ?lastName;
  String ?email;
  String ? imageUrl;
  String ? dateOfBirth;
  String ? gender;
  String ? phone;
  String ? notes;
  bool ? isVerified;
  Seller? seller;

  Customer({
     this.name,
     this.id,
     this.firstName,
     this.lastName,
     this.email,
    this.imageUrl,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.notes,
     this.isVerified,
    this.seller
  });
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CustomerToJson(this);
}
