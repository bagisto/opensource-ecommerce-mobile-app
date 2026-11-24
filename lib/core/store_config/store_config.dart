import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'store_config_cubit.dart';

/// Public store settings of the current channel (`storeConfig` query).
///
/// Every flag is nullable: `null` means the API has not answered (yet), and
/// the feature keeps working as before. Only a value returned by the API
/// switches a feature off or on.
class StoreConfig extends Equatable {
  final bool? wishlistEnabled;
  final bool? compareEnabled;
  final bool? imageSearchEnabled;
  final bool? socialShareEnabled;
  final List<String>? socialShareProviders;
  final String? socialShareMessage;
  final bool? reviewerNameCensored;
  final bool? guestCheckoutEnabled;
  final bool? customerReviewEnabled;
  final bool? guestReviewEnabled;
  final bool? reorderEnabled;

  /// Admin product review summary mode: `star_counts` or `review_counts`.
  final String? reviewSummary;
  final bool? newsletterEnabled;
  final bool? minimumOrderEnabled;
  final double? minimumOrderAmount;
  final bool? minimumOrderIncludesDiscount;
  final bool? minimumOrderIncludesTax;
  final String? minimumOrderMessage;

  /// Admin "Allow Customer to Directly Buy Product" (Buy Now button).
  final bool? buyNowEnabled;

  /// Admin cart summary: `display_item_quantity` or
  /// `display_number_of_items_in_cart`.
  final String? cartSummary;

  /// Admin "Cart Page" toggle. Off: no cart tab, no add-to-cart.
  final bool? cartPageEnabled;

  /// Admin "Estimated Shipping" toggle. Off: estimate shipping accordion hidden in cart.
  final bool? estimateShippingEnabled;

  /// Admin "Cross sell Products" toggle. Off: cross-sell products hidden in cart.
  final bool? cartCrossSellEnabled;

  /// Maximum products to show in detail-page Related and Up-Sell sections and
  /// the cart Cross-Sell section. Null means use the complete API list.
  final int? relatedProductsLimit;
  final int? upSellProductsLimit;
  final int? crossSellProductsLimit;

  /// Admin "redirect after login": `home` or `account`.
  final String? loginRedirectTo;

  /// Admin mini cart switch and its offer text, shown on the cart page.
  final bool? miniCartEnabled;
  final String? miniCartOfferInfo;

  /// Admin header announcement offer bar: e.g. "Get UPTO 20% OFF on your 1st order".
  final String? headerOfferTitle;
  final String? headerOfferLinkTitle;
  final String? headerOfferLink;

  /// Admin order number configuration: prefix, length (zero-padding), suffix.
  final String? orderNumberPrefix;
  final int? orderNumberLength;
  final String? orderNumberSuffix;

  /// Tax display settings in cart/checkout: excluding_tax, including_tax, both
  final String? taxCartDisplayPrices;
  final String? taxCartDisplaySubtotal;
  final String? taxCartDisplayShipping;
  final bool? taxCartShowBreakdown;

  /// Tax display settings in orders/invoices: excluding_tax, including_tax, both
  final String? taxOrderDisplayPrices;
  final String? taxOrderDisplaySubtotal;
  final String? taxOrderDisplayShipping;

  const StoreConfig({
    this.wishlistEnabled,
    this.compareEnabled,
    this.imageSearchEnabled,
    this.socialShareEnabled,
    this.socialShareProviders,
    this.socialShareMessage,
    this.reviewerNameCensored,
    this.guestCheckoutEnabled,
    this.customerReviewEnabled,
    this.guestReviewEnabled,
    this.reorderEnabled,
    this.reviewSummary,
    this.newsletterEnabled,
    this.minimumOrderEnabled,
    this.minimumOrderAmount,
    this.minimumOrderIncludesDiscount,
    this.minimumOrderIncludesTax,
    this.minimumOrderMessage,
    this.buyNowEnabled,
    this.cartSummary,
    this.cartPageEnabled,
    this.estimateShippingEnabled,
    this.cartCrossSellEnabled,
    this.relatedProductsLimit,
    this.upSellProductsLimit,
    this.crossSellProductsLimit,
    this.loginRedirectTo,
    this.miniCartEnabled,
    this.miniCartOfferInfo,
    this.headerOfferTitle,
    this.headerOfferLinkTitle,
    this.headerOfferLink,
    this.orderNumberPrefix,
    this.orderNumberLength,
    this.orderNumberSuffix,
    this.taxCartDisplayPrices,
    this.taxCartDisplaySubtotal,
    this.taxCartDisplayShipping,
    this.taxCartShowBreakdown,
    this.taxOrderDisplayPrices,
    this.taxOrderDisplaySubtotal,
    this.taxOrderDisplayShipping,
  });

