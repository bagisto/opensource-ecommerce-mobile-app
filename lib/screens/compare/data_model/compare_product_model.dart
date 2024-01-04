import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../data_model/review_model/review_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
import '../../product_screen/data_model/product_details_model.dart';

part 'compare_product_model.g.dart';

@JsonSerializable()
class CompareProductsData extends GraphQlBaseModel {
  List<CompareProducts>? data;

  CompareProductsData({this.data});

  factory CompareProductsData.fromJson(Map<String, dynamic> json) =>
      _$CompareProductsDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CompareProductsDataToJson(this);
}

@JsonSerializable()
class CompareProducts {
  String? id;
  String? productId;
  String? customerId;
  String? createdAt;
  String? updatedAt;
  Product? product;
  Customer? customer;
  ProductFlats? productFlat;
  CartModel? cart;

  CompareProducts(
      {this.id,
      this.productId,
      this.customerId,
      this.createdAt,
      this.updatedAt,
      this.product,
      this.customer,
      this.cart, this.productFlat});


  factory CompareProducts.fromJson(Map<String, dynamic> json) =>
      _$CompareProductsFromJson(json);

  Map<String, dynamic> toJson() => _$CompareProductsToJson(this);
}

@JsonSerializable()
class Customer {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? email;
  String? phone;
  String? password;
  String? apiToken;
  int? customerGroupId;
  bool? subscribedToNewsLetter;
  bool? isVerified;
  String? token;
  String? notes;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.gender,
      this.dateOfBirth,
      this.email,
      this.phone,
      this.password,
      this.apiToken,
      this.customerGroupId,
      this.subscribedToNewsLetter,
      this.isVerified,
      this.token,
      this.notes,
      this.status,
      this.createdAt,
      this.updatedAt});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
