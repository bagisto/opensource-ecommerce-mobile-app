import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/catalogue_tools/data/models/seller_catalogue_tools.dart';
import 'package:bagisto_flutter/marketplace/features/catalogue_tools/data/repository/seller_catalogue_tools_repository.dart';
import 'package:bagisto_flutter/marketplace/features/catalogue_tools/presentation/bloc/seller_assign_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/catalogue_tools/presentation/bloc/seller_barcode_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/catalogue_tools/presentation/bloc/seller_magic_ai_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/catalogue_tools/presentation/pages/seller_assign_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeToolsRepository implements SellerCatalogueToolsRepository {
  _FakeToolsRepository({
    this.pages = const {},
    this.storedBarcode,
    this.magicAi,
    this.suggestion,
    this.failWith,
  });

  final Map<int, PaginatedResult<SellerAssignableProduct>> pages;
  SellerBarcode? storedBarcode;
  final SellerMagicAiContext? magicAi;
  final SellerMagicAiSuggestion? suggestion;
  final SellerApiException? failWith;

  Map<String, dynamic>? lastAssignInput;
  String? lastBarcodeType;
  List<int>? lastBatchIds;
  Map<String, dynamic>? lastMagicAiCall;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<PaginatedResult<SellerAssignableProduct>> assignableProducts({
    int page = 1,
    String? search,
    String? type,
  }) async {
    if (failWith != null) throw failWith!;
    return pages[page] ??
        const PaginatedResult(
          items: [],
          totalCount: 0,
          lastPage: 1,
          currentPage: 1,
        );
  }

  @override
  Future<SellerAssignedProduct> assign(SellerAssignDraft draft) async {
    if (failWith != null) throw failWith!;
    lastAssignInput = draft.toInput();
    return SellerAssignedProduct(
      catalogueId: 101,
      productId: draft.productId,
      sku: 'SP-008',
      name: 'Puffer jacket',
      price: draft.price,
      condition: draft.condition,
    );
  }

  @override
  Future<SellerBarcode> barcode(int catalogueId) async {
    if (failWith != null) throw failWith!;
    return storedBarcode ?? SellerBarcode(catalogueId: catalogueId);
  }

  @override
  Future<SellerBarcode> generateBarcode(int catalogueId, {String? type}) async {
    if (failWith != null) throw failWith!;
    lastBarcodeType = type;
    storedBarcode = SellerBarcode(
      catalogueId: catalogueId,
      value: '000000000120',
      type: type,
    );
    return storedBarcode!;
  }

  @override
  Future<SellerBarcodeBatchResult> generateBarcodes(
    List<int> catalogueIds, {
    String? type,
  }) async {
    if (failWith != null) throw failWith!;
    lastBatchIds = catalogueIds;
    return SellerBarcodeBatchResult(
      type: type,
      requested: catalogueIds.length,
      generated: catalogueIds.length,
    );
  }

  @override
  Future<SellerBarcodePrintResult> printBarcodes(List<int> catalogueIds) async {
    if (failWith != null) throw failWith!;
    lastBatchIds = catalogueIds;
    return SellerBarcodePrintResult(
      requested: catalogueIds.length,
      printable: catalogueIds.length,
      downloadUrl: 'http://example.test/print.pdf',
    );
  }

  @override
  Future<SellerMagicAiContext> magicAiContext(int catalogueId) async {
    if (failWith != null) throw failWith!;
    return magicAi ?? SellerMagicAiContext(productId: catalogueId);
  }

  @override
  Future<SellerMagicAiSuggestion> generateWithMagicAi({
    required int productId,
    required String description,
    List<String> images = const [],
    List<String> attributes = const [],
  }) async {
    if (failWith != null) throw failWith!;
    lastMagicAiCall = {
      'productId': productId,
      'description': description,
      'images': images,
      'attributes': attributes,
    };
    return suggestion ?? SellerMagicAiSuggestion(productId: productId);
  }
}

const _assignable = SellerAssignableProduct(
  productId: 106,
  sku: 'SP-008',
  name: 'Puffer jacket',
  price: 21,
  sellersCount: 1,
);

