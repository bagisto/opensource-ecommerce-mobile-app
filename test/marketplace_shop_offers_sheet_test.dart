import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/models/shop_marketplace.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/bloc/shop_marketplace_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/pages/shop_offers_sheet.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/widgets/shop_product_report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers only the offers lookup; the sheet asks for nothing else.
class _Offers implements ShopMarketplaceRepository {
  bool flagEnabledValue = false;
  List<ShopFlagReason> reasonsValue = const [];

  @override
  Future<bool> flagEnabled({required String type}) async => flagEnabledValue;

  @override
  Future<List<ShopFlagReason>> flagReasons({String? type}) async =>
      reasonsValue;

  @override
  Future<List<ShopProductOffer>> productOffers(String urlKey) async => const [
    ShopProductOffer(
      listingId: 715,
      sellerId: 38,
      sellerName: 'Arabic  Acme Store-2',
      productId: 744,
      price: 324,
      formattedPrice: r'$324.00',
      condition: 'new',
      description: 'New',
      avgRating: 5,
    ),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('an offer is bought at the quantity chosen on its stepper', (
    tester,
  ) async {
    final cubit = ShopOffersCubit(repository: _Offers());
    await cubit.load('simple-admin');

    ShopProductOffer? bought;
    int? boughtQuantity;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: ShopOffersSheet(
              onAddToCart: (context, offer, quantity) {
                bought = offer;
                boughtQuantity = quantity;
              },
            ),
          ),
        ),
      ),
    );

    // Starts at one, and cannot go below it.
    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.byKey(const Key('shopOfferQuantityMinus')));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byKey(const Key('shopOfferQuantityPlus')));
    await tester.tap(find.byKey(const Key('shopOfferQuantityPlus')));
    await tester.pump();
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.byKey(const Key('shopOfferAddToCart-715')));

    expect(bought?.listingId, 715);
    expect(bought?.sellerId, 38);
    expect(boughtQuantity, 3);

    // "New" is the condition and the seller's note both; it is said once.
    expect(find.text('New'), findsOneWidget);

    // "Best price" tag must not be displayed.
    expect(find.text('Best price'), findsNothing);
  });

  testWidgets(
    'shows Report Product when enabled and reasons exist',
    (tester) async {
      final repo = _Offers()
        ..flagEnabledValue = true
        ..reasonsValue = const [
          ShopFlagReason(id: 1, name: 'Duplicate product'),
          ShopFlagReason(id: 7, name: 'Other Reason'),
        ];
      final cubit = ShopOffersCubit(repository: repo);
      await cubit.load('simple-admin');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const ShopOffersSheet(),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('shopOfferReport-715')), findsOneWidget);
      expect(find.text('Report Product'), findsOneWidget);
    },
  );

  testWidgets(
    'ShopProductReportSheet shows text field and submit button when selecting other',
    (tester) async {
      String? submittedReason;
      String? submittedOther;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ShopProductReportSheet(
              reasons: const [
                ShopFlagReason(id: 1, name: 'Duplicate product'),
                ShopFlagReason(id: 7, name: 'Other Reason'),
              ],
              onSubmit: (reason, other) async {
                submittedReason = reason;
                submittedOther = other;
                return true;
              },
            ),
          ),
        ),
      );

      // Initially other text field is not shown.
      expect(find.byKey(const Key('productReportOtherReasonInput')), findsNothing);
      expect(find.byKey(const Key('productReportOtherSubmit')), findsNothing);

      // Tap "Other Reason"
      await tester.tap(find.text('Other Reason'));
      await tester.pumpAndSettle();

      // Now text field and submit button are shown.
      expect(find.byKey(const Key('productReportOtherReasonInput')), findsOneWidget);
      expect(find.byKey(const Key('productReportOtherSubmit')), findsOneWidget);

      // Submit without entering text should fail validation.
      await tester.tap(find.byKey(const Key('productReportOtherSubmit')));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a reason'), findsOneWidget);
      expect(submittedReason, isNull);

      // Enter text and submit.
      await tester.enterText(
        find.byKey(const Key('productReportOtherReasonInput')),
        'Counterfeit product',
      );
      await tester.tap(find.byKey(const Key('productReportOtherSubmit')));
      await tester.pumpAndSettle();

      expect(submittedReason, 'Other Reason');
      expect(submittedOther, 'Counterfeit product');
    },
  );
}

