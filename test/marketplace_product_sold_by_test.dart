import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_sold_by_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/models/shop_marketplace.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/bloc/shop_marketplace_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/pages/shop_seller_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// The "Sold by" line on a customer's product page.
///
/// On a marketplace the shopper buys from a shop, not from the store, and the
/// product page said nothing about which one.
class _Shop implements ShopMarketplaceRepository {
  _Shop({
    this.soldBy,
    this.reasons = const [],
    this.reasonsFail = false,
    this.loadError,
    this.reportError,
  });

  final ShopProductSeller? soldBy;
  final List<ShopFlagReason> reasons;
  final bool reasonsFail;
  final String? loadError;
  final String? reportError;

  String? askedFor;
  Map<String, Object?>? flagged;

  @override
  Future<ShopProductSeller?> productSeller(String product) async {
    askedFor = product;
    if (loadError != null) {
      throw SellerApiException(loadError!, SellerApiFailure.unknown);
    }
    return soldBy;
  }

  @override
  Future<bool> flagEnabled({required String type}) async => true;

  @override
  Future<List<ShopFlagReason>> flagReasons({String? type}) async {
    if (reasonsFail) {
      throw const SellerApiException('nope', SellerApiFailure.unknown);
    }
    return reasons;
  }

  @override
  Future<void> flagProduct({
    required int listingId,
    required String reason,
    String? otherReason,
  }) async {
    flagged = {'listingId': listingId, 'reason': reason};
    if (reportError != null) {
      throw SellerApiException(reportError!, SellerApiFailure.unknown);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const _acme = ShopProductSeller(
  sellerId: 38,
  businessName: 'Acme Store-2',
  slug: 'acme-store-2',
  avgRating: 5,
  totalReviews: 1,
  otherSellersCount: 0,
  listingId: 26,
);

const _reasons = [
  ShopFlagReason(id: 2, name: 'Damaged product', type: 'product'),
  ShopFlagReason(id: 6, name: 'Receive wrong product', type: 'product'),
];

/// Only `state` is read by the section, so nothing else is needed.
class _FakeAuth extends Fake implements AuthBloc {
  _FakeAuth(this.state);

  @override
  final AuthState state;

  @override
  Stream<AuthState> get stream => const Stream<AuthState>.empty();

  @override
  Future<void> close() async {}
}

Future<ShopProductSellerCubit> _pump(
  WidgetTester tester,
  _Shop repository, {
  String product = 'nike-air-max',
  AuthState auth = const AuthAuthenticated(token: 'customer-token'),
}) async {
  final cubit = ShopProductSellerCubit(repository: repository);
  await cubit.load(product);
  addTearDown(cubit.close);

  // The auth bloc lives above the navigator, as in the app, so a pushed
  // login page can see it too.
  await tester.pumpWidget(
    BlocProvider<AuthBloc>.value(
      value: _FakeAuth(auth),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const ProductSoldBySection(),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
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
  const missingProduct = 'No product found under that url key or id.';

  testWidgets('only the exact background seller lookup toast is suppressed', (
    tester,
  ) async {
    final repository = _Shop(loadError: missingProduct);
    final cubit = await _pump(tester, repository);

    // Load after mounting so the listener receives the failure transition.
    await cubit.load('445');
    await tester.pumpAndSettle();

    expect(repository.askedFor, '445');
    expect(cubit.state.status, ShopStatus.failed);
    expect(cubit.state.errorMessage, missingProduct);
    expect(find.text('Sold By'), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('other seller lookup errors still show a toast', (tester) async {
    const message = 'Unable to load seller details.';
    final cubit = await _pump(tester, _Shop(loadError: message));
    await cubit.load('445');
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  });

  testWidgets('the same message from a report action remains visible', (
    tester,
  ) async {
    final cubit = await _pump(
      tester,
      _Shop(soldBy: _acme, reasons: _reasons, reportError: missingProduct),
    );
    expect(await cubit.report(reason: 'Damaged product'), isFalse);
    await tester.pumpAndSettle();

    expect(find.text('Acme Store-2'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(missingProduct), findsOneWidget);
  });

  testWidgets('a product in a seller\'s shop opens', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // The shop page took an `onOpenProduct` and nothing on the shopper's side
    // ever passed one, so every tile in a seller's shop was a dead tap.
    ShopSellerProduct? opened;

    final cubit = ShopSellerCubit(
      repository: _ShopWithProducts(),
      slug: 'acme-store-2',
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
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ShopSellerPage(
            onOpenProduct: (_, product) => opened = product,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final tile = find.byKey(const Key('shopSellerProduct_41'));
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(tile);

    expect(opened?.name, 'Nike Air Max');
    expect(opened?.urlKey, 'nike-air-max');
  });

  testWidgets('the shopper is told who they are buying from', (tester) async {
    await _pump(tester, _Shop(soldBy: _acme, reasons: _reasons));

    expect(find.text('Sold By'), findsOneWidget);
    expect(find.text('Acme Store-2'), findsOneWidget);
    expect(find.byKey(const Key('productSoldByRating')), findsOneWidget);
    expect(find.text('1 review'), findsNothing);
  });

  testWidgets('a product with no seller draws nothing at all', (tester) async {
    // An admin's own product has none, and neither does one whose seller was
    // suspended — an empty frame would be worse than no line.
    await _pump(tester, _Shop());

    expect(find.text('Sold By'), findsNothing);
    expect(find.byKey(const Key('productSoldByReport')), findsNothing);
  });

  testWidgets('an unrated shop shows no stars', (tester) async {
    // Five empty stars read as a bad score rather than no score.
    await _pump(
      tester,
      _Shop(
        soldBy: const ShopProductSeller(
          sellerId: 41,
          businessName: 'T Test Store',
          slug: 't-test-store',
          totalReviews: 0,
        ),
        reasons: _reasons,
      ),
    );

    expect(find.text('T Test Store'), findsOneWidget);
    expect(find.byKey(const Key('productSoldByRating')), findsNothing);
  });

  testWidgets('the report is filed against this seller\'s listing', (
    tester,
  ) async {
    // Not the product: the report is about one seller's offer of it.
    final repository = _Shop(soldBy: _acme, reasons: _reasons);
    await _pump(tester, repository);

    await tester.tap(find.byKey(const Key('productSoldByReport')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Damaged product'));
    await tester.pumpAndSettle();

    expect(repository.flagged, {'listingId': 26, 'reason': 'Damaged product'});
  });

  testWidgets('a guest is asked to log in instead of reporting', (
    tester,
  ) async {
    final repository = _Shop(soldBy: _acme, reasons: _reasons);
    await _pump(tester, repository, auth: const AuthUnauthenticated());

    await tester.tap(find.byKey(const Key('productSoldByReport')));
    await tester.pumpAndSettle();

    expect(find.text('Alert'), findsOneWidget);
    expect(
      find.text('You need to login to report this product'),
      findsOneWidget,
    );
    expect(find.text('Damaged product'), findsNothing);

    // Disagree just closes it.
    await tester.tap(find.byKey(const Key('productReportLoginDisagree')));
    await tester.pumpAndSettle();
    expect(find.text('Alert'), findsNothing);
    expect(find.byType(LoginPage), findsNothing);
    expect(repository.flagged, isNull);
  });

  testWidgets('Agree takes the guest to the login screen', (tester) async {
    await _pump(
      tester,
      _Shop(soldBy: _acme, reasons: _reasons),
      auth: const AuthUnauthenticated(),
    );

    await tester.tap(find.byKey(const Key('productSoldByReport')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('productReportLoginAgree')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('a marketplace with no reasons hides the report', (tester) async {
    await _pump(tester, _Shop(soldBy: _acme));

    expect(find.text('Acme Store-2'), findsOneWidget);
    expect(find.byKey(const Key('productSoldByReport')), findsNothing);
  });

  testWidgets('reasons failing does not cost the line itself', (tester) async {
    // Who sells the product is the point; the report is an extra.
    await _pump(tester, _Shop(soldBy: _acme, reasonsFail: true));

    expect(find.text('Acme Store-2'), findsOneWidget);
    expect(find.byKey(const Key('productSoldByReport')), findsNothing);
  });

  testWidgets('other sellers are offered where there are any', (tester) async {
    var opened = 0;
    final cubit = ShopProductSellerCubit(
      repository: _Shop(
        soldBy: const ShopProductSeller(
          sellerId: 38,
          businessName: 'Acme Store-2',
          slug: 'acme-store-2',
          otherSellersCount: 3,
          listingId: 26,
        ),
      ),
    );
    await cubit.load('nike-air-max');
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: ProductSoldBySection(onOpenOffers: (_, _) => opened++),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('3 other sellers'), findsOneWidget);
    await tester.tap(find.byKey(const Key('productSoldByOffers')));
    expect(opened, 1);
  });

  testWidgets('a product the server has no seller for stays quiet', (
    tester,
  ) async {
    // The server answers "No product found under that url key or id." for a
    // product an admin created. A shopper browsing the catalogue should not
    // be told that; the line is simply absent.
    final cubit = ShopProductSellerCubit(repository: _NoSeller());
    await cubit.load('nike-air-max');
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const ProductSoldBySection(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(cubit.state.errorMessage, isNull);
    expect(find.text('Sold By'), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
  });

  test('the endpoint is asked with whatever the page holds', () async {
    // A product opened from search carries its numeric id and no url key; the
    // endpoint takes either.
    final repository = _Shop(soldBy: _acme);
    final cubit = ShopProductSellerCubit(repository: repository);
    addTearDown(cubit.close);

    await cubit.load('41');

    expect(repository.askedFor, '41');
    expect(cubit.state.seller?.businessName, 'Acme Store-2');
  });
}

/// What the server answers for a product that has no seller of its own.
class _NoSeller implements ShopMarketplaceRepository {
  @override
  Future<ShopProductSeller?> productSeller(String product) async {
    throw const SellerApiException(
      'No product found under that url key or id.',
      SellerApiFailure.notFound,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// A seller with one product, so the shop page has a tile to tap.
class _ShopWithProducts implements ShopMarketplaceRepository {
  @override
  Future<ShopSeller> seller(String slug) async =>
      const ShopSeller(id: 38, slug: 'acme-store-2', businessName: 'Acme');

  @override
  Future<PaginatedResult<ShopSellerProduct>> sellerProducts({
    required String slug,
    int page = 1,
    String? sort,
    String? price,
    String? type,
    String? name,
  }) async => PaginatedResult(
    items: const [
      ShopSellerProduct(
        id: 41,
        sku: 'nike-air-max',
        name: 'Nike Air Max',
        urlKey: 'nike-air-max',
        type: 'simple',
      ),
    ],
    totalCount: 1,
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
