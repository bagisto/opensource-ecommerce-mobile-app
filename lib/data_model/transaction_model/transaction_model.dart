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

import '../../screens/home_page/data_model/new_product_data.dart';
import '../graphql_base_model.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends GraphQlBaseModel{
  PaginatorInfo? paginatorInfo;
  List<TransactionData>? data;

  TransactionModel({this.paginatorInfo, this.data});

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$TransactionModelToJson(this);

}

@JsonSerializable()
class PaginatorInfo {
  int? count;
  int? currentPage;
  int? lastPage;
  int? total;

  PaginatorInfo({this.count, this.currentPage, this.lastPage, this.total});
  factory PaginatorInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginatorInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaginatorInfoToJson(this);

}

@JsonSerializable()
class TransactionData {
  String? id;
  String? type;
  String? transactionId;
  String? method;
  String? comment;
  double? baseTotal;
  String? marketplaceSellerId;
  String? marketplaceOrderId;
  String? createdAt;
  String? updatedAt;
  MarketplaceOrder? marketplaceOrder;

  TransactionData(
      {this.id,
        this.type,
        this.transactionId,
        this.method,
        this.comment,
        this.baseTotal,
        this.marketplaceSellerId,
        this.marketplaceOrderId,
        this.createdAt,
        this.updatedAt,
        this.marketplaceOrder});

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TransactionDataToJson(this);
}

@JsonSerializable()
class MarketplaceOrder {
  String? id;
  String? status;
  bool? isWithdrawalRequested;
  String? sellerPayoutStatus;
  int? commissionPercentage;
  double? commission;
  double? baseCommission;
  double? commissionInvoiced;
  double? baseCommissionInvoiced;
  double? sellerTotal;
  double? baseSellerTotal;
  double? sellerTotalInvoiced;
  double? baseSellerTotalInvoiced;
  int? totalItemCount;
  int? totalQtyOrdered;
  double? grandTotal;
  double? baseGrandTotal;
  double? grandTotalInvoiced;
  double? baseGrandTotalInvoiced;
  int? grandTotalRefunded;
  int? baseGrandTotalRefunded;
  double? subTotal;
  double? baseSubTotal;
  double? subTotalInvoiced;
  double? baseSubTotalInvoiced;
  int? subTotalRefunded;
  int? baseSubTotalRefunded;
  int? discountPercent;
  int? discountAmount;
  int? baseDiscountAmount;
  int? discountAmountInvoiced;
  int? baseDiscountAmountInvoiced;
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
  String? marketplaceSellerId;
  String? orderId;
  String? createdAt;
  String? updatedAt;
  Seller? seller;
  AdditionalInfo? additionalInfo;
  List<MarketplaceOrderItem>? marketplaceOrderItems;

  MarketplaceOrder(
      {this.id,
        this.status,
        this.isWithdrawalRequested,
        this.sellerPayoutStatus,
        this.commissionPercentage,
        this.commission,
        this.baseCommission,
        this.commissionInvoiced,
        this.baseCommissionInvoiced,
        this.sellerTotal,
        this.baseSellerTotal,
        this.sellerTotalInvoiced,
        this.baseSellerTotalInvoiced,
        this.totalItemCount,
        this.totalQtyOrdered,
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
        this.discountAmountInvoiced,
        this.baseDiscountAmountInvoiced,
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
        this.marketplaceSellerId,
        this.orderId,
        this.createdAt,
        this.updatedAt,
        this.seller,
        this.marketplaceOrderItems, this.additionalInfo});

  factory MarketplaceOrder.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceOrderFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceOrderToJson(this);
}

@JsonSerializable()
class AdditionalInfo {
  FormattedPrice? formattedPrice;

  AdditionalInfo({this.formattedPrice});

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) =>
      _$AdditionalInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AdditionalInfoToJson(this);
}

@JsonSerializable()
class FormattedPrice {
  String? sellerTotal;
  String? baseSellerTotal;
  String? baseSellerTotalInvoiced;

  FormattedPrice(
      {this.sellerTotal, this.baseSellerTotal, this.baseSellerTotalInvoiced});

  factory FormattedPrice.fromJson(Map<String, dynamic> json) =>
      _$FormattedPriceFromJson(json);

  Map<String, dynamic> toJson() => _$FormattedPriceToJson(this);
}

@JsonSerializable()
class MarketplaceOrderItem {
  String? id;
  double? commission;
  double? baseCommission;
  double? commissionInvoiced;
  double? baseCommissionInvoiced;
  double? sellerTotal;
  double? baseSellerTotal;
  double? sellerTotalInvoiced;
  double? baseSellerTotalInvoiced;
  String? orderItemId;
  String? marketplaceProductId;
  String? marketplaceOrderId;
  String? parentId;
  OrderItem? orderItem;

  MarketplaceOrderItem(
      {this.id,
        this.commission,
        this.baseCommission,
        this.commissionInvoiced,
        this.baseCommissionInvoiced,
        this.sellerTotal,
        this.baseSellerTotal,
        this.sellerTotalInvoiced,
        this.baseSellerTotalInvoiced,
        this.orderItemId,
        this.marketplaceProductId,
        this.marketplaceOrderId,
        this.parentId,
        this.orderItem});

  factory MarketplaceOrderItem.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceOrderItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MarketplaceOrderItemToJson(this);
}

@JsonSerializable()
class OrderItem {
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
  double? price;
  double? basePrice;
  double? total;
  double? baseTotal;
  double? totalInvoiced;
  double? baseTotalInvoiced;
  int? amountRefunded;
  int? baseAmountRefunded;
  int? discountPercent;
  int? discountAmount;
  int? baseDiscountAmount;
  int? discountInvoiced;
  int? baseDiscountInvoiced;
  int? discountRefunded;
  int? baseDiscountRefunded;
  int? taxPercent;
  int? taxAmount;
  int? baseTaxAmount;
  int? taxAmountInvoiced;
  int? baseTaxAmountInvoiced;
  int? taxAmountRefunded;
  int? baseTaxAmountRefunded;
  String? productId;
  String? productType;
  String? orderId;
  String? parentId;
  String? additional;
  String? createdAt;
  String? updatedAt;

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
        this.additional,
        this.createdAt,
        this.updatedAt});


  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrderItemToJson(this);
}
