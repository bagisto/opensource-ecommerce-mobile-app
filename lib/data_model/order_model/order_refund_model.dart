
import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../screens/cart_screen/cart_model/cart_data_model.dart';
import 'order_detail_model.dart';

part 'order_refund_model.g.dart';

@JsonSerializable()
class OrderRefundModel extends GraphQlBaseModel {
  @JsonKey(name: "data")
  List<ViewRefunds>? viewRefunds;
  OrderRefundModel({this.viewRefunds});

  factory OrderRefundModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRefundModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderRefundModelToJson(this);
}

@JsonSerializable()
class ViewRefunds {
  int? id;
  dynamic incrementId;
  String? state;
  int? emailSent;
  int? totalQty;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? orderCurrencyCode;
  int? adjustmentRefund;
  int? baseAdjustmentRefund;
  int? adjustmentFee;
  int? baseAdjustmentFee;
  int? subTotal;
  int? baseSubTotal;
  int? grandTotal;
  int? baseGrandTotal;
  int? shippingAmount;
  int? baseShippingAmount;
  int? taxAmount;
  int? baseTaxAmount;
  int? discountPercent;
  int? discountAmount;
  int? baseDiscountAmount;
  int? orderId;
  String? createdAt;
  String? updatedAt;
  FormattedPrice? formattedPrice;
  List<RefundItems>? items;
  Order? order;

  ViewRefunds(
      {this.id,
        this.incrementId,
        this.state,
        this.emailSent,
        this.totalQty,
        this.baseCurrencyCode,
        this.channelCurrencyCode,
        this.orderCurrencyCode,
        this.adjustmentRefund,
        this.baseAdjustmentRefund,
        this.adjustmentFee,
        this.baseAdjustmentFee,
        this.subTotal,
        this.baseSubTotal,
        this.grandTotal,
        this.baseGrandTotal,
        this.shippingAmount,
        this.baseShippingAmount,
        this.taxAmount,
        this.baseTaxAmount,
        this.discountPercent,
        this.discountAmount,
        this.baseDiscountAmount,
        this.orderId,
        this.createdAt,
        this.updatedAt,
        this.items,
        this.order, this.formattedPrice});

  factory ViewRefunds.fromJson(Map<String, dynamic> json) =>
      _$ViewRefundsFromJson(json);

  Map<String, dynamic> toJson() => _$ViewRefundsToJson(this);
}

@JsonSerializable()
class RefundItems {
  int? id;
  String? name;
  dynamic description;
  String? sku;
  int? qty;
  int? price;
  int? basePrice;
  int? total;
  int? baseTotal;
  int? taxAmount;
  int? baseTaxAmount;
  int? discountPercent;
  int? discountAmount;
  int? baseDiscountAmount;
  int? productId;
  String? productType;
  int? orderItemId;
  int? refundId;
  dynamic parentId;
  String? additional;
  String? createdAt;
  String? updatedAt;
  OrderProduct? product;
  FormattedPrice? formattedPrice;

  RefundItems(
      {this.id,
        this.name,
        this.description,
        this.sku,
        this.qty,
        this.price,
        this.basePrice,
        this.total,
        this.baseTotal,
        this.taxAmount,
        this.baseTaxAmount,
        this.discountPercent,
        this.discountAmount,
        this.baseDiscountAmount,
        this.productId,
        this.productType,
        this.orderItemId,
        this.refundId,
        this.parentId,
        this.additional,
        this.createdAt,
        this.updatedAt,
        this.product, this.formattedPrice});

  factory RefundItems.fromJson(Map<String, dynamic> json) =>
      _$RefundItemsFromJson(json);

  Map<String, dynamic> toJson() => _$RefundItemsToJson(this);
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
  String? shippingMethod;
  String? shippingTitle;
  String? shippingDescription;
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

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
