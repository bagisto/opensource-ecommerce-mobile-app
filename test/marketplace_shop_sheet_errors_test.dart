import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/models/shop_marketplace.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/bloc/shop_marketplace_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/pages/shop_seller_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAuth extends Fake implements AuthBloc {
  _FakeAuth(this.state);

  @override
  final AuthState state;

  @override
  Stream<AuthState> get stream => const Stream<AuthState>.empty();

  @override
  Future<void> close() async {}
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
      ) {
    emit(const CartState(status: CartStatus.loaded));
  }
}

/// What a shop-page sheet does when the marketplace says no.
///
/// A review, a message and a report all sit in a sheet over the page, and the
/// page's snackbar came up behind it: the shopper pressed the button, saw
/// nothing at all, and only found out it had failed after closing the sheet
/// themselves. The marketplace refuses these often — one review per seller,
/// and a report only from someone who has ordered — so the refusal has to be
/// said where the shopper is looking.
class _Refuses implements ShopMarketplaceRepository {
  _Refuses({required this.message});

  final String message;
  String? lastFlagReason;

  Never _no() => throw SellerApiException(message, SellerApiFailure.validation);

  @override
  Future<ShopSeller> seller(String slug) async => const ShopSeller(
    id: 38,
    slug: 'acme-store-2',
    businessName: 'Acme Store-2',
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
  Future<List<ShopFlagReason>> flagReasons({String? type}) async =>
      const [
        ShopFlagReason(id: 3, name: 'Damaged product', type: 'seller'),
        ShopFlagReason(id: 9, name: 'Other Reason', type: 'seller'),
      ];

  @override
  Future<void> reviewSeller({
    required String slug,
    required int rating,
    required String title,
    required String comment,
  }) async => _no();

  @override
  Future<void> contactSeller({
    required String slug,
    required String name,
    required String email,
    required String message,
    String? subject,
  }) async => _no();

  @override
  Future<void> flagSeller({
    required String slug,
    required String reason,
  }) async {
    lastFlagReason = reason;
    _no();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<void> _open(
  WidgetTester tester,
  _Refuses repository, {
  List<ShopFlagReason>? reasons,
}) async {
  final cubit = ShopSellerCubit(repository: repository, slug: 'acme-store-2');
  await cubit.load();
  addTearDown(cubit.close);

  final cartBloc = _TestCartBloc();
  addTearDown(cartBloc.close);
  final authBloc = _FakeAuth(const AuthAuthenticated(token: 'customer-token'));
  addTearDown(authBloc.close);

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<CartBloc>.value(value: cartBloc),
        BlocProvider<ShopSellerCubit>.value(value: cubit),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ShopSellerPage(
          reportReasons: reasons ?? const [
            ShopFlagReason(id: 3, name: 'Damaged product', type: 'seller'),
            ShopFlagReason(id: 9, name: 'Other Reason', type: 'seller'),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('shopSellerActions')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a refused review is said in the sheet', (tester) async {
    await _open(
      tester,
      _Refuses(message: 'You have already reviewed this seller.'),
    );

    await tester.tap(find.text('Write a review'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('shopReviewTitle')), 'Great');
    await tester.enterText(find.byKey(const Key('shopReviewComment')), 'Good quality');
    await tester.tap(find.byKey(const Key('shopReviewSubmit')));
    await tester.pumpAndSettle();

    final shown = tester.widget<Text>(find.byKey(const Key('shopSheetError')));
    expect(shown.data, 'You have already reviewed this seller.');
    // And the sheet is still there, so the shopper can change it and retry.
    expect(find.byKey(const Key('shopReviewSubmit')), findsOneWidget);
  });

  testWidgets('a review with no title says what is missing', (tester) async {
    await _open(tester, _Refuses(message: 'unused'));

    await tester.tap(find.text('Write a review'));
    await tester.pumpAndSettle();

    // It used to return silently, which reads exactly like a dead button.
    await tester.tap(find.byKey(const Key('shopReviewSubmit')));
    await tester.pumpAndSettle();

    expect(find.text('The title field is required'), findsOneWidget);
  });

  testWidgets('a refused message is said in the sheet', (tester) async {
    await _open(tester, _Refuses(message: 'That seller is not accepting mail.'));

    await tester.tap(find.text('Contact Seller'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('shopContactName')), 'Alice');
    await tester.enterText(find.byKey(const Key('shopContactEmail')), 'alice@example.com');
    await tester.enterText(find.byKey(const Key('shopContactSubject')), 'Question');
    await tester.enterText(find.byKey(const Key('shopContactMessage')), 'Hi');
    await tester.tap(find.byKey(const Key('shopContactSubmit')));
    await tester.pumpAndSettle();

    final shown = tester.widget<Text>(find.byKey(const Key('shopSheetError')));
    expect(shown.data, 'That seller is not accepting mail.');
    expect(find.byKey(const Key('shopContactSubmit')), findsOneWidget);
  });

  testWidgets('a refused report keeps its sheet open', (tester) async {
    // Only a shopper who has ordered from the seller may report them, so this
    // is the refusal most shoppers will actually meet.
    await _open(
      tester,
      _Refuses(message: 'You have not ordered from this seller.'),
    );

    await tester.tap(find.text('Report this seller'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('shopReportReason_3')));
    await tester.pumpAndSettle();

    final shown = tester.widget<Text>(find.byKey(const Key('shopSheetError')));
    expect(shown.data, 'You have not ordered from this seller.');
    expect(find.byKey(const Key('shopReportReason_3')), findsOneWidget);
  });

  testWidgets(
    'selecting other reason shows text field, validates required, and submits custom text',
    (tester) async {
      final repo = _Refuses(message: 'You have already reported this seller');
      await _open(tester, repo);

      await tester.tap(find.text('Report this seller'));
      await tester.pumpAndSettle();

      // Initially other input is not visible.
      expect(find.byKey(const Key('shopReportOtherReasonInput')), findsNothing);
      expect(find.byKey(const Key('shopReportOtherSubmit')), findsNothing);

      // Tap "Other Reason"
      await tester.tap(find.text('Other Reason'));
      await tester.pumpAndSettle();

      // Now text field and submit button appear
      expect(find.byKey(const Key('shopReportOtherReasonInput')), findsOneWidget);
      expect(find.byKey(const Key('shopReportOtherSubmit')), findsOneWidget);

      // Submit without text triggers validation error matching web
      await tester.tap(find.byKey(const Key('shopReportOtherSubmit')));
      await tester.pumpAndSettle();

      expect(find.text('The Reason field is required'), findsOneWidget);
      expect(repo.lastFlagReason, isNull);

      // Enter reason and submit
      await tester.enterText(
        find.byKey(const Key('shopReportOtherReasonInput')),
        'Seller is unresponsive to messages',
      );
      await tester.pumpAndSettle();

      // Validation error disappears on edit
      expect(find.text('The Reason field is required'), findsNothing);

      await tester.tap(find.byKey(const Key('shopReportOtherSubmit')));
      await tester.pumpAndSettle();

      expect(repo.lastFlagReason, 'Seller is unresponsive to messages');
      // Sheet displays server response error
      final shown = tester.widget<Text>(find.byKey(const Key('shopSheetError')));
      expect(shown.data, 'You have already reported this seller');
    },
  );
}
