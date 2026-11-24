import '../../features/category/data/models/product_model.dart';
import '../../features/home/data/models/home_models.dart';
import '../../l10n/app_localizations.dart';

/// Presentation model representing how a product's price, prefix label,
/// and strikethrough price should be displayed to match Bagisto Web rules.
class ProductPriceDisplay {
  /// The prefix label, e.g. "Starting at", "Starting from", "As low as", or null.
  final String? label;

  /// The main formatted price to display, e.g. "$150.00" or "$20.00 To $50.00".
  final String displayPrice;

  /// The strikethrough price, e.g. "$195.00" or null.
  final String? strikethroughPrice;

  /// Whether there is a strikethrough price to show.
  bool get hasDiscount =>
      strikethroughPrice != null && strikethroughPrice!.isNotEmpty;

  const ProductPriceDisplay({
    this.label,
    required this.displayPrice,
    this.strikethroughPrice,
  });

  /// Factory for [HomeProduct]
  factory ProductPriceDisplay.fromHomeProduct(
    HomeProduct product, [
    AppLocalizations? l10n,
  ]) {
    return ProductPriceDisplay.calculate(
      type: product.type,
      bookingType: product.bookingType,
      price: product.price,
      formattedPrice: product.formattedPrice,
      minimumPrice: product.minimumPrice,
      formattedMinimumPrice: product.formattedMinimumPrice,
      maximumPrice: product.maximumPrice,
      formattedMaximumPrice: product.formattedMaximumPrice,
      regularMinimumPrice: product.regularMinimumPrice,
      formattedRegularMinimumPrice: product.formattedRegularMinimumPrice,
      regularMaximumPrice: product.regularMaximumPrice,
      formattedRegularMaximumPrice: product.formattedRegularMaximumPrice,
      specialPrice: product.specialPrice,
      formattedSpecialPrice: product.formattedSpecialPrice,
      startingPrice: product.startingPrice,
      formattedStartingPrice: product.formattedStartingPrice,
      startingRegularPrice: product.startingRegularPrice,
      formattedStartingRegularPrice: product.formattedStartingRegularPrice,
      l10n: l10n,
    );
  }

  /// Factory for [ProductModel]
  factory ProductPriceDisplay.fromProductModel(
    ProductModel product, [
    AppLocalizations? l10n,
  ]) {
    final firstBooking = product.bookingProducts.isNotEmpty
        ? product.bookingProducts.first
        : null;

    return ProductPriceDisplay.calculate(
      type: product.type ?? 'simple',
      bookingType: product.bookingType,
      price: product.price,
      formattedPrice: product.formattedPrice,
      minimumPrice: product.minimumPrice,
      formattedMinimumPrice: product.formattedMinimumPrice,
      maximumPrice: product.maximumPrice,
      formattedMaximumPrice: product.formattedMaximumPrice,
      regularMinimumPrice: product.regularMinimumPrice,
      formattedRegularMinimumPrice: product.formattedRegularMinimumPrice,
      regularMaximumPrice: product.regularMaximumPrice,
      formattedRegularMaximumPrice: product.formattedRegularMaximumPrice,
      specialPrice: product.specialPrice,
      formattedSpecialPrice: product.formattedSpecialPrice,
      startingPrice: firstBooking?.startingPrice,
      formattedStartingPrice: firstBooking?.formattedStartingPrice,
      startingRegularPrice: firstBooking?.startingRegularPrice,
      formattedStartingRegularPrice:
          firstBooking?.formattedStartingRegularPrice,
      l10n: l10n,
    );
  }

