// Cart models matching Bagisto GraphQL schema.
// Derived from: nextjs-commerce/src/graphql/cart/mutations/

import 'dart:convert';

import '../../../../core/currency/currency_formatter.dart';
import '../../../../core/store_config/store_config.dart';
import '../../../checkout/data/models/checkout_model.dart';

class CartModel {
  final int id;
  final String? cartToken;
  final double subtotal;
  final String? formattedSubtotal;
  final double subTotalInclTax;
  final String? formattedSubTotalInclTax;
  final double taxAmount;
  final String? formattedTaxAmount;
  final double shippingAmount;
  final String? formattedShippingAmount;
  final double shippingAmountInclTax;
  final String? formattedShippingAmountInclTax;
  final double grandTotal;
  final String? formattedGrandTotal;
  final double discountAmount;
  final String? formattedDiscountAmount;
  final String? couponCode;
  final int itemsCount;
  final int itemsQty;
  final bool isGuest;
  final List<CartItemModel> items;
  final Map<String, String> appliedTaxes;

  const CartModel({
    required this.id,
    this.cartToken,
    this.subtotal = 0,
    this.formattedSubtotal,
    this.subTotalInclTax = 0,
    this.formattedSubTotalInclTax,
    this.taxAmount = 0,
    this.formattedTaxAmount,
    this.shippingAmount = 0,
    this.formattedShippingAmount,
    this.shippingAmountInclTax = 0,
    this.formattedShippingAmountInclTax,
    this.grandTotal = 0,
    this.formattedGrandTotal,
    this.discountAmount = 0,
    this.formattedDiscountAmount,
    this.couponCode,
    this.itemsCount = 0,
    this.itemsQty = 0,
    this.isGuest = true,
    this.items = const [],
    this.appliedTaxes = const {},
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: _parseInt(json['id']),
      cartToken: _read(json, 'cartToken', 'cart_token') as String?,
      subtotal: _parseDouble(_read(json, 'subtotal', 'sub_total')),
      formattedSubtotal:
          _read(json, 'formattedSubtotal', 'formatted_sub_total') as String?,
      subTotalInclTax: _parseDouble(
        _read(json, 'subTotalInclTax', 'sub_total_incl_tax'),
      ),
      formattedSubTotalInclTax:
          _read(
                json,
                'formattedSubTotalInclTax',
                'formatted_sub_total_incl_tax',
              )
              as String?,
      taxAmount: () {
        final taxTot = _parseDouble(_read(json, 'taxTotal', 'tax_total'));
        if (taxTot > 0) return taxTot;
        return _parseDouble(_read(json, 'taxAmount', 'tax_amount'));
      }(),
      formattedTaxAmount: () {
        final taxTot = _parseDouble(_read(json, 'taxTotal', 'tax_total'));
        final fmtTot =
            _read(json, 'formattedTaxTotal', 'formatted_tax_total') as String?;
        if (taxTot > 0 && fmtTot != null && fmtTot.isNotEmpty) return fmtTot;
        final fmtAmt =
            _read(json, 'formattedTaxAmount', 'formatted_tax_amount')
                as String?;
        return (taxTot > 0) ? (fmtTot ?? fmtAmt) : (fmtAmt ?? fmtTot);
      }(),
      shippingAmount: _parseDouble(
        _read(json, 'shippingAmount', 'shipping_amount'),
      ),
      formattedShippingAmount:
          _read(json, 'formattedShippingAmount', 'formatted_shipping_amount')
              as String?,
      shippingAmountInclTax: _parseDouble(
        _read(json, 'shippingAmountInclTax', 'shipping_amount_incl_tax'),
      ),
      formattedShippingAmountInclTax:
          _read(
                json,
                'formattedShippingAmountInclTax',
                'formatted_shipping_amount_incl_tax',
              )
              as String?,
      grandTotal: _parseDouble(_read(json, 'grandTotal', 'grand_total')),
      formattedGrandTotal:
          _read(json, 'formattedGrandTotal', 'formatted_grand_total')
              as String?,
      discountAmount: _parseDouble(
        _read(json, 'discountAmount', 'discount_amount'),
      ),
      formattedDiscountAmount:
          _read(json, 'formattedDiscountAmount', 'formatted_discount_amount')
              as String?,
      couponCode: _read(json, 'couponCode', 'coupon_code') as String?,
      itemsCount: _parseInt(_read(json, 'itemsCount', 'items_count')),
      itemsQty: _parseInt(_read(json, 'itemsQty', 'items_qty')),
      isGuest: _parseBool(_read(json, 'isGuest', 'is_guest')) ?? true,
      items: _parseItems(json['items']),
      appliedTaxes: _parseAppliedTaxes(
        _read(json, 'appliedTaxes', 'applied_taxes'),
      ),
    );
  }

