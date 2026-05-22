import 'package:bagisto_flutter/core/wishlist/wishlist_cubit.dart';
import 'package:bagisto_flutter/features/cart/data/models/cart_model.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/cart/presentation/pages/cart_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({'auth_token': 'test-token'});
  });

  testWidgets(
    'tapping a red cart heart removes from wishlist without removing cart item',
    (WidgetTester tester) async {
      final cartBloc = _TestCartBloc()
        ..seedLoadedCart(
          const CartModel(
            id: 1,
            grandTotal: 120,
            formattedGrandTotal: '\$120.00',
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
          ),
        );
      final wishlistCubit = _TestWishlistCubit()..seedWishlisted(77);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CartBloc>.value(value: cartBloc),
            BlocProvider<WishlistCubit>.value(value: wishlistCubit),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const CartPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Royal Luxe Leather Sofa'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      expect(wishlistCubit.toggledProductIds, [77]);
      expect(cartBloc.recordedEvents.whereType<RemoveFromCart>(), isEmpty);
      expect(find.text('Royal Luxe Leather Sofa'), findsOneWidget);
      expect(wishlistCubit.state.isWishlisted(77), isFalse);
    },
  );
}

class _TestWishlistCubit extends WishlistCubit {
  final List<int> toggledProductIds = [];

  void seedWishlisted(int productId) {
    emit(
      WishlistCubitState(
        wishlistedProducts: {productId: '/api/shop/wishlists/1'},
        isLoaded: true,
      ),
    );
  }

  @override
  Future<bool?> toggleWishlist({required int productId}) async {
    toggledProductIds.add(productId);
    final updatedMap = Map<int, String>.from(state.wishlistedProducts)
      ..remove(productId);
    emit(state.copyWith(wishlistedProducts: updatedMap));
    return false;
  }
}

class _TestCartBloc extends CartBloc {
  final List<CartEvent> recordedEvents = [];

  _TestCartBloc()
    : super(
        repository: CartRepository(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        ),
      );

  void seedLoadedCart(CartModel cart) {
    emit(
      CartState(
        status: CartStatus.loaded,
        cart: cart,
        cartToken: 'test-token',
        isGuest: false,
      ),
    );
  }

  @override
  void add(CartEvent event) {
    recordedEvents.add(event);
  }
}
