import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/ui/seller_ui.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/models/seller_settings.dart';
import 'package:bagisto_flutter/marketplace/features/settings/data/repository/seller_settings_repository.dart';
import 'package:bagisto_flutter/marketplace/features/settings/presentation/bloc/seller_settings_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/settings/presentation/pages/seller_settings_page.dart';
import 'package:bagisto_flutter/marketplace/features/settings/presentation/pages/seller_account_health_page.dart';
import 'package:bagisto_flutter/marketplace/features/settings/presentation/pages/seller_account_health_guide_page.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/models/shop_marketplace.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/bloc/shop_marketplace_cubits.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeSettingsRepository implements SellerSettingsRepository {
  _FakeSettingsRepository({
    this.stored = const SellerSettings(),
    this.staff = const [],
    this.storedRoles = const [],
    this.health,
    this.healthFails = false,
    this.failWith,
  });

  SellerSettings stored;
  List<SellerUser> staff;
  List<SellerRole> storedRoles;
  SellerAccountHealth? health;

  /// Standing in for a role that does not include the scorecard.
  final bool healthFails;
  final SellerApiException? failWith;

  Map<String, dynamic>? lastUserInput;
  Map<String, dynamic>? lastRoleInput;
  String? lastCurrentPassword;
  bool didRefreshHealth = false;

  @override
  GraphQLClient get client => throw UnimplementedError();

  static PaginatedResult<T> _page<T>(List<T> items) => PaginatedResult<T>(
    items: items,
    totalCount: items.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<SellerSettings> settings() async {
    if (failWith != null) throw failWith!;
    return stored;
  }

  @override
  Future<SellerSettings> updateSettings({
    String? preferredLocale,
    bool? emailNotifications,
  }) async {
    if (failWith != null) throw failWith!;
    stored = SellerSettings(
      preferredLocale: preferredLocale ?? stored.preferredLocale,
      emailNotifications: emailNotifications ?? stored.emailNotifications,
      currency: stored.currency,
      availableLocales: stored.availableLocales,
    );
    return stored;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (failWith != null) throw failWith!;
    lastCurrentPassword = currentPassword;
  }

  @override
  Future<PaginatedResult<SellerUser>> users({
    int page = 1,
    String? search,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(staff);
  }

  @override
  Future<void> createUser(SellerUserDraft draft) async {
    if (failWith != null) throw failWith!;
    lastUserInput = draft.toInput();
    staff = [...staff, SellerUser(id: 1, name: draft.name, email: draft.email)];
  }

  @override
  Future<void> updateUser(SellerUserDraft draft) async {
    if (failWith != null) throw failWith!;
    lastUserInput = draft.toInput();
  }

  @override
  Future<void> deleteUser(int id) async {
    if (failWith != null) throw failWith!;
    staff = staff.where((user) => user.id != id).toList();
  }

  @override
  Future<PaginatedResult<SellerRole>> roles({
    int page = 1,
    String? search,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(storedRoles);
  }

  @override
  Future<void> createRole(SellerRole role) async {
    if (failWith != null) throw failWith!;
    lastRoleInput = role.toInput();
    storedRoles = [...storedRoles, role];
  }

  @override
  Future<void> updateRole(SellerRole role) async {
    if (failWith != null) throw failWith!;
    lastRoleInput = role.toInput();
  }

  @override
  Future<void> deleteRole(int id) async {
    if (failWith != null) throw failWith!;
    storedRoles = storedRoles.where((role) => role.id != id).toList();
  }

  @override
  Future<List<({String key, String name, int level})>> aclPermissions() async =>
      const [];

  @override
  Future<SellerAccountHealth> accountHealth() async {
    if (healthFails) {
      throw const SellerApiException('Forbidden', SellerApiFailure.forbidden);
    }
    if (failWith != null) throw failWith!;
    return health ?? const SellerAccountHealth();
  }

  @override
  Future<SellerAccountHealth> refreshAccountHealth() async {
    if (failWith != null) throw failWith!;
    didRefreshHealth = true;
    return health ?? const SellerAccountHealth();
  }
}

class _FakeShopRepository implements ShopMarketplaceRepository {
  _FakeShopRepository({
    this.storedSellers = const [],
    this.shop,
    this.products = const [],
    this.top = const [],
    this.storedReviews = const [],
    this.offers = const [],
    this.threads = const [],
    this.thread,
    this.failWith,
    this.topFails = false,
  });

  List<ShopSeller> storedSellers;
  ShopSeller? shop;
  List<ShopSellerProduct> products;
  List<ShopSellerProduct> top;
  List<ShopSellerReview> storedReviews;
  List<ShopProductOffer> offers;
  List<ShopConversation> threads;
  ShopConversation? thread;
  final SellerApiException? failWith;
  final bool topFails;

  Map<String, dynamic>? lastReview;
  Map<String, dynamic>? lastContact;
  String? lastReportReason;
  String? lastSentMessage;
  int? markedReadFor;

  @override
  GraphQLClient get client => throw UnimplementedError();

  /// Who a product is sold by, and reports against that listing.
  ShopProductSeller? productSellerResult;
  Map<String, dynamic>? lastProductFlag;

  @override
  Future<ShopProductSeller?> productSeller(String product) async {
    if (failWith != null) throw failWith!;
    return productSellerResult;
  }

  @override
  Future<void> flagProduct({
    required int listingId,
    required String reason,
    String? otherReason,
  }) async {
    if (failWith != null) throw failWith!;
    lastProductFlag = {
      'listingId': listingId,
      'reason': reason,
      'otherReason': otherReason,
    };
  }

  static PaginatedResult<T> _page<T>(List<T> items) => PaginatedResult<T>(
    items: items,
    totalCount: items.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<PaginatedResult<ShopSeller>> sellers({
    int page = 1,
    String? search,
    String? country,
    String? city,
    String? sort,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(storedSellers);
  }

  @override
  Future<ShopSeller> seller(String slug) async {
    if (failWith != null) throw failWith!;
    return shop!;
  }

  @override
  Future<PaginatedResult<ShopSellerProduct>> sellerProducts({
    required String slug,
    int page = 1,
    String? sort,
    String? price,
    String? type,
    String? name,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(products);
  }

  @override
  Future<List<ShopSellerProduct>> topProducts(String slug) async {
    if (topFails) {
      throw const SellerApiException('Nope', SellerApiFailure.unknown);
    }
    return top;
  }

  @override
  Future<PaginatedResult<ShopSellerReview>> sellerReviews({
    required String slug,
    int page = 1,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(storedReviews);
  }

  @override
  Future<void> reviewSeller({
    required String slug,
    required int rating,
    required String title,
    required String comment,
  }) async {
    if (failWith != null) throw failWith!;
    lastReview = {
      'slug': slug,
      'rating': rating,
      'title': title,
      'comment': comment,
    };
  }

  @override
  Future<void> contactSeller({
    required String slug,
    required String name,
    required String email,
    required String message,
    String? subject,
  }) async {
    if (failWith != null) throw failWith!;
    lastContact = {
      'slug': slug,
      'name': name,
      'email': email,
      'query': message,
      'subject': subject,
    };
  }

  @override
  Future<void> flagSeller({
    required String slug,
    required String reason,
  }) async {
    if (failWith != null) throw failWith!;
    lastReportReason = reason;
  }

  @override
  Future<List<ShopFlagReason>> flagReasons({String? type}) async => const [];

  @override
  Future<bool> flagEnabled({required String type}) async => true;

  @override
  Future<List<ShopProductOffer>> productOffers(String urlKey) async {
    if (failWith != null) throw failWith!;
    return offers;
  }

  @override
  Future<PaginatedResult<ShopConversation>> conversations({
    int page = 1,
    String? search,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(threads);
  }

  @override
  Future<ShopConversation> conversation(int sellerId, {String? days}) async {
    if (failWith != null) throw failWith!;
    return thread!;
  }

  String? lastSentAttachment;
  String? lastSentAttachmentName;

  @override
  Future<void> sendMessage({
    required int sellerId,
    String? message,
    String? attachment,
    String? attachmentName,
  }) async {
    if (failWith != null) throw failWith!;
    lastSentMessage = message;
    lastSentAttachment = attachment;
    lastSentAttachmentName = attachmentName;
  }

  @override
  Future<void> markRead(int sellerId) async {
    markedReadFor = sellerId;
  }
}

const _shop = ShopSeller(
  id: 38,
  slug: 'acme-store-2',
  businessName: 'Acme Store-2',
  city: 'Pune',
  country: 'IN',
  avgRating: 5,
  totalReviews: 1,
  totalProducts: 12,
  totalOrders: 2,
);

void main() {
  group('settings models', () {
    test('a role granting everything sends no key list', () {
      const all = SellerRole(id: 1, name: 'Owner', permissionType: 'all');
      const custom = SellerRole(
        id: 2,
        name: 'Packer',
        permissions: ['sales.orders'],
      );

      expect(all.toInput().containsKey('permissions'), isFalse);
      expect(custom.toInput()['permissions'], ['sales.orders']);
    });

    test('a role held by staff cannot be deleted', () {
      const held = SellerRole(id: 1, name: 'Owner', usersCount: 2);
      const free = SellerRole(id: 2, name: 'Packer');

      expect(held.isInUse, isTrue);
      expect(free.isInUse, isFalse);
    });

    test('a staff draft only sends a password when one is being set', () {
      const withPassword = SellerUserDraft(
        name: 'Riya',
        email: 'riya@example.com',
        password: 'secret123',
      );
      const without = SellerUserDraft(name: 'Riya', email: 'riya@example.com');

      expect(withPassword.toInput()['password'], 'secret123');
      expect(withPassword.toInput()['passwordConfirmation'], 'secret123');
      expect(without.toInput().containsKey('password'), isFalse);
    });

    test('a staff member can only sign in once approved and not suspended', () {
      const ready = SellerUser(
        id: 1,
        name: 'A',
        email: 'a@x',
        isApproved: true,
      );
      const suspended = SellerUser(
        id: 2,
        name: 'B',
        email: 'b@x',
        isApproved: true,
        isSuspended: true,
      );
      const pending = SellerUser(id: 3, name: 'C', email: 'c@x');

      expect(ready.canSignIn, isTrue);
      expect(suspended.canSignIn, isFalse);
      expect(pending.canSignIn, isFalse);
    });

    test('account health reads metrics that arrive keyed by name', () {
      final health = SellerAccountHealth.fromJson(const {
        'score': 100,
        'scoreStatus': 'good',
        'overall': 'good',
        'canRefresh': true,
        'metrics': {
          'cancellation_rate': {
            'key': 'cancellation_rate',
            'value': 0,
            'formatted': '0%',
            'status': 'good',
            'thresholds': {'warning': 2.5, 'critical': 5},
          },
          'customer_feedback': {
            'key': 'customer_feedback',
            'value': 5,
            'formatted': '5.0',
            'status': 'good',
          },
        },
      });

      expect(health.score, 100);
      expect(health.isGood, isTrue);
      expect(health.metrics, hasLength(2));
      expect(health.metrics.first.label, 'Cancellation rate');
      expect(health.metrics.first.thresholds['critical'], 5);
    });
  });

  group('SellerSettingsCubit', () {
    testWidgets('password fields have visible containers in dark theme', (
      tester,
    ) async {
      final cubit = SellerSettingsCubit(
        repository: _FakeSettingsRepository(
          stored: const SellerSettings(
            preferredLocale: 'en',
            currency: 'USD',
            availableLocales: [SellerLocale(code: 'en', name: 'English')],
          ),
          health: const SellerAccountHealth(
            score: 89,
            overall: 'good',
            canRefresh: true,
          ),
        ),
      );
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(
        BlocProvider<SellerSettingsCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SellerSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final locale = tester.widget<DropdownButtonFormField<String>>(
        find.byKey(const Key('sellerSettingsLocale')),
      );
      expect(locale.decoration.filled, isTrue);
      expect(locale.decoration.fillColor, AppColors.neutral900);
      expect(locale.decoration.enabledBorder, isA<OutlineInputBorder>());

      await tester.pumpWidget(
        BlocProvider<SellerSettingsCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SellerAccountHealthPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final refresh = tester.widget<SellerBusyButton>(
        find.byKey(const Key('sellerHealthRefresh')),
      );
      expect(
        refresh.style?.side?.resolve(<WidgetState>{}),
        const BorderSide(color: AppColors.primary500),
      );

      expect(find.byKey(const Key('sellerHealthGuideTile')), findsOneWidget);
      expect(find.byKey(const Key('sellerHealthGuideButton')), findsOneWidget);

      await tester.tap(find.byKey(const Key('sellerHealthGuideTile')));
      await tester.pumpAndSettle();

      expect(find.byType(SellerAccountHealthGuidePage), findsOneWidget);
      expect(find.text('How the Health Score Is Calculated'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Live calculator'), 200);
      expect(find.text('Live calculator'), findsOneWidget);

      Navigator.of(
        tester.element(find.byType(SellerAccountHealthGuidePage)),
      ).pop();
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        BlocProvider<SellerSettingsCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SellerSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('sellerSettingsCurrentPassword')),
        240,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      for (final key in const [
        Key('sellerSettingsCurrentPassword'),
        Key('sellerSettingsNewPassword'),
      ]) {
        final field = tester.widget<TextField>(find.byKey(key));
        expect(field.decoration?.filled, isTrue);
        expect(field.decoration?.fillColor, AppColors.neutral900);
        expect(field.decoration?.enabledBorder, isA<OutlineInputBorder>());
      }
    });

    testWidgets(
        'SellerAccountHealthGuidePage calculates health score dynamically',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SellerAccountHealthGuidePage(
            flagsEnabled: true,
            redFlagLimit: 10,
            initialCancelRate: 0.0,
            initialRating: 5.0,
            initialFlags: 0,
            initialHasReviews: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('How the Health Score Is Calculated'), findsOneWidget);
      expect(find.text('Healthy'), findsWidgets);
      expect(find.textContaining('100'), findsWidgets);

      // Toggle off reviews
      await tester.tap(find.text('No reviews'));
      await tester.pumpAndSettle();

      // Avg rating remains visible and movable, but does not affect health score (just like on Web)
      expect(find.text('Avg rating'), findsOneWidget);
      final ratingSliderFinder = find.byKey(const Key('accountHealthRatingSlider'));
      final ratingSlider = tester.widget<Slider>(ratingSliderFinder);
      expect(ratingSlider.onChanged, isNotNull);

      // Moving the slider updates the chip value but does NOT change the health score
      ratingSlider.onChanged!(1.0);
      await tester.pumpAndSettle();
      expect(find.text('1.0 / 5'), findsOneWidget);
      expect(find.textContaining('100'), findsWidgets);
    });

    test('load reads settings, staff, roles and health', () async {
      final cubit = SellerSettingsCubit(
        repository: _FakeSettingsRepository(
          stored: const SellerSettings(currency: 'USD'),
          staff: const [SellerUser(id: 1, name: 'Riya', email: 'riya@x')],
          storedRoles: const [SellerRole(id: 1, name: 'Owner')],
          health: const SellerAccountHealth(score: 100, overall: 'good'),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerSettingsStatus.loaded);
      expect(cubit.state.settings?.currency, 'USD');
      expect(cubit.state.users, hasLength(1));
      expect(cubit.state.roles, hasLength(1));
      expect(cubit.state.health?.score, 100);
    });

    test('a role without the scorecard still gets the rest of the '
        'screen', () async {
      final cubit = SellerSettingsCubit(
        repository: _FakeSettingsRepository(healthFails: true),
      );

      await cubit.load();

      expect(cubit.state.status, SellerSettingsStatus.loaded);
      expect(cubit.state.health, isNull);
    });

    test('changing the password sends the current one too', () async {
      final repository = _FakeSettingsRepository();
      final cubit = SellerSettingsCubit(repository: repository);

      final ok = await cubit.changePassword(
        currentPassword: 'old-one',
        newPassword: 'new-one',
      );

      expect(ok, isTrue);
      expect(repository.lastCurrentPassword, 'old-one');
    });

    test('saving a new staff member creates rather than updates', () async {
      final repository = _FakeSettingsRepository();
      final cubit = SellerSettingsCubit(repository: repository);

      await cubit.saveUser(
        const SellerUserDraft(
          name: 'Riya',
          email: 'riya@example.com',
          password: 'secret123',
          roleId: 1,
        ),
      );

      expect(repository.lastUserInput?['email'], 'riya@example.com');
      expect(repository.lastUserInput?['marketplaceRoleId'], 1);
      expect(cubit.state.users, hasLength(1));
    });

    test('a failed read surfaces the server message', () async {
      final cubit = SellerSettingsCubit(
        repository: _FakeSettingsRepository(
          failWith: const SellerApiException(
            'Forbidden',
            SellerApiFailure.forbidden,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerSettingsStatus.failed);
      expect(cubit.state.errorMessage, 'Forbidden');
    });

    test('refreshing health keeps the new scorecard', () async {
      final repository = _FakeSettingsRepository(
        health: const SellerAccountHealth(score: 92, overall: 'good'),
      );
      final cubit = SellerSettingsCubit(repository: repository);

      final ok = await cubit.refreshHealth();

      expect(ok, isTrue);
      expect(repository.didRefreshHealth, isTrue);
      expect(cubit.state.health?.score, 92);
    });
  });

  group('shop models', () {
    test('a shop reads its social links, skipping the empty ones', () {
      final seller = ShopSeller.fromJson(const {
        'id': 38,
        'slug': 'acme-store-2',
        'businessName': 'Acme Store-2',
        'socialLinks': [
          {
            'code': 'facebook',
            'name': 'Facebook',
            'value': 'https://facebook.com/acme',
          },
          {'code': 'twitter', 'name': 'Twitter', 'value': ''},
        ],
        'additionalFields': [
          {'code': 'gst', 'label': 'GST number', 'value': '27ABCDE'},
        ],
      });

      expect(seller.socialLinks, hasLength(1));
      expect(seller.socialLinks.single.label, 'Facebook');
      expect(seller.additionalFields.single.label, 'GST number');
    });

    test('a shop review parses customerImageUrl when present or null', () {
      final withImage = ShopSellerReview.fromJson(const {
        'id': 27,
        'rating': 5,
        'title': 'Great store',
        'comment': 'Fast delivery',
        'customerName': 'Aarav Sharma',
        'customerImageUrl': 'https://example.com/avatar.png',
        'createdAt': '2026-10-27',
      });
      expect(withImage.customerImageUrl, 'https://example.com/avatar.png');

      final withoutImage = ShopSellerReview.fromJson(const {
        'id': 28,
        'rating': 4,
        'customerName': 'Neha',
      });
      expect(withoutImage.customerImageUrl, isNull);
    });

    test('a shop reports where it is, from whichever half exists', () {
      expect(_shop.location, 'Pune, IN');

      const noCity = ShopSeller(
        id: 1,
        slug: 'x',
        businessName: 'X',
        country: 'IN',
      );
      expect(noCity.location, 'IN');
    });

    test('the best offer is the cheapest one that can be bought', () {
      const state = ShopOffersState(
        offers: [
          ShopProductOffer(
            listingId: 1,
            sellerId: 1,
            sellerName: 'Cheap but gone',
            price: 5,
            isSaleable: false,
          ),
          ShopProductOffer(
            listingId: 2,
            sellerId: 2,
            sellerName: 'In stock',
            price: 12,
          ),
          ShopProductOffer(
            listingId: 3,
            sellerId: 3,
            sellerName: 'Dearer',
            price: 20,
          ),
        ],
      );

      expect(state.bestOffer?.sellerName, 'In stock');
    });

    test('a message knows whose side it is on', () {
      const mine = ShopMessage(id: 1, senderType: 'customer');
      const theirs = ShopMessage(id: 2, senderType: 'seller');

      expect(mine.isMine, isTrue);
      expect(theirs.isMine, isFalse);
    });
  });

  group('ShopSellerCubit', () {
    test('load reads the shop, its products and its reviews', () async {
      final cubit = ShopSellerCubit(
        repository: _FakeShopRepository(
          shop: _shop,
          products: const [
            ShopSellerProduct(id: 56, sku: 'demo-mug', name: 'Stoneware Mug'),
          ],
          storedReviews: const [ShopSellerReview(id: 1, rating: 5)],
        ),
        slug: 'acme-store-2',
      );

      await cubit.load();

      expect(cubit.state.status, ShopStatus.loaded);
      expect(cubit.state.seller?.businessName, 'Acme Store-2');
      expect(cubit.state.products, hasLength(1));
      expect(cubit.state.reviews, hasLength(1));
    });

    test('a shop with no best-sellers shelf still opens', () async {
      final cubit = ShopSellerCubit(
        repository: _FakeShopRepository(shop: _shop, topFails: true),
        slug: 'acme-store-2',
      );

      await cubit.load();

      expect(cubit.state.status, ShopStatus.loaded);
      expect(cubit.state.topProducts, isEmpty);
    });

    test('the best-sellers shelf is kept when the shop has one', () async {
      final cubit = ShopSellerCubit(
        repository: _FakeShopRepository(
          shop: _shop,
          top: const [
            ShopSellerProduct(id: 58, sku: 'demo-watch', name: 'Wrist Watch'),
          ],
        ),
        slug: 'acme-store-2',
      );

      await cubit.load();

      expect(cubit.state.topProducts.single.sku, 'demo-watch');
    });

    test(
      'a review is posted and the shopper told it awaits approval',
      () async {
        final repository = _FakeShopRepository(shop: _shop);
        final cubit = ShopSellerCubit(
          repository: repository,
          slug: 'acme-store-2',
        );

        final ok = await cubit.review(
          rating: 5,
          title: '  Fast dispatch  ',
          comment: 'Arrived Monday.',
        );

        expect(ok, isTrue);
        expect(repository.lastReview?['title'], 'Fast dispatch');
        expect(cubit.state.successMessage, contains('awaiting approval'));
      },
    );

    test('the contact form sends the message under `query`', () async {
      final repository = _FakeShopRepository(shop: _shop);
      final cubit = ShopSellerCubit(
        repository: repository,
        slug: 'acme-store-2',
      );

      await cubit.contact(
        name: 'Aarav',
        email: 'aarav@example.com',
        message: 'Do you ship to Goa?',
      );

      expect(repository.lastContact?['query'], 'Do you ship to Goa?');
      expect(repository.lastContact?['name'], 'Aarav');
    });

    test('reporting sends the reason text, not an id', () async {
      final repository = _FakeShopRepository(shop: _shop);
      final cubit = ShopSellerCubit(
        repository: repository,
        slug: 'acme-store-2',
      );

      await cubit.report('Damaged product sold by seller');

      expect(repository.lastReportReason, 'Damaged product sold by seller');
    });
  });

  group('ShopConversationsCubit', () {
    test('opening a thread with unread messages marks it read', () async {
      final repository = _FakeShopRepository(
        threads: const [ShopConversation(id: 38, unreadCount: 2)],
        thread: const ShopConversation(id: 38, unreadCount: 2),
      );
      final cubit = ShopConversationsCubit(repository: repository);

      await cubit.load();
      await cubit.open(38);

      expect(repository.markedReadFor, 38);
      expect(cubit.state.openThread?.id, 38);
    });

    test('an already-read thread is not marked again', () async {
      final repository = _FakeShopRepository(
        thread: const ShopConversation(id: 38),
      );
      final cubit = ShopConversationsCubit(repository: repository);

      await cubit.open(38);

      expect(repository.markedReadFor, isNull);
    });

    test('an empty message is not worth sending', () async {
      final repository = _FakeShopRepository(
        thread: const ShopConversation(id: 38),
      );
      final cubit = ShopConversationsCubit(repository: repository);

      final sent = await cubit.send(38, '   ');

      expect(sent, isFalse);
      expect(repository.lastSentMessage, isNull);
    });

    test('sending rereads the thread', () async {
      final repository = _FakeShopRepository(
        thread: const ShopConversation(
          id: 38,
          messages: [ShopMessage(id: 1, senderType: 'customer', text: 'Hi')],
        ),
      );
      final cubit = ShopConversationsCubit(repository: repository);

      final sent = await cubit.send(38, '  Hi  ');

      expect(sent, isTrue);
      expect(repository.lastSentMessage, 'Hi');
      expect(cubit.state.openThread?.messages, hasLength(1));
    });

    test('sending attachment without message succeeds', () async {
      final repository = _FakeShopRepository(
        thread: const ShopConversation(
          id: 38,
          messages: [
            ShopMessage(
              id: 1,
              senderType: 'customer',
              attachmentUrl: 'https://example.com/file.png',
            ),
          ],
        ),
      );
      final cubit = ShopConversationsCubit(repository: repository);

      final sent = await cubit.send(
        38,
        '',
        attachment: 'data:image/png;base64,...',
        attachmentName: 'file.png',
      );

      expect(sent, isTrue);
      expect(repository.lastSentMessage, isNull);
      expect(repository.lastSentAttachment, 'data:image/png;base64,...');
      expect(repository.lastSentAttachmentName, 'file.png');
    });
  });

  group('ShopOffersCubit', () {
    test('load reads every seller offering the product', () async {
      final cubit = ShopOffersCubit(
        repository: _FakeShopRepository(
          offers: const [
            ShopProductOffer(
              listingId: 41,
              sellerId: 38,
              sellerName: 'Acme Store-2',
              price: 12.5,
            ),
          ],
        ),
      );

      await cubit.load('demo-mug-1786708923');

      expect(cubit.state.status, ShopStatus.loaded);
      expect(cubit.state.offers.single.sellerName, 'Acme Store-2');
      expect(cubit.state.bestOffer?.listingId, 41);
    });

    test('a product only one seller has reads as an empty list', () async {
      final cubit = ShopOffersCubit(repository: _FakeShopRepository());

      await cubit.load('demo-lamp');

      expect(cubit.state.offers, isEmpty);
      expect(cubit.state.bestOffer, isNull);
    });
  });

  group('ShopSellersCubit', () {
    test('load reads the directory', () async {
      final cubit = ShopSellersCubit(
        repository: _FakeShopRepository(storedSellers: const [_shop]),
      );

      await cubit.load();

      expect(cubit.state.status, ShopStatus.loaded);
      expect(cubit.state.sellers.single.slug, 'acme-store-2');
    });

    test('a failed read surfaces the message', () async {
      final cubit = ShopSellersCubit(
        repository: _FakeShopRepository(
          failWith: const SellerApiException(
            'Network error',
            SellerApiFailure.unknown,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, ShopStatus.failed);
      expect(cubit.state.errorMessage, 'Network error');
    });
  });
}