  factory StoreConfig.fromJson(Map<String, dynamic> json) {
    final message = json['minimumOrderMessage']?.toString().trim();
    return StoreConfig(
      wishlistEnabled: _bool(json['wishlistEnabled']),
      compareEnabled: _bool(json['compareEnabled']),
      imageSearchEnabled: _bool(json['imageSearchEnabled']),
      socialShareEnabled: _bool(json['socialShareEnabled']),
      socialShareProviders: _strings(json['socialShareProviders']),
      socialShareMessage: _text(json['socialShareMessage']),
      reviewerNameCensored: _bool(json['reviewerNameCensored']),
      guestCheckoutEnabled: _bool(json['guestCheckoutEnabled']),
      customerReviewEnabled: _bool(json['customerReviewEnabled']),
      guestReviewEnabled: _bool(json['guestReviewEnabled']),
      reorderEnabled: _bool(json['reorderEnabled']),
      reviewSummary: _text(json['reviewSummary'])?.toLowerCase(),
      newsletterEnabled: _bool(json['newsletterEnabled']),
      minimumOrderEnabled: _bool(json['minimumOrderEnabled']),
      minimumOrderAmount: _double(json['minimumOrderAmount']),
      minimumOrderIncludesDiscount: _bool(json['minimumOrderIncludesDiscount']),
      minimumOrderIncludesTax: _bool(json['minimumOrderIncludesTax']),
      minimumOrderMessage: (message == null || message.isEmpty)
          ? null
          : message,
      buyNowEnabled: _bool(
        json['buyNowButtonEnabled'] ?? json['buyNowEnabled'],
      ),
      cartSummary: json['cartSummary']?.toString(),
      cartPageEnabled: _bool(json['cartPageEnabled']),
      estimateShippingEnabled: _bool(json['estimateShippingEnabled']),
      cartCrossSellEnabled: _bool(json['cartCrossSellEnabled']),
      relatedProductsLimit: _int(json['relatedProductsLimit']),
      upSellProductsLimit: _int(json['upSellProductsLimit']),
      crossSellProductsLimit: _int(json['crossSellProductsLimit']),
      loginRedirectTo: json['loginRedirectTo']?.toString(),
      miniCartEnabled: _bool(
        json['miniCartOfferInfoEnabled'] ?? json['miniCartEnabled'],
      ),
      miniCartOfferInfo: _text(json['miniCartOfferInfo']),
      headerOfferTitle: _text(json['headerOfferTitle']),
      headerOfferLinkTitle: _text(json['headerOfferLinkTitle']),
      headerOfferLink: _text(json['headerOfferLink']),
      orderNumberPrefix: _text(json['orderNumberPrefix']),
      orderNumberLength: _int(json['orderNumberLength']),
      orderNumberSuffix: _text(json['orderNumberSuffix']),
      taxCartDisplayPrices: json['taxCartDisplayPrices']?.toString(),
      taxCartDisplaySubtotal: json['taxCartDisplaySubtotal']?.toString(),
      taxCartDisplayShipping: json['taxCartDisplayShipping']?.toString(),
      taxCartShowBreakdown: _bool(json['taxCartShowBreakdown']),
      taxOrderDisplayPrices: json['taxOrderDisplayPrices']?.toString(),
      taxOrderDisplaySubtotal: json['taxOrderDisplaySubtotal']?.toString(),
      taxOrderDisplayShipping: json['taxOrderDisplayShipping']?.toString(),
    );
  }

  /// The config provided above [context], or an empty config when the app
  /// has no [StoreConfigCubit] (for example in isolated widget tests).
  static StoreConfig of(BuildContext context, {bool listen = true}) {
    try {
      return listen
          ? context.watch<StoreConfigCubit>().state
          : context.read<StoreConfigCubit>().state;
    } on ProviderNotFoundException {
      return const StoreConfig();
    }
  }

