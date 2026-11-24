import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/repository/seller_product_repository.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/bloc/seller_product_create_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/pages/seller_product_create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creating a product used to pop the create page and then push the editor
/// from that same, now-dead context. The editor rendered but could neither
/// scroll nor change tab. The page hands the product back instead, so the
/// caller opens the editor from a context still on the tree.
class _FakeRepository implements SellerProductRepository {
  @override
  Future<SellerProductListItem> create({
    required String type,
    required int attributeFamilyId,
    required String sku,
    bool isDraft = false,
    List<Map<String, dynamic>>? superAttributes,
  }) async {
    return SellerProductListItem.fromJson({
      'id': '/api/seller/products/7',
      'productId': 70,
      'sku': sku,
      'name': sku,
      'type': type,
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  testWidgets('creating a product returns it to the caller', (tester) async {
    SellerProductListItem? handedBack;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  handedBack = await Navigator.of(context)
                      .push<SellerProductListItem>(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => SellerProductCreateCubit(
                              repository: _FakeRepository(),
                            ),
                            child: const SellerProductCreatePage(),
                          ),
                        ),
                      );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('sellerProductCreateSku')),
      'demo-sku',
    );
    // The kind cards made the form taller than the viewport, and a list only
    // builds what is on screen.
    await tester.dragUntilVisible(
      find.byKey(const Key('sellerProductCreateSubmit')),
      find.byType(ListView),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerProductCreateSubmit')));
    await tester.pumpAndSettle();

    // The create page is gone and the product came back with it, which is
    // what lets the caller push the editor from a live context.
    expect(find.byType(SellerProductCreatePage), findsNothing);
    expect(handedBack, isNotNull);
    expect(handedBack!.sku, 'demo-sku');
  });
  testWidgets('a plan that names its types offers only those', (tester) async {
    // A type outside the plan is refused by the server on create, so offering
    // it is offering a dead end. `allowsType` existed and nothing used it.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) => SellerProductCreateCubit(repository: _FakeRepository()),
          child: const SellerProductCreatePage(
            allowedTypes: ['simple', 'virtual'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sellerProductKind_simple')), findsOneWidget);
    expect(find.byKey(const Key('sellerProductKind_virtual')), findsOneWidget);
    expect(find.byKey(const Key('sellerProductKind_bundle')), findsNothing);
    expect(find.byKey(const Key('sellerProductKind_booking')), findsNothing);
    // A configurable is not on this plan either, so the switch is not offered.
    expect(find.byKey(const Key('sellerProductHasVariations')), findsNothing);
  });

  testWidgets('no plan restriction offers every kind', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) => SellerProductCreateCubit(repository: _FakeRepository()),
          child: const SellerProductCreatePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final kind in const [
      'simple',
      'downloadable',
      'virtual',
      'booking',
      'bundle',
      'grouped',
    ]) {
      expect(
        find.byKey(Key('sellerProductKind_$kind')),
        findsOneWidget,
        reason: kind,
      );
    }
    expect(find.byKey(const Key('sellerProductHasVariations')), findsOneWidget);
  });
}
