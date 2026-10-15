import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/product_card_large.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/product_card_small.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'store_config_fakes.dart';

const _product = HomeProduct(
  id: '/api/shop/products/1',
  numericId: 1,
  sku: 'sku-1',
  type: 'simple',
  name: 'Sofa',
  urlKey: 'sofa',
  price: 10,
  isSaleable: true,
);

Future<void> _pump(
  WidgetTester tester,
  StoreConfigCubit cubit,
  Widget child,
) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: cubit,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(width: 200, child: child),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  for (final entry in <String, Widget Function()>{
    'small card': () => ProductCardSmall(
      product: _product,
      cardWidth: 120,
      onWishlistTap: () {},
    ),
    'large card': () =>
        ProductCardLarge(product: _product, onWishlistTap: () {}),
  }.entries) {
    testWidgets('${entry.key} hides the heart when wishlist is off', (
      tester,
    ) async {
      final cubit = seededStoreConfigCubit(const {'wishlistEnabled': false});
      addTearDown(cubit.close);

      await _pump(tester, cubit, entry.value());

      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('${entry.key} shows the heart when the API is silent', (
      tester,
    ) async {
      final cubit = seededStoreConfigCubit(const {});
      addTearDown(cubit.close);

      await _pump(tester, cubit, entry.value());

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  }
}