  bool get showWishlist => wishlistEnabled != false;
  bool get showCompare => compareEnabled != false;
  bool get showImageSearch => imageSearchEnabled != false;
  bool get showSocialShare =>
      socialShareEnabled != false &&
      (socialShareProviders == null || socialShareProviders!.isNotEmpty);
  bool get showReorder => reorderEnabled != false;
  bool get showNewsletter => newsletterEnabled != false;
  bool get showBuyNow => buyNowEnabled != false;
  bool get showCartPage => cartPageEnabled != false;
  bool get showEstimateShipping => estimateShippingEnabled != false;
  bool get showCartCrossSell => cartCrossSellEnabled != false;

  /// Keeps the first [limit] entries; missing limit leaves list unchanged.
  List<T> limitProducts<T>(List<T> products, int? limit) {
    if (limit == null) return products;
    return products.take(limit < 0 ? 0 : limit).toList(growable: false);
  }

  /// Offer text for the cart page, or null when switched off or empty.
  String? get cartOfferInfo =>
      miniCartEnabled == false ? null : miniCartOfferInfo;

  /// Whether an announcement header offer is configured.
  bool get hasHeaderOffer => (headerOfferTitle ?? '').trim().isNotEmpty;

  /// Cart summary counts cart lines instead of item quantities.
  bool get cartSummaryShowsItemCount =>
      cartSummary == 'display_number_of_items_in_cart';

  /// The cart count to show: lines or total quantity, per [cartSummary].
  int cartCount({required int itemsCount, required int itemsQty}) =>
      cartSummaryShowsItemCount ? itemsCount : itemsQty;
  bool get allowGuestCheckout => guestCheckoutEnabled != false;
  bool get allowCustomerReview => customerReviewEnabled != false;
  bool get allowGuestReview => guestReviewEnabled != false;
  bool get censorReviewerName => reviewerNameCensored == true;
  bool get reviewSummaryShowsReviewCount => reviewSummary == 'review_counts';

  /// The number shown beside a product's average rating, per admin setting.
  int reviewSummaryCount({required int reviewCount, required int starCount}) =>
      reviewSummaryShowsReviewCount ? reviewCount : starCount;

  /// Tax display options for subtotal and shipping:
  bool get showSubtotalBoth => taxCartDisplaySubtotal == 'both';
  bool get showSubtotalInclTax =>
      taxCartDisplaySubtotal == 'including_tax' ||
      taxCartDisplaySubtotal == 'both';
  bool get showShippingBoth => taxCartDisplayShipping == 'both';
  bool get showShippingInclTax =>
      taxCartDisplayShipping == 'including_tax' ||
      taxCartDisplayShipping == 'both';
  bool get showItemPriceBoth => taxCartDisplayPrices == 'both';
  bool get showItemPriceInclTax =>
      taxCartDisplayPrices == 'including_tax' || taxCartDisplayPrices == 'both';
  bool get showTaxBreakdown => taxCartShowBreakdown == true;

  /// Tax display options for orders and invoices:
  bool get showOrderSubtotalBoth => taxOrderDisplaySubtotal == 'both';
  bool get showOrderSubtotalInclTax =>
      taxOrderDisplaySubtotal == 'including_tax' ||
      taxOrderDisplaySubtotal == 'both';
  bool get showOrderShippingBoth => taxOrderDisplayShipping == 'both';
  bool get showOrderShippingInclTax =>
      taxOrderDisplayShipping == 'including_tax' ||
      taxOrderDisplayShipping == 'both';
  bool get showOrderItemPriceBoth => taxOrderDisplayPrices == 'both';
  bool get showOrderItemPriceInclTax =>
      taxOrderDisplayPrices == 'including_tax' ||
      taxOrderDisplayPrices == 'both';

  /// A minimum order amount is configured and active.
  bool get hasMinimumOrder =>
      minimumOrderEnabled == true && (minimumOrderAmount ?? 0) > 0;

  /// The cart amount compared against [minimumOrderAmount].
  double minimumOrderTotal({
    required double subtotal,
    required double discount,
    required double tax,
  }) {
    var total = subtotal;
    if (minimumOrderIncludesDiscount == true) total -= discount;
    if (minimumOrderIncludesTax == true) total += tax;
    return total;
  }

  bool meetsMinimumOrder({
    required double subtotal,
    required double discount,
    required double tax,
  }) {
    if (!hasMinimumOrder) return true;
    return minimumOrderTotal(
          subtotal: subtotal,
          discount: discount,
          tax: tax,
        ) >=
        minimumOrderAmount!;
  }

