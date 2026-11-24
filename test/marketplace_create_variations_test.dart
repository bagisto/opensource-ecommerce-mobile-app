import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_configurable_attributes_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_product_create_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/pages/seller_product_create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Creating a configurable, as the panel asks it.
///
/// The panel asks one question — which attributes vary — and every option the
/// ticked attributes carry becomes an axis of the grid. The app used to ask a
/// second question the panel does not, making the seller pick the options one
/// by one.
class _Attributes implements SellerConfigurableAttributesRepository {
  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  GraphQLClient? get sellerClient => null;

  @override
  Future<List<SellerConfigurableAttribute>> load() => forFamily(1);

  @override
  Future<List<SellerConfigurableAttribute>> forFamily(int familyId) async => [
    const SellerConfigurableAttribute(
      code: 'color',
      name: 'Color',
      options: [
        SellerProductCategoryRef(id: '1', name: 'Red'),
        SellerProductCategoryRef(id: '2', name: 'Green'),
      ],
    ),
    const SellerConfigurableAttribute(
      code: 'size',
      name: 'Size',
      options: [
        SellerProductCategoryRef(id: '6', name: 'S'),
        SellerProductCategoryRef(id: '7', name: 'M'),
      ],
    ),
  ];
}

class _Products implements SellerProductRepository {
  Map<String, dynamic>? lastCreate;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProductListItem> create({
    required String type,
    required int attributeFamilyId,
    required String sku,
    bool isDraft = false,
    List<Map<String, dynamic>>? superAttributes,
  }) async {
    lastCreate = {'type': type, 'sku': sku, 'superAttributes': superAttributes};
    return SellerProductListItem(
      iri: const SellerIri('/api/seller/products/1'),
      productId: 1,
      sku: sku,
      name: sku,
      type: type,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<_Products> _open(WidgetTester tester) async {
  final products = _Products();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) => SellerProductCreateCubit(
          repository: products,
          attributes: _Attributes(),
        ),
        child: const SellerProductCreatePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return products;
}

/// Turns the product into one that varies, as the panel's Yes does.
Future<void> _wantsVariations(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('sellerProductHasVariations')));
  await tester.pumpAndSettle();
}

/// Brings a control into view. The form is taller than the test viewport, and
/// a list only builds what is on screen.
Future<void> _reveal(WidgetTester tester, Key key) async {
  await tester.dragUntilVisible(
    find.byKey(key),
    find.byType(ListView),
    const Offset(0, -120),
  );
  await tester.pumpAndSettle();
}

/// Taps a control, scrolling to it first.
Future<void> _tap(WidgetTester tester, Key key) async {
  await _reveal(tester, key);
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the kinds are named, not the API codes', (tester) async {
    await _open(tester);

    expect(find.text('Physical product'), findsOneWidget);
    expect(find.text('Digital download'), findsOneWidget);
    // The dropdown used to offer these raw.
    expect(find.text('configurable'), findsNothing);
    expect(find.text('downloadable'), findsNothing);
  });

  testWidgets('the seller is asked which attributes vary, and nothing else', (
    tester,
  ) async {
    // The panel asks this one question. Ticking an attribute used to open a
    // second, "Which Color options?", which the panel never asks.
    await _open(tester);
    await _wantsVariations(tester);

    await _reveal(tester, const Key('variantAttribute_color'));
    expect(find.byKey(const Key('variantAttribute_color')), findsOneWidget);
    expect(find.byKey(const Key('variantAttribute_size')), findsOneWidget);

    await _tap(tester, const Key('variantAttribute_color'));

    expect(find.byKey(const Key('variantOption_color_1')), findsNothing);
    expect(find.text('Which Color options?'), findsNothing);
  });

  testWidgets('configurable creation sends all family attributes with options', (
    tester,
  ) async {
    final products = await _open(tester);
    await _wantsVariations(tester);

    await _tap(tester, const Key('variantAttribute_color'));

    await _reveal(tester, const Key('sellerProductCreateSku'));
    await tester.enterText(
      find.byKey(const Key('sellerProductCreateSku')),
      'varies-by-colour',
    );
    await _tap(tester, const Key('sellerProductCreateSubmit'));

    expect(products.lastCreate?['type'], 'configurable');
    final sent = products.lastCreate?['superAttributes'] as List?;
    expect(sent, hasLength(2));
    final codes = sent!.map((s) => (s as Map)['attributeCode']).toSet();
    expect(codes, containsAll(['color', 'size']));
  });

  testWidgets('a product that varies by nothing is refused before sending', (
    tester,
  ) async {
    // The server's own rule: "A configurable product requires at least one
    // attribute with options."
    final products = await _open(tester);
    await _wantsVariations(tester);

    await _reveal(tester, const Key('sellerProductCreateSku'));
    await tester.enterText(
      find.byKey(const Key('sellerProductCreateSku')),
      'no-attributes',
    );
    await _tap(tester, const Key('sellerProductCreateSubmit'));

    expect(products.lastCreate, isNull);
    expect(
      find.text('Choose at least one attribute the product varies by'),
      findsOneWidget,
    );
  });

  testWidgets('a product that does not vary is created as simple', (
    tester,
  ) async {
    final products = await _open(tester);

    await _reveal(tester, const Key('sellerProductCreateSku'));
    await tester.enterText(
      find.byKey(const Key('sellerProductCreateSku')),
      'plain-shirt',
    );
    await _tap(tester, const Key('sellerProductCreateSubmit'));

    expect(products.lastCreate?['type'], 'simple');
    expect(products.lastCreate?['superAttributes'], isNull);
  });
}
