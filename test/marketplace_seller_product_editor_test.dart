import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/models/seller_inventory_source.dart';
import 'package:bagisto_flutter/marketplace/features/inventory_sources/data/repository/seller_inventory_source_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_product_create_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_product_editor_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/pages/seller_product_editor_page.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/models/seller_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const _iri = SellerIri('/theme/api-4.9/public/api/seller/products/50');

const _stored = SellerProductDetail(
  iri: _iri,
  productId: 65,
  sku: 'demo-sneaker',
  name: 'Runner Sneakers',
  type: 'simple',
  status: 1,
  price: 74,
  urlKey: 'runner-sneakers',
  shortDescription: 'Running shoes',
  description: 'Comfortable running shoes.',
  quantity: 60,
  images: [SellerProductImage(url: 'http://example.com/a.jpg')],
  stocks: [
    SellerProductStock(
      sourceId: 5,
      sourceCode: 'default',
      sourceName: 'Default',
      qty: 60,
    ),
  ],
);

class _FakeProductRepository implements SellerProductRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
  _FakeProductRepository({
    this.categories = const [],
    this.variants = const [],
    this.saveError,
    this.categoriesError,
    this.createError,
    this.detailResult = _stored,
  });

  final SellerProductDetail detailResult;
  final List<SellerProductCategoryNode> categories;
  final List<SellerProductListItem> variants;
  final SellerApiException? saveError;
  final SellerApiException? categoriesError;
  final SellerApiException? createError;

  Map<String, dynamic>? lastUpdateInput;
  String? createdSku;
  Map<String, dynamic>? createArgs;
  List<int>? lastDeletedCatalogueIds;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProductDetail> detail(SellerIri iri) async => detailResult;

  @override
  Future<List<SellerProductCategoryNode>> assignableCategories() async {
    if (categoriesError != null) throw categoriesError!;
    return categories;
  }

  @override
  Future<SellerProductDetail> update(SellerProductDraft draft) async {
    lastUpdateInput = draft.toInput();
    if (saveError != null) throw saveError!;
    return detailResult;
  }

  @override
  Future<SellerProductDetail> updateVariants({
    required SellerIri iri,
    required List<Map<String, dynamic>> variants,
  }) async => detailResult;

  @override
  Future<SellerProductListItem> create({
    required String type,
    required int attributeFamilyId,
    required String sku,
    bool isDraft = false,
    List<Map<String, dynamic>>? superAttributes,
  }) async {
    if (createError != null) throw createError!;
    createdSku = sku;
    createArgs = {
      'type': type,
      'attributeFamilyId': attributeFamilyId,
      'isDraft': isDraft,
    };
    return SellerProductListItem(
      iri: const SellerIri('/api/seller/products/77'),
      productId: 91,
      sku: sku,
      name: '',
      type: type,
    );
  }

  final variantWrites = <SellerVariantEdit>[];

  String? requestedVariantSku;

  @override
  Future<void> delete(SellerIri iri) async {}

  @override
  Future<SellerProductDeleteBatch> deleteBatch(List<int> catalogueIds) async {
    lastDeletedCatalogueIds = catalogueIds;
    return const SellerProductDeleteBatch(
      requested: 0,
      deleted: 0,
      unassigned: 0,
      skipped: 0,
    );
  }

  @override
  Future<PaginatedResult<SellerProductListItem>> list({
    int page = 1,
    SellerProductFilters filters = const SellerProductFilters(),
  }) => throw UnimplementedError();
}

class _FakeInventoryRepository implements SellerInventorySourceRepository {
  _FakeInventoryRepository({this.sources = const []});

