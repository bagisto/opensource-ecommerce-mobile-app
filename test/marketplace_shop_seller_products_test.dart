import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/models/shop_marketplace.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/bloc/shop_marketplace_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/pages/shop_seller_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _ShopRepo implements ShopMarketplaceRepository {
  _ShopRepo({required this.products});

  final List<ShopSellerProduct> products;

  @override
  Future<ShopSeller> seller(String slug) async => const ShopSeller(
    id: 1,
    slug: 'seller1k',
    businessName: 'Seller 1 Business',
  );

  @override
  Future<PaginatedResult<ShopSellerProduct>> sellerProducts({
    required String slug,
    int page = 1,
    String? sort,
    String? price,
    String? type,
    String? name,
  }) async => PaginatedResult(
    items: products,
    totalCount: products.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<List<ShopSellerProduct>> topProducts(String slug) async => const [];

  @override
  Future<PaginatedResult<ShopSellerReview>> sellerReviews({
    required String slug,
    int page = 1,
  }) async => PaginatedResult(
    items: const [],
    totalCount: 0,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _TestCartBloc extends CartBloc {
  _TestCartBloc()
    : super(
        repository: CartRepository(
          client: GraphQLClient(
            link: Link.function((request, [forward]) => const Stream.empty()),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        ),
      );
}

void main() {
  const sellerSimple = ShopSellerProduct(
    id: 48,
    sku: 'seller-simple',
    name: 'Seller Simple',
    isNew: true,
    onSale: true,
    isSaleable: true,
    type: 'simple',
    minPrice: 20.0,
  );

  const bookingProduct = ShopSellerProduct(
    id: 15,
    sku: 'booking-product',
    name: 'booking-product',
    isNew: true,
    onSale: false,
    isSaleable: false,
    type: 'booking',
    minPrice: 50.0,
  );

  const arcticProduct = ShopSellerProduct(
    id: 133,
    sku: 'arctic-bliss',
    name: 'Arctic Bliss Stylish Winter Scarf',
    isNew: false,
    onSale: false,
    isSaleable: true,
    type: 'simple',
    minPrice: 15.0,
  );

  Future<void> pumpPage(
    WidgetTester tester, {
    required List<ShopSellerProduct> products,
  }) async {
    final cubit = ShopSellerCubit(
      repository: _ShopRepo(products: products),
      slug: 'seller1k',
    );
    await cubit.load();
    addTearDown(cubit.close);

    final cartBloc = _TestCartBloc();
    addTearDown(cartBloc.close);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>.value(value: cartBloc),
          BlocProvider<ShopSellerCubit>.value(value: cubit),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ShopSellerPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'product with both isNew and onSale shows only Sale chip, not New',
    (tester) async {
      await pumpPage(tester, products: [sellerSimple]);

      expect(find.text('Sale'), findsOneWidget);
      expect(find.text('New'), findsNothing);

      // Verify Sale badge background color is red (#DC2626)
      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final saleBadge = decoratedBoxes.firstWhere(
        (box) => (box.decoration as BoxDecoration).color == const Color(0xFFDC2626),
      );
      expect(saleBadge, isNotNull);
    },
  );

  testWidgets(
    'product with only isNew shows New chip with dark navy color',
    (tester) async {
      await pumpPage(tester, products: [bookingProduct]);

      expect(find.text('New'), findsOneWidget);
      expect(find.text('Sale'), findsNothing);

      // Verify New badge background color is dark navy (#0F172A)
      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final newBadge = decoratedBoxes.firstWhere(
        (box) => (box.decoration as BoxDecoration).color == const Color(0xFF0F172A),
      );
      expect(newBadge, isNotNull);
    },
  );

  testWidgets(
    'product with neither isNew nor onSale shows no badge chip',
    (tester) async {
      await pumpPage(tester, products: [arcticProduct]);

      expect(find.text('Sale'), findsNothing);
      expect(find.text('New'), findsNothing);
    },
  );

  testWidgets(
    'out of stock product has disabled Add to Cart button and NO Out of stock text',
    (tester) async {
      await pumpPage(tester, products: [bookingProduct]);

      // No "Out of stock" text
      expect(find.text('Out of stock'), findsNothing);
      expect(find.text('Out of Stock'), findsNothing);

      // Add to Cart button exists but is disabled
      final button = tester.widget<OutlinedButton>(
        find.byKey(const Key('shopSellerAddToCart_15')),
      );
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'switching to list view preserves single-badge precedence and no Out of stock text',
    (tester) async {
      await pumpPage(tester, products: [sellerSimple, bookingProduct, arcticProduct]);

      // Switch to list view
      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();

      // Seller Simple: only Sale
      expect(find.text('Sale'), findsOneWidget);

      // Booking product: only New
      expect(find.text('New'), findsOneWidget);

      // No "Out of stock" text anywhere
      expect(find.text('Out of stock'), findsNothing);
      expect(find.text('Out of Stock'), findsNothing);

      // Booking product Add to Cart button is disabled in list view too
      final listButton = tester.widget<OutlinedButton>(
        find.byKey(const Key('shopSellerAddToCart_15')),
      );
      expect(listButton.onPressed, isNull);
    },
  );
}
