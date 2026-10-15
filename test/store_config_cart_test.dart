import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/core/wishlist/wishlist_cubit.dart';
import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bagisto_flutter/features/cart/data/models/cart_model.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/cart/presentation/pages/cart_page.dart';
import 'package:bagisto_flutter/features/checkout/presentation/pages/checkout_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store_config_fakes.dart';

GraphQLClient _client() => GraphQLClient(
  link: HttpLink('https://example.com/graphql'),
  cache: GraphQLCache(store: InMemoryStore()),
);

class _RecordingCartRepository extends CartRepository {
  _RecordingCartRepository() : super(client: _client());

  int guestLookups = 0;

  @override
  Future<bool> guestCheckoutAllowed(Iterable<int> productIds) async {
    guestLookups++;
    return true;
  }
}

class _TestCartBloc extends CartBloc {
  _TestCartBloc(CartRepository repository) : super(repository: repository);

  void seed(CartModel cart) => emit(
    CartState(
      status: CartStatus.loaded,
      cart: cart,
      cartToken: 'test-token',
      isGuest: true,
    ),
  );

  @override
  void add(CartEvent event) {}
}

const _cart = CartModel(
  id: 1,
  subtotal: 120,
  formattedSubtotal: r'$120.00',
  grandTotal: 120,
  formattedGrandTotal: r'$120.00',
  items: [
    CartItemModel(
      id: 11,
      cartId: 1,
      productId: 77,
      name: 'Royal Luxe Leather Sofa',
      price: 120,
      total: 120,
      quantity: 1,
    ),
  ],
);

Future<_RecordingCartRepository> _pumpCart(
  WidgetTester tester,
  StoreConfigCubit config, {
  CartModel cart = _cart,
}) async {
  final repository = _RecordingCartRepository();
  final cartBloc = _TestCartBloc(repository)..seed(cart);
  final auth = AuthBloc(repository: AuthRepository(client: _client()));
  addTearDown(cartBloc.close);
  addTearDown(auth.close);
  addTearDown(config.close);

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>.value(value: cartBloc),
        BlocProvider<AuthBloc>.value(value: auth),
        BlocProvider<WishlistCubit>(create: (_) => WishlistCubit()),
        BlocProvider<StoreConfigCubit>.value(value: config),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CartPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

Future<void> _tapPayNow(WidgetTester tester) async {
  await tester.tap(find.text('Pay Now'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('cart item has no wishlist heart when wishlist is off', (
    tester,
  ) async {
    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {'wishlistEnabled': false}),
    );

    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });

  testWidgets('guest Pay Now opens login when guest checkout is off', (
    tester,
  ) async {
    final repository = await _pumpCart(
      tester,
      seededStoreConfigCubit(const {'guestCheckoutEnabled': false}),
    );

    await _tapPayNow(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(repository.guestLookups, 0);
  });

  testWidgets('cart below the minimum order shows the API message', (
    tester,
  ) async {
    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {
        'minimumOrderEnabled': true,
        'minimumOrderAmount': 200,
        'minimumOrderMessage': 'Spend 200 to check out',
      }),
    );

    expect(find.text('Spend 200 to check out'), findsOneWidget);

    await _tapPayNow(tester);

    expect(find.byType(CheckoutPage), findsNothing);
  });

  testWidgets('minimum order without an API message uses the app text', (
    tester,
  ) async {
    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {
        'minimumOrderEnabled': true,
        'minimumOrderAmount': 200,
      }),
    );

    expect(
      find.byKey(const ValueKey('cart_minimum_order_message')),
      findsOneWidget,
    );
    expect(find.textContaining('200.00'), findsOneWidget);
  });

  testWidgets('cart header follows the cart summary setting', (tester) async {
    final cart = _cart.copyWith(itemsCount: 2, itemsQty: 5);

    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {
        'cartSummary': 'display_number_of_items_in_cart',
      }),
      cart: cart,
    );
    expect(find.text('2 Items in the Cart'), findsOneWidget);

    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {'cartSummary': 'display_item_quantity'}),
      cart: cart,
    );
    expect(find.text('5 Units in the Cart'), findsOneWidget);
  });

  testWidgets('cart shows the admin mini cart offer text', (tester) async {
    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {
        'miniCartEnabled': true,
        'miniCartOfferInfo': 'Get Up To 30% OFF on your 1st order',
      }),
    );

    expect(
      find.byKey(const ValueKey('cart_offer_info')),
      findsOneWidget,
    );
    expect(find.text('Get Up To 30% OFF on your 1st order'), findsOneWidget);
  });

  testWidgets('empty cart also shows the offer text, like the web', (
    tester,
  ) async {
    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {'miniCartOfferInfo': 'Sale today'}),
      cart: const CartModel(id: 1),
    );

    expect(find.text('Sale today'), findsOneWidget);
  });

  testWidgets('offer text hides when switched off or empty', (tester) async {
    for (final json in <Map<String, dynamic>>[
      {'miniCartEnabled': false, 'miniCartOfferInfo': 'Sale'},
      {'miniCartOfferInfoEnabled': false, 'miniCartOfferInfo': 'Sale'},
      {'miniCartEnabled': true, 'miniCartOfferInfo': '  '},
    ]) {
      await _pumpCart(tester, seededStoreConfigCubit(json));

      expect(
        find.byKey(const ValueKey('cart_offer_info')),
        findsNothing,
        reason: '$json',
      );
    }
  });

  testWidgets('cart above the minimum order shows no message', (tester) async {
    await _pumpCart(
      tester,
      seededStoreConfigCubit(const {
        'minimumOrderEnabled': true,
        'minimumOrderAmount': 100,
      }),
    );

    expect(
      find.byKey(const ValueKey('cart_minimum_order_message')),
      findsNothing,
    );
  });
}