  final List<SellerInventorySource> sources;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<PaginatedResult<SellerInventorySource>> list({
    int page = 1,
    String? search,
    int? status,
  }) async => PaginatedResult<SellerInventorySource>(
    items: sources,
    totalCount: sources.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<SellerInventorySource> create(SellerInventorySourceInput input) =>
      throw UnimplementedError();

  @override
  Future<SellerInventorySource> update(
    SellerIri iri,
    SellerInventorySourceInput input,
  ) => throw UnimplementedError();

  @override
  Future<void> delete(SellerIri iri) => throw UnimplementedError();
}

SellerProductEditorCubit _editor({
  _FakeProductRepository? products,
  _FakeInventoryRepository? inventory,
}) {
  return SellerProductEditorCubit(
    productRepository: products ?? _FakeProductRepository(),
    inventoryRepository: inventory ?? _FakeInventoryRepository(),
    iri: _iri,
  );
}

void main() {
  Future<void> openEditor(
    WidgetTester tester,
    SellerProductEditorCubit cubit,
  ) async {
    await cubit.load();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SellerProductEditorCubit>.value(
          value: cubit,
          child: const SellerProductEditorPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('URL key follows the name after switching locales', (
    tester,
  ) async {
    final japanese = _FakeProductRepository(
      detailResult: const SellerProductDetail(
        iri: _iri,
        productId: 65,
        sku: 'demo-sneaker',
        name: 'Rental booth',
        type: 'simple',
        urlKey: 'existing-japanese-key',
      ),
    );
    final cubit = SellerProductEditorCubit(
      productRepository: _FakeProductRepository(),
      inventoryRepository: _FakeInventoryRepository(),
      iri: _iri,
      repositoryForLocale: (_) => japanese,
      loadLocales: () async => const [
        SellerLocale(code: 'en', name: 'English'),
        SellerLocale(code: 'ja', name: 'Japanese'),
      ],
    );
    addTearDown(cubit.close);
    await openEditor(tester, cubit);

    final name = find.byKey(const Key('sellerProductField_name'));
    final urlKey = find.byKey(const Key('sellerProductField_urlKey'));
    await tester.enterText(urlKey, 'custom-english-key');
    await tester.enterText(name, 'Runner Sneakers updated');
    expect(
      tester.widget<TextField>(urlKey).controller!.text,
      'runner-sneakers-updated',
    );

    await cubit.setLocale('ja');
    await tester.pumpAndSettle();

    await tester.enterText(name, 'Rental booth updated');
    expect(
      tester.widget<TextField>(urlKey).controller!.text,
      'rental-booth-updated',
    );

    await tester.enterText(urlKey, 'custom-japanese-key');
    expect(
      tester.widget<TextField>(urlKey).controller!.text,
      'custom-japanese-key',
    );
    await tester.enterText(name, 'Rental booth final');
    expect(
      tester.widget<TextField>(urlKey).controller!.text,
      'rental-booth-final',
    );

    await tester.enterText(urlKey, '');
    await tester.enterText(name, 'レンタル 商品');
    expect(tester.widget<TextField>(urlKey).controller!.text, 'レンタル-商品');
  });

  for (final entry in {
    'name': 'General',
    'urlKey': 'General',
    'shortDescription': 'Description',
    'description': 'Description',
    'price': 'Price',
  }.entries) {
    testWidgets('save blocks blank ${entry.key}', (tester) async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      addTearDown(cubit.close);
      await openEditor(tester, cubit);
      await tester.tap(find.widgetWithText(Tab, entry.value));
      await tester.pumpAndSettle();
      final field = find.byKey(Key('sellerProductField_${entry.key}'));
      await tester.ensureVisible(field);
      await tester.enterText(field, '   ');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repository.lastUpdateInput, isNull);
      expect(tester.widget<TextField>(field).decoration!.errorText, isNotNull);
    });
  }

  testWidgets('save validates required fields on unopened tabs', (
    tester,
  ) async {
    final repository = _FakeProductRepository(
      detailResult: const SellerProductDetail(
        iri: _iri,
        productId: 65,
        sku: 'new',
        name: 'New',
        type: 'simple',
        urlKey: 'new',
      ),
    );
    final cubit = _editor(products: repository);
    addTearDown(cubit.close);
    await openEditor(tester, cubit);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repository.lastUpdateInput, isNull);
    expect(
      find.textContaining('Short description is required'),
      findsOneWidget,
    );
  });

