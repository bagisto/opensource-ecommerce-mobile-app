import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_filters.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_products_bloc.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/pages/seller_products_page.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_product_card.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_product_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubProductsBloc extends Bloc<SellerProductsEvent, SellerProductsState>
    implements SellerProductsBloc {
  _StubProductsBloc(super.initialState) {
    on<SellerProductsEvent>((event, emit) => received.add(event));
  }

  final List<SellerProductsEvent> received = [];

  @override
  SellerProductRepository get repository => throw UnimplementedError();
}

SellerProductListItem _item(String sku, {String name = 'Runner Sneakers'}) =>
    SellerProductListItem(
      iri: SellerIri('/theme/api-4.9/public/api/seller/products/50'),
      productId: 65,
      sku: sku,
      name: name,
      type: 'simple',
      price: 74,
      quantity: 60,
      approvalState: 'approved',
      isApproved: true,
    );

Widget _wrap(_StubProductsBloc bloc, {SellerProductsPage? page}) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider<SellerProductsBloc>.value(
        value: bloc,
        child: page ?? const SellerProductsPage(),
      ),
    ),
  );
}

Widget _filterSheetHarness(ThemeData theme) {
  return MaterialApp(
    theme: theme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) {
        return Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () => showSellerProductFilterSheet(
                context,
                current: const SellerProductFilters(),
              ),
              child: const Text('Open filters'),
            ),
          ),
        );
      },
    ),
  );
}

