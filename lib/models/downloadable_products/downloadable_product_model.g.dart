// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloadable_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadableProductModel _$DownloadableProductModelFromJson(
        Map<String, dynamic> json) =>
    DownloadableProductModel(
      downloadableLinkPurchases: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              DownloadableLinkPurchases.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$DownloadableProductModelToJson(
        DownloadableProductModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.downloadableLinkPurchases,
    };

DownloadableLinkPurchases _$DownloadableLinkPurchasesFromJson(
        Map<String, dynamic> json) =>
    DownloadableLinkPurchases(
      id: json['id'] as String?,
      productName: json['productName'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      file: json['file'] as String?,
      fileName: json['fileName'] as String?,
      type: json['type'] as String?,
      downloadBought: json['downloadBought'] as int?,
      downloadUsed: json['downloadUsed'] as int?,
      status: json['status'] as bool?,
      customerId: json['customerId'] as String?,
      orderId: json['orderId'] as String?,
      orderItemId: json['orderItemId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      order: json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>),
      orderItem: json['orderItem'] == null
          ? null
          : OrderItem.fromJson(json['orderItem'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DownloadableLinkPurchasesToJson(
        DownloadableLinkPurchases instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'name': instance.name,
      'url': instance.url,
      'file': instance.file,
      'fileName': instance.fileName,
      'type': instance.type,
      'downloadBought': instance.downloadBought,
      'downloadUsed': instance.downloadUsed,
      'status': instance.status,
      'customerId': instance.customerId,
      'orderId': instance.orderId,
      'orderItemId': instance.orderItemId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'customer': instance.customer,
      'order': instance.order,
      'orderItem': instance.orderItem,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      name: json['name'] as String?,
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      email: json['email'] as String?,
      phone: json['phone'],
      password: json['password'] as String?,
      apiToken: json['apiToken'] as String?,
      customerGroupId: json['customerGroupId'] as int?,
      subscribedToNewsLetter: json['subscribedToNewsLetter'] as bool?,
      isVerified: json['isVerified'] as bool?,
      token: json['token'] as String?,
      notes: json['notes'],
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'apiToken': instance.apiToken,
      'customerGroupId': instance.customerGroupId,
      'subscribedToNewsLetter': instance.subscribedToNewsLetter,
      'isVerified': instance.isVerified,
      'token': instance.token,
      'notes': instance.notes,
      'status': instance.status,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int?,
      incrementId: json['incrementId'] as String?,
      status: json['status'] as String?,
      channelName: json['channelName'] as String?,
      isGuest: json['isGuest'] as int?,
      customerEmail: json['customerEmail'] as String?,
      customerFirstName: json['customerFirstName'] as String?,
      customerLastName: json['customerLastName'] as String?,
      customerCompanyName: json['customerCompanyName'],
      customerVatId: json['customerVatId'],
      shippingMethod: json['shippingMethod'],
      shippingTitle: json['shippingTitle'],
      shippingDescription: json['shippingDescription'],
      couponCode: json['couponCode'],
      isGift: json['isGift'] as int?,
      totalItemCount: json['totalItemCount'] as int?,
      totalQtyOrdered: json['totalQtyOrdered'] as int?,
      baseCurrencyCode: json['baseCurrencyCode'] as String?,
      channelCurrencyCode: json['channelCurrencyCode'] as String?,
      orderCurrencyCode: json['orderCurrencyCode'] as String?,
      grandTotal: json['grandTotal'] as int?,
      baseGrandTotal: json['baseGrandTotal'] as int?,
      grandTotalInvoiced: json['grandTotalInvoiced'] as int?,
      baseGrandTotalInvoiced: json['baseGrandTotalInvoiced'] as int?,
      grandTotalRefunded: json['grandTotalRefunded'] as int?,
      baseGrandTotalRefunded: json['baseGrandTotalRefunded'] as int?,
      subTotal: json['subTotal'] as int?,
      baseSubTotal: json['baseSubTotal'] as int?,
      subTotalInvoiced: json['subTotalInvoiced'] as int?,
      baseSubTotalInvoiced: json['baseSubTotalInvoiced'] as int?,
      subTotalRefunded: json['subTotalRefunded'] as int?,
      baseSubTotalRefunded: json['baseSubTotalRefunded'] as int?,
      discountPercent: json['discountPercent'] as int?,
      discountAmount: json['discountAmount'] as int?,
      baseDiscountAmount: json['baseDiscountAmount'] as int?,
      discountInvoiced: json['discountInvoiced'] as int?,
      baseDiscountInvoiced: json['baseDiscountInvoiced'] as int?,
      discountRefunded: json['discountRefunded'] as int?,
      baseDiscountRefunded: json['baseDiscountRefunded'] as int?,
      taxAmount: json['taxAmount'] as int?,
      baseTaxAmount: json['baseTaxAmount'] as int?,
      taxAmountInvoiced: json['taxAmountInvoiced'] as int?,
      baseTaxAmountInvoiced: json['baseTaxAmountInvoiced'] as int?,
      taxAmountRefunded: json['taxAmountRefunded'] as int?,
      baseTaxAmountRefunded: json['baseTaxAmountRefunded'] as int?,
      shippingAmount: json['shippingAmount'] as int?,
      baseShippingAmount: json['baseShippingAmount'] as int?,
      shippingInvoiced: json['shippingInvoiced'] as int?,
      baseShippingInvoiced: json['baseShippingInvoiced'] as int?,
      shippingRefunded: json['shippingRefunded'] as int?,
      baseShippingRefunded: json['baseShippingRefunded'] as int?,
      customerId: json['customerId'] as int?,
      customerType: json['customerType'] as String?,
      channelId: json['channelId'] as int?,
      channelType: json['channelType'] as String?,
      cartId: json['cartId'] as String?,
      appliedCartRuleIds: json['appliedCartRuleIds'] as String?,
      shippingDiscountAmount: json['shippingDiscountAmount'] as int?,
      baseShippingDiscountAmount: json['baseShippingDiscountAmount'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'incrementId': instance.incrementId,
      'status': instance.status,
      'channelName': instance.channelName,
      'isGuest': instance.isGuest,
      'customerEmail': instance.customerEmail,
      'customerFirstName': instance.customerFirstName,
      'customerLastName': instance.customerLastName,
      'customerCompanyName': instance.customerCompanyName,
      'customerVatId': instance.customerVatId,
      'shippingMethod': instance.shippingMethod,
      'shippingTitle': instance.shippingTitle,
      'shippingDescription': instance.shippingDescription,
      'couponCode': instance.couponCode,
      'isGift': instance.isGift,
      'totalItemCount': instance.totalItemCount,
      'totalQtyOrdered': instance.totalQtyOrdered,
      'baseCurrencyCode': instance.baseCurrencyCode,
      'channelCurrencyCode': instance.channelCurrencyCode,
      'orderCurrencyCode': instance.orderCurrencyCode,
      'grandTotal': instance.grandTotal,
      'baseGrandTotal': instance.baseGrandTotal,
      'grandTotalInvoiced': instance.grandTotalInvoiced,
      'baseGrandTotalInvoiced': instance.baseGrandTotalInvoiced,
      'grandTotalRefunded': instance.grandTotalRefunded,
      'baseGrandTotalRefunded': instance.baseGrandTotalRefunded,
      'subTotal': instance.subTotal,
      'baseSubTotal': instance.baseSubTotal,
      'subTotalInvoiced': instance.subTotalInvoiced,
      'baseSubTotalInvoiced': instance.baseSubTotalInvoiced,
      'subTotalRefunded': instance.subTotalRefunded,
      'baseSubTotalRefunded': instance.baseSubTotalRefunded,
      'discountPercent': instance.discountPercent,
      'discountAmount': instance.discountAmount,
      'baseDiscountAmount': instance.baseDiscountAmount,
      'discountInvoiced': instance.discountInvoiced,
      'baseDiscountInvoiced': instance.baseDiscountInvoiced,
      'discountRefunded': instance.discountRefunded,
      'baseDiscountRefunded': instance.baseDiscountRefunded,
      'taxAmount': instance.taxAmount,
      'baseTaxAmount': instance.baseTaxAmount,
      'taxAmountInvoiced': instance.taxAmountInvoiced,
      'baseTaxAmountInvoiced': instance.baseTaxAmountInvoiced,
      'taxAmountRefunded': instance.taxAmountRefunded,
      'baseTaxAmountRefunded': instance.baseTaxAmountRefunded,
      'shippingAmount': instance.shippingAmount,
      'baseShippingAmount': instance.baseShippingAmount,
      'shippingInvoiced': instance.shippingInvoiced,
      'baseShippingInvoiced': instance.baseShippingInvoiced,
      'shippingRefunded': instance.shippingRefunded,
      'baseShippingRefunded': instance.baseShippingRefunded,
      'customerId': instance.customerId,
      'customerType': instance.customerType,
      'channelId': instance.channelId,
      'channelType': instance.channelType,
      'cartId': instance.cartId,
      'appliedCartRuleIds': instance.appliedCartRuleIds,
      'shippingDiscountAmount': instance.shippingDiscountAmount,
      'baseShippingDiscountAmount': instance.baseShippingDiscountAmount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
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
    };