  for (final clearExisting in [false, true]) {
    testWidgets('variant price required, clear existing: $clearExisting', (
      tester,
    ) async {
      final repository = _FakeProductRepository(
        detailResult: SellerProductDetail(
          iri: _iri,
          productId: 65,
          sku: 'parent',
          name: 'Parent',
          type: 'configurable',
          urlKey: 'parent',
          price: 74,
          shortDescription: 'Short',
          description: 'Full',
          variants: [
            SellerProductVariant(
              variantId: 71,
              sku: 'parent-red',
              name: 'Red',
              price: clearExisting ? 20 : null,
            ),
          ],
        ),
      );
      final cubit = _editor(products: repository);
      addTearDown(cubit.close);
      await openEditor(tester, cubit);
      if (clearExisting) {
        await tester.ensureVisible(find.widgetWithText(Tab, 'Variants'));
        await tester.tap(find.widgetWithText(Tab, 'Variants'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('variantPrice_71')), '');
        await tester.ensureVisible(find.widgetWithText(Tab, 'General'));
        await tester.tap(find.widgetWithText(Tab, 'General'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repository.lastUpdateInput, isNull);
      expect(find.text('Variants: Price is required'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(Tab, 'Variants'));
      await tester.tap(find.widgetWithText(Tab, 'Variants'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('variantPrice_71')), '0');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repository.lastUpdateInput!['variants'][0]['price'], 0);
    });
  }

  for (final initiallyEnabled in [false, true]) {
    testWidgets(
      'variant price required regardless of enabled switch ($initiallyEnabled)',
      (tester) async {
        final repository = _FakeProductRepository(
          detailResult: SellerProductDetail(
            iri: _iri,
            productId: 65,
            sku: 'parent',
            name: 'Parent',
            type: 'configurable',
            urlKey: 'parent',
            price: 74,
            shortDescription: 'Short',
            description: 'Full',
            variants: [
              SellerProductVariant(
                variantId: 71,
                sku: 'parent-red',
                status: initiallyEnabled,
              ),
              const SellerProductVariant(
                variantId: 72,
                sku: 'parent-blue',
                price: 25,
              ),
            ],
          ),
        );
        final cubit = _editor(products: repository);
        addTearDown(cubit.close);
        await openEditor(tester, cubit);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(repository.lastUpdateInput, isNull);
        expect(find.text('Variants: Price is required'), findsOneWidget);
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.widgetWithText(Tab, 'Variants'));
        await tester.tap(find.widgetWithText(Tab, 'Variants'));
        await tester.pumpAndSettle();
        final priceField = find.byKey(const Key('variantPrice_71'));
        InputDecoration priceDecoration() => tester
            .widget<TextField>(
              find.descendant(of: priceField, matching: find.byType(TextField)),
            )
            .decoration!;
        final toggle = find.byKey(const Key('variantStatus_71'));
        expect(priceDecoration().errorText, 'Price is required');
        expect(priceDecoration().labelText, 'Price *');
        await tester.ensureVisible(toggle);
        await tester.tap(toggle);
        await tester.pumpAndSettle();
        expect(priceDecoration().errorText, 'Price is required');
        expect(priceDecoration().labelText, 'Price *');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(repository.lastUpdateInput, isNull);
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
        await tester.ensureVisible(priceField);
        await tester.enterText(priceField, '20');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(
          repository.lastUpdateInput?['variants'][0]['status'],
          initiallyEnabled ? 0 : 1,
        );
        expect(repository.lastUpdateInput?['variants'][0]['price'], 20);
      },
    );
  }

  for (final value in ['abc', 'NaN', 'Infinity']) {
    testWidgets('save blocks invalid price $value', (tester) async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      addTearDown(cubit.close);
      await openEditor(tester, cubit);
      await tester.tap(find.widgetWithText(Tab, 'Price'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('sellerProductField_price')),
        value,
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repository.lastUpdateInput, isNull);
      expect(find.text('Enter a valid price'), findsWidgets);
    });
  }

