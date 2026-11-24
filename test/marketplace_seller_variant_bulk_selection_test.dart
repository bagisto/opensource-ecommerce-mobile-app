import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_variant_bulk_action.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_variant_creator.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_variant_bulk_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _attributes = [
  SellerProductAttributeValue(
    code: 'color',
    name: 'Color',
    type: 'select',
    options: [
      SellerProductCategoryRef(id: '2', name: 'Green'),
      SellerProductCategoryRef(id: '3', name: 'Yellow'),
    ],
  ),
  SellerProductAttributeValue(
    code: 'size',
    name: 'Size',
    type: 'select',
    options: [SellerProductCategoryRef(id: '6', name: 'S')],
  ),
];

const _variants = [
  SellerProductVariant(
    variantId: 1819,
    sku: 'yellow',
    name: 'Yellow',
    price: 10,
    optionIds: {'color': '3'},
    options: {'color': 'Yellow'},
  ),
  SellerProductVariant(
    variantId: 1820,
    sku: 'yellow-s',
    name: 'Yellow S',
    price: 10,
    optionIds: {'color': '3', 'size': '6'},
    options: {'color': 'Yellow', 'size': 'S'},
  ),
  SellerProductVariant(
    variantId: 1821,
    sku: 'green-s',
    name: 'Green S',
    price: 12,
    optionIds: {'color': '2', 'size': '6'},
    options: {'color': 'Green', 'size': 'S'},
  ),
];

void main() {
  testWidgets(
    'selecting Color Green checks matching row and leaves rows visible',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SellerVariantCreator(
                attributes: _attributes,
                stockLocations: const [],
                parentSku: 'parent',
                parentName: 'Parent',
                optionNames: const {},
                existingVariants: _variants,
                canBulkEdit: true,
                onBulkUpdate: (SellerVariantBulkRequest request) async => true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('bulkVariant_1819')), findsOneWidget);
      expect(find.byKey(const Key('bulkVariant_1820')), findsOneWidget);
      expect(find.byKey(const Key('bulkVariant_1821')), findsOneWidget);
      expect(find.text('Select Action'), findsNothing);

      await tester.tap(find.text('Select Variants'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Color: Green'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Checkbox>(find.byKey(const Key('bulkVariant_1819')))
            .value,
        false,
      );
      expect(
        tester
            .widget<Checkbox>(find.byKey(const Key('bulkVariant_1820')))
            .value,
        false,
      );
      expect(
        tester
            .widget<Checkbox>(find.byKey(const Key('bulkVariant_1821')))
            .value,
        true,
      );
      expect(find.text('Select Action'), findsOneWidget);
    },
  );
  testWidgets('price action submits selected variant values', (tester) async {
    SellerVariantBulkRequest? sent;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SellerVariantBulkActionSheet(
            action: SellerVariantBulkAction.editPrices,
            variants: [_variants[2]],
            stockLocations: const [],
            errorMessage: () => null,
            onSubmit: (request) async {
              sent = request;
              return true;
            },
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField).last, '15.5');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(sent?.variantIds, [1821]);
    expect(sent?.values, {1821: 15.5});
  });

  testWidgets('destructive action confirms before any editor sheet', (
    tester,
  ) async {
    SellerVariantBulkRequest? sent;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SellerVariantCreator(
              attributes: _attributes,
              stockLocations: const [],
              parentSku: 'parent',
              parentName: 'Parent',
              optionNames: const {},
              existingVariants: [_variants.first],
              canBulkEdit: true,
              onBulkUpdate: (request) async {
                sent = request;
                return true;
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bulkVariant_1819')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select Action'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove Images').last);
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to perform this action?'),
      findsOneWidget,
    );
    expect(find.byType(SellerVariantBulkActionSheet), findsNothing);
    expect(sent, isNull);

    await tester.tap(find.text('Agree'));
    await tester.pumpAndSettle();
    expect(sent?.action, SellerVariantBulkAction.removeImages);
    expect(sent?.variantIds, [1819]);
  });
}