  /// Core pricing rules calculation matching Bagisto Web:
  ///
  /// - Grouped: Label "Starting at", Price: formattedMinimumPrice, Strike-Through: Never show
  /// - Booking (event/rental): Label "Starting from", Price: bookingProducts[0].formattedStartingPrice,
  ///   Strike-Through: Show formattedStartingRegularPrice if startingRegularPrice > startingPrice
  /// - Booking (default/appointment/table): No label, Price: formattedMinimumPrice,
  ///   Strike-Through: Show formattedRegularMinimumPrice if regularMinimumPrice > minimumPrice
  /// - Configurable: Label "As low as", Price: formattedMinimumPrice,
  ///   Strike-Through: Show formattedRegularMinimumPrice if regularMinimumPrice > minimumPrice
  /// - Bundle: No label; show From–To range formattedMinimumPrice to formattedMaximumPrice
  ///   (show “To” only when min != max), Compare regular and current prices separately for min and max
  /// - Simple/Virtual/Downloadable: No label, Price: formattedMinimumPrice,
  ///   Strike-Through: Show formattedRegularMinimumPrice if regularMinimumPrice > minimumPrice
  static ProductPriceDisplay calculate({
    required String type,
    String? bookingType,
    double? price,
    String? formattedPrice,
    double? minimumPrice,
    String? formattedMinimumPrice,
    double? maximumPrice,
    String? formattedMaximumPrice,
    double? regularMinimumPrice,
    String? formattedRegularMinimumPrice,
    double? regularMaximumPrice,
    String? formattedRegularMaximumPrice,
    double? specialPrice,
    String? formattedSpecialPrice,
    double? startingPrice,
    String? formattedStartingPrice,
    double? startingRegularPrice,
    String? formattedStartingRegularPrice,
    AppLocalizations? l10n,
  }) {
    final lowerType = type.toLowerCase();

    // 1. Grouped
    if (lowerType == 'grouped') {
      final currentPrice = (formattedMinimumPrice?.isNotEmpty ?? false)
          ? formattedMinimumPrice!
          : (formattedPrice ?? (price != null ? price.toStringAsFixed(2) : ''));

      return ProductPriceDisplay(
        label: l10n?.priceStartingAt ?? 'Starting at',
        displayPrice: currentPrice,
        strikethroughPrice: null, // Never show strikethrough for grouped
      );
    }

    // 2. Booking
    if (lowerType == 'booking') {
      final bType = (bookingType ?? '').toLowerCase();
      final isEventOrRental = bType == 'event' || bType == 'rental';

      if (isEventOrRental) {
        final currentPrice = (formattedStartingPrice?.isNotEmpty ?? false)
            ? formattedStartingPrice!
            : ((formattedMinimumPrice?.isNotEmpty ?? false)
                ? formattedMinimumPrice!
                : (formattedPrice ??
                    (price != null ? price.toStringAsFixed(2) : '')));

        final hasStrikethrough = startingRegularPrice != null &&
            startingPrice != null &&
            startingRegularPrice > startingPrice &&
            (formattedStartingRegularPrice?.isNotEmpty ?? false);

        return ProductPriceDisplay(
          label: l10n?.priceStartingFrom ?? 'Starting from',
          displayPrice: currentPrice,
          strikethroughPrice:
              hasStrikethrough ? formattedStartingRegularPrice : null,
        );
      } else {
        // default / appointment / table
        final currentPrice = (formattedMinimumPrice?.isNotEmpty ?? false)
            ? formattedMinimumPrice!
            : (formattedPrice ??
                (price != null ? price.toStringAsFixed(2) : ''));

        final hasStrikethrough = regularMinimumPrice != null &&
            minimumPrice != null &&
            regularMinimumPrice > minimumPrice &&
            (formattedRegularMinimumPrice?.isNotEmpty ?? false);

        return ProductPriceDisplay(
          label: null,
          displayPrice: currentPrice,
          strikethroughPrice:
              hasStrikethrough ? formattedRegularMinimumPrice : null,
        );
      }
    }

    // 3. Configurable
    if (lowerType == 'configurable') {
      final currentPrice = (formattedMinimumPrice?.isNotEmpty ?? false)
          ? formattedMinimumPrice!
          : (formattedPrice ?? (price != null ? price.toStringAsFixed(2) : ''));

      final hasStrikethrough = regularMinimumPrice != null &&
          minimumPrice != null &&
          regularMinimumPrice > minimumPrice &&
          (formattedRegularMinimumPrice?.isNotEmpty ?? false);

      return ProductPriceDisplay(
        label: l10n?.priceAsLowAs ?? 'As low as',
        displayPrice: currentPrice,
        strikethroughPrice:
            hasStrikethrough ? formattedRegularMinimumPrice : null,
      );
    }

    // 4. Bundle
    if (lowerType == 'bundle') {
      final hasMin = formattedMinimumPrice?.isNotEmpty ?? false;
      final hasMax = formattedMaximumPrice?.isNotEmpty ?? false;
      final pricesDiffer = minimumPrice != null &&
          maximumPrice != null &&
          minimumPrice != maximumPrice;

      final toSeparator = l10n?.priceRangeTo ?? 'To';

      final String currentPrice;
      if (pricesDiffer && hasMin && hasMax) {
        currentPrice = '$formattedMinimumPrice $toSeparator $formattedMaximumPrice';
      } else {
        currentPrice = hasMin
            ? formattedMinimumPrice!
            : (hasMax
                ? formattedMaximumPrice!
                : (formattedPrice ??
                    (price != null ? price.toStringAsFixed(2) : '')));
      }

      String? strikethrough;
      if (pricesDiffer) {
        final minHasDiscount = regularMinimumPrice != null &&
            minimumPrice != null &&
            regularMinimumPrice > minimumPrice &&
            (formattedRegularMinimumPrice?.isNotEmpty ?? false);
        final maxHasDiscount = regularMaximumPrice != null &&
            maximumPrice != null &&
            regularMaximumPrice > maximumPrice &&
            (formattedRegularMaximumPrice?.isNotEmpty ?? false);

        if (minHasDiscount && maxHasDiscount) {
          strikethrough =
              '$formattedRegularMinimumPrice $toSeparator $formattedRegularMaximumPrice';
        } else if (minHasDiscount) {
          strikethrough = formattedRegularMinimumPrice;
        } else if (maxHasDiscount) {
          strikethrough = formattedRegularMaximumPrice;
        }
      } else {
        final hasDiscount = regularMinimumPrice != null &&
            minimumPrice != null &&
            regularMinimumPrice > minimumPrice &&
            (formattedRegularMinimumPrice?.isNotEmpty ?? false);
        if (hasDiscount) {
          strikethrough = formattedRegularMinimumPrice;
        }
      }

      return ProductPriceDisplay(
        label: null,
        displayPrice: currentPrice,
        strikethroughPrice: strikethrough,
      );
    }

    // 5. Simple / Virtual / Downloadable / Default
    final hasRegularDiscount = regularMinimumPrice != null &&
        minimumPrice != null &&
        regularMinimumPrice > minimumPrice &&
        (formattedRegularMinimumPrice?.isNotEmpty ?? false);

    final hasSpecialDiscount = specialPrice != null &&
        specialPrice > 0 &&
        price != null &&
        price > 0 &&
        specialPrice < price &&
        (formattedSpecialPrice?.isNotEmpty ?? false);

    final String currentPrice;
    if (formattedMinimumPrice?.isNotEmpty ?? false) {
      currentPrice = formattedMinimumPrice!;
    } else if (hasSpecialDiscount) {
      currentPrice = formattedSpecialPrice!;
    } else if (formattedPrice?.isNotEmpty ?? false) {
      currentPrice = formattedPrice!;
    } else {
      currentPrice = price != null ? price.toStringAsFixed(2) : '';
    }

    final String? strikethrough;
    if (hasRegularDiscount) {
      strikethrough = formattedRegularMinimumPrice;
    } else if (hasSpecialDiscount && (formattedPrice?.isNotEmpty ?? false)) {
      strikethrough = formattedPrice;
    } else {
      strikethrough = null;
    }

    return ProductPriceDisplay(
      label: null,
      displayPrice: currentPrice,
      strikethroughPrice: strikethrough,
    );
  }
}