  testWidgets('editor previews picked data URI product images', (tester) async {
    const dataUri =
        'data:image/png;base64,'
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/p9sAAAAASUVORK5CYII=';
    final cubit = _editor();
    await cubit.load();
    cubit.setImages(const [dataUri]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SellerProductEditorCubit>.value(
          value: cubit,
          child: const SellerProductEditorPage(),
        ),
      ),
    );

    await tester.tap(find.text('Images'));
    await tester.pumpAndSettle();

    final preview = tester.widget<Image>(find.byType(Image));
    expect(preview.gaplessPlayback, isTrue);
    expect(find.byIcon(Icons.image_outlined), findsNothing);

    await cubit.close();
  });

  testWidgets('editor returns changed when popped after a save', (
    tester,
  ) async {
    final cubit = _editor();
    await cubit.load();

    bool? editorResult;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              editorResult = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<SellerProductEditorCubit>.value(
                    value: cubit,
                    child: const SellerProductEditorPage(),
                  ),
                ),
              );
            },
            child: const Text('Open editor'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('sellerProductField_name')),
      'Runner Sneakers v2',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(editorResult, isTrue);

    await cubit.close();
  });

  group('create cubit', () {
    test('creating sends the chosen type, family and draft flag', () async {
      final repository = _FakeProductRepository();
      final cubit = SellerProductCreateCubit(repository: repository);

      await cubit.submit(
        type: 'virtual',
        sku: 'new-sku',
        attributeFamilyId: 3,
        isDraft: true,
      );

      expect(cubit.state.status, SellerProductCreateStatus.created);
      expect(repository.createdSku, 'new-sku');
      expect(repository.createArgs, {
        'type': 'virtual',
        'attributeFamilyId': 3,
        'isDraft': true,
      });
      expect(cubit.state.created?.iri.numericId, 77);
    });

    test('a rejected create surfaces the server message', () async {
      final cubit = SellerProductCreateCubit(
        repository: _FakeProductRepository(
          createError: const SellerApiException(
            'The SKU has already been taken.',
            SellerApiFailure.validation,
          ),
        ),
      );

      await cubit.submit(type: 'simple', sku: 'taken', attributeFamilyId: 1);

      expect(cubit.state.status, SellerProductCreateStatus.failed);
      expect(cubit.state.errorMessage, 'The SKU has already been taken.');
    });
  });

  group('editor cubit', () {
    test('load brings the product, categories and stock locations', () async {
      final cubit = _editor(
        products: _FakeProductRepository(
          categories: const [
            SellerProductCategoryNode(id: 2, name: 'Mens', level: 1),
          ],
        ),
        inventory: _FakeInventoryRepository(
          sources: const [
            SellerInventorySource(
              iri: SellerIri('/api/seller/inventory-sources/5'),
              id: 5,
              code: 'default',
              name: 'Default',
              status: true,
            ),
          ],
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerProductEditorStatus.ready);
      expect(cubit.state.product?.name, 'Runner Sneakers');
      expect(cubit.state.categories.single.name, 'Mens');
      expect(cubit.state.stockLocations.single.id, 5);
    });

    test('a restricted category list does not break the editor', () async {
      final cubit = _editor(
        products: _FakeProductRepository(
          categoriesError: const SellerApiException(
            'You do not have permission to perform this action.',
            SellerApiFailure.forbidden,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerProductEditorStatus.ready);
      expect(cubit.state.categories, isEmpty);
    });

    test('saving an untouched product sends nothing', () async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      await cubit.load();

      final ok = await cubit.save();

      expect(ok, isTrue);
      expect(repository.lastUpdateInput, isNull);
    });

    test('editing the name sends only the id and the name', () async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      await cubit.load();

      cubit.edit((draft) => draft.copyWith(name: 'Runner Sneakers v2'));
      await cubit.save();

      expect(repository.lastUpdateInput, {
        'id': _iri.value,
        'name': 'Runner Sneakers v2',
      });
    });

    test('adding an image resends the whole image list', () async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      await cubit.load();

      cubit.setImages([...cubit.currentImages, 'data:image/png;base64,AAA']);
      await cubit.save();

      expect(repository.lastUpdateInput?['images'], [
        'http://example.com/a.jpg',
        'data:image/png;base64,AAA',
      ]);
    });

    test('changing one stock row sends every row', () async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      await cubit.load();

      cubit.setStock(6, 12);
      await cubit.save();

      expect(repository.lastUpdateInput?['inventories'], [
        {'inventorySourceId': 5, 'qty': 60},
        {'inventorySourceId': 6, 'qty': 12},
      ]);
    });

    test('zeroing stock is sent rather than dropped', () async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      await cubit.load();

      cubit.setStock(5, 0);
      await cubit.save();

      expect(repository.lastUpdateInput?['inventories'], [
        {'inventorySourceId': 5, 'qty': 0},
      ]);
    });

    test(
      'a configurable loads its variants and edits them by core id',
      () async {
        final repository = _FakeProductRepository(
          variants: [
            SellerProductListItem(
              iri: const SellerIri('/api/seller/products/56'),
              productId: 71,
              sku: 'cfg-shirt-variant-1-6',
              name: 'Red / S',
              type: 'simple',
              price: 100,
            ),
          ],
        );
        final cubit = _editor(products: repository);
        await cubit.load();

        // The stored product is simple, so no lookup happens for it.
        expect(repository.requestedVariantSku, isNull);
        expect(cubit.state.variants, isEmpty);

        cubit.setVariants({
          71: const SellerVariantEdit(variantId: 71, price: 1200, status: true),
        });
        await cubit.save();

        expect(repository.lastUpdateInput?['variants'], [
          {'variantId': 71, 'price': 1200, 'status': 1},
        ]);
      },
    );

    test('variant delete waits for save and omits it from full list', () async {
      const configurable = SellerProductDetail(
        iri: _iri,
        productId: 65,
        sku: 'demo-shirt',
        name: 'Demo shirt',
        type: 'configurable',
        status: 1,
        variants: [
          SellerProductVariant(
            variantId: 71,
            listingId: 81,
            sku: 'demo-shirt-red',
            name: 'Red',
            price: 10,
          ),
          SellerProductVariant(
            variantId: 72,
            listingId: 82,
            sku: 'demo-shirt-blue',
            name: 'Blue',
            price: 12,
          ),
        ],
      );
      final repository = _FakeProductRepository(detailResult: configurable);
      final cubit = _editor(products: repository);
      addTearDown(cubit.close);
      await cubit.load();

      cubit.deleteVariant(71);

      expect(cubit.state.variants.map((variant) => variant.variantId), [72]);
      expect(repository.lastUpdateInput, isNull);
      expect(repository.lastDeletedCatalogueIds, isNull);

      await cubit.save();

      expect(
        (repository.lastUpdateInput!['variants'] as List).map(
          (variant) => (variant as Map)['variantId'],
        ),
        [72],
      );
      expect(repository.lastDeletedCatalogueIds, isNull);
    });

    test('booking configuration reaches the payload', () async {
      final repository = _FakeProductRepository();
      final cubit = _editor(products: repository);
      await cubit.load();

      cubit.setBooking(
        const SellerBookingConfig(
          type: 'event',
          qty: 100,
          tickets: [SellerBookingTicket(name: 'Gold', qty: 50, price: 1000)],
        ),
      );
      await cubit.save();

      final booking = repository.lastUpdateInput?['booking'] as Map;
      expect(booking['type'], 'event');
      expect((booking['tickets'] as List), hasLength(1));
    });

    test('a rejected save keeps the edits and shows the message', () async {
      final cubit = _editor(
        products: _FakeProductRepository(
          saveError: const SellerApiException(
            'The URL key has already been taken.',
            SellerApiFailure.validation,
          ),
        ),
      );
      await cubit.load();

      cubit.edit((draft) => draft.copyWith(urlKey: 'taken'));
      final ok = await cubit.save();

      expect(ok, isFalse);
      expect(cubit.state.errorMessage, 'The URL key has already been taken.');
      expect(cubit.state.draft?.urlKey, 'taken');
    });

    test('booking, virtual, and downloadable products do not have weight', () {
      const booking = SellerProductDetail(
        iri: _iri,
        productId: 1,
        sku: 'booking-1',
        name: 'Booking 1',
        type: 'booking',
      );
      const virtual = SellerProductDetail(
        iri: _iri,
        productId: 2,
        sku: 'virtual-1',
        name: 'Virtual 1',
        type: 'virtual',
      );
      const downloadable = SellerProductDetail(
        iri: _iri,
        productId: 3,
        sku: 'dl-1',
        name: 'Downloadable 1',
        type: 'downloadable',
      );
      const simpleWithoutWeightAttr = SellerProductDetail(
        iri: _iri,
        productId: 4,
        sku: 'simple-1',
        name: 'Simple 1',
        type: 'simple',
        attributes: [
          SellerProductAttributeValue(
            code: 'price',
            name: 'Price',
            type: 'price',
          ),
        ],
      );
      const simpleWithWeightAttr = SellerProductDetail(
        iri: _iri,
        productId: 5,
        sku: 'simple-2',
        name: 'Simple 2',
        type: 'simple',
        attributes: [
          SellerProductAttributeValue(
            code: 'weight',
            name: 'Weight',
            type: 'text',
          ),
        ],
      );

      expect(booking.hasWeight, isFalse);
      expect(virtual.hasWeight, isFalse);
      expect(downloadable.hasWeight, isFalse);
      expect(simpleWithoutWeightAttr.hasWeight, isFalse);
      expect(simpleWithWeightAttr.hasWeight, isTrue);
    });

    testWidgets(
      'booking product does not show weight and saves without weight error',
      (tester) async {
        final repository = _FakeProductRepository(
          detailResult: const SellerProductDetail(
            iri: _iri,
            productId: 90,
            sku: 'booking-service',
            name: 'Booking Service',
            type: 'booking',
            urlKey: 'booking-service',
            price: 150,
            shortDescription: 'Service short description',
            description: 'Service full description',
          ),
        );
        final cubit = _editor(products: repository);
        addTearDown(cubit.close);
        await openEditor(tester, cubit);

        // Weight field should not be present in the UI
        expect(
          find.byKey(const Key('sellerProductField_weight')),
          findsNothing,
        );

        // Make a change via cubit and tap Save
        cubit.setBooking(const SellerBookingConfig(type: 'event', qty: 50));
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Should validate successfully without complaining about weight
        expect(find.text('Weight is required'), findsNothing);
        expect(repository.lastUpdateInput, isNotNull);
        expect(repository.lastUpdateInput?.containsKey('weight'), isFalse);
      },
    );

    for (final rentingType in ['daily', 'hourly', 'daily_and_hourly']) {
      testWidgets('rental $rentingType requires its visible price', (
        tester,
      ) async {
        final repository = _FakeProductRepository(
          detailResult: SellerProductDetail(
            iri: _iri,
            productId: 91,
            sku: 'rental-product',
            name: 'Rental Product',
            type: 'booking',
            urlKey: 'rental-product',
            price: 150,
            shortDescription: 'Short description',
            description: 'Full description',
            booking: SellerBookingConfig(
              type: 'rental',
              qty: 1,
              location: 'Noida',
              availableEveryWeek: true,
              rentingType: rentingType,
            ),
          ),
        );
        final cubit = _editor(products: repository);
        addTearDown(cubit.close);
        await openEditor(tester, cubit);

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(repository.lastUpdateInput, isNull);
        expect(
          find.text(
            rentingType == 'hourly'
                ? 'Hourly Price is required'
                : 'Daily Price is required',
          ),
          findsOneWidget,
        );
      });
    }

    testWidgets('rental save requires positive quantity', (tester) async {
      final repository = _FakeProductRepository(
        detailResult: const SellerProductDetail(
          iri: _iri,
          productId: 91,
          sku: 'rental-product',
          name: 'Rental Product',
          type: 'booking',
          urlKey: 'rental-product',
          price: 150,
          shortDescription: 'Short description',
          description: 'Full description',
          booking: SellerBookingConfig(
            type: 'rental',
            qty: 0,
            location: 'Noida',
            availableEveryWeek: true,
            rentingType: 'hourly',
            hourlyPrice: 588,
          ),
        ),
      );
      final cubit = _editor(products: repository);
      addTearDown(cubit.close);
      await openEditor(tester, cubit);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repository.lastUpdateInput, isNull);
      expect(find.text('Qty is required'), findsOneWidget);
    });

    for (final missing in ['from', 'to']) {
      testWidgets('default booking requires available $missing on save', (
        tester,
      ) async {
        final repository = _FakeProductRepository(
          detailResult: SellerProductDetail(
            iri: _iri,
            productId: 91,
            sku: 'default-booking',
            name: 'Default Booking',
            type: 'booking',
            urlKey: 'default-booking',
            price: 150,
            shortDescription: 'Short description',
            description: 'Full description',
            booking: SellerBookingConfig(
              type: 'default',
              location: 'Noida',
              availableFrom: missing == 'from' ? null : '2026-11-03 00:00:00',
              availableTo: missing == 'to' ? null : '2026-11-10 23:59:59',
            ),
          ),
        );
        final cubit = _editor(products: repository);
        addTearDown(cubit.close);
        await openEditor(tester, cubit);

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(repository.lastUpdateInput, isNull);
        expect(
          find.text(
            missing == 'from'
                ? 'Available from is required'
                : 'Available to is required',
          ),
          findsOneWidget,
        );
      });
    }

    testWidgets('table save requires guest capacity and slot settings', (
      tester,
    ) async {
      final repository = _FakeProductRepository(
        detailResult: const SellerProductDetail(
          iri: _iri,
          productId: 91,
          sku: 'table-product',
          name: 'Table Product',
          type: 'booking',
          urlKey: 'table-product',
          price: 150,
          shortDescription: 'Short description',
          description: 'Full description',
          booking: SellerBookingConfig(
            type: 'table',
            qty: 1,
            location: 'Noida',
            availableEveryWeek: true,
            priceType: 'per_guest',
            guestLimit: 4,
          ),
        ),
      );
      final cubit = _editor(products: repository);
      addTearDown(cubit.close);
      await openEditor(tester, cubit);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repository.lastUpdateInput, isNull);
      expect(find.text('Slot Duration (Mins) is required'), findsOneWidget);
      expect(find.text('Prevent Scheduling Before is required'), findsNothing);
    });
  });
}
