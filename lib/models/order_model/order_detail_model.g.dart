// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailModel _$OrderDetailModelFromJson(Map<String, dynamic> json) =>
    OrderDetailModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as String?
      ..status = json['status'] as bool?
      ..message = json['message'] as String?
      ..cartCount = json['cartCount'] as int?
      ..error = json['error'];

Map<String, dynamic> _$OrderDetailModelToJson(OrderDetailModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'cartCount': instance.cartCount,
      'error': instance.error,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      orderDetail: json['orderDetail'] == null
          ? null
          : OrderDetail.fromJson(json['orderDetail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'orderDetail': instance.orderDetail,
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
      id: json['id'] as int?,
      incrementId: json['incrementId'] as String?,
      channelName: json['channelName'] as String?,
      isGuest: json['isGuest'] as int?,
      customerEmail: json['customerEmail'] as String?,
      customerFirstName: json['customerFirstName'] as String?,
      customerLastName: json['customerLastName'] as String?,
      customerCompanyName: json['customerCompanyName'] as String?,
      customerVatId: json['customerVatId'] as String?,
      shippingMethod: json['shippingMethod'] as String?,
      shippingTitle: json['shippingTitle'] as String?,
      shippingDescription: json['shippingDescription'] as String?,
      couponCode: json['couponCode'] as String?,
      isGift: json['isGift'] as int?,
      totalItemCount: json['totalItemCount'] as int?,
      totalQtyOrdered: json['totalQtyOrdered'] as int?,
      baseCurrencyCode: json['baseCurrencyCode'] as String?,
      channelCurrencyCode: json['channelCurrencyCode'] as String?,
      orderCurrencyCode: json['orderCurrencyCode'] as String?,
      grandTotal: json['grandTotal'],
      baseGrandTotal: json['baseGrandTotal'],
      grandTotalInvoiced: json['grandTotalInvoiced'],
      baseGrandTotalInvoiced: json['baseGrandTotalInvoiced'],
      grandTotalRefunded: json['grandTotalRefunded'],
      baseGrandTotalRefunded: json['baseGrandTotalRefunded'],
      subTotal: json['subTotal'],
      baseSubTotal: json['baseSubTotal'],
      subTotalInvoiced: json['subTotalInvoiced'],
      baseSubTotalInvoiced: json['baseSubTotalInvoiced'],
      subTotalRefunded: json['subTotalRefunded'],
      baseSubTotalRefunded: json['baseSubTotalRefunded'],
      discountPercent: json['discountPercent'],
      discountAmount: json['discountAmount'],
      baseDiscountAmount: json['baseDiscountAmount'],
      discountInvoiced: json['discountInvoiced'],
      baseDiscountInvoiced: json['baseDiscountInvoiced'],
      discountRefunded: json['discountRefunded'],
      baseDiscountRefunded: json['baseDiscountRefunded'],
      taxAmount: json['taxAmount'],
      baseTaxAmount: json['baseTaxAmount'],
      taxAmountInvoiced: json['taxAmountInvoiced'],
      baseTaxAmountInvoiced: json['baseTaxAmountInvoiced'],
      taxAmountRefunded: json['taxAmountRefunded'],
      baseTaxAmountRefunded: json['baseTaxAmountRefunded'],
      shippingAmount: json['shippingAmount'],
      baseShippingAmount: json['baseShippingAmount'],
      shippingInvoiced: json['shippingInvoiced'],
      baseShippingInvoiced: json['baseShippingInvoiced'],
      shippingRefunded: json['shippingRefunded'],
      baseShippingRefunded: json['baseShippingRefunded'],
      customerId: json['customerId'],
      customerType: json['customerType'] as String?,
      channelId: json['channelId'] as int?,
      channelType: json['channelType'] as String?,
      cartId: json['cartId'] as String?,
      appliedCartRuleIds: json['appliedCartRuleIds'] as String?,
      shippingDiscountAmount: json['shippingDiscountAmount'] as int?,
      baseShippingDiscountAmount: json['baseShippingDiscountAmount'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      billingAddress: json['billingAddress'] == null
          ? null
          : BillingAddress.fromJson(
              json['billingAddress'] as Map<String, dynamic>),
      shippingAddress: json['shippingAddress'] == null
          ? null
          : BillingAddress.fromJson(
              json['shippingAddress'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList(),
      payment: json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
      formattedPrice: json['formattedPrice'] == null
          ? null
          : FormattedPrice.fromJson(
              json['formattedPrice'] as Map<String, dynamic>),
      status: json['status'] as String?,
      shipments: json['shipments'] as List<dynamic>?,
      invoices: json['invoices'] as List<dynamic>?,
      refunds: json['refunds'] as List<dynamic>?,
    )
      ..success = json['success'] as String?
      ..responseStatus = json['responseStatus'] as bool?;

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'success': instance.success,
      'responseStatus': instance.responseStatus,
      'formattedPrice': instance.formattedPrice,
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
      'billingAddress': instance.billingAddress,
      'shippingAddress': instance.shippingAddress,
      'items': instance.items,
      'payment': instance.payment,
      'shipments': instance.shipments,
      'invoices': instance.invoices,
      'refunds': instance.refunds,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as String?,
      method: json['method'] as String?,
      methodTitle: json['methodTitle'] as String?,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'methodTitle': instance.methodTitle,
    };

BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) =>
    BillingAddress(
      id: json['id'] as int?,
      customerId: json['customerId'] as String?,
      cartId: json['cartId'] as String?,
      orderId: json['orderId'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      companyName: json['companyName'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      postcode: json['postcode'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      vatId: json['vatId'] as String?,
      defaultAddress: json['defaultAddress'] as int?,
    );

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'cartId': instance.cartId,
      'orderId': instance.orderId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'companyName': instance.companyName,
      'address1': instance.address1,
      'address2': instance.address2,
      'postcode': instance.postcode,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'email': instance.email,
      'phone': instance.phone,
      'vatId': instance.vatId,
      'defaultAddress': instance.defaultAddress,
    };

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      quantity: json['quantity'] as int?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      couponCode: json['couponCode'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      totalWeight: (json['totalWeight'] as num?)?.toDouble(),
      qtyOrdered: json['qtyOrdered'] as int?,
      qtyShipped: json['qtyShipped'] as int?,
      qtyInvoiced: json['qtyInvoiced'] as int?,
      qtyCanceled: json['qtyCanceled'] as int?,
      qtyRefunded: json['qtyRefunded'] as int?,
      price: json['price'],
      basePrice: json['basePrice'],
      total: json['total'],
      baseTotal: json['baseTotal'],
      totalInvoiced: json['totalInvoiced'],
      baseTotalInvoiced: json['baseTotalInvoiced'],
      amountRefunded: json['amountRefunded'],
      baseAmountRefunded: json['baseAmountRefunded'],
      discountPercent: json['discountPercent'],
      discountAmount: json['discountAmount'],
      baseDiscountAmount: json['baseDiscountAmount'],
      discountInvoiced: json['discountInvoiced'],
      baseDiscountInvoiced: json['baseDiscountInvoiced'],
      discountRefunded: json['discountRefunded'],
      baseDiscountRefunded: json['baseDiscountRefunded'],
      taxPercent: json['taxPercent'],
      taxAmount: json['taxAmount'],
      baseTaxAmount: json['baseTaxAmount'],
      taxAmountInvoiced: json['taxAmountInvoiced'],
      baseTaxAmountInvoiced: json['baseTaxAmountInvoiced'],
      taxAmountRefunded: json['taxAmountRefunded'],
      baseTaxAmountRefunded: json['baseTaxAmountRefunded'],
      productId: json['productId'] as String?,
      productType: json['productType'] as String?,
      orderId: json['orderId'] as String?,
      parentId: json['parentId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    )..formattedPrice = json['formattedPrice'] == null
        ? null
        : FormattedPrice.fromJson(
            json['formattedPrice'] as Map<String, dynamic>);

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
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
      'quantity': instance.quantity,
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
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'product': instance.product,
      'formattedPrice': instance.formattedPrice,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      attributeFamilyId: json['attributeFamilyId'],
      sku: json['sku'] as String?,
      parentId: json['parentId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      productFlats: (json['productFlats'] as List<dynamic>?)
          ?.map((e) => ProductFlats.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..images = (json['images'] as List<dynamic>?)
        ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributeFamilyId': instance.attributeFamilyId,
      'sku': instance.sku,
      'name': instance.name,
      'parentId': instance.parentId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'images': instance.images,
      'productFlats': instance.productFlats,
    };

Child _$ChildFromJson(Map<String, dynamic> json) => Child(
      id: json['id'] as String?,
      sku: json['sku'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      couponCode: json['couponCode'] as String?,
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
    );

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
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
    };
