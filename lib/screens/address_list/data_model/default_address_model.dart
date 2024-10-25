import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'default_address_model.g.dart';

@JsonSerializable()
class SetDefaultAddress extends BaseModel{
  @JsonKey(name: "address")
  AddressData? address;

  SetDefaultAddress({
    this.address,
  });

  factory SetDefaultAddress.fromJson(Map<String, dynamic> json) => _$SetDefaultAddressFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SetDefaultAddressToJson(this);
}

@JsonSerializable()
class AddressData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "addressType")
  String? addressType;
  @JsonKey(name: "parentAddressId")
  dynamic parentAddressId;
  @JsonKey(name: "customerId")
  String? customerId;
  @JsonKey(name: "cartId")
  dynamic cartId;
  @JsonKey(name: "orderId")
  dynamic orderId;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "gender")
  dynamic gender;
  @JsonKey(name: "companyName")
  String? companyName;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "state")
  String? state;
  @JsonKey(name: "country")
  String? country;
  @JsonKey(name: "postcode")
  String? postcode;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "vatId")
  String? vatId;
  @JsonKey(name: "defaultAddress")
  bool? defaultAddress;
  @JsonKey(name: "useForShipping")
  bool? useForShipping;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;

  AddressData({
    this.id,
    this.addressType,
    this.parentAddressId,
    this.customerId,
    this.cartId,
    this.orderId,
    this.firstName,
    this.lastName,
    this.gender,
    this.companyName,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.email,
    this.phone,
    this.vatId,
    this.defaultAddress,
    this.useForShipping,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => _$AddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);
}
