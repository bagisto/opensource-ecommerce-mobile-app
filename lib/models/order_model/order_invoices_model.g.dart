// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_invoices_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoicesModel _$InvoicesModelFromJson(Map<String, dynamic> json) =>
    InvoicesModel(
      viewInvoices: (json['data'] as List<dynamic>?)
          ?.map((e) => ViewInvoices.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$InvoicesModelToJson(InvoicesModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.viewInvoices,
    };

ViewInvoices _$ViewInvoicesFromJson(Map<String, dynamic> json) => ViewInvoices(
      id: json['id'] as int?,
      incrementId: json['incrementId'] as String?,
      state: json['state'] as String?,
      emailSent: json['emailSent'] as int?,
      totalQty: json['totalQty'] as int?,
      baseCurrencyCode: json['baseCurrencyCode'] as String?,
      channelCurrencyCode: json['channelCurrencyCode'] as String?,
      orderCurrencyCode: json['orderCurrencyCode'] as String?,
      subTotal: json['subTotal'] as int?,
      baseSubTotal: json['baseSubTotal'] as int?,
      grandTotal: json['grandTotal'] as int?,
      baseGrandTotal: json['baseGrandTotal'] as int?,
      shippingAmount: json['shippingAmount'] as int?,
      baseShippingAmount: json['baseShippingAmount'] as int?,
      taxAmount: json['taxAmount'] as int?,
      baseTaxAmount: json['baseTaxAmount'] as int?,
      discountAmount: json['discountAmount'] as int?,
      baseDiscountAmount: json['baseDiscountAmount'] as int?,
      orderId: json['orderId'] as int?,
      orderAddressId: json['orderAddressId'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      transactionId: json['transactionId'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InvoicesItems.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ViewInvoicesToJson(ViewInvoices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'incrementId': instance.incrementId,
      'state': instance.state,
      'emailSent': instance.emailSent,
      'totalQty': instance.totalQty,
      'baseCurrencyCode': instance.baseCurrencyCode,
      'channelCurrencyCode': instance.channelCurrencyCode,
      'orderCurrencyCode': instance.orderCurrencyCode,
      'subTotal': instance.subTotal,
      'baseSubTotal': instance.baseSubTotal,
      'grandTotal': instance.grandTotal,
      'baseGrandTotal': instance.baseGrandTotal,
      'shippingAmount': instance.shippingAmount,
      'baseShippingAmount': instance.baseShippingAmount,
      'taxAmount': instance.taxAmount,
      'baseTaxAmount': instance.baseTaxAmount,
      'discountAmount': instance.discountAmount,
      'baseDiscountAmount': instance.baseDiscountAmount,
      'orderId': instance.orderId,
      'orderAddressId': instance.orderAddressId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'transactionId': instance.transactionId,
      'items': instance.items,
    };

InvoicesItems _$InvoicesItemsFromJson(Map<String, dynamic> json) =>
    InvoicesItems(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      description: json['description'],
      qty: json['qty'] as int?,
      price: json['price'] as int?,
      basePrice: json['basePrice'] as int?,
      total: json['total'] as int?,
      baseTotal: json['baseTotal'] as int?,
      taxAmount: json['taxAmount'] as int?,
      baseTaxAmount: json['baseTaxAmount'] as int?,
      productId: json['productId'] as String?,
      productType: json['productType'] as String?,
      orderItemId: json['orderItemId'] as String?,
      invoiceId: json['invoiceId'] as String?,
      parentId: json['parentId'],
      additional: json['additional'] as String?,
      discountPercent: json['discountPercent'] as int?,
      discountAmount: json['discountAmount'] as int?,
      baseDiscountAmount: json['baseDiscountAmount'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      orderItem: json['orderItem'] == null
          ? null
          : OrderItem.fromJson(json['orderItem'] as Map<String, dynamic>),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvoicesItemsToJson(InvoicesItems instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'qty': instance.qty,
      'price': instance.price,
      'basePrice': instance.basePrice,
      'total': instance.total,
      'baseTotal': instance.baseTotal,
      'taxAmount': instance.taxAmount,
      'baseTaxAmount': instance.baseTaxAmount,
      'productId': instance.productId,
      'productType': instance.productType,
      'orderItemId': instance.orderItemId,
      'invoiceId': instance.invoiceId,
      'parentId': instance.parentId,
      'additional': instance.additional,
      'discountPercent': instance.discountPercent,
      'discountAmount': instance.discountAmount,
      'baseDiscountAmount': instance.baseDiscountAmount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'orderItem': instance.orderItem,
      'product': instance.product,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      couponCode: json['couponCode'],
      weight: json['weight'] as int?,
      totalWeight: json['totalWeight'] as int?,
      qtyOrdered: json['qtyOrdered'] as int?,
      qtyShipped: json['qtyShipped'] as int?,
      qtyInvoiced: json['qtyInvoiced'] as int?,
      qtyCanceled: json['qtyCanceled'] as int?,
      qtyRefunded: json['qtyRefunded'] as int?,
      price: json['price'] as int?,
      basePrice: json['basePrice'] as int?,
      total: json['total'] as int?,
      baseTotal: json['baseTotal'] as int?,
      totalInvoiced: json['totalInvoiced'] as int?,
      baseTotalInvoiced: json['baseTotalInvoiced'] as int?,
      amountRefunded: json['amountRefunded'] as int?,
      baseAmountRefunded: json['baseAmountRefunded'] as int?,
      discountPercent: json['discountPercent'] as int?,
      discountAmount: json['discountAmount'] as int?,
      baseDiscountAmount: json['baseDiscountAmount'] as int?,
      discountInvoiced: json['discountInvoiced'] as int?,
      baseDiscountInvoiced: json['baseDiscountInvoiced'] as int?,
      discountRefunded: json['discountRefunded'] as int?,
      baseDiscountRefunded: json['baseDiscountRefunded'] as int?,
      taxPercent: json['taxPercent'] as int?,
      taxAmount: json['taxAmount'] as int?,
      baseTaxAmount: json['baseTaxAmount'] as int?,
      taxAmountInvoiced: json['taxAmountInvoiced'] as int?,
      baseTaxAmountInvoiced: json['baseTaxAmountInvoiced'] as int?,
      taxAmountRefunded: json['taxAmountRefunded'] as int?,
      baseTaxAmountRefunded: json['baseTaxAmountRefunded'] as int?,
      productId: json['productId'] as String?,
      productType: json['productType'] as String?,
      orderId: json['orderId'] as String?,
      parentId: json['parentId'],
      additional: json['additional'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'type': instance.type,
      'name': instance.name,
      'couponCode': instance.couponCode,
      'weight': instance.weight,
      'totalWeight': instance.totalWeight,
      'qtyOrdered': instance.qtyOrdered,
      'qtyShipped': instance.qtyShipped,
      'qtyInvoiced': instance.qtyInvoiced,
      'qtyCanceled': instance.qtyCanceled,
      'qtyRefunded': instance.qtyRefunded,
      'price': instance.price,
      'basePrice': instance.basePrice,
      'total': instance.total,
      'baseTotal': instance.baseTotal,
      'totalInvoiced': instance.totalInvoiced,
      'baseTotalInvoiced': instance.baseTotalInvoiced,
      'amountRefunded': instance.amountRefunded,
      'baseAmountRefunded': instance.baseAmountRefunded,
      'discountPercent': instance.discountPercent,
      'discountAmount': instance.discountAmount,
      'baseDiscountAmount': instance.baseDiscountAmount,
      'discountInvoiced': instance.discountInvoiced,
      'baseDiscountInvoiced': instance.baseDiscountInvoiced,
      'discountRefunded': instance.discountRefunded,
      'baseDiscountRefunded': instance.baseDiscountRefunded,
      'taxPercent': instance.taxPercent,
      'taxAmount': instance.taxAmount,
      'baseTaxAmount': instance.baseTaxAmount,
      'taxAmountInvoiced': instance.taxAmountInvoiced,
      'baseTaxAmountInvoiced': instance.baseTaxAmountInvoiced,
      'taxAmountRefunded': instance.taxAmountRefunded,
      'baseTaxAmountRefunded': instance.baseTaxAmountRefunded,
      'productId': instance.productId,
      'productType': instance.productType,
      'orderId': instance.orderId,
      'parentId': instance.parentId,
      'additional': instance.additional,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
