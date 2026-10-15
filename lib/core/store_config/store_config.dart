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
  final bool? reviewerNameCensored;
  final bool? guestCheckoutEnabled;
  final bool? customerReviewEnabled;
  final bool? guestReviewEnabled;
  final bool? reorderEnabled;
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

  /// Admin "redirect after login": `home` or `account`.
  final String? loginRedirectTo;

  /// Admin mini cart switch and its offer text, shown on the cart page.
  final bool? miniCartEnabled;
  final String? miniCartOfferInfo;

  const StoreConfig({
    this.wishlistEnabled,
    this.compareEnabled,
    this.imageSearchEnabled,
    this.socialShareEnabled,
    this.reviewerNameCensored,
    this.guestCheckoutEnabled,
    this.customerReviewEnabled,
    this.guestReviewEnabled,
    this.reorderEnabled,
    this.newsletterEnabled,
    this.minimumOrderEnabled,
    this.minimumOrderAmount,
    this.minimumOrderIncludesDiscount,
    this.minimumOrderIncludesTax,
    this.minimumOrderMessage,
    this.buyNowEnabled,
    this.cartSummary,
    this.cartPageEnabled,
    this.loginRedirectTo,
    this.miniCartEnabled,
    this.miniCartOfferInfo,
  });

  factory StoreConfig.fromJson(Map<String, dynamic> json) {
    final message = json['minimumOrderMessage']?.toString().trim();
    return StoreConfig(
      wishlistEnabled: _bool(json['wishlistEnabled']),
      compareEnabled: _bool(json['compareEnabled']),
      imageSearchEnabled: _bool(json['imageSearchEnabled']),
      socialShareEnabled: _bool(json['socialShareEnabled']),
      reviewerNameCensored: _bool(json['reviewerNameCensored']),
      guestCheckoutEnabled: _bool(json['guestCheckoutEnabled']),
      customerReviewEnabled: _bool(json['customerReviewEnabled']),
      guestReviewEnabled: _bool(json['guestReviewEnabled']),
      reorderEnabled: _bool(json['reorderEnabled']),
      newsletterEnabled: _bool(json['newsletterEnabled']),
      minimumOrderEnabled: _bool(json['minimumOrderEnabled']),
      minimumOrderAmount: _double(json['minimumOrderAmount']),
      minimumOrderIncludesDiscount: _bool(
        json['minimumOrderIncludesDiscount'],
      ),
      minimumOrderIncludesTax: _bool(json['minimumOrderIncludesTax']),
      minimumOrderMessage: (message == null || message.isEmpty)
          ? null
          : message,
      buyNowEnabled: _bool(
        json['buyNowButtonEnabled'] ?? json['buyNowEnabled'],
      ),
      cartSummary: json['cartSummary']?.toString(),
      cartPageEnabled: _bool(json['cartPageEnabled']),
      loginRedirectTo: json['loginRedirectTo']?.toString(),
      miniCartEnabled: _bool(
        json['miniCartOfferInfoEnabled'] ?? json['miniCartEnabled'],
      ),
      miniCartOfferInfo: _text(json['miniCartOfferInfo']),
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
  bool get showSocialShare => socialShareEnabled != false;
  bool get showReorder => reorderEnabled != false;
  bool get showNewsletter => newsletterEnabled != false;
  bool get showBuyNow => buyNowEnabled != false;
  bool get showCartPage => cartPageEnabled != false;

  /// Offer text for the cart page, or null when switched off or empty.
  String? get cartOfferInfo =>
      miniCartEnabled == false ? null : miniCartOfferInfo;

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
    return minimumOrderTotal(subtotal: subtotal, discount: discount, tax: tax) >=
        minimumOrderAmount!;
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

  static double? _double(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  @override
  List<Object?> get props => [
    wishlistEnabled,
    compareEnabled,
    imageSearchEnabled,
    socialShareEnabled,
    reviewerNameCensored,
    guestCheckoutEnabled,
    customerReviewEnabled,
    guestReviewEnabled,
    reorderEnabled,
    newsletterEnabled,
    minimumOrderEnabled,
    minimumOrderAmount,
    minimumOrderIncludesDiscount,
    minimumOrderIncludesTax,
    minimumOrderMessage,
    buyNowEnabled,
    cartSummary,
    cartPageEnabled,
    loginRedirectTo,
    miniCartEnabled,
    miniCartOfferInfo,
  ];
}

/// Reviewer name masked like the storefront ("Censoring Reviewer Name"):
/// every word but the last is kept, the last becomes its first letter + `***`.
/// "H h Bukv" -> "H h B***", "Paul" -> "P***".
String censoredReviewerName(String name) {
  final words = name.trim().split(RegExp(r'\s+'))
    ..removeWhere((word) => word.isEmpty);
  if (words.isEmpty) return '';
  final last = words.removeLast();
  return [...words, '${last.characters.first}***'].join(' ');
}