void main() {
  group('SellerAssignDraft', () {
    test('sends inventories as records, not a source-to-quantity map', () {
      const draft = SellerAssignDraft(
        productId: 106,
        price: 19.5,
        stocks: {5: 8},
      );

      // A map here is rejected by the server as "Invalid inventory source".
      expect(draft.toInput()['inventories'], [
        {'inventorySourceId': 5, 'qty': 8},
      ]);
    });

    test('leaves out an empty description and empty stock', () {
      const draft = SellerAssignDraft(productId: 106, price: 19.5);
      final input = draft.toInput();

      expect(input.containsKey('description'), isFalse);
      expect(input.containsKey('inventories'), isFalse);
      expect(input['condition'], 'new');
    });
  });

  group('SellerAssignCubit', () {
    testWidgets('the offer sheet fits a long stock source beside quantity', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cubit = SellerAssignCubit(
        repository: _FakeToolsRepository(
          pages: {
            1: const PaginatedResult(
              items: [
                SellerAssignableProduct(
                  productId: 106,
                  sku: 'BP-001',
                  name: 'Arctic Frost Winter Accessories Bundle',
                  price: 21,
                ),
              ],
              totalCount: 1,
              lastPage: 1,
              currentPage: 1,
            ),
          },
        ),
      );
      await cubit.load();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const SellerAssignPage(
              stockSources: [
                (
                  id: 5,
                  name: 'Atlas Outfitters Warehouse With Extra Long Name',
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Sell this'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Sell this opens the full assign page and submits the offer', (
      tester,
    ) async {
      final repository = _FakeToolsRepository(
        pages: {
          1: const PaginatedResult(
            items: [
              SellerAssignableProduct(
                productId: 744,
                sku: 'test',
                name: 'Admin test',
                price: 234,
              ),
            ],
            totalCount: 1,
            lastPage: 1,
            currentPage: 1,
          ),
        },
      );
      final cubit = SellerAssignCubit(repository: repository);
      await cubit.load();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const SellerAssignPage(
              stockSources: [(id: 5, name: 'Default')],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Sell this'));
      await tester.pumpAndSettle();

      // A page, not a sheet: it has its own app bar.
      expect(find.text('Assign Product'), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text('Product Details'), findsOneWidget);
      expect(
        find.byKey(const Key('sellerAssignOriginalPrice')),
        findsOneWidget,
      );
      expect(find.text('Condition *'), findsOneWidget);
      expect(find.text('Your price *'), findsOneWidget);
      expect(find.text('Your description *'), findsOneWidget);
      expect(find.text('0/300'), findsOneWidget);

      // The price starts empty; submitting without one is refused.
      final price = tester.widget<TextField>(
        find.byKey(const Key('sellerAssignPrice')),
      );
      expect(price.controller!.text, isEmpty);

      await tester.enterText(find.byKey(const Key('sellerAssignPrice')), '250');
      await tester.enterText(
        find.byKey(const Key('sellerAssignDescription')),
        'Fresh stock',
      );
      await tester.tap(find.byKey(const Key('sellerAssignSubmit')));
      await tester.pumpAndSettle();

      expect(repository.lastAssignInput, isNotNull);
      expect(find.text('Assign Product'), findsNothing);
    });

    testWidgets(
      'tapping an already-sold product explains instead of opening the offer sheet',
      (tester) async {
        final cubit = SellerAssignCubit(
          repository: _FakeToolsRepository(
            pages: {
              1: const PaginatedResult(
                items: [
                  SellerAssignableProduct(
                    productId: 744,
                    sku: 'ddaad',
                    name: 'Sold product',
                    price: 10,
                    isAlreadySelling: true,
                  ),
                ],
                totalCount: 1,
                lastPage: 1,
                currentPage: 1,
              ),
            },
          ),
        );
        await cubit.load();

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider.value(
              value: cubit,
              child: const SellerAssignPage(stockSources: []),
            ),
          ),
        );

        expect(find.text('Sell this'), findsOneWidget);
        expect(find.text('You are already selling this product'), findsNothing);

        await tester.tap(find.text('Sold product'));
        await tester.pumpAndSettle();

        expect(find.byType(BottomSheet), findsNothing);
        expect(
          find.text('You are already selling this product'),
          findsOneWidget,
        );
      },
    );

    test('isAlreadySelling is read from the server row', () {
      final row = SellerAssignableProduct.fromJson({
        'id': 744,
        'sku': 'ddaad',
        'name': 'x',
        'isAlreadySelling': true,
      });
      final other = SellerAssignableProduct.fromJson({'id': 1});

      expect(row.isAlreadySelling, isTrue);
      expect(other.isAlreadySelling, isFalse);
    });

    test('load reads the products this seller could sell', () async {
      final cubit = SellerAssignCubit(
        repository: _FakeToolsRepository(
          pages: {
            1: const PaginatedResult(
              items: [_assignable],
              totalCount: 1,
              lastPage: 1,
              currentPage: 1,
            ),
          },
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerAssignStatus.loaded);
      expect(cubit.state.products.single.productId, 106);
    });

    test(
      'an assigned product stays in the list, marked as already sold',
      () async {
        final repository = _FakeToolsRepository(
          pages: {
            1: const PaginatedResult(
              items: [_assignable],
              totalCount: 1,
              lastPage: 1,
              currentPage: 1,
            ),
          },
        );
        final cubit = SellerAssignCubit(repository: repository);

        await cubit.load();
        final ok = await cubit.assign(
          const SellerAssignDraft(productId: 106, price: 19.5, stocks: {5: 8}),
        );

        expect(ok, isTrue);
        expect(cubit.state.products.single.isAlreadySelling, isTrue);
        expect(cubit.state.totalCount, 1);
        expect(cubit.state.assigned?.catalogueId, 101);
        expect(repository.lastAssignInput?['productId'], 106);
      },
    );

    test('a rejected assign keeps the product and reports why', () async {
      final cubit = SellerAssignCubit(
        repository: _FakeToolsRepository(
          failWith: const SellerApiException(
            'Invalid inventory source.',
            SellerApiFailure.validation,
          ),
        ),
      );

      final ok = await cubit.assign(
        const SellerAssignDraft(productId: 106, price: 19.5),
      );

      expect(ok, isFalse);
      expect(cubit.state.errorMessage, 'Invalid inventory source.');
      expect(cubit.state.isSubmitting, isFalse);
    });
  });

  group('SellerBarcodeCubit', () {
    test(
      'load starts the picker on the symbology the server reports',
      () async {
        final cubit = SellerBarcodeCubit(
          repository: _FakeToolsRepository(
            storedBarcode: const SellerBarcode(catalogueId: 97, type: 'ean13'),
          ),
          catalogueId: 97,
        );

        await cubit.load();

        expect(cubit.state.status, SellerBarcodeStatus.loaded);
        expect(cubit.state.symbology, 'ean13');
        expect(cubit.state.barcode?.isGenerated, isFalse);
      },
    );

    test('generate sends the chosen symbology and keeps the result', () async {
      final repository = _FakeToolsRepository();
      final cubit = SellerBarcodeCubit(repository: repository, catalogueId: 97);

      await cubit.load();
      cubit.selectSymbology('code39');
      final ok = await cubit.generate();

      expect(ok, isTrue);
      expect(repository.lastBarcodeType, 'code39');
      expect(cubit.state.barcode?.value, '000000000120');
      expect(cubit.state.barcode?.isGenerated, isTrue);
    });
  });

  group('SellerBarcodeBatchCubit', () {
    test('generate reports how many were made', () async {
      final repository = _FakeToolsRepository();
      final cubit = SellerBarcodeBatchCubit(repository: repository);

      await cubit.generate([95, 96], type: 'code128');

      expect(repository.lastBatchIds, [95, 96]);
      expect(cubit.state.batch?.generated, 2);
      expect(cubit.state.batch?.skipped, 0);
    });

    test('print hands back the PDF link', () async {
      final cubit = SellerBarcodeBatchCubit(repository: _FakeToolsRepository());

      await cubit.print([95, 96]);

      expect(cubit.state.print?.printable, 2);
      expect(cubit.state.print?.downloadUrl, 'http://example.test/print.pdf');
    });

    test('an empty selection does nothing', () async {
      final repository = _FakeToolsRepository();
      final cubit = SellerBarcodeBatchCubit(repository: repository);

      await cubit.generate(const []);

      expect(repository.lastBatchIds, isNull);
      expect(cubit.state.batch, isNull);
    });
  });

  group('SellerMagicAiCubit', () {
    test('a marketplace with Magic AI off lands on unavailable, not an '
        'error', () async {
      final cubit = SellerMagicAiCubit(
        repository: _FakeToolsRepository(
          magicAi: const SellerMagicAiContext(
            productId: 120,
            disabledReason: 'globally',
          ),
        ),
        catalogueId: 97,
      );

      await cubit.load();

      expect(cubit.state.status, SellerMagicAiStatus.unavailable);
      expect(cubit.state.context?.disabledReason, 'globally');
    });

    test('generating while it is off does not call the server', () async {
      final repository = _FakeToolsRepository(
        magicAi: const SellerMagicAiContext(productId: 120),
      );
      final cubit = SellerMagicAiCubit(repository: repository, catalogueId: 97);

      await cubit.load();
      final ok = await cubit.generate(description: 'A brass desk lamp');

      expect(ok, isFalse);
      expect(repository.lastMagicAiCall, isNull);
    });

    test('generate sends the core product id, not the catalogue id', () async {
      final repository = _FakeToolsRepository(
        magicAi: const SellerMagicAiContext(
          productId: 120,
          enabled: true,
          allowImages: true,
          maxImages: 2,
          allowFieldSelection: true,
        ),
        suggestion: const SellerMagicAiSuggestion(
          productId: 120,
          values: {'name': 'Brass desk lamp'},
        ),
      );
      final cubit = SellerMagicAiCubit(repository: repository, catalogueId: 97);

      await cubit.load();
      cubit.toggleField('name');
      final ok = await cubit.generate(
        description: 'A brass desk lamp',
        images: const ['a.png', 'b.png', 'c.png'],
      );

      expect(ok, isTrue);
      expect(repository.lastMagicAiCall?['productId'], 120);
      expect(repository.lastMagicAiCall?['attributes'], ['name']);
      // Three images offered, two allowed.
      expect(repository.lastMagicAiCall?['images'], ['a.png', 'b.png']);
      expect(cubit.state.suggestion?.values['name'], 'Brass desk lamp');
    });

    test('an empty description is not worth a request', () async {
      final repository = _FakeToolsRepository(
        magicAi: const SellerMagicAiContext(productId: 120, enabled: true),
      );
      final cubit = SellerMagicAiCubit(repository: repository, catalogueId: 97);

      await cubit.load();
      final ok = await cubit.generate(description: '   ');

      expect(ok, isFalse);
      expect(repository.lastMagicAiCall, isNull);
    });
  });
}
