
import 'package:json_annotation/json_annotation.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../product_screen/data_model/product_details_model.dart';
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
  dynamic grandTotal;
  dynamic baseGrandTotal;
  dynamic subTotal;
  dynamic baseSubTotal;
  dynamic taxTotal;
  dynamic baseTaxTotal;
  dynamic discountAmount;
  dynamic baseDiscountAmount;
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
  String? checkoutMethod;
  dynamic conversionTime;


  CartModel({this.items,this.id, this.customerEmail, this.customerFirstName, this.customerLastName, this.shippingMethod,
    this.couponCode, this.isGift, this.itemsCount, this.itemsQty, this.exchangeRate, this.globalCurrencyCode,
    this.baseCurrencyCode, this.channelCurrencyCode, this.cartCurrencyCode, this.grandTotal, this.baseGrandTotal,
    this.subTotal, this.baseSubTotal, this.taxTotal, this.baseTaxTotal, this.discountAmount,
    this.baseDiscountAmount, this.isGuest, this.isActive,  this.customerId, this.channelId, this.appliedCartRuleIds, this.createdAt, this.updatedAt,this.formattedPrice,this.shippingAddress,
    this.billingAddress,this.selectedShippingRate,this.payment, this.checkoutMethod, this.conversionTime});

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
  dynamic price;
  dynamic basePrice;
  dynamic  total;
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
  Additional? additional;
  String? createdAt;
  String? updatedAt;
  Product? product;
  FormattedPrice? formattedPrice;
  String? urlKey;

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
    this.additional,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.urlKey, this.formattedPrice
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
  dynamic weight;
  dynamic totalWeight;
  dynamic baseTotalWeight;
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
  dynamic taxTotal;
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
      this.baseDiscount, this.adjustmentFee, this.baseAdjustmentFee, this.adjustmentRefund, this.amountRefunded,
      this.baseAmountRefunded, this.basePrice, this.baseTotalInvoiced, this.discountPercent, this.taxPercent, this.totalInvoiced);


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
  String? id;
  String? code;
  String? label;
  String? swatchType;
  String? swatchValue;
  String? type;
  List<Options>? options;


  Attributes({this.optionId,this.optionLabel,this.attributeCode,this.attributeName, this.id, this.options, this.type,
  this.code, this.label, this.swatchType, this.swatchValue});
  factory Attributes.fromJson(Map<String, dynamic> json) {
    return _$AttributesFromJson(json);
  }
  Map<String, dynamic> toJson() => _$AttributesToJson(this);

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