void main() {
  for (final themeCase in [
    (name: 'light', theme: AppTheme.lightTheme),
    (name: 'dark', theme: AppTheme.darkTheme),
  ]) {
    testWidgets(
      'selected filter chips use readable foreground in ${themeCase.name} theme',
      (tester) async {
        await tester.pumpWidget(_filterSheetHarness(themeCase.theme));

        await tester.tap(find.text('Open filters'));
        await tester.pumpAndSettle();

        final selectedChips = tester.widgetList<ChoiceChip>(
          find.byWidgetPredicate(
            (widget) => widget is ChoiceChip && widget.selected,
          ),
        );

        expect(selectedChips, isNotEmpty);
        for (final chip in selectedChips) {
          expect(chip.selectedColor, AppColors.primary500);
          expect(chip.labelStyle?.color, AppColors.white);
          expect(chip.checkmarkColor, AppColors.white);
        }
      },
    );
  }

  testWidgets('renders a row per product with its approval badge', (
    tester,
  ) async {
    final bloc = _StubProductsBloc(
      SellerProductsState(
        status: SellerProductsStatus.loaded,
        items: [
          _item('demo-sneaker'),
          _item('demo-lamp', name: 'Desk Lamp'),
        ],
        totalCount: 2,
        lastPage: 1,
      ),
    );

    await tester.pumpWidget(_wrap(bloc));
    await tester.pump();

    expect(find.byType(SellerProductCard), findsNWidgets(2));
    expect(find.text('Runner Sneakers'), findsOneWidget);
    expect(find.text('Desk Lamp'), findsOneWidget);
    expect(find.text('Approved'), findsNWidgets(2));
    expect(find.text('2 products'), findsOneWidget);
  });

  testWidgets('an empty catalogue explains itself', (tester) async {
    final bloc = _StubProductsBloc(
      const SellerProductsState(status: SellerProductsStatus.loaded),
    );

    await tester.pumpWidget(_wrap(bloc));
    await tester.pump();

    expect(find.text('No products yet'), findsOneWidget);
  });

  testWidgets('an empty filtered result says so instead', (tester) async {
    final bloc = _StubProductsBloc(
      const SellerProductsState(
        status: SellerProductsStatus.loaded,
        filters: SellerProductFilters(type: 'bundle'),
      ),
    );

    await tester.pumpWidget(_wrap(bloc));
    await tester.pump();

    expect(find.text('No products match these filters'), findsOneWidget);
  });

  testWidgets('a failure offers a retry that reloads', (tester) async {
    final bloc = _StubProductsBloc(
      const SellerProductsState(
        status: SellerProductsStatus.failed,
        errorMessage: 'Unauthorized.',
      ),
    );

    await tester.pumpWidget(_wrap(bloc));
    await tester.pump();

    expect(find.text('Unauthorized.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('sellerProductsRetry')));
    await tester.pump();

    expect(bloc.received.whereType<LoadSellerProducts>(), isNotEmpty);
  });

  testWidgets('submitting the search field dispatches the search', (
    tester,
  ) async {
    final bloc = _StubProductsBloc(
      SellerProductsState(
        status: SellerProductsStatus.loaded,
        items: [_item('demo-sneaker')],
        totalCount: 1,
        lastPage: 1,
      ),
    );

    await tester.pumpWidget(_wrap(bloc));
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('sellerProductsSearch')),
      'shoe',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    final search = bloc.received.whereType<SearchSellerProducts>().last;
    expect(search.term, 'shoe');
  });

  testWidgets('tapping a row reports the product to the host', (tester) async {
    final bloc = _StubProductsBloc(
      SellerProductsState(
        status: SellerProductsStatus.loaded,
        items: [_item('demo-sneaker')],
        totalCount: 1,
        lastPage: 1,
      ),
    );
    SellerProductListItem? opened;

    await tester.pumpWidget(
      _wrap(
        bloc,
        page: SellerProductsPage(
          onOpenProduct: (context, product) => opened = product,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(SellerProductCard).first);
    await tester.pump();

    expect(opened?.sku, 'demo-sneaker');
  });

  testWidgets(
    'shows green SnackBar with Product deleted successfully on deletion',
    (tester) async {
      final bloc = _StubProductsBloc(
        SellerProductsState(
          status: SellerProductsStatus.loaded,
          items: [_item('demo-sneaker')],
          totalCount: 1,
          lastPage: 1,
        ),
      );

      await tester.pumpWidget(_wrap(bloc));
      await tester.pump();

      bloc.emit(
        bloc.state.copyWith(
          lastBatch: const SellerProductDeleteBatch(
            deleted: 2,
            unassigned: 0,
            skipped: 0,
            requested: 2,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Product deleted successfully'), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, AppColors.successGreen);
    },
  );

  testWidgets('a selection offers barcode generate and print, like web', (
    tester,
  ) async {
    final bloc = _StubProductsBloc(
      SellerProductsState(
        status: SellerProductsStatus.loaded,
        items: [_item('demo-sneaker')],
        selected: const {50},
        totalCount: 1,
        lastPage: 1,
      ),
    );
    List<int>? generatedIds;
    String? generatedType;
    List<int>? printedIds;

    await tester.pumpWidget(
      _wrap(
        bloc,
        page: SellerProductsPage(
          onGenerateBarcodes: (ids, type) async {
            generatedIds = ids;
            generatedType = type;
            return '1 generated, 0 skipped';
          },
          onPrintBarcodes: (ids) async {
            printedIds = ids;
            return null;
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('sellerProductsBarcodeMenu')));
    await tester.pumpAndSettle();
    expect(find.text('Generate barcodes'), findsOneWidget);
    expect(find.text('Print barcodes'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sellerProductsGenerateBarcodes')));
    await tester.pumpAndSettle();
    expect(find.text('Code 128'), findsOneWidget);
    expect(find.text('EAN-13'), findsOneWidget);
    expect(find.text('UPC-A'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sellerBarcodeType_ean13')));
    await tester.pumpAndSettle();
    expect(generatedIds, [50]);
    expect(generatedType, 'ean13');
    expect(find.text('1 generated, 0 skipped'), findsOneWidget);
    // The selection ends and the list is read again.
    expect(bloc.received.whereType<ClearSellerProductSelection>(), isNotEmpty);
    expect(
      bloc.received.whereType<RefreshSellerProducts>().any((e) => e.silent),
      isTrue,
    );

    await tester.tap(find.byKey(const Key('sellerProductsBarcodeMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerProductsPrintBarcodes')));
    await tester.pumpAndSettle();
    expect(printedIds, [50]);
  });

  testWidgets('without the barcode permission the menu is absent', (
    tester,
  ) async {
    final bloc = _StubProductsBloc(
      SellerProductsState(
        status: SellerProductsStatus.loaded,
        items: [_item('demo-sneaker')],
        selected: const {50},
        totalCount: 1,
        lastPage: 1,
      ),
    );

    await tester.pumpWidget(_wrap(bloc));
    await tester.pump();

    expect(find.byKey(const Key('sellerProductsBarcodeMenu')), findsNothing);
    expect(
      find.byKey(const Key('sellerProductsDeleteSelected')),
      findsOneWidget,
    );
  });
}
