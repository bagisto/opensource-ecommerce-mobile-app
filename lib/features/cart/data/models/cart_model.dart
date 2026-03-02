/// Cart models matching Bagisto GraphQL schema
/// Derived from: nextjs-commerce/src/graphql/cart/mutations/
import 'dart:convert';

class CartModel {
  final int id;
  final String? cartToken;
  final double subtotal;
  final double taxAmount;
  final double shippingAmount;
  final double grandTotal;
  final double discountAmount;
  final String? couponCode;
  final int itemsCount;
  final int itemsQty;
  final bool isGuest;
  final List<CartItemModel> items;

  const CartModel({
    required this.id,
    this.cartToken,
    this.subtotal = 0,
    this.taxAmount = 0,
    this.shippingAmount = 0,
    this.grandTotal = 0,
    this.discountAmount = 0,
    this.couponCode,
    this.itemsCount = 0,
    this.itemsQty = 0,
    this.isGuest = true,
    this.items = const [],
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: _parseInt(json['id']),
      cartToken: json['cartToken'] as String?,
      subtotal: _parseDouble(json['subtotal']),
      taxAmount: _parseDouble(json['taxAmount']),
      shippingAmount: _parseDouble(json['shippingAmount']),
      grandTotal: _parseDouble(json['grandTotal']),
      discountAmount: _parseDouble(json['discountAmount']),
      couponCode: json['couponCode'] as String?,
      itemsCount: _parseInt(json['itemsCount']),
      itemsQty: _parseInt(json['itemsQty']),
      isGuest: json['isGuest'] as bool? ?? true,
      items: _parseItems(json['items']),
    );
  }

  /// Empty cart
  static const CartModel empty = CartModel(id: 0);

  bool get isEmpty => items.isEmpty;

  bool get hasCoupon => couponCode != null && couponCode!.isNotEmpty;

  CartModel copyWith({
    int? id,
    String? cartToken,
    double? subtotal,
    double? taxAmount,
    double? shippingAmount,
    double? grandTotal,
    double? discountAmount,
    String? couponCode,
    int? itemsCount,
    int? itemsQty,
    bool? isGuest,
    List<CartItemModel>? items,
    bool clearCoupon = false,
  }) {
    return CartModel(
      id: id ?? this.id,
      cartToken: cartToken ?? this.cartToken,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      discountAmount: discountAmount ?? this.discountAmount,
      couponCode: clearCoupon ? null : (couponCode ?? this.couponCode),
      itemsCount: itemsCount ?? this.itemsCount,
      itemsQty: itemsQty ?? this.itemsQty,
      isGuest: isGuest ?? this.isGuest,
      items: items ?? this.items,
    );
  }

  static List<CartItemModel> _parseItems(dynamic json) {
    if (json == null) return [];
    final edges = json['edges'] as List<dynamic>?;
    if (edges == null) return [];
    return edges
        .map((e) => CartItemModel.fromJson(e['node'] as Map<String, dynamic>))
        .toList();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}

class CartItemModel {
  final int id;
  final int cartId;
  final int productId;
  final String name;
  final double price;
  final String? baseImage; // JSON string with image URLs
  final String? sku;
  final int quantity;
  final String? type;
  final String? productUrlKey;
  final bool canChangeQty;

  const CartItemModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.name,
    required this.price,
    this.baseImage,
    this.sku,
    required this.quantity,
    this.type,
    this.productUrlKey,
    this.canChangeQty = true,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: CartModel._parseInt(json['id']),
      cartId: CartModel._parseInt(json['cartId']),
      productId: CartModel._parseInt(json['productId']),
      name: json['name'] as String? ?? '',
      price: CartModel._parseDouble(json['price']),
      baseImage: json['baseImage'] as String?,
      sku: json['sku'] as String?,
      quantity: CartModel._parseInt(json['quantity']),
      type: json['type'] as String?,
      productUrlKey: json['productUrlKey'] as String?,
      canChangeQty: json['canChangeQty'] as bool? ?? true,
    );
  }

  /// Parse image URL from baseImage JSON string
  String? get imageUrl {
    if (baseImage == null || baseImage!.isEmpty) return null;
    try {
      final map = jsonDecode(baseImage!) as Map<String, dynamic>;
      return (map['medium_image_url'] ??
              map['small_image_url'] ??
              map['original_image_url']) as String?;
    } catch (_) {
      return null;
    }
  }

  /// Total price for this item (price * quantity)
  double get totalPrice => price * quantity;
}

/// Response from createCartToken
class CartTokenResponse {
  final int id;
  final String cartToken;
  final String? sessionToken;
  final bool isGuest;
  final bool success;
  final String? message;

  const CartTokenResponse({
    required this.id,
    required this.cartToken,
    this.sessionToken,
    this.isGuest = true,
    this.success = false,
    this.message,
  });

  factory CartTokenResponse.fromJson(Map<String, dynamic> json) {
    return CartTokenResponse(
      id: CartModel._parseInt(json['id']),
      cartToken: json['cartToken'] as String? ?? '',
      sessionToken: json['sessionToken'] as String?,
      isGuest: json['isGuest'] as bool? ?? true,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
