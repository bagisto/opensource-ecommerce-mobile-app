import 'package:flutter_test/flutter_test.dart';
import 'package:bagisto_flutter/core/currency/product_price_display.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';

void main() {
  group('ProductPriceDisplay Unit Tests (Web Parity)', () {
    test('1. Grouped Product: label "Starting at", formattedMinimumPrice, never show strikethrough', () {
      final display = ProductPriceDisplay.calculate(
        type: 'grouped',
        price: 200.0,
        formattedPrice: '\$200.00',
        minimumPrice: 150.0,
        formattedMinimumPrice: '\$150.00',
        regularMinimumPrice: 180.0,
        formattedRegularMinimumPrice: '\$180.00',
      );

      expect(display.label, 'Starting at');
      expect(display.displayPrice, '\$150.00');
      expect(display.strikethroughPrice, isNull);
      expect(display.hasDiscount, isFalse);
    });

    test('2a. Booking (event): label "Starting from", formattedStartingPrice, strikethrough if startingRegularPrice > startingPrice', () {
      final displayWithDiscount = ProductPriceDisplay.calculate(
        type: 'booking',
        bookingType: 'event',
        startingPrice: 100.0,
        formattedStartingPrice: '\$100.00',
        startingRegularPrice: 120.0,
        formattedStartingRegularPrice: '\$120.00',
      );

      expect(displayWithDiscount.label, 'Starting from');
      expect(displayWithDiscount.displayPrice, '\$100.00');
      expect(displayWithDiscount.strikethroughPrice, '\$120.00');
      expect(displayWithDiscount.hasDiscount, isTrue);

      final displayNoDiscount = ProductPriceDisplay.calculate(
        type: 'booking',
        bookingType: 'event',
        startingPrice: 100.0,
        formattedStartingPrice: '\$100.00',
        startingRegularPrice: 100.0,
        formattedStartingRegularPrice: '\$100.00',
      );

      expect(displayNoDiscount.label, 'Starting from');
      expect(displayNoDiscount.displayPrice, '\$100.00');
      expect(displayNoDiscount.strikethroughPrice, isNull);
      expect(displayNoDiscount.hasDiscount, isFalse);
    });

    test('2b. Booking (rental): label "Starting from", formattedStartingPrice', () {
      final display = ProductPriceDisplay.calculate(
        type: 'booking',
        bookingType: 'rental',
        startingPrice: 153.0,
        formattedStartingPrice: '\$153.00',
        startingRegularPrice: 175.0,
        formattedStartingRegularPrice: '\$175.00',
      );

      expect(display.label, 'Starting from');
      expect(display.displayPrice, '\$153.00');
      expect(display.strikethroughPrice, '\$175.00');
      expect(display.hasDiscount, isTrue);
    });

    test('3. Booking (appointment/table/default): no label, formattedMinimumPrice, strikethrough if regular > min', () {
      final display = ProductPriceDisplay.calculate(
        type: 'booking',
        bookingType: 'appointment',
        minimumPrice: 145.0,
        formattedMinimumPrice: '\$145.00',
        regularMinimumPrice: 195.0,
        formattedRegularMinimumPrice: '\$195.00',
      );

      expect(display.label, isNull);
      expect(display.displayPrice, '\$145.00');
      expect(display.strikethroughPrice, '\$195.00');
      expect(display.hasDiscount, isTrue);
    });

    test('4. Configurable: label "As low as", formattedMinimumPrice, strikethrough if regular > min', () {
      final display = ProductPriceDisplay.calculate(
        type: 'configurable',
        minimumPrice: 50.0,
        formattedMinimumPrice: '\$50.00',
        regularMinimumPrice: 70.0,
        formattedRegularMinimumPrice: '\$70.00',
      );

      expect(display.label, 'As low as');
      expect(display.displayPrice, '\$50.00');
      expect(display.strikethroughPrice, '\$70.00');
      expect(display.hasDiscount, isTrue);
    });

    test('5a. Bundle: min != max shows "From To" range without label, compares regular and current separately', () {
      final displayBothDiscount = ProductPriceDisplay.calculate(
        type: 'bundle',
        minimumPrice: 20.0,
        formattedMinimumPrice: '\$20.00',
        maximumPrice: 50.0,
        formattedMaximumPrice: '\$50.00',
        regularMinimumPrice: 30.0,
        formattedRegularMinimumPrice: '\$30.00',
        regularMaximumPrice: 60.0,
        formattedRegularMaximumPrice: '\$60.00',
      );

      expect(displayBothDiscount.label, isNull);
      expect(displayBothDiscount.displayPrice, '\$20.00 To \$50.00');
      expect(displayBothDiscount.strikethroughPrice, '\$30.00 To \$60.00');
      expect(displayBothDiscount.hasDiscount, isTrue);

      final displayMinDiscountOnly = ProductPriceDisplay.calculate(
        type: 'bundle',
        minimumPrice: 20.0,
        formattedMinimumPrice: '\$20.00',
        maximumPrice: 50.0,
        formattedMaximumPrice: '\$50.00',
        regularMinimumPrice: 30.0,
        formattedRegularMinimumPrice: '\$30.00',
        regularMaximumPrice: 50.0,
        formattedRegularMaximumPrice: '\$50.00',
      );

      expect(displayMinDiscountOnly.displayPrice, '\$20.00 To \$50.00');
      expect(displayMinDiscountOnly.strikethroughPrice, '\$30.00');
      expect(displayMinDiscountOnly.hasDiscount, isTrue);
    });

    test('5b. Bundle: min == max displays single price without "To" range', () {
      final displayEqual = ProductPriceDisplay.calculate(
        type: 'bundle',
        minimumPrice: 40.0,
        formattedMinimumPrice: '\$40.00',
        maximumPrice: 40.0,
        formattedMaximumPrice: '\$40.00',
        regularMinimumPrice: 50.0,
        formattedRegularMinimumPrice: '\$50.00',
      );

      expect(displayEqual.label, isNull);
      expect(displayEqual.displayPrice, '\$40.00');
      expect(displayEqual.strikethroughPrice, '\$50.00');
      expect(displayEqual.hasDiscount, isTrue);
    });

    test('6. Simple/Virtual/Downloadable: no label, formattedMinimumPrice, strikethrough if regular > min', () {
      final display = ProductPriceDisplay.calculate(
        type: 'simple',
        minimumPrice: 49.0,
        formattedMinimumPrice: '\$49.00',
        regularMinimumPrice: 99.0,
        formattedRegularMinimumPrice: '\$99.00',
      );

      expect(display.label, isNull);
      expect(display.displayPrice, '\$49.00');
      expect(display.strikethroughPrice, '\$99.00');
      expect(display.hasDiscount, isTrue);
    });

    test('HomeProduct and ProductModel model integration', () {
      final homeProduct = HomeProduct(
        id: '1',
        sku: 'SKU1',
        type: 'grouped',
        name: 'Grouped Item',
        urlKey: 'grouped-item',
        price: 200,
        minimumPrice: 150,
        formattedMinimumPrice: '\$150.00',
        regularMinimumPrice: 190,
        formattedRegularMinimumPrice: '\$190.00',
        isSaleable: true,
      );

      expect(homeProduct.priceLabelPrefix, 'Starting at');
      expect(homeProduct.displayPriceLabel, '\$150.00');
      expect(homeProduct.originalPriceLabel, isNull);
      expect(homeProduct.hasDiscount, isFalse);

      final productModel = ProductModel(
        id: '2',
        sku: 'SKU2',
        type: 'configurable',
        name: 'Configurable Shirt',
        minimumPrice: 25,
        formattedMinimumPrice: '\$25.00',
        regularMinimumPrice: 35,
        formattedRegularMinimumPrice: '\$35.00',
      );

      expect(productModel.priceLabelPrefix, 'As low as');
      expect(productModel.formattedDisplayPrice, '\$25.00');
      expect(productModel.formattedOriginalPrice, '\$35.00');
      expect(productModel.hasDiscount, isTrue);
    });
  });
}
