import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/ui/seller_ui.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/models/seller_inventory_source.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_variant_creator.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_type_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The variations of a configurable, as `sellerProduct` hands them over.
///
/// The server names each row after the option ids it was built from — "Variant
/// 1 6" — but carries the options themselves under `superAttributes`, already
/// labelled, so the tab can read "Red / S" without a second request.
SellerProductVariant _variant(
  int id,
  String sku,
  String name, {
  Map<String, String> options = const {},
  double? price,
}) {
  return SellerProductVariant(
    variantId: id,
    listingId: id - 100,
    sku: sku,
    name: name,
    price: price,
    options: options,
  );
}

final _variants = [
  _variant(
    268,
    'probe-variant-1-6',
    'Variant 1 6',
    options: {'color': 'Red', 'size': 'S'},
    price: 100,
  ),
  _variant(
    269,
    'probe-variant-2-6',
    'Variant 2 6',
    options: {'color': 'Green', 'size': 'S'},
  ),
  _variant(
    270,
    'probe-variant-1-7',
    'Variant 1 7',
    options: {'color': 'Red', 'size': 'M'},
  ),
];

Future<void> _pump(
  WidgetTester tester, {
  List<SellerProductVariant>? variants,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SellerVariantSection(
            title: 'Variations',
            notice: 'Add a variant for each combination.',
            variants: variants ?? _variants,
            edits: const <int, SellerVariantEdit>{},
            onDelete: (_) {},
            onChanged: (_) {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('searchable option picker previews selected combinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SellerVariantCreator(
              attributes: const [
                SellerProductAttributeValue(
                  code: 'color',
                  name: 'Color',
                  type: 'select',
                  options: [
                    SellerProductCategoryRef(id: '4', name: 'Red'),
                    SellerProductCategoryRef(id: '5', name: 'Blue'),
                  ],
                ),
              ],
              stockLocations: const [
                SellerInventorySource(
                  iri: SellerIri('/api/seller/inventory-sources/1'),
                  id: 1,
                  code: 'default',
                  name: 'Default',
                ),
              ],
              parentSku: 'shirt',
              parentName: 'Shirt',
              optionNames: const {},
              existingVariants: const [],
              onCreate: (_) async => true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select options'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('variantOptionSearch')), 'red');
    await tester.pumpAndSettle();

    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    await tester.tap(find.byType(CheckboxListTile));
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.textContaining('SKU - shirt-variant-4'), findsOneWidget);
    expect(find.byKey(const ValueKey('variantPrice_color=4')), findsOneWidget);
  });

  testWidgets('each variant card shows combination label and options', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Red / S'), findsOneWidget);
    expect(find.text('Green / S'), findsOneWidget);
    expect(find.text('Red / M'), findsOneWidget);

    expect(find.text('SKU - probe-variant-1-6'), findsOneWidget);
    expect(find.byKey(const Key('variantEdit_268')), findsOneWidget);
    expect(find.byKey(const Key('variantDelete_268')), findsOneWidget);
  });

  testWidgets('tapping edit opens sheet with values the server holds', (
    tester,
  ) async {
    await _pump(tester);

    await tester.tap(find.byKey(const Key('variantEdit_268')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('variantName_268')),
        matching: find.text('Variant 1 6'),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byKey(const Key('variantSku_268')),
        matching: find.text('probe-variant-1-6'),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byKey(const Key('variantPrice_268')),
        matching: find.text('100.0'),
      ),
      findsOneWidget,
    );

    expect(find.byKey(const Key('variantWeight_268')), findsOneWidget);
    expect(find.byKey(const Key('variantStatus_268')), findsOneWidget);
  });

  testWidgets('it says which attributes the product varies by', (tester) async {
    await _pump(tester);

    Finder axis(String label) => find.descendant(
      of: find.byType(SellerPill),
      matching: find.text(label),
    );

    expect(axis('Color'), findsOneWidget);
    expect(axis('Size'), findsOneWidget);
  });

  testWidgets('a variant carrying no options falls back to its SKU', (
    tester,
  ) async {
    await _pump(
      tester,
      variants: [_variant(268, 'probe-variant-1-6', 'Variant 1 6')],
    );

    expect(find.text('probe-variant-1-6'), findsWidgets);
  });

  testWidgets(
    'a variant edits what the API accepts including quantities and images',
    (tester) async {
      await _pump(tester);

      await tester.tap(find.byKey(const Key('variantEdit_268')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('variantSku_268')), findsOneWidget);
      expect(find.byKey(const Key('variantWeight_268')), findsOneWidget);
      expect(find.byKey(const Key('variantStatus_268')), findsOneWidget);
      expect(find.byKey(const Key('variantAddImage_268')), findsOneWidget);
      expect(find.text('Quantities'), findsOneWidget);
      expect(find.text('Images'), findsOneWidget);
    },
  );

  testWidgets(
    'selecting only one attribute generates variants, and clicking delete removes it',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SellerVariantCreator(
                attributes: const [
                  SellerProductAttributeValue(
                    code: 'color',
                    name: 'Color',
                    type: 'select',
                    options: [
                      SellerProductCategoryRef(id: '1', name: 'Red'),
                      SellerProductCategoryRef(id: '2', name: 'Blue'),
                    ],
                  ),
                  SellerProductAttributeValue(
                    code: 'size',
                    name: 'Size',
                    type: 'select',
                    options: [
                      SellerProductCategoryRef(id: '6', name: 'S'),
                      SellerProductCategoryRef(id: '7', name: 'M'),
                    ],
                  ),
                ],
                stockLocations: const [
                  SellerInventorySource(
                    iri: SellerIri('/api/seller/inventory-sources/1'),
                    id: 1,
                    code: 'default',
                    name: 'Default',
                  ),
                ],
                parentSku: 'top',
                parentName: 'Top',
                optionNames: const {},
                existingVariants: const [],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open Color dropdown (first "Select options")
      await tester.tap(find.text('Select options').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // A single variant card should now be visible even though Size is unselected
      expect(find.textContaining('SKU - top-variant-1'), findsOneWidget);
      expect(find.byKey(const Key('variantDelete_color=1')), findsOneWidget);

      // Tapping Delete must remove the card immediately from the tab
      await tester.tap(find.byKey(const Key('variantDelete_color=1')));
      await tester.pumpAndSettle();

      expect(find.textContaining('SKU - top-variant-1'), findsNothing);
    },
  );

  testWidgets(
    'variant card displays option name without parent prefix, attribute details below SKU, and default price 0.00',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SellerVariantCreator(
                attributes: const [
                  SellerProductAttributeValue(
                    code: 'color',
                    name: 'Color',
                    type: 'select',
                    options: [
                      SellerProductCategoryRef(id: '1', name: 'Red'),
                    ],
                  ),
                  SellerProductAttributeValue(
                    code: 'size',
                    name: 'Size',
                    type: 'select',
                    options: [
                      SellerProductCategoryRef(id: '6', name: 'S'),
                    ],
                  ),
                ],
                stockLocations: const [
                  SellerInventorySource(
                    iri: SellerIri('/api/seller/inventory-sources/1'),
                    id: 1,
                    code: 'default',
                    name: 'Default',
                  ),
                ],
                parentSku: 'aman-new',
                parentName: 'Config aman',
                currencySymbol: 'Nu.',
                optionNames: const {},
                existingVariants: const [],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Select Color -> Red
      await tester.tap(find.text('Select options').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Select Size -> S
      await tester.tap(find.text('Select options').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // 1. Variant name should be 'Red | S' (no 'Config aman' parent prefix)
      expect(find.text('Red | S'), findsOneWidget);
      expect(find.textContaining('Config aman Red'), findsNothing);

      // 2. SKU and Attribute details
      expect(find.text('SKU - aman-new-variant-1-6'), findsOneWidget);
      expect(find.text('Color: Red, Size: S'), findsOneWidget);

      // 3. Price defaults to Nu. 0.00, NOT 10
      expect(find.text('Nu. 0.00'), findsOneWidget);
      expect(find.text('10.00'), findsNothing);
      expect(find.text('Nu. 10.00'), findsNothing);

      // 4. Opening Edit sheet defaults price to 0.0, NOT 10
      await tester.tap(find.byKey(const Key('variantEdit_color=1|size=6')));
      await tester.pumpAndSettle();

      final priceField = tester.widget<TextFormField>(
        find.byKey(const Key('variantPrice_0')),
      );
      expect(priceField.controller?.text, '0.0');
    },
  );

  test('SellerProductVariant parses images from GraphQL maps and keeps them in toEdit', () {
    final json = {
      'variantId': 514,
      'sku': 'aman-new-variant-1-6',
      'name': 'Aman config Red / S',
      'price': 10,
      'images': [
        {
          'url': 'http://192.168.15.90/mp-app/public/storage/product/514/EI66HiZSJFRf2Vej8eaUPAb8SoxI1jRAyVpBDB7b.png',
          'position': 1,
        }
      ],
    };

    final variant = SellerProductVariant.fromJson(json);
    expect(variant.images, [
      'http://192.168.15.90/mp-app/public/storage/product/514/EI66HiZSJFRf2Vej8eaUPAb8SoxI1jRAyVpBDB7b.png',
    ]);

    final edit = variant.toEdit();
    expect(edit.images, [
      'http://192.168.15.90/mp-app/public/storage/product/514/EI66HiZSJFRf2Vej8eaUPAb8SoxI1jRAyVpBDB7b.png',
    ]);
  });
}

