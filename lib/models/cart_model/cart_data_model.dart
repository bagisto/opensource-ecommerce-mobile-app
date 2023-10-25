// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:bagisto_app_demo/models/product_model/product_screen_model.dart';
import '../../base_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';


part 'cart_data_model.g.dart';

@JsonSerializable()
class CartModel extends GraphQlBaseModel {
  String? id;
  String? customerEmail;
  String? customerFirstName;
  String? customerLastName;
  String? shippingMethod;
  String? couponCode;
  bool? isGift;
  int? itemsCount;
  int? itemsQty;
  String? exchangeRate;
  String? globalCurrencyCode;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? cartCurrencyCode;
  var grandTotal;
  var baseGrandTotal;
  var subTotal;
  var baseSubTotal;
  var baseTaxTotal;
  var discountAmount;
  var baseDiscountAmount;
  bool? isGuest;
  bool? isActive;
  String? customerId;
  String? channelId;
  String? appliedCartRuleIds;
  String? createdAt;
  String? updatedAt;
  FormattedPrice? formattedPrice;
  List<Items>? items;
  ShippingAddress? shippingAddress;
  ShippingAddress? billingAddress;
  SelectedShippingRate? selectedShippingRate;
  Payment? payment;


  CartModel({this.items,this.id, this.customerEmail, this.customerFirstName, this.customerLastName, this.shippingMethod,
    this.couponCode, this.isGift, this.itemsCount, this.itemsQty, this.exchangeRate, this.globalCurrencyCode,
    this.baseCurrencyCode, this.channelCurrencyCode, this.cartCurrencyCode, this.grandTotal, this.baseGrandTotal,
    this.subTotal, this.baseSubTotal, this.baseTaxTotal, this.discountAmount,
    this.baseDiscountAmount, this.isGuest, this.isActive,  this.customerId, this.channelId, this.appliedCartRuleIds, this.createdAt, this.updatedAt,this.formattedPrice,this.shippingAddress,
    this.billingAddress,this.selectedShippingRate,this.payment});
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return _$CartModelFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$CartModelToJson(this);

}


@JsonSerializable()
class Payment{
  String? id;
  String? method;
  String? methodTitle;

  Payment({this.id, this.method, this.methodTitle});
  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

}

@JsonSerializable()
class Items {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? couponCode;
  double? weight;
  double? totalWeight;
  int? qtyOrdered;
  int? qtyShipped;
  int? qtyInvoiced;
  int? qtyCanceled;
  int? qtyRefunded;
  int? quantity;
  String? productId;
  String? productType;
  String? orderId;
  String? parentId;
  Additional? additional;
  String? createdAt;
  String? updatedAt;
  Product? product;
  FormattedPrice? formattedPrice;
  // List<String>? invoiceItems;
  // List<String>? shipmentItems;
  // List<String>? refundItems;

