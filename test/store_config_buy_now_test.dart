import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/product/presentation/bloc/product_detail_bloc.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_action_bar.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'store_config_fakes.dart';

GraphQLClient _client() => GraphQLClient(
  link: HttpLink('https://example.com/graphql'),
  cache: GraphQLCache(store: InMemoryStore()),
);

class _SeededProductBloc extends ProductDetailBloc {
  _SeededProductBloc(ProductDetailState state)
    : super(repository: CategoryRepository(client: _client())) {
    emit(state);
  }
}

Future<void> _pump(WidgetTester tester, StoreConfigCubit config) async {
  addTearDown(config.close);
  final product = ProductModel.fromJson(const {
    'id': '/api/shop/products/22',
    '_id': 22,
    'type': 'simple',
    'name': 'test',
    'price': '100',
    'isSaleable': '1',
  });
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailBloc>(
              create: (_) => _SeededProductBloc(
                ProductDetailState(
                  status: ProductDetailStatus.loaded,
                  product: product,
                ),
              ),
            ),
            BlocProvider<CartBloc>(
              create: (_) => CartBloc(repository: CartRepository(client: _client())),
            ),
            BlocProvider<StoreConfigCubit>.value(value: config),
          ],
          child: const ProductActionBar(),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  test('buy now flag reads both API key names', () {
    expect(
      StoreConfig.fromJson(const {'buyNowEnabled': false}).showBuyNow,
      isFalse,
    );
    expect(
      StoreConfig.fromJson(const {'buyNowButtonEnabled': false}).showBuyNow,
      isFalse,
    );
    expect(const StoreConfig().showBuyNow, isTrue);
  });

  testWidgets('Buy Now is hidden when the admin toggle is off', (tester) async {
    await _pump(tester, seededStoreConfigCubit(const {'buyNowEnabled': false}));

    expect(find.text('Buy Now'), findsNothing);
    expect(find.text('Add to Cart'), findsOneWidget);
  });

  testWidgets('cart page off hides Add to Cart and Buy Now', (tester) async {
    await _pump(
      tester,
      seededStoreConfigCubit(const {'cartPageEnabled': false}),
    );

    expect(find.text('Add to Cart'), findsNothing);
    expect(find.text('Buy Now'), findsNothing);
  });

  testWidgets('Buy Now is shown when the toggle is on or unknown', (
    tester,
  ) async {
    await _pump(tester, seededStoreConfigCubit(const {'buyNowEnabled': true}));

    expect(find.text('Buy Now'), findsOneWidget);
  });
}
