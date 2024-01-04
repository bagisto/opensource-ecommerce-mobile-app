/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/transaction_model/transaction_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../screens/home_page/data_model/new_product_data.dart';
import '../graphql_base_model.dart';
part 'transaction_detail_model.g.dart';

@JsonSerializable()
class TransactionDetailModel extends GraphQlBaseModel {
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

  TransactionDetailModel(
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

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$TransactionDetailModelToJson(this);
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

  Map<String, dynamic> toJson() =>
      _$MarketplaceOrderToJson(this);
}

@JsonSerializable()
class AdditionalInfo {
  FormattedPrice? formattedPrice;

  AdditionalInfo({this.formattedPrice});

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) =>
      _$AdditionalInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AdditionalInfoToJson(this);

}

@JsonSerializable()
class FormattedPrice {
  String? commission;
  String? total;
  String? dueTotal;
  String? price;
  String? baseRemainingTotal;
  String? baseCommission;
  String? commissionInvoiced;
  String? baseCommissionInvoiced;
  String? sellerTotal;
  String? baseSellerTotal;
  String? sellerTotalInvoiced;
  String? baseSellerTotalInvoiced;
  String? grandTotal;
  String? baseGrandTotal;
  String? grandTotalInvoiced;
  String? baseGrandTotalInvoiced;
  String? grandTotalRefunded;
  String? baseGrandTotalRefunded;
  String? subTotal;
  String? totalPaid;
  String? baseSubTotal;
  String? subTotalInvoiced;
  String? baseSubTotalInvoiced;
  String? subTotalRefunded;
  String? baseSubTotalRefunded;
  String? discountAmount;
  String? baseDiscountAmount;
  String? discountAmountInvoiced;
  String? baseDiscountAmountInvoiced;
  String? discountRefunded;
  String? baseDiscountRefunded;
  String? taxAmount;
  String? baseTaxAmount;
  String? taxAmountInvoiced;
  String? baseTaxAmountInvoiced;
  String? taxAmountRefunded;
  String? baseTaxAmountRefunded;
  String? shippingAmount;
  String? baseShippingAmount;
  String? shippingInvoiced;
  String? baseShippingInvoiced;
  String? shippingRefunded;
  String? baseShippingRefunded;

  FormattedPrice({this.commission,
    this.baseCommission,
    this.commissionInvoiced,
    this.baseCommissionInvoiced,
    this.sellerTotal,
    this.baseSellerTotal,
    this.sellerTotalInvoiced,
    this.baseSellerTotalInvoiced,
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
    this.shippingRefunded, this.baseRemainingTotal,
    this.baseShippingRefunded, this.price, this.total,this.dueTotal, this.totalPaid});

  factory FormattedPrice.fromJson(Map<String, dynamic> json) =>
      _$FormattedPriceFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FormattedPriceToJson(this);
}