  Items({
    this.id,
    this.sku,
    this.quantity,
    this.type,
    this.name,
    this.couponCode,
    this.weight,
    this.totalWeight,
    this.qtyOrdered,
    this.qtyShipped,
    this.qtyInvoiced,
    this.qtyCanceled,
    this.qtyRefunded,
    this.productId,
    this.productType,
    this.orderId,
    this.parentId,
    this.additional,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class CartDetailModel extends GraphQlBaseModel {
  String? id;
  int? quantity;
  String? sku;
  String? type;
  String? name;
  String? couponCode;
  var weight;
  var totalWeight;
  var baseTotalWeight;
  int? price;
  int? basePrice;
  int? total;
  int? baseTotal;
  int? taxPercent;
  int? taxAmount;
  int? baseTaxAmount;
  int? discountPercent;
  int? discountAmount;
  int? baseDiscountAmount;
  Additional? additional;
  String? productId;
  String? cartId;
  String? appliedCartRuleIds;
  String? createdAt;
  String? updatedAt;
  // Product? product;

  CartDetailModel({this.id, this.quantity, this.sku, this.type, this.name, this.couponCode, this.weight,
    this.totalWeight, this.baseTotalWeight, this.price, this.basePrice, this.total, this.baseTotal, this.taxPercent,
    this.taxAmount, this.baseTaxAmount, this.discountPercent, this.discountAmount, this.baseDiscountAmount,
    this.additional, this.productId, this.cartId, this.appliedCartRuleIds, this.createdAt, this.updatedAt, /*this.product*/});

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    return _$CartDetailModelFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$CartDetailModelToJson(this);

}
@JsonSerializable()
class ShippingAddress {
  String? id;
  String? addressType;
  String? customerId;
  String? cartId;
  String? orderId;
  String? firstName;
  String? lastName;
  String? gender;
  String? companyName;
  String? address1;
  String? address2;
  String? postcode;
  String? city;
  String? state;
  String? country;
  String? email;
  String? phone;
  bool? defaultAddress;
  String? vatId;
  // Additional? additional;
  String? createdAt;
  String? updatedAt;

  ShippingAddress(
      {this.id,
        this.addressType,
        this.customerId,
        this.cartId,
        this.orderId,
        this.firstName,
        this.lastName,
        this.gender,
        this.companyName,
        this.address1,
        this.address2,
        this.postcode,
        this.city,
        this.state,
        this.country,
        this.email,
        this.phone,
        this.defaultAddress,
        this.vatId,
        // this.additional,
        this.createdAt,
        this.updatedAt});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return _$ShippingAddressFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}
@JsonSerializable()
class SelectedShippingRate {
  String? id;
  String? carrier;
  String? carrierTitle;
  String? method;
  String? methodTitle;
  String? methodDescription;
  int? price;
  int? basePrice;
  int? discountAmount;
  int? baseDiscountAmount;
  String? cartAddressId;
  String? createdAt;
  String? updatedAt;
  FormattedPrice? formattedPrice;

  SelectedShippingRate(
      {this.id,
        this.carrier,
        this.carrierTitle,
        this.method,
        this.methodTitle,
        this.methodDescription,
        this.price,
        this.basePrice,
        this.discountAmount,
        this.baseDiscountAmount,
        this.cartAddressId,
        this.createdAt,
        this.updatedAt,
        this.formattedPrice});

  factory SelectedShippingRate.fromJson(Map<String, dynamic> json) {
    return _$SelectedShippingRateFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SelectedShippingRateToJson(this);
}

@JsonSerializable()
class FormattedPrice {
  var price;
  var basePrice;
  var total;
  var baseTotal;
  var totalInvoiced;
  var baseTotalInvoiced;
  var amountRefunded;
  var baseAmountRefunded;
  var discountPercent;
  var discountAmount;
  var baseDiscountAmount;
  var discountInvoiced;
  var baseDiscountInvoiced;
  var discountRefunded;
  var baseDiscountRefunded;
  var taxPercent;
  var taxAmount;
  var baseTaxAmount;
  var taxAmountInvoiced;
  var baseTaxAmountInvoiced;
  var taxAmountRefunded;
  var baseTaxAmountRefunded;
  String? grandTotal;
  String? baseGrandTotal;
  String? grandTotalInvoiced;
  String? baseGrandTotalInvoiced;
  String? grandTotalRefunded;
  String? baseGrandTotalRefunded;
  String? subTotal;
  String? baseSubTotal;
  String? subTotalInvoiced;
  String? baseSubTotalInvoiced;
  String? subTotalRefunded;
  String? shippingAmount;
  String? baseShippingAmount;
  String? shippingInvoiced;
  String? baseShippingInvoiced;
  String? shippingRefunded;
  String? baseShippingRefunded;
  String? baseDiscountedSubTotal;
  String? discount;
  String? discountedSubTotal;
  var taxTotal;
  String? baseTaxTotal;
  String? baseDiscount;
  String? adjustmentFee;
  String? baseAdjustmentFee;
  String? adjustmentRefund;

  FormattedPrice(
      this.grandTotal,
      this.baseGrandTotal,
      this.grandTotalInvoiced,
      this.baseGrandTotalInvoiced,
      this.grandTotalRefunded,
      this.baseGrandTotalRefunded,
      this.subTotal,
      this.baseSubTotal,
      this.subTotalInvoiced,
      this.baseSubTotalInvoiced,
      this.subTotalRefunded,
      this.discountAmount,
      this.baseDiscountAmount,
      this.discountInvoiced,
      this.baseDiscountInvoiced,
      this.discountRefunded,
      this.baseDiscountRefunded,
      this.taxAmount,
      this.baseTaxAmount,
      this.taxAmountInvoiced,
      this.baseTaxAmountInvoiced,
      this.taxAmountRefunded,
      this.baseTaxAmountRefunded,
      this.shippingAmount,
      this.baseShippingAmount,
      this.shippingInvoiced,
      this.baseShippingInvoiced,
      this.shippingRefunded,
      this.baseShippingRefunded,
      this.baseDiscountedSubTotal,
      this.price,
      this.discount,
      this.discountedSubTotal,
      this.total,
      this.taxTotal,
      this.baseTaxTotal, this.baseTotal,
      this.baseDiscount, this.adjustmentFee, this.baseAdjustmentFee, this.adjustmentRefund);


  factory FormattedPrice.fromJson(Map<String, dynamic> json) {
    return _$FormattedPriceFromJson(json);
  }
  Map<String, dynamic> toJson() => _$FormattedPriceToJson(this);
}

@JsonSerializable()
class Additional{
bool? isBuyNow;
String? productId;
int? quantity;
String? selectedConfigurableOption;
SuperAttributes? superAttributes;
List<Attributes>? attributes;

Additional({this.isBuyNow,this.productId,this.quantity,this.selectedConfigurableOption,this.superAttributes,this.attributes});
factory Additional.fromJson(Map<String, dynamic> json) {
  return _$AdditionalFromJson(json);
}
Map<String, dynamic> toJson() => _$AdditionalToJson(this);

}

@JsonSerializable()
class SuperAttributes{
  int? attributeId;
  int? optionId;

  SuperAttributes({this.attributeId,this.optionId});
  factory SuperAttributes.fromJson(Map<String, dynamic> json) {
    return _$SuperAttributesFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SuperAttributesToJson(this);

}

@JsonSerializable()
class Attributes{
  String? optionId;
  String? optionLabel;
  String? attributeCode;
  String? attributeName;


  Attributes({this.optionId,this.optionLabel,this.attributeCode,this.attributeName});
  factory Attributes.fromJson(Map<String, dynamic> json) {
    return _$AttributesFromJson(json);
  }
  Map<String, dynamic> toJson() => _$AttributesToJson(this);

}


