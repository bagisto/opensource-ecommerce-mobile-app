/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_error_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../screens/cart_screen/cart_model/cart_data_model.dart';
import '../product_model/product_screen_model.dart';
part 'order_detail_model.g.dart';

@JsonSerializable()
class OrderDetail extends GraphQlBaseErrorModel {
  FormattedPrice? formattedPrice;
  int? id;
  String? incrementId;
  String? status;
  String? channelName;
  int? isGuest;
  String? customerEmail;
  String? customerFirstName;
  String? customerLastName;
  String? customerCompanyName;
  String? customerVatId;
  String? shippingMethod;
  String? shippingTitle;
  String? shippingDescription;
  String? couponCode;
  int? isGift;
  int? totalItemCount;
  int? totalQtyOrdered;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? orderCurrencyCode;
  dynamic grandTotal;
  dynamic baseGrandTotal;
  dynamic grandTotalInvoiced;
  dynamic baseGrandTotalInvoiced;
  dynamic grandTotalRefunded;
  dynamic baseGrandTotalRefunded;
  dynamic subTotal;
  dynamic baseSubTotal;
  dynamic subTotalInvoiced;
  dynamic baseSubTotalInvoiced;
  dynamic subTotalRefunded;
  dynamic baseSubTotalRefunded;
  dynamic discountPercent;
  dynamic discountAmount;
  dynamic baseDiscountAmount;
  dynamic discountInvoiced;
  dynamic baseDiscountInvoiced;
  dynamic discountRefunded;
  dynamic baseDiscountRefunded;
  dynamic taxAmount;
  dynamic baseTaxAmount;
  dynamic taxAmountInvoiced;
  dynamic baseTaxAmountInvoiced;
  dynamic taxAmountRefunded;
  dynamic baseTaxAmountRefunded;
  dynamic shippingAmount;
  dynamic baseShippingAmount;
  dynamic shippingInvoiced;
  dynamic baseShippingInvoiced;
  dynamic shippingRefunded;
  dynamic baseShippingRefunded;
  dynamic customerId;
  String? customerType;
  int? channelId;
  String? channelType;
  String? cartId;
  String? appliedCartRuleIds;
  int? shippingDiscountAmount;
  int? baseShippingDiscountAmount;
  String? createdAt;
  String? updatedAt;
  BillingAddress? billingAddress;
  BillingAddress? shippingAddress;
  List<Items>? items;
  Payment? payment;


  // List<String>? shipments;

  OrderDetail(
      {this.id,
      this.incrementId,
      this.channelName,
      this.isGuest,
      this.customerEmail,
      this.customerFirstName,
      this.customerLastName,
      this.customerCompanyName,
      this.customerVatId,
      this.shippingMethod,
      this.shippingTitle,
      this.shippingDescription,
      this.couponCode,
      this.isGift,
      this.totalItemCount,
      this.totalQtyOrdered,
      this.baseCurrencyCode,
      this.channelCurrencyCode,
      this.orderCurrencyCode,
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
      this.baseSubTotalRefunded,
      this.discountPercent,
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
      this.customerId,
      this.customerType,
      this.channelId,
      this.channelType,
      this.cartId,
      this.appliedCartRuleIds,
      this.shippingDiscountAmount,
      this.baseShippingDiscountAmount,
      this.createdAt,
      this.updatedAt,
      this.billingAddress,
      this.shippingAddress,
      this.items,
      this.payment,
      this.formattedPrice});

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}

@JsonSerializable()
class Payment {
  String? id;
  String? method;
  String? methodTitle;

