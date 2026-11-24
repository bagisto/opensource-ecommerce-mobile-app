import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/pages/seller_assigned_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const _iri = SellerIri('/theme/api-4.9/public/api/seller/products/715');

const _detail = SellerProductDetail(
  iri: _iri,
  productId: 744,
  sku: 'ddaad',
  name: 'Simple Admin',
  type: 'simple',
  status: 1,
  isOwner: false,
  price: 324.11,
  quantity: 100,
  weight: 1,
  urlKey: 'simple-admin',
  shortDescription: '',
  condition: 'new',
  sellerDescription: 'New',
  originalPrice: 262.44,
  formattedOriginalPrice: r'$262.44',
  stocks: [
    SellerProductStock(
      sourceId: 5,
      sourceCode: 'default',
      sourceName: 'Default',
      qty: 100,
    ),
  ],
);

class _Repository extends SellerProductRepository {
  _Repository()
    : super(
        client: GraphQLClient(
          cache: GraphQLCache(),
          link: Link.function((request, [forward]) => const Stream.empty()),
        ),
      );

  SellerProductDraft? saved;

  @override
  Future<SellerProductDetail> detail(SellerIri iri) async => _detail;

  @override
  Future<SellerProductDetail> update(SellerProductDraft original) async {
    saved = original;
    return _detail;
  }
}

Future<_Repository> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final repository = _Repository();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SellerAssignedProductPage(repository: repository, iri: _iri),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  testWidgets('shows only what web shows for an assigned product', (
    tester,
  ) async {
    await _open(tester);

    expect(find.text('Assign Product'), findsOneWidget);
    expect(find.text('Simple Admin'), findsOneWidget);
    // The web's Product Details card: name, original price, status.
    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text(r'$262.44'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Disapproved'), findsOneWidget);
    expect(find.byKey(const Key('sellerAssignedCondition')), findsOneWidget);
    expect(find.byKey(const Key('sellerAssignedPrice')), findsOneWidget);
    expect(find.byKey(const Key('sellerAssignedNote')), findsOneWidget);
    expect(find.byKey(const Key('sellerAssignedStock_5')), findsOneWidget);
    // The full editor's fields are not here.
    expect(find.text('Product Number'), findsNothing);
    expect(find.text('Description'), findsNothing);
  });

  testWidgets('saving sends only the seller\'s own fields', (tester) async {
    final repository = await _open(tester);

    await tester.enterText(find.byKey(const Key('sellerAssignedPrice')), '300');
    await tester.enterText(
      find.byKey(const Key('sellerAssignedStock_5')),
      '80',
    );
    await tester.tap(find.byKey(const Key('sellerAssignedSave')));
    await tester.pumpAndSettle();

    final input = repository.saved!.toInput();
    expect(input['price'], 300);
    expect(input['inventories'], [
      {'inventorySourceId': 5, 'qty': 80},
    ]);
    expect(input.containsKey('name'), isFalse);
    expect(input.containsKey('condition'), isFalse);
  });

  testWidgets('a price that is not a number is refused', (tester) async {
    final repository = await _open(tester);

    await tester.enterText(find.byKey(const Key('sellerAssignedPrice')), 'x');
    await tester.tap(find.byKey(const Key('sellerAssignedSave')));
    await tester.pump();

    expect(find.text('Enter a valid price'), findsOneWidget);
    expect(repository.saved, isNull);
  });
}
