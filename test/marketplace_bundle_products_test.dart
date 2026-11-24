import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_product_picker_sheet.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_type_sections.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Putting products inside a bundle option.
///
/// The tab opened on nothing for one reason: the app asked the seller to type
/// a "core product id", a number they have no way of knowing. They cancelled,
/// saved an option holding nothing, and 2.4.9 refused the whole update with
/// "Each bundle option needs at least one product" — so nothing was stored and
/// the tab was empty again next time. Verified live 2026-08-18.
const _saved = SellerBundleOption(
  bundleOptionId: 10,
  label: 'Choose a bag',
  type: 'radio',
  isRequired: true,
  products: [
    SellerBundleOptionProduct(
      bundleOptionProductId: 21,
      productId: 271,
      sku: 'hcchchjccj666-variant-4',
      name: 'Variant 4',
      qty: 2,
    ),
  ],
);

Future<List<SellerBundleOption>> _pump(
  WidgetTester tester, {
  List<SellerBundleOption> options = const [_saved],
  SellerPickedProduct? picks,
}) async {
  var current = options;

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => SellerBundleSection(
              title: 'Bundle options',
              notice: 'Saving sends the whole set back.',
              addLabel: 'Add option',
              options: current,
              onChanged: (value) => setState(() => current = value),
              onPickProduct: () async => picks,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return current;
}

/// What the section last handed back.
List<SellerBundleOption> _current(WidgetTester tester) => tester
    .widget<SellerBundleSection>(find.byType(SellerBundleSection))
    .options;

void main() {
  testWidgets('the tab opens on the options the product holds', (tester) async {
    await _pump(tester);

    expect(
      find.descendant(
        of: find.byType(TextFormField),
        matching: find.text('Choose a bag'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a bundled product is named, not numbered', (tester) async {
    // "Product #271" told a seller nothing; the read carries the SKU and name.
    await _pump(tester);

    expect(find.text('Variant 4 · hcchchjccj666-variant-4'), findsOneWidget);
  });

  testWidgets('an option with no products says so', (tester) async {
    await _pump(
      tester,
      options: const [SellerBundleOption(label: 'Empty', products: [])],
    );

    expect(
      find.textContaining('at least one product'),
      findsOneWidget,
      reason: 'the server refuses the save and names no option',
    );
  });

  testWidgets('a picked product joins the option with its name', (
    tester,
  ) async {
    await _pump(
      tester,
      options: const [SellerBundleOption(label: 'Empty')],
      picks: const SellerPickedProduct(
        productId: 272,
        sku: 'hcchchjccj666-variant-5',
        name: 'Variant 5',
      ),
    );

    await tester.tap(find.byKey(const Key('bundleAddProduct')));
    await tester.pumpAndSettle();

    final product = _current(tester).single.products.single;
    expect(product.productId, 272);
    expect(product.name, 'Variant 5');
    expect(find.text('Variant 5 · hcchchjccj666-variant-5'), findsOneWidget);
  });

  testWidgets('editing the qty keeps the row the server holds', (tester) async {
    // Rebuilding the row drops its bundleOptionProductId, and a save without
    // that id deletes the row and creates another — proved live, 20 became 21.
    await _pump(tester);

    await tester.enterText(find.widgetWithText(TextFormField, '2'), '5');
    await tester.pumpAndSettle();

    final product = _current(tester).single.products.single;
    expect(product.qty, 5);
    expect(product.bundleOptionProductId, 21);
    expect(product.sku, 'hcchchjccj666-variant-4');
  });

  test('the row sends the id it was read with', () {
    expect(_saved.products.single.toInput(), {
      'bundleOptionProductId': 21,
      'productId': 271,
      'qty': 2,
      'isDefault': false,
      'sortOrder': 0,
    });
  });

  test('a grouped link keeps its own id too', () {
    const link = SellerGroupedLink(
      linkId: 4,
      associatedProductId: 271,
      qty: 3,
      sku: 'hcchchjccj666-variant-4',
      name: 'Variant 4',
    );

    expect(link.copyWith(qty: 6).linkId, 4);
    expect(link.toInput()['linkId'], 4);
  });
}