  Payment({this.id, this.method, this.methodTitle});

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class BillingAddress {
  String? id;
  String? customerId;
  String? cartId;
  String ? orderId;
  String? firstName;
  String? lastName;
  String? gender;
  String? companyName;
  @JsonKey(name: "address")
  String? address1;
  String? address2;
  String? postcode;
  String? city;
  String? state;
  String? country;
  String? email;
  String? phone;
  String? vatId;
  bool? defaultAddress;

  BillingAddress(
      {this.id,
      this.customerId,
      this.cartId,
      this.orderId,
      this.firstName,
      this.lastName,
      this.gender,
      this.companyName,
        @JsonKey(name: "address")
        this.address1,
      this.address2,
      this.postcode,
      this.city,
      this.state,
      this.country,
      this.email,
      this.phone,
      this.vatId,
      this.defaultAddress});

  factory BillingAddress.fromJson(Map<String, dynamic> json) =>
      _$BillingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$BillingAddressToJson(this);
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
  dynamic price;
  dynamic basePrice;
  dynamic total;
  dynamic baseTotal;
  dynamic totalInvoiced;
  dynamic baseTotalInvoiced;
  dynamic amountRefunded;
  dynamic baseAmountRefunded;
  dynamic discountPercent;
  dynamic discountAmount;
  dynamic baseDiscountAmount;
  dynamic discountInvoiced;
  dynamic baseDiscountInvoiced;
  dynamic discountRefunded;
  dynamic baseDiscountRefunded;
  dynamic taxPercent;
  dynamic taxAmount;
  dynamic baseTaxAmount;
  dynamic taxAmountInvoiced;
  dynamic baseTaxAmountInvoiced;
  dynamic taxAmountRefunded;
  dynamic baseTaxAmountRefunded;
  String? productId;
  String? productType;
  String? orderId;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  OrderProduct? product;
  FormattedPrice? formattedPrice;
  Additional? additional;
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
    this.price,
    this.basePrice,
    this.total,
    this.baseTotal,
    this.totalInvoiced,
    this.baseTotalInvoiced,
    this.amountRefunded,
    this.baseAmountRefunded,
    this.discountPercent,
    this.discountAmount,
    this.baseDiscountAmount,
    this.discountInvoiced,
    this.baseDiscountInvoiced,
    this.discountRefunded,
    this.baseDiscountRefunded,
    this.taxPercent,
    this.taxAmount,
    this.baseTaxAmount,
    this.taxAmountInvoiced,
    this.baseTaxAmountInvoiced,
    this.taxAmountRefunded,
    this.baseTaxAmountRefunded,
    this.productId,
    this.productType,
    this.orderId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.additional
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class OrderProduct {
  String? id;
  String? type;
  dynamic attributeFamilyId;
  String? sku;
  String? name;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  List<Images>? images;
  List<ProductFlats>? productFlats;

  OrderProduct(
      {this.id,
      this.type,
      this.attributeFamilyId,
      this.sku,
      this.name,
      this.parentId,
      this.createdAt,
      this.updatedAt,
      this.productFlats});

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}

// @JsonSerializable()
// class Images{
//   String? id;
//   String? type;
//   String? path;
//   String? url;
//   String? productId;
//   Images({this.id,this.type,this.productId,this.path,this.url});
//
//   factory Images.fromJson(Map<String, dynamic> json) =>
//       _$ImagesFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ImagesToJson(this);
//
//
// }

@JsonSerializable()
class Child {
  String? id;
  String? sku;
  String? type;
  String? name;
  String? couponCode;
  int? weight;
  int? totalWeight;
  int? qtyOrdered;
  int? qtyShipped;
  int? qtyInvoiced;
  int? qtyCanceled;
  int? qtyRefunded;
  int? price;
  int? basePrice;
  int? total;
  int? baseTotal;
  int? totalInvoiced;
  int? baseTotalInvoiced;

  Child({
    this.id,
    this.sku,
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
    this.price,
    this.basePrice,
    this.total,
    this.baseTotal,
    this.totalInvoiced,
    this.baseTotalInvoiced,
  });

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  Map<String, dynamic> toJson() => _$ChildToJson(this);
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
class Options {
  String? id;
  String? label;
  String? swatchType;
  String? swatchValue;
  bool? isSelect = false;

  Options({this.id, this.label, this.swatchType,this.isSelect,this.swatchValue});


  factory Options.fromJson(Map<String, dynamic> json) =>
      _$OptionsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OptionsToJson(this);
}

