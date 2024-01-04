
import 'package:json_annotation/json_annotation.dart';

import '../../../data_model/graphql_base_model.dart';
part 'downloadable_product_model.g.dart';


@JsonSerializable()
class DownloadableProductModel extends GraphQlBaseModel {
  @JsonKey(name: "data")
  List<DownloadableLinkPurchases>? downloadableLinkPurchases;

  DownloadableProductModel({this.downloadableLinkPurchases});

  factory DownloadableProductModel.fromJson(Map<String, dynamic> json) {
    return _$DownloadableProductModelFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$DownloadableProductModelToJson(this);

}

@JsonSerializable()
class DownloadableLinkPurchases {
  String? id;
  String? productName;
  String? name;
  String? url;
  String? file;
  String? fileName;
  String? type;
  int? downloadBought;
  int? downloadUsed;
  bool? status;
  String? customerId;
  String? orderId;
  String? orderItemId;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  Order? order;
  OrderItem? orderItem;

  DownloadableLinkPurchases(
      {this.id,
        this.productName,
        this.name,
        this.url,
        this.file,
        this.fileName,
        this.type,
        this.downloadBought,
        this.downloadUsed,
        this.status,
        this.customerId,
        this.orderId,
        this.orderItemId,
        this.createdAt,
        this.updatedAt,
        this.customer,
        this.order,
        this.orderItem});

  factory DownloadableLinkPurchases.fromJson(Map<String, dynamic> json) {
    return _$DownloadableLinkPurchasesFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DownloadableLinkPurchasesToJson(this);

}

@JsonSerializable()
class Customer {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  dynamic gender;
  dynamic dateOfBirth;
  String? email;
  dynamic phone;
  String? password;
  String? apiToken;
  int? customerGroupId;
  bool? subscribedToNewsLetter;
  bool? isVerified;
  String? token;
  dynamic notes;
  bool? status;

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
        this.status});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return _$CustomerFromJson(json);
  }
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

}

@JsonSerializable()
class Order {
  int? id;
  String? incrementId;
  String? status;
  String? channelName;
  int? isGuest;
  String? customerEmail;
  String? customerFirstName;
  String? customerLastName;
  dynamic customerCompanyName;
  dynamic customerVatId;
  dynamic shippingMethod;
  dynamic shippingTitle;
  dynamic shippingDescription;
  dynamic couponCode;
  int? isGift;
  int? totalItemCount;
  int? totalQtyOrdered;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? orderCurrencyCode;
  int? grandTotal;
  int? baseGrandTotal;
  int? grandTotalInvoiced;
  int? baseGrandTotalInvoiced;
  int? grandTotalRefunded;
  int? baseGrandTotalRefunded;
  int? subTotal;
  int? baseSubTotal;
  int? subTotalInvoiced;
  int? baseSubTotalInvoiced;
  int? subTotalRefunded;
  int? baseSubTotalRefunded;
  int? discountPercent;
  int? discountAmount;
  int? baseDiscountAmount;
  int? discountInvoiced;
  int? baseDiscountInvoiced;
  int? discountRefunded;
  int? baseDiscountRefunded;
  int? taxAmount;
  int? baseTaxAmount;
  int? taxAmountInvoiced;
  int? baseTaxAmountInvoiced;
  int? taxAmountRefunded;
  int? baseTaxAmountRefunded;
  int? shippingAmount;
  int? baseShippingAmount;
  int? shippingInvoiced;
  int? baseShippingInvoiced;
  int? shippingRefunded;
  int? baseShippingRefunded;
  int? customerId;
  String? customerType;
  int? channelId;
  String? channelType;
  String? cartId;
  String? appliedCartRuleIds;
  int? shippingDiscountAmount;
  int? baseShippingDiscountAmount;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.id,
        this.incrementId,
        this.status,
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
        this.updatedAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return _$OrderFromJson(json);
  }
  Map<String, dynamic> toJson() => _$OrderToJson(this);

}

@JsonSerializable()
class OrderItem {
  String? id;
  String? sku;
  String? type;
  String? name;
  dynamic couponCode;
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

  OrderItem(
      {this.id,
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
        this.baseTotal});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return _$OrderItemFromJson(json);
  }
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

}
