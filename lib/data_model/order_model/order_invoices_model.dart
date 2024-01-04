import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'order_detail_model.dart';
part 'order_invoices_model.g.dart';

@JsonSerializable()
class InvoicesModel extends GraphQlBaseModel{

  @JsonKey(name: "data")
  List<ViewInvoices>? viewInvoices;

  InvoicesModel({this.viewInvoices});

  factory InvoicesModel.fromJson(Map<String, dynamic> json) =>
      _$InvoicesModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InvoicesModelToJson(this);

}

@JsonSerializable()
class ViewInvoices {
  int? id;
  String? incrementId;
  String? state;
  int? emailSent;
  int? totalQty;
  String? baseCurrencyCode;
  String? channelCurrencyCode;
  String? orderCurrencyCode;
  int? subTotal;
  int? baseSubTotal;
  int? grandTotal;
  int? baseGrandTotal;
  int? shippingAmount;
  int? baseShippingAmount;
  int? taxAmount;
  int? baseTaxAmount;
  int? discountAmount;
  int? baseDiscountAmount;
  int? orderId;
  int? orderAddressId;
  String? createdAt;
  String? updatedAt;
  dynamic transactionId;
  List<InvoicesItems>? items;

  ViewInvoices(
      {this.id,
        this.incrementId,
        this.state,
        this.emailSent,
        this.totalQty,
        this.baseCurrencyCode,
        this.channelCurrencyCode,
        this.orderCurrencyCode,
        this.subTotal,
        this.baseSubTotal,
        this.grandTotal,
        this.baseGrandTotal,
        this.shippingAmount,
        this.baseShippingAmount,
        this.taxAmount,
        this.baseTaxAmount,
        this.discountAmount,
        this.baseDiscountAmount,
        this.orderId,
        this.orderAddressId,
        this.createdAt,
        this.updatedAt,
        this.transactionId,
        this.items});

  factory ViewInvoices.fromJson(Map<String, dynamic> json) =>
      _$ViewInvoicesFromJson(json);

  Map<String, dynamic> toJson() => _$ViewInvoicesToJson(this);
}

@JsonSerializable()
class InvoicesItems {
  String? id;
  String? sku;
  String? type;
  String? name;
  dynamic description;
  int? qty;
  int? price;
  int? basePrice;
  int? total;
  int? baseTotal;
  int? taxAmount;
  int? baseTaxAmount;
  String? productId;
  String? productType;
  String? orderItemId;
  String? invoiceId;
  dynamic parentId;
  String? additional;
  int? discountPercent;
  int? discountAmount;
  int? baseDiscountAmount;
  String? createdAt;
  String? updatedAt;
  OrderItem? orderItem;
  OrderProduct? product;

  InvoicesItems(
      {this.id,
        this.sku,
        this.type,
        this.name,
        this.description,
        this.qty,
        this.price,
        this.basePrice,
        this.total,
        this.baseTotal,
        this.taxAmount,
        this.baseTaxAmount,
        this.productId,
        this.productType,
        this.orderItemId,
        this.invoiceId,
        this.parentId,
        this.additional,
        this.discountPercent,
        this.discountAmount,
        this.baseDiscountAmount,
        this.createdAt,
        this.updatedAt,
        this.orderItem,
        this.product});

  factory InvoicesItems.fromJson(Map<String, dynamic> json) =>
      _$InvoicesItemsFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesItemsToJson(this);
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
  int? totalInvoiced;
  int? baseTotalInvoiced;
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
  dynamic parentId;
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

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

