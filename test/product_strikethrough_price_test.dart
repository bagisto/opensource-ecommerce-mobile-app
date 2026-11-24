// Discounted products show the original price struck through on the product
// detail page — for simple (special price), configurable, bundle and catalog
// price rule products — and the detail queries ask for the regular price the
// strikethrough is read from.
import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_info_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(ProductModel product, {ProductVariant? variant}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SingleChildScrollView(
      child: ProductInfoSection(product: product, selectedVariant: variant),
    ),
  ),
);

/// A simple product discounted by a special price.
const _simpleSpecial = ProductModel(
  id: '/api/shop/products/22',
  numericId: 22,
  type: 'simple',
  name: 'Analog Watch',
  price: 3000,
  formattedPrice: r'$3,000.00',
  specialPrice: 2700,
  formattedSpecialPrice: r'$2,700.00',
  isSaleable: true,
);

/// A configurable product: the cheapest variant is below the regular price.
const _configurable = ProductModel(
  id: '/api/shop/products/2533',
  numericId: 2533,
  type: 'configurable',
  name: 'Cotton Tee',
  price: 0,
  formattedPrice: r'$0.00',
  minimumPrice: 4490,
  formattedMinimumPrice: r'$4,490.00',
  regularMinimumPrice: 5990,
  formattedRegularMinimumPrice: r'$5,990.00',
  isSaleable: true,
);

/// A bundle product: the bundle's from-price is below its regular total.
const _bundle = ProductModel(
  id: '/api/shop/products/40',
  numericId: 40,
  type: 'bundle',
  name: 'Desk Bundle',
  price: 2000,
  formattedPrice: r'$2,000.00',
  minimumPrice: 1800,
  formattedMinimumPrice: r'$1,800.00',
  regularMinimumPrice: 2000,
  formattedRegularMinimumPrice: r'$2,000.00',
  isSaleable: true,
);

/// A catalog price rule: no special price, but the final price is lower.
const _catalogRule = ProductModel(
  id: '/api/shop/products/2358',
  numericId: 2358,
  type: 'simple',
  name: 'Leather Bag',
  price: 4000,
  formattedPrice: r'$4,000.00',
  minimumPrice: 3600,
  formattedMinimumPrice: r'$3,600.00',
  regularMinimumPrice: 4000,
  formattedRegularMinimumPrice: r'$4,000.00',
  isSaleable: true,
);

const _noDiscount = ProductModel(
  id: '/api/shop/products/99',
  numericId: 99,
  type: 'simple',
  name: 'Plain Mug',
  price: 4000,
  formattedPrice: r'$4,000.00',
  minimumPrice: 4000,
  formattedMinimumPrice: r'$4,000.00',
  regularMinimumPrice: 4000,
  formattedRegularMinimumPrice: r'$4,000.00',
  isSaleable: true,
);

Finder _struckThrough(String label) => find.byWidgetPredicate(
  (widget) =>
      widget is Text &&
      widget.data == label &&
      widget.style?.decoration == TextDecoration.lineThrough,
  description: 'struck-through "$label"',
);

Finder _anyStrikethrough() => find.byWidgetPredicate(
  (widget) =>
      widget is Text && widget.style?.decoration == TextDecoration.lineThrough,
  description: 'any struck-through price',
);

void main() {
  testWidgets('simple product with a special price strikes the regular price', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_simpleSpecial));

    expect(find.text(r'$2,700.00'), findsOneWidget);
    expect(_struckThrough(r'$3,000.00'), findsOneWidget);
    expect(find.text('10% off'), findsOneWidget);
  });

  testWidgets('configurable product strikes the regular minimum price', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_configurable));

    expect(find.text(r'$4,490.00'), findsOneWidget);
    expect(_struckThrough(r'$5,990.00'), findsOneWidget);
    expect(find.text('25% off'), findsOneWidget);
  });

  testWidgets('bundle product strikes the regular minimum price', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_bundle));

    expect(find.text(r'$1,800.00'), findsOneWidget);
    expect(_struckThrough(r'$2,000.00'), findsOneWidget);
    expect(find.text('10% off'), findsOneWidget);
  });

  testWidgets('catalog price rule strikes the regular price', (tester) async {
    await tester.pumpWidget(_wrap(_catalogRule));

    expect(find.text(r'$3,600.00'), findsOneWidget);
    expect(_struckThrough(r'$4,000.00'), findsOneWidget);
    expect(find.text('10% off'), findsOneWidget);
  });

  testWidgets('undiscounted product shows no strikethrough', (tester) async {
    await tester.pumpWidget(_wrap(_noDiscount));

    expect(find.text(r'$4,000.00'), findsOneWidget);
    expect(_anyStrikethrough(), findsNothing);
    expect(find.textContaining('% off'), findsNothing);
  });

  testWidgets('selected variant price overrides the product price', (
    tester,
  ) async {
    const variant = ProductVariant(
      id: '/api/shop/products/2534',
      numericId: 2534,
      name: 'Cotton Tee - S',
      price: 5990,
      formattedPrice: r'$5,990.00',
      specialPrice: 4490,
      formattedSpecialPrice: r'$4,490.00',
    );

    await tester.pumpWidget(_wrap(_configurable, variant: variant));

    expect(find.text(r'$4,490.00'), findsOneWidget);
    expect(_struckThrough(r'$5,990.00'), findsOneWidget);
  });

  test('the model exposes the regular price for every discount shape', () {
    expect(_simpleSpecial.formattedOriginalPrice, r'$3,000.00');
    expect(_configurable.formattedOriginalPrice, r'$5,990.00');
    expect(_configurable.discountPercent, 25);
    expect(_bundle.formattedOriginalPrice, r'$2,000.00');
    expect(_catalogRule.formattedOriginalPrice, r'$4,000.00');
    expect(_catalogRule.discountPercent, 10);
    expect(_noDiscount.formattedOriginalPrice, isNull);
    expect(_noDiscount.discountPercent, isNull);
  });

  test('product detail queries request the regular price', () {
    expect(
      ProductQueries.getProductByUrlKey,
      contains('formattedRegularMinimumPrice'),
    );
    expect(
      ProductQueries.getProductById,
      contains('formattedRegularMinimumPrice'),
    );
    for (final type in ['simple', 'configurable', 'bundle', 'grouped']) {
      expect(
        ProductQueries.getProductByUrlKeyByType(type),
        contains('formattedRegularMinimumPrice'),
        reason: 'type: $type',
      );
    }
  });
}