  /// Formats an order identifier using [orderNumberPrefix], [orderNumberLength],
  /// and [orderNumberSuffix] when configured, including a leading '#' in both cases.
  ///
  /// - If [orderIncrementId] is provided and already formatted (contains non-digits),
  ///   it strips any leading/contained '#' and prepends '#'.
  /// - Otherwise, formats the numeric identifier:
  ///   `"#${prefix}${id.padLeft(length, '0')}${suffix}"`
  /// - If no custom prefix, length, or suffix is configured, returns the raw numeric
  ///   identifier with '#': `"#${id}"`.
  String formatOrderNumber(
    String? orderId, {
    String? orderIncrementId,
    bool withHash = true,
  }) {
    final cleanIncrement = (orderIncrementId ?? '').replaceAll('#', '').trim();
    final cleanId = (orderId ?? '').replaceAll('#', '').trim();

    String formatted;
    // If orderIncrementId already contains non-digits, it is already a formatted increment ID.
    if (cleanIncrement.isNotEmpty && int.tryParse(cleanIncrement) == null) {
      formatted = cleanIncrement;
    } else {
      final idToUse = cleanIncrement.isNotEmpty ? cleanIncrement : cleanId;
      if (idToUse.isEmpty) return '';

      final hasCustomConfig =
          (orderNumberPrefix != null && orderNumberPrefix!.isNotEmpty) ||
          (orderNumberLength != null && orderNumberLength! > 0) ||
          (orderNumberSuffix != null && orderNumberSuffix!.isNotEmpty);

      if (!hasCustomConfig) {
        formatted = idToUse;
      } else {
        final body = (orderNumberLength != null && orderNumberLength! > 0)
            ? idToUse.padLeft(orderNumberLength!, '0')
            : idToUse;
        final prefix = orderNumberPrefix ?? '';
        final suffix = orderNumberSuffix ?? '';
        formatted = '$prefix$body$suffix';
      }
    }

    if (formatted.isEmpty) return '';
    return withHash ? '#$formatted' : formatted;
  }

  static bool? _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case '1':
        case 'true':
          return true;
        case '0':
        case 'false':
          return false;
      }
    }
    return null;
  }

  static String? _text(Object? value) {
    final text = value?.toString().trim();
    return (text == null || text.isEmpty) ? null : text;
  }

  static List<String>? _strings(Object? value) {
    if (value is! Iterable) return null;
    return value
        .map((item) => item.toString().trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  static double? _double(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  static int? _int(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  @override
  List<Object?> get props => [
    wishlistEnabled,
    compareEnabled,
    imageSearchEnabled,
    socialShareEnabled,
    socialShareProviders,
    socialShareMessage,
    reviewerNameCensored,
    guestCheckoutEnabled,
    customerReviewEnabled,
    guestReviewEnabled,
    reorderEnabled,
    reviewSummary,
    newsletterEnabled,
    minimumOrderEnabled,
    minimumOrderAmount,
    minimumOrderIncludesDiscount,
    minimumOrderIncludesTax,
    minimumOrderMessage,
    buyNowEnabled,
    cartSummary,
    cartPageEnabled,
    estimateShippingEnabled,
    cartCrossSellEnabled,
    relatedProductsLimit,
    upSellProductsLimit,
    crossSellProductsLimit,
    loginRedirectTo,
    miniCartEnabled,
    miniCartOfferInfo,
    headerOfferTitle,
    headerOfferLinkTitle,
    headerOfferLink,
    orderNumberPrefix,
    orderNumberLength,
    orderNumberSuffix,
    taxCartDisplayPrices,
    taxCartDisplaySubtotal,
    taxCartDisplayShipping,
    taxCartShowBreakdown,
    taxOrderDisplayPrices,
    taxOrderDisplaySubtotal,
    taxOrderDisplayShipping,
  ];
}

/// Reviewer name masked like the storefront ("Censoring Reviewer Name"):
/// preserve each word's first character and mask its remaining characters.
/// "guest mobile" -> "g**** m*****", "Paul" -> "P***".
String censoredReviewerName(String name) {
  final words = name.trim().split(RegExp(r'\s+'))
    ..removeWhere((word) => word.isEmpty);
  if (words.isEmpty) return '';
  return words
      .map((word) {
        final characters = word.characters;
        return '${characters.first}${List.filled(characters.length - 1, '*').join()}';
      })
      .join(' ');
}
