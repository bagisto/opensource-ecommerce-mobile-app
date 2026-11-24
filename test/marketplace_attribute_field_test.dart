import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_attribute_field.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// The editor renders whatever attributes the marketplace defines, so the
/// grouping and the per-type control are what decide whether a seller can
/// actually fill the form in.
void main() {
  group('SellerAttributeGroup', () {
    test('the codes a live product carries land where they belong', () {
      // Taken from a real product on the marketplace: 32 attributes.
      expect(SellerAttributeGroup.of('sku'), SellerAttributeGroup.general);
      expect(
        SellerAttributeGroup.of('product_number'),
        SellerAttributeGroup.general,
      );
      expect(
        SellerAttributeGroup.of('description'),
        SellerAttributeGroup.description,
      );
      expect(SellerAttributeGroup.of('cost'), SellerAttributeGroup.price);
      expect(
        SellerAttributeGroup.of('special_price_from'),
        SellerAttributeGroup.price,
      );
      expect(SellerAttributeGroup.of('weight'), SellerAttributeGroup.shipping);
      expect(SellerAttributeGroup.of('length'), SellerAttributeGroup.shipping);
      expect(SellerAttributeGroup.of('meta_title'), SellerAttributeGroup.meta);
      expect(
        SellerAttributeGroup.of('manage_stock'),
        SellerAttributeGroup.inventory,
      );
    });

    test('an attribute the admin adds later still gets a home', () {
      expect(
        SellerAttributeGroup.of('warranty_months'),
        SellerAttributeGroup.attributes,
      );
    });
  });

  group('SellerAttributeField', () {
    Future<void> pump(
      WidgetTester tester,
      SellerProductAttributeValue attribute, {
      void Function(String, String)? onChanged,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SellerAttributeField(
              attribute: attribute,
              controller: TextEditingController(text: attribute.value ?? ''),
              onChanged: onChanged ?? (_, _) {},
            ),
          ),
        ),
      );
    }

    testWidgets('a select becomes a dropdown of its options', (tester) async {
      await pump(
        tester,
        const SellerProductAttributeValue(
          code: 'color',
          name: 'Color',
          type: 'select',
          value: '2',
          options: [
            SellerProductCategoryRef(id: '1', name: 'Red'),
            SellerProductCategoryRef(id: '2', name: 'Green'),
          ],
        ),
      );

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('Green'), findsOneWidget);
    });

    testWidgets('an option the admin has since removed does not throw', (
      tester,
    ) async {
      await pump(
        tester,
        const SellerProductAttributeValue(
          code: 'color',
          name: 'Color',
          type: 'select',
          // The product still holds 99; the list no longer offers it.
          value: '99',
          options: [SellerProductCategoryRef(id: '1', name: 'Red')],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('a boolean becomes a switch and reports 1 or 0', (
      tester,
    ) async {
      final changes = <String, String>{};
      await pump(
        tester,
        const SellerProductAttributeValue(
          code: 'manage_stock',
          name: 'Manage stock',
          type: 'boolean',
          value: '0',
        ),
        onChanged: (code, value) => changes[code] = value,
      );

      expect(find.byType(SwitchListTile), findsOneWidget);
      await tester.tap(find.byType(SwitchListTile));
      expect(changes['manage_stock'], '1');
    });

    testWidgets('a required attribute is starred', (tester) async {
      await pump(
        tester,
        const SellerProductAttributeValue(
          code: 'sku',
          name: 'SKU',
          type: 'text',
          isRequired: true,
        ),
      );

      expect(find.text('SKU *'), findsOneWidget);
    });

    testWidgets('a textarea gets room to write in', (tester) async {
      await pump(
        tester,
        const SellerProductAttributeValue(
          code: 'description',
          name: 'Description',
          type: 'textarea',
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLines, greaterThan(1));
    });

    testWidgets('an image attribute is left to the media strip', (
      tester,
    ) async {
      await pump(
        tester,
        const SellerProductAttributeValue(
          code: 'barcode_image',
          name: 'Barcode image',
          type: 'image',
        ),
      );

      expect(find.byType(TextField), findsNothing);
    });
  });
  group('an edit in progress', () {
    /// Hosts one field and keeps what it reports, as the editor does.
    ///
    /// A switch and a select have no controller, so the field showed the value
    /// the product loaded with no matter what was tapped: the control sprang
    /// back and the edit looked lost, though it was recorded all along.
    Future<Map<String, String>> pumpLive(
      WidgetTester tester,
      SellerProductAttributeValue attribute,
    ) async {
      final edits = <String, String>{};
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => SellerAttributeField(
                attribute: attribute,
                controller: TextEditingController(text: attribute.value ?? ''),
                value: edits[attribute.code],
                onChanged: (code, value) => setState(() => edits[code] = value),
              ),
            ),
          ),
        ),
      );
      return edits;
    }

    testWidgets('tapping a switch moves it', (tester) async {
      await pumpLive(
        tester,
        const SellerProductAttributeValue(
          code: 'allow_rma',
          name: 'Allow RMA',
          type: 'boolean',
          value: '0',
        ),
      );

      await tester.tap(find.byKey(const Key('sellerProductField_allow_rma')));
      await tester.pumpAndSettle();

      final control = tester.widget<SwitchListTile>(
        find.byKey(const Key('sellerProductField_allow_rma')),
      );
      expect(control.value, isTrue);
    });

    testWidgets('turning a switch back off moves it back', (tester) async {
      await pumpLive(
        tester,
        const SellerProductAttributeValue(
          code: 'manage_stock',
          name: 'Manage Stock',
          type: 'boolean',
          value: '1',
        ),
      );

      await tester.tap(
        find.byKey(const Key('sellerProductField_manage_stock')),
      );
      await tester.pumpAndSettle();

      final control = tester.widget<SwitchListTile>(
        find.byKey(const Key('sellerProductField_manage_stock')),
      );
      expect(control.value, isFalse);
    });

    testWidgets('a select with no options says so rather than opening on '
        'nothing', (tester) async {
      // RMA Rules arrives this way: type select, options empty. Nothing in
      // the seller API lists RMA rules, so it can never be answered.
      await pumpLive(
        tester,
        const SellerProductAttributeValue(
          code: 'rma_rule_id',
          name: 'RMA Rules',
          type: 'select',
        ),
      );

      expect(find.text('None available'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsNothing);

      final field = tester.widget<TextField>(
        find.byKey(const Key('sellerProductField_rma_rule_id')),
      );
      expect(field.enabled, isFalse);
    });
  });
}
