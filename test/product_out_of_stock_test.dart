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

class _RecordingCartBloc extends CartBloc {
  _RecordingCartBloc() : super(repository: CartRepository(client: _client()));

  final events = <CartEvent>[];

  @override
  void add(CartEvent event) => events.add(event);
}

ProductModel _product({required String? isSaleable}) => ProductModel.fromJson({
  'id': '/api/shop/products/22',
  '_id': 22,
  'type': 'simple',
  'name': 'test',
  'price': '100',
  'isSaleable': isSaleable,
});

Future<_RecordingCartBloc> _pump(
  WidgetTester tester,
  ProductDetailState state,
) async {
  final cartBloc = _RecordingCartBloc();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailBloc>(
              create: (_) => _SeededProductBloc(state),
            ),
            BlocProvider<CartBloc>.value(value: cartBloc),
          ],
          child: const ProductActionBar(),
        ),
      ),
    ),
  );
  await tester.pump();
  return cartBloc;
}

void main() {
  test('out-of-stock state follows isSaleable from the API', () {
    // Live API: out-of-stock product 22 returns isSaleable "".
    expect(
      ProductDetailState(product: _product(isSaleable: '')).isOutOfStock,
      isTrue,
    );
    expect(
      ProductDetailState(product: _product(isSaleable: '1')).isOutOfStock,
      isFalse,
    );
    // Field not returned: do not guess.
    expect(
      ProductDetailState(product: _product(isSaleable: null)).isOutOfStock,
      isFalse,
    );
    // Selected configurable variant that is not saleable.
    expect(
      ProductDetailState(
        product: _product(isSaleable: '1'),
        selectedVariant: const ProductVariant(id: '5', isSaleable: '0'),
      ).isOutOfStock,
      isTrue,
    );
  });

  testWidgets('out-of-stock product cannot be added to cart or bought', (
    tester,
  ) async {
    final cartBloc = await _pump(
      tester,
      ProductDetailState(
        status: ProductDetailStatus.loaded,
        product: _product(isSaleable: ''),
      ),
    );

    expect(find.byKey(const ValueKey('product_add_to_cart_disabled')), findsOneWidget);
    await tester.tap(find.text('Add to Cart'));
    await tester.tap(find.text('Buy Now'));
    await tester.pump();

    expect(cartBloc.events.whereType<AddToCart>(), isEmpty);
  });

  testWidgets('saleable product can be added to cart', (tester) async {
    final cartBloc = await _pump(
      tester,
      ProductDetailState(
        status: ProductDetailStatus.loaded,
        product: _product(isSaleable: '1'),
      ),
    );

    expect(find.byKey(const ValueKey('product_add_to_cart_disabled')), findsNothing);
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();

    expect(cartBloc.events.whereType<AddToCart>(), hasLength(1));
  });
}
