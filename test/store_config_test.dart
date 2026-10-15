import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/core/store_config/store_config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Payload returned by the local Bagisto server on 2026-10-14.
const _serverPayload = <String, dynamic>{
  'id': '/api/shop/store_configs/default',
  'guestCheckoutEnabled': true,
  'reorderEnabled': true,
  'minimumOrderEnabled': false,
  'minimumOrderAmount': null,
  'minimumOrderIncludesDiscount': false,
  'minimumOrderIncludesTax': false,
  'minimumOrderMessage': null,
  'customerReviewEnabled': true,
  'guestReviewEnabled': false,
  'reviewerNameCensored': true,
  'compareEnabled': true,
  'wishlistEnabled': true,
  'imageSearchEnabled': true,
  'socialShareEnabled': false,
  'newsletterEnabled': true,
};

class _FakeRepository extends StoreConfigRepository {
  _FakeRepository(this.result)
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(),
        ),
      );

  final Object result;

  @override
  Future<StoreConfig> fetch() async {
    final value = result;
    if (value is StoreConfig) return value;
    throw value;
  }
}

void main() {
  group('StoreConfig.fromJson', () {
    test('parses the server payload', () {
      final config = StoreConfig.fromJson(_serverPayload);

      expect(config.guestCheckoutEnabled, isTrue);
      expect(config.guestReviewEnabled, isFalse);
      expect(config.socialShareEnabled, isFalse);
      expect(config.reviewerNameCensored, isTrue);
      expect(config.minimumOrderEnabled, isFalse);
      expect(config.minimumOrderAmount, isNull);
      expect(config.minimumOrderMessage, isNull);
    });

    test('keeps missing fields null', () {
      final config = StoreConfig.fromJson(const {'wishlistEnabled': false});

      expect(config.wishlistEnabled, isFalse);
      expect(config.compareEnabled, isNull);
      expect(config.showCompare, isTrue);
    });

    test('accepts string and numeric encodings', () {
      final config = StoreConfig.fromJson(const {
        'wishlistEnabled': '0',
        'compareEnabled': 1,
        'minimumOrderEnabled': 'true',
        'minimumOrderAmount': '150.50',
        'minimumOrderMessage': '  ',
      });

      expect(config.wishlistEnabled, isFalse);
      expect(config.compareEnabled, isTrue);
      expect(config.minimumOrderEnabled, isTrue);
      expect(config.minimumOrderAmount, 150.5);
      expect(config.minimumOrderMessage, isNull);
    });
  });

  group('StoreConfig getters', () {
    test('empty config keeps every feature on', () {
      const config = StoreConfig();

      expect(config.showWishlist, isTrue);
      expect(config.showCompare, isTrue);
      expect(config.showImageSearch, isTrue);
      expect(config.showSocialShare, isTrue);
      expect(config.showReorder, isTrue);
      expect(config.showNewsletter, isTrue);
      expect(config.allowGuestCheckout, isTrue);
      expect(config.allowCustomerReview, isTrue);
      expect(config.allowGuestReview, isTrue);
      expect(config.censorReviewerName, isFalse);
      expect(config.hasMinimumOrder, isFalse);
    });

    test('false flags turn features off', () {
      final config = StoreConfig.fromJson(const {
        'wishlistEnabled': false,
        'compareEnabled': false,
        'imageSearchEnabled': false,
        'socialShareEnabled': false,
        'reorderEnabled': false,
        'newsletterEnabled': false,
        'guestCheckoutEnabled': false,
        'customerReviewEnabled': false,
        'guestReviewEnabled': false,
      });

      expect(config.showWishlist, isFalse);
      expect(config.showCompare, isFalse);
      expect(config.showImageSearch, isFalse);
      expect(config.showSocialShare, isFalse);
      expect(config.showReorder, isFalse);
      expect(config.showNewsletter, isFalse);
      expect(config.allowGuestCheckout, isFalse);
      expect(config.allowCustomerReview, isFalse);
      expect(config.allowGuestReview, isFalse);
    });

    test('minimum order total follows the include flags', () {
      final plain = StoreConfig.fromJson(const {
        'minimumOrderEnabled': true,
        'minimumOrderAmount': 100,
      });
      final withDiscountAndTax = StoreConfig.fromJson(const {
        'minimumOrderEnabled': true,
        'minimumOrderAmount': 100,
        'minimumOrderIncludesDiscount': true,
        'minimumOrderIncludesTax': true,
      });

      expect(plain.hasMinimumOrder, isTrue);
      expect(
        plain.minimumOrderTotal(subtotal: 90, discount: 10, tax: 15),
        90,
      );
      expect(
        withDiscountAndTax.minimumOrderTotal(
          subtotal: 90,
          discount: 10,
          tax: 15,
        ),
        95,
      );
      expect(
        plain.meetsMinimumOrder(subtotal: 90, discount: 0, tax: 0),
        isFalse,
      );
      expect(
        plain.meetsMinimumOrder(subtotal: 100, discount: 0, tax: 0),
        isTrue,
      );
    });

    test('minimum order without an amount does not block', () {
      final config = StoreConfig.fromJson(const {'minimumOrderEnabled': true});

      expect(config.hasMinimumOrder, isFalse);
      expect(
        config.meetsMinimumOrder(subtotal: 0, discount: 0, tax: 0),
        isTrue,
      );
    });
  });

  test('cart page flag', () {
    expect(const StoreConfig().showCartPage, isTrue);
    expect(
      StoreConfig.fromJson(const {'cartPageEnabled': false}).showCartPage,
      isFalse,
    );
  });

  group('cart summary', () {
    test('number of items mode counts cart lines', () {
      final config = StoreConfig.fromJson(const {
        'cartSummary': 'display_number_of_items_in_cart',
      });
      expect(config.cartSummaryShowsItemCount, isTrue);
      expect(config.cartCount(itemsCount: 2, itemsQty: 5), 2);
    });

    test('item quantity mode and unknown both count quantities', () {
      final config = StoreConfig.fromJson(const {
        'cartSummary': 'display_item_quantity',
      });
      expect(config.cartCount(itemsCount: 2, itemsQty: 5), 5);
      expect(const StoreConfig().cartCount(itemsCount: 2, itemsQty: 5), 5);
    });
  });

  test('store config query uses the server field names', () {
    final query = StoreConfigQueries.getStoreConfig;
    expect(query, contains('buyNowButtonEnabled'));
    expect(query, contains('cartSummary'));
    expect(query, contains('cartPageEnabled'));
    expect(query, contains('miniCartOfferInfo'));
    expect(query, isNot(contains('miniCartOfferInfoEnabled')));
    expect(query, isNot(contains('buyNowEnabled')));
  });

  group('StoreConfigCubit', () {
    test('load emits the fetched config', () async {
      final fetched = StoreConfig.fromJson(_serverPayload);
      final cubit = StoreConfigCubit(repository: _FakeRepository(fetched));
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state, fetched);
    });

    test('a failed load keeps the previous config', () async {
      final cubit = StoreConfigCubit(
        repository: _FakeRepository(Exception('offline')),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state, const StoreConfig());
    });
  });

  testWidgets('StoreConfig.of falls back to an empty config', (tester) async {
    late StoreConfig withoutCubit;
    late StoreConfig withCubit;
    final seeded = StoreConfig.fromJson(const {'wishlistEnabled': false});
    final cubit = StoreConfigCubit(repository: _FakeRepository(seeded));
    addTearDown(cubit.close);
    await cubit.load();

    await tester.pumpWidget(
      Column(
        children: [
          Builder(
            builder: (context) {
              withoutCubit = StoreConfig.of(context);
              return const SizedBox();
            },
          ),
          BlocProvider.value(
            value: cubit,
            child: Builder(
              builder: (context) {
                withCubit = StoreConfig.of(context);
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );

    expect(withoutCubit, const StoreConfig());
    expect(withCubit.showWishlist, isFalse);
  });
}