  static Map<String, String> _parseAppliedTaxes(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val?.toString() ?? ''),
      );
    }
    return const {};
  }

  /// Empty cart
  static const CartModel empty = CartModel(id: 0);

  bool get isEmpty => items.isEmpty;

  bool get hasCoupon => couponCode != null && couponCode!.isNotEmpty;

  /// Whether tax is included in the subtotal / prices
  bool get hasTaxIncluded => subTotalInclTax > 0 && subTotalInclTax > subtotal;

  /// Whether the cart has applied taxes breakdown from the backend
  bool get hasAppliedTaxes => appliedTaxes.isNotEmpty;

  /// Whether the cart contains only virtual or downloadable products (no shipping needed)
  bool get isVirtualOnly =>
      items.isNotEmpty &&
      items.every(
        (item) => item.isVirtual || item.isDownloadable || item.isBooking,
      );

  /// Whether the cart has physical items that require shipping estimation
  bool get hasStockableItems => !isEmpty && !isVirtualOnly;

  CartModel copyWith({
    int? id,
    String? cartToken,
    double? subtotal,
    String? formattedSubtotal,
    double? subTotalInclTax,
    String? formattedSubTotalInclTax,
    double? taxAmount,
    String? formattedTaxAmount,
    double? shippingAmount,
    String? formattedShippingAmount,
    double? shippingAmountInclTax,
    String? formattedShippingAmountInclTax,
    double? grandTotal,
    String? formattedGrandTotal,
    double? discountAmount,
    String? formattedDiscountAmount,
    String? couponCode,
    int? itemsCount,
    int? itemsQty,
    bool? isGuest,
    List<CartItemModel>? items,
    Map<String, String>? appliedTaxes,
    bool clearCoupon = false,
  }) {
    return CartModel(
      id: id ?? this.id,
      cartToken: cartToken ?? this.cartToken,
      subtotal: subtotal ?? this.subtotal,
      formattedSubtotal: formattedSubtotal ?? this.formattedSubtotal,
      subTotalInclTax: subTotalInclTax ?? this.subTotalInclTax,
      formattedSubTotalInclTax:
          formattedSubTotalInclTax ?? this.formattedSubTotalInclTax,
      taxAmount: taxAmount ?? this.taxAmount,
      formattedTaxAmount: formattedTaxAmount ?? this.formattedTaxAmount,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      formattedShippingAmount:
          formattedShippingAmount ?? this.formattedShippingAmount,
      shippingAmountInclTax:
          shippingAmountInclTax ?? this.shippingAmountInclTax,
      formattedShippingAmountInclTax:
          formattedShippingAmountInclTax ?? this.formattedShippingAmountInclTax,
      grandTotal: grandTotal ?? this.grandTotal,
      formattedGrandTotal: formattedGrandTotal ?? this.formattedGrandTotal,
      discountAmount: discountAmount ?? this.discountAmount,
      formattedDiscountAmount:
          formattedDiscountAmount ?? this.formattedDiscountAmount,
      couponCode: clearCoupon ? null : (couponCode ?? this.couponCode),
      itemsCount: itemsCount ?? this.itemsCount,
      itemsQty: itemsQty ?? this.itemsQty,
      isGuest: isGuest ?? this.isGuest,
      items: items ?? this.items,
      appliedTaxes: appliedTaxes ?? this.appliedTaxes,
    );
  }

  static List<CartItemModel> _parseItems(dynamic json) {
    if (json == null) return [];
    if (json is Map<String, dynamic>) {
      final edges = json['edges'] as List<dynamic>?;
      if (edges == null) return [];
      return edges
          .map((e) => CartItemModel.fromJson(e['node'] as Map<String, dynamic>))
          .toList();
    }
    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map(CartItemModel.fromJson)
          .toList();
    }
    return [];
  }

  static dynamic _read(
    Map<String, dynamic> json,
    String camelKey,
    String snakeKey,
  ) {
    if (json.containsKey(camelKey)) return json[camelKey];
    return json[snakeKey];
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == '1' || normalized == 'true') return true;
      if (normalized == '0' || normalized == 'false') return false;
    }
    return null;
  }

  /// Generates the itemized breakdown for each applied tax rate, matching Web Cart Summary:
  /// e.g.
  /// tax-in (20%)
  ///   simple product                       $77.60 ($388.00)
  ///   Delivery Charges                      $2.40 ($12.00)
  List<CartTaxBreakdownLine> get taxBreakdownLines {
    if (!hasAppliedTaxes) return const [];

    final symbol = _extractCurrencySymbol();

    // Check if delivery charges have tax
    final shippingTax =
        (shippingAmountInclTax > 0 && shippingAmountInclTax > shippingAmount)
        ? (shippingAmountInclTax - shippingAmount)
        : 0.0;

    return appliedTaxes.entries.map((entry) {
      final rateName = entry.key;
      final rateTotal = entry.value;

      final breakdownItems = <CartTaxBreakdownItem>[];
      for (final item in items) {
        if (item.taxAmount > 0) {
          final taxable =
              item.formattedTotal ?? '$symbol${item.total.toStringAsFixed(2)}';
          breakdownItems.add(
            CartTaxBreakdownItem(
              name: item.name,
              taxAmount: '$symbol${item.taxAmount.toStringAsFixed(2)}',
              taxableAmount: taxable,
            ),
          );
        }
      }

      if (shippingTax > 0) {
        final shippingTaxable =
            formattedShippingAmount ??
            '$symbol${shippingAmount.toStringAsFixed(2)}';
        breakdownItems.add(
          CartTaxBreakdownItem(
            name: 'Delivery Charges',
            taxAmount: '$symbol${shippingTax.toStringAsFixed(2)}',
            taxableAmount: shippingTaxable,
          ),
        );
      }

      return CartTaxBreakdownLine(
        rateName: rateName,
        rateTotal: rateTotal,
        items: breakdownItems,
      );
    }).toList();
  }

  String _extractCurrencySymbol() {
    final sample = formattedGrandTotal ?? formattedSubtotal ?? '';
    final match = RegExp(r'^([^\d\s]+)').firstMatch(sample.trim());
    return match != null ? match.group(1)! : '\$';
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

/// Itemized breakdown line for an applied tax rate (matches Web cart summary)
class CartTaxBreakdownLine {
  final String rateName;
  final String rateTotal;
  final List<CartTaxBreakdownItem> items;

  const CartTaxBreakdownLine({
    required this.rateName,
    required this.rateTotal,
    required this.items,
  });
}

/// Item within an applied tax rate breakdown (matches Web cart summary)
class CartTaxBreakdownItem {
  final String name;
  final String taxAmount;
  final String taxableAmount;

  const CartTaxBreakdownItem({
    required this.name,
    required this.taxAmount,
    required this.taxableAmount,
  });
}

class CartItemModel {
  final int id;
  final int cartId;
  final int productId;
  final String name;
  final double price;
  final String? formattedPrice;
  final double priceInclTax;
  final String? formattedPriceInclTax;
  final double total;
  final String? formattedTotal;
  final double totalInclTax;
  final String? formattedTotalInclTax;
  final double taxAmount;
  final String? baseImage; // JSON string with image URLs
  final String? sku;
  final int quantity;
  final String? type;
  final String? productUrlKey;
  final bool canChangeQty;
  final List<String> options;

  const CartItemModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.name,
    required this.price,
    this.formattedPrice,
    this.priceInclTax = 0,
    this.formattedPriceInclTax,
    this.total = 0,
    this.formattedTotal,
    this.totalInclTax = 0,
    this.formattedTotalInclTax,
    this.taxAmount = 0,
    this.baseImage,
    this.sku,
    required this.quantity,
    this.type,
    this.productUrlKey,
    this.canChangeQty = true,
    this.options = const [],
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final baseImageValue = CartModel._read(json, 'baseImage', 'base_image');
    return CartItemModel(
      id: CartModel._parseInt(json['id']),
      cartId: CartModel._parseInt(CartModel._read(json, 'cartId', 'cart_id')),
      productId: CartModel._parseInt(
        CartModel._read(json, 'productId', 'product_id'),
      ),
      name: json['name'] as String? ?? '',
      price: CartModel._parseDouble(json['price']),
      formattedPrice:
          CartModel._read(json, 'formattedPrice', 'formatted_price') as String?,
      priceInclTax: CartModel._parseDouble(
        CartModel._read(json, 'priceInclTax', 'price_incl_tax'),
      ),
      formattedPriceInclTax:
          CartModel._read(
                json,
                'formattedPriceInclTax',
                'formatted_price_incl_tax',
              )
              as String?,
      total: CartModel._parseDouble(json['total']),
      formattedTotal:
          CartModel._read(json, 'formattedTotal', 'formatted_total') as String?,
      totalInclTax: CartModel._parseDouble(
        CartModel._read(json, 'totalInclTax', 'total_incl_tax'),
      ),
      formattedTotalInclTax:
          CartModel._read(
                json,
                'formattedTotalInclTax',
                'formatted_total_incl_tax',
              )
              as String?,
      taxAmount: CartModel._parseDouble(
        CartModel._read(json, 'taxAmount', 'tax_amount'),
      ),
      baseImage: baseImageValue is String
          ? baseImageValue
          : (baseImageValue == null ? null : jsonEncode(baseImageValue)),
      sku: json['sku'] as String?,
      quantity: CartModel._parseInt(json['quantity']),
      type: json['type'] as String?,
      productUrlKey:
          CartModel._read(json, 'productUrlKey', 'product_url_key') as String?,
      canChangeQty:
          CartModel._parseBool(
            CartModel._read(json, 'canChangeQty', 'can_change_qty'),
          ) ??
          true,
      options: _parseOptions(json['options']),
    );
  }

  /// Parse image URL from baseImage JSON string
  String? get imageUrl {
    if (baseImage == null || baseImage!.isEmpty) return null;
    try {
      final map = jsonDecode(baseImage!) as Map<String, dynamic>;
      return (map['medium_image_url'] ??
              map['small_image_url'] ??
              map['original_image_url'])
          as String?;
    } catch (_) {
      return null;
    }
  }

  /// Total price for this item (price * quantity)
  double get totalPrice => price * quantity;

  String get displayPrice =>
      formattedPrice ?? CurrencyFormatter.formatAmount(price);

  String get displayTotal =>
      formattedTotal ??
      CurrencyFormatter.formatAmount(total > 0 ? total : totalPrice);

  String get displayPriceInclTax =>
      formattedPriceInclTax ??
      CurrencyFormatter.formatAmount(priceInclTax > 0 ? priceInclTax : price);

  String get displayTotalInclTax =>
      formattedTotalInclTax ??
      CurrencyFormatter.formatAmount(
        totalInclTax > 0
            ? totalInclTax
            : (priceInclTax > 0 ? priceInclTax * quantity : totalPrice),
      );

  /// Unit price formatted according to StoreConfig taxCartDisplayPrices
  String formattedUnitPrice(StoreConfig config) {
    if (config.showItemPriceInclTax && priceInclTax > 0) {
      return displayPriceInclTax;
    }
    return displayPrice;
  }

  /// Optional subtitle for unit price when StoreConfig taxCartDisplayPrices is 'both'
  String? formattedUnitPriceSubValue(
    StoreConfig config,
    String Function(String) exclTaxFormatter,
  ) {
    if (config.showItemPriceBoth &&
        priceInclTax > 0 &&
        (priceInclTax - price).abs() > 0.001) {
      return exclTaxFormatter(displayPrice);
    }
    return null;
  }

  /// Line total formatted according to StoreConfig taxCartDisplayPrices
  String formattedLineTotal(StoreConfig config) {
    if (config.showItemPriceInclTax && totalInclTax > 0) {
      return displayTotalInclTax;
    }
    return displayTotal;
  }

  /// Optional subtitle for line total when StoreConfig taxCartDisplayPrices is 'both'
  String? formattedLineTotalSubValue(
    StoreConfig config,
    String Function(String) exclTaxFormatter,
  ) {
    if (config.showItemPriceBoth &&
        totalInclTax > 0 &&
        (totalInclTax - total).abs() > 0.001) {
      return exclTaxFormatter(displayTotal);
    }
    return null;
  }

  /// Whether this is a virtual product
  bool get isVirtual => type == 'virtual';

  /// Whether this is a downloadable product
  bool get isDownloadable => type == 'downloadable';

  /// Whether this is a booking product
  bool get isBooking => type == 'booking';

  static List<String> _parseOptions(dynamic value) {
    final lines = _extractOptions(value);
    return lines
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toSet()
        .toList();
  }

  static List<String> _extractOptions(dynamic value) {
    if (value == null) return const [];

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return const [];
      try {
        return _extractOptions(jsonDecode(trimmed));
      } catch (_) {
        return <String>[trimmed];
      }
    }

    if (value is List) {
      return value.expand(_extractOptions).toList();
    }

    if (value is Map) {
      // Try label + value pattern (e.g. {"label": "Color", "value": "Blue"})
      final label = value['label']?.toString().trim();
      final rawOptionValue =
          value['value'] ?? value['optionValue'] ?? value['option_value'];
      final formattedValue = _formatOptionValue(rawOptionValue);

      if ((label ?? '').isNotEmpty && formattedValue.isNotEmpty) {
        return <String>['${label!} : $formattedValue'];
      }

      // Try attributeName + optionLabel pattern
      // (e.g. {"attributeName": "Booking From", "optionLabel": "28th Mar, 2026"})
      final attrName =
          (value['attributeName'] ??
                  value['attribute_name'] ??
                  value['attributename'])
              ?.toString()
              .trim();
      final optLabel =
          (value['optionLabel'] ??
                  value['option_label'] ??
                  value['optionlabel'])
              ?.toString()
              .trim();

      if ((attrName ?? '').isNotEmpty && (optLabel ?? '').isNotEmpty) {
        return <String>['$attrName : $optLabel'];
      }

      final lines = <String>[];
      value.forEach((key, entryValue) {
        final k = '$key';
        // Skip internal/meta keys
        if (k == '__typename' ||
            k == 'optionId' ||
            k == 'option_id' ||
            k == 'optionid' ||
            k == 'id') {
          return;
        }

        final entryFormatted = _formatOptionValue(entryValue);
        if (entryFormatted.isNotEmpty &&
            entryValue is! Map &&
            entryValue is! List &&
            k != 'label') {
          lines.add('${_normalizeOptionLabel(k)} : $entryFormatted');
        } else {
          lines.addAll(_extractOptions(entryValue));
        }
      });
      return lines;
    }

    return <String>[value.toString()];
  }

  static String _formatOptionValue(dynamic value) {
    if (value == null) return '';

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return '';
      try {
        final decoded = jsonDecode(trimmed);
        return _formatOptionValue(decoded);
      } catch (_) {
        return trimmed;
      }
    }

    if (value is List) {
      return value
          .map(_formatOptionValue)
          .where((entry) => entry.isNotEmpty)
          .join(', ');
    }

    if (value is Map) {
      if (value.containsKey('label') && value.containsKey('value')) {
        return _formatOptionValue(value['value']);
      }

      final pieces = <String>[];
      value.forEach((key, entryValue) {
        if ('$key' == '__typename') return;
        final entryFormatted = _formatOptionValue(entryValue);
        if (entryFormatted.isEmpty) return;
        if (entryValue is Map || entryValue is List) {
          pieces.add(entryFormatted);
        } else {
          pieces.add('${_normalizeOptionLabel('$key')}: $entryFormatted');
        }
      });
      return pieces.join(', ');
    }

    return value.toString();
  }

  static String _normalizeOptionLabel(String raw) {
    return raw
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .trim();
  }
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

/// Result of createEstimateShipping mutation containing updated cart and shipping rates.
class EstimateShippingResult {
  final CartModel cart;
  final List<ShippingRate> shippingMethods;
  final String? selectedShippingRate;

  const EstimateShippingResult({
    required this.cart,
    this.shippingMethods = const [],
    this.selectedShippingRate,
  });
}
