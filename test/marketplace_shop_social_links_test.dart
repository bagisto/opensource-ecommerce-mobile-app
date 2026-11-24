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

/// The shop page's Facebook / Instagram / YouTube chips.
///
/// The seller's own URLs arrive on `socialLinks` — verified live, all three
/// filled in for Acme Store-2 — and the chips were plain `Chip`s, which take
/// no tap at all. A shopper pressed them and nothing happened.
class _Shop implements ShopMarketplaceRepository {
  _Shop({required this.links});

  final List<ShopSellerAttribute> links;

  @override
  Future<ShopSeller> seller(String slug) async => ShopSeller(
    id: 38,
    slug: 'acme-store-2',
    businessName: 'Acme Store-2',
    socialLinks: links,
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
    items: const [],
    totalCount: 0,
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

/// The three links the live seller actually carries.
const _live = [
  ShopSellerAttribute(
    code: 'facebook',
    label: 'Facebook',
    value: 'https://facebook.com/acme',
  ),
  ShopSellerAttribute(
    code: 'instagram',
    label: 'Instagram',
    value: 'https://instagram.com/acme',
  ),
  ShopSellerAttribute(
    code: 'youtube',
    label: 'YouTube',
    value: 'https://youtube.com/@acme',
  ),
];

class _TestCartBloc extends CartBloc {
  _TestCartBloc()
    : super(
        repository: CartRepository(
          client: GraphQLClient(
            link: Link.function((request, [forward]) => const Stream.empty()),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        ),
      ) {
    emit(const CartState(status: CartStatus.loaded));
  }
}

Future<void> _pump(WidgetTester tester, List<ShopSellerAttribute> links) async {
  final cubit = ShopSellerCubit(
    repository: _Shop(links: links),
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
        home: const ShopSellerPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final opened = <Uri>[];

  setUp(() {
    opened.clear();
    shopOpenLink = (url) async {
      opened.add(url);
      return true;
    };
  });

  tearDown(() {
    shopOpenLink = (url) async => false;
  });

  Future<void> switchToAbout(WidgetTester tester) async {
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
  }

  Future<void> openShareSheet(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('shopSellerActions')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shopSellerActionShare')));
    await tester.pumpAndSettle();
  }

  testWidgets('about tab does not show social chips', (tester) async {
    await _pump(tester, _live);
    await switchToAbout(tester);

    for (final code in const ['facebook', 'instagram', 'youtube']) {
      expect(find.byKey(Key('shopSellerSocial_$code')), findsNothing);
    }
  });

  testWidgets('a hand-typed address still opens via share sheet', (tester) async {
    // Sellers type these themselves, and a bare host parses as a relative
    // path that opens nothing.
    await _pump(tester, const [
      ShopSellerAttribute(
        code: 'facebook',
        label: 'Facebook',
        value: 'facebook.com/acme',
      ),
    ]);
    await openShareSheet(tester);

    await tester.tap(find.byKey(const Key('shopSellerShareSheet_facebook')));
    await tester.pumpAndSettle();

    expect(opened.single.toString(), 'https://facebook.com/acme');
  });

  testWidgets('a link with no address is not drawn in share sheet', (tester) async {
    await _pump(tester, const [
      ShopSellerAttribute(code: 'facebook', label: 'Facebook'),
      ShopSellerAttribute(
        code: 'youtube',
        label: 'YouTube',
        value: 'https://youtube.com/@acme',
      ),
    ]);
    await openShareSheet(tester);

    expect(find.byKey(const Key('shopSellerShareSheet_facebook')), findsNothing);
    expect(find.byKey(const Key('shopSellerShareSheet_youtube')), findsOneWidget);
  });

  testWidgets('a link nothing can open says so', (tester) async {
    shopOpenLink = (url) async => false;
    await _pump(tester, _live);
    await openShareSheet(tester);

    await tester.tap(find.byKey(const Key('shopSellerShareSheet_facebook')));
    await tester.pumpAndSettle();

    expect(find.text('That link could not be opened'), findsOneWidget);
  });

  testWidgets('share in menu bar opens bottomsheet and launches social link',
      (tester) async {
    await _pump(tester, _live);

    // Open menu
    await tester.tap(find.byKey(const Key('shopSellerActions')));
    await tester.pumpAndSettle();

    // Tap share option
    expect(find.byKey(const Key('shopSellerActionShare')), findsOneWidget);
    await tester.tap(find.byKey(const Key('shopSellerActionShare')));
    await tester.pumpAndSettle();

    // Verify bottom sheet shows the 3 eligible social shares
    expect(find.byKey(const Key('shopSellerShareSheet_facebook')), findsOneWidget);
    expect(find.byKey(const Key('shopSellerShareSheet_instagram')), findsOneWidget);
    expect(find.byKey(const Key('shopSellerShareSheet_youtube')), findsOneWidget);

    // Tap Facebook in bottom sheet
    await tester.tap(find.byKey(const Key('shopSellerShareSheet_facebook')));
    await tester.pumpAndSettle();

    expect(opened.single.toString(), 'https://facebook.com/acme');
  });

  testWidgets('share menu option is omitted when seller has no social links',
      (tester) async {
    await _pump(tester, const [
      ShopSellerAttribute(code: 'facebook', label: 'Facebook'), // hasValue is false
    ]);

    await tester.tap(find.byKey(const Key('shopSellerActions')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shopSellerActionShare')), findsNothing);
  });

  testWidgets('share bottomsheet takes full width even with a single social link',
      (tester) async {
    await _pump(tester, const [
      ShopSellerAttribute(
        code: 'facebook',
        label: 'Facebook',
        value: 'https://facebook.com/acme',
      ),
    ]);

    // Open menu and tap share
    await tester.tap(find.byKey(const Key('shopSellerActions')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shopSellerActionShare')));
    await tester.pumpAndSettle();

    // Verify bottom sheet is displayed
    final bottomSheetFinder = find.byType(BottomSheet);
    expect(bottomSheetFinder, findsOneWidget);

    final expectedWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final sheetSize = tester.getSize(bottomSheetFinder);
    expect(sheetSize.width, closeTo(expectedWidth, 0.5));
  });
}
