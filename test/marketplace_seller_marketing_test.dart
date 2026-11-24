import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_bulk_ops.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_marketing.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_marketing_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/bloc/seller_marketing_cubits.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeMarketingRepository implements SellerMarketingRepository {
  _FakeMarketingRepository({
    this.discounts = const [],
    this.joinable = const [],
    this.deals = const [],
    this.storedCoupons = const [],
    this.failWith,
  });

  List<SellerProductDiscount> discounts;
  List<SellerJoinableDiscount> joinable;
  List<SellerCheckoutDeal> deals;
  List<SellerCoupon> storedCoupons;
  final SellerApiException? failWith;

  Map<String, dynamic>? lastDiscountInput;
  Map<String, dynamic>? lastDealInput;
  Map<String, dynamic>? lastCouponInput;
  List<int>? lastEnrolled;
  List<int>? lastWithdrawn;
  int? deletedCouponId;
  int? copiedDealId;
  int? readJoinable;

  /// The server's own lists, as the editor reads them.
  SellerRuleOptions options = const SellerRuleOptions(
    channels: [SellerRuleOption(value: '1', label: 'Default')],
    customerGroups: [
      SellerRuleOption(value: '1', label: 'Guest'),
      SellerRuleOption(value: '2', label: 'General'),
      SellerRuleOption(value: '3', label: 'Wholesale'),
    ],
    actionTypes: [
      SellerRuleOption(
        value: 'by_percent',
        label: 'Percentage of product price',
      ),
      SellerRuleOption(
        value: 'by_fixed',
        label: 'Fixed amount off product price',
      ),
    ],
    conditionGroups: [
      SellerConditionGroup(
        key: 'product',
        label: 'Product attribute',
        attributes: [
          SellerConditionAttribute(
            key: 'product|category_ids',
            label: 'Categories',
            type: 'multiselect',
            operators: [
              SellerRuleOption(value: '{}', label: 'Contains'),
              SellerRuleOption(value: '!{}', label: 'Does not contain'),
            ],
            options: [
              SellerRuleOption(value: '1', label: 'Root'),
              SellerRuleOption(value: '4', label: 'Mugs'),
            ],
          ),
          SellerConditionAttribute(
            key: 'product|price',
            label: 'Price',
            type: 'price',
            operators: [
              SellerRuleOption(value: '==', label: 'Is equal to'),
              SellerRuleOption(value: '>=', label: 'Equals or greater than'),
            ],
          ),
        ],
      ),
      SellerConditionGroup(
        key: 'cart',
        label: 'Cart attribute',
        attributes: [
          SellerConditionAttribute(
            key: 'cart|base_sub_total',
            label: 'Subtotal',
            type: 'price',
            operators: [
              SellerRuleOption(value: '>=', label: 'Equals or greater than'),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  GraphQLClient get client => throw UnimplementedError();

  static PaginatedResult<T> _page<T>(List<T> items) => PaginatedResult<T>(
    items: items,
    totalCount: items.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<PaginatedResult<SellerProductDiscount>> productDiscounts({
    int page = 1,
    String? search,
    int? status,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(discounts);
  }

  @override
  Future<SellerProductDiscount> productDiscount(int id) async =>
      discounts.firstWhere((discount) => discount.id == id);

  @override
  Future<SellerProductDiscount> createProductDiscount(
    SellerProductDiscount discount,
  ) async {
    if (failWith != null) throw failWith!;
    lastDiscountInput = discount.toInput();
    discounts = [...discounts, discount];
    return discount;
  }

  @override
  Future<SellerProductDiscount> updateProductDiscount(
    SellerProductDiscount discount,
  ) async {
    if (failWith != null) throw failWith!;
    lastDiscountInput = discount.toInput();
    return discount;
  }

  @override
  Future<void> deleteProductDiscount(int id) async {
    if (failWith != null) throw failWith!;
    discounts = discounts.where((discount) => discount.id != id).toList();
  }

  @override
  Future<PaginatedResult<SellerJoinableDiscount>> joinableDiscounts({
    int page = 1,
    String? search,
    int? status,
    String? participation,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(joinable);
  }

  /// One admin rule in full — what the detail screen reads.
  @override
  Future<SellerJoinableDiscount> joinableDiscount(int id) async {
    if (failWith != null) throw failWith!;
    readJoinable = id;
    return joinable.firstWhere((campaign) => campaign.id == id);
  }

  /// What a rule may be written against. The condition rows are built from
  /// this, so a fake that returns nothing gives an editor with empty rows.
  @override
  Future<SellerRuleOptions> ruleOptions() async {
    if (failWith != null) throw failWith!;
    return options;
  }

  @override
  Future<SellerRuleOptions> dealOptions() async {
    if (failWith != null) throw failWith!;
    return options;
  }

  @override
  Future<void> enrolInDiscounts(List<int> ids) async {
    if (failWith != null) throw failWith!;
    lastEnrolled = ids;
  }

  @override
  Future<void> withdrawFromDiscounts(List<int> ids) async {
    if (failWith != null) throw failWith!;
    lastWithdrawn = ids;
  }

  @override
  Future<PaginatedResult<SellerCheckoutDeal>> checkoutDeals({
    int page = 1,
    String? search,
    int? status,
    int? couponType,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(deals);
  }

  @override
  Future<SellerCheckoutDeal> checkoutDeal(int id) async =>
      deals.firstWhere((deal) => deal.id == id);

  @override
  Future<SellerCheckoutDeal> createCheckoutDeal(SellerCheckoutDeal deal) async {
    if (failWith != null) throw failWith!;
    lastDealInput = deal.toInput();
    deals = [...deals, deal];
    return deal;
  }

  @override
  Future<SellerCheckoutDeal> updateCheckoutDeal(SellerCheckoutDeal deal) async {
    if (failWith != null) throw failWith!;
    lastDealInput = deal.toInput();
    return deal;
  }

  @override
  Future<void> deleteCheckoutDeal(int id) async {
    if (failWith != null) throw failWith!;
    deals = deals.where((deal) => deal.id != id).toList();
  }

  @override
  Future<SellerCheckoutDeal> copyCheckoutDeal(int id) async {
    if (failWith != null) throw failWith!;
    copiedDealId = id;
    final original = deals.firstWhere((deal) => deal.id == id);
    final copy = original.copyWith(
      name: 'Copy of ${original.name}',
      status: false,
    );
    deals = [...deals, copy];
    return copy;
  }

  @override
  Future<PaginatedResult<SellerCoupon>> coupons({
    required int dealId,
    int page = 1,
    String? search,
  }) async {
    if (failWith != null) throw failWith!;
    return _page(storedCoupons);
  }

  @override
  Future<void> generateCoupons(SellerCouponBatchRequest request) async {
    if (failWith != null) throw failWith!;
    lastCouponInput = request.toInput();
    storedCoupons = [
      ...storedCoupons,
      for (var index = 0; index < request.quantity; index++)
        SellerCoupon(
          id: 100 + index,
          code: 'CODE$index',
          dealId: request.dealId,
        ),
    ];
  }

  @override
  Future<void> deleteCoupon(int couponId) async {
    if (failWith != null) throw failWith!;
    deletedCouponId = couponId;
    storedCoupons = storedCoupons
        .where((coupon) => coupon.id != couponId)
        .toList();
  }
}

const _discount = SellerProductDiscount(
  id: 28,
  name: 'Monsoon 10% off',
  actionType: SellerDiscountAction.byPercent,
  discountAmount: 10,
  channels: [1],
  customerGroups: [1, 2, 3],
);

const _deal = SellerCheckoutDeal(
  id: 23,
  name: 'Festive 200 off',
  actionType: SellerDiscountAction.byFixed,
  discountAmount: 200,
  needsCoupon: true,
  autoGenerateCoupons: true,
  couponsCount: 5,
);

void main() {
  group('models', () {
    test('a percentage rule labels its amount with a percent sign', () {
      expect(_discount.amountLabel, '10%');
      expect(_deal.amountLabel, '200.00');
    });

    test('the coupon flags are ints on the wire, not booleans', () {
      final input = _deal.toInput();

      expect(input['couponType'], 1);
      expect(input['useAutoGeneration'], 1);
    });

    test('a fixed code is only sent when the deal is not generating a '
        'batch', () {
      const auto = SellerCheckoutDeal(
        id: 1,
        name: 'Auto',
        needsCoupon: true,
        autoGenerateCoupons: true,
        couponCode: 'IGNORED',
      );
      const single = SellerCheckoutDeal(
        id: 2,
        name: 'Single',
        needsCoupon: true,
        couponCode: 'WELCOME5',
      );

      expect(auto.toInput().containsKey('couponCode'), isFalse);
      expect(single.toInput()['couponCode'], 'WELCOME5');
    });

    test('a coupon batch is never asked for below the server minimum', () {
      const request = SellerCouponBatchRequest(dealId: 23, codeLength: 8);

      // The server refuses anything under 10 outright.
      expect(request.toInput()['codeLength'], 10);
    });

    test('a stock edit sends records, matching the assign mutation', () {
      const edit = SellerStockEdit(productId: 56, quantities: {5: 24});

      expect(edit.toRecord()['inventories'], [
        {'inventorySourceId': 5, 'qty': 24},
      ]);
    });

    test('a price edit leaves out what was not changed', () {
      const edit = SellerPriceEdit(productId: 56, price: 13.5);
      final record = edit.toRecord();

      expect(record['price'], 13.5);
      expect(record.containsKey('specialPrice'), isFalse);
    });

    test('an import reports progress from whatever stats the server sent', () {
      final job = SellerImport.fromJson(const {
        'id': 1,
        'state': 'validating',
        'nextAction': 'validate',
        'stats': {'processed': 5, 'total': 20},
      });

      expect(job.progress, 0.25);
      expect(job.isFinished, isFalse);

      final noStats = SellerImport.fromJson(const {
        'id': 2,
        'state': 'pending',
      });
      expect(noStats.progress, isNull);
    });
  });

  group('bulk payloads', () {
    // These used to be rendered into the document by hand: the server's
    // `Iterable` scalar dropped nested objects arriving as variables and
    // answered "No inventories were saved". Re-checked live on 2026-08-18 —
    // both mass saves now accept variables and read back — so the records go
    // as data and no GraphQL is built by string.
    test('a price row carries every field the save takes', () {
      expect(
        const SellerPriceEdit(
          productId: 56,
          price: 13.5,
          specialPrice: 9.5,
          specialPriceFrom: '2026-09-01',
          specialPriceTo: '2026-09-30',
        ).toRecord(),
        {
          'productId': 56,
          'price': 13.5,
          'specialPrice': 9.5,
          'specialPriceFrom': '2026-09-01',
          'specialPriceTo': '2026-09-30',
        },
      );
    });

    test('a stock row sends records, one per source', () {
      expect(
        const SellerStockEdit(productId: 56, quantities: {5: 24}).toRecord(),
        {
          'productId': 56,
          'inventories': [
            {'inventorySourceId': 5, 'qty': 24},
          ],
        },
      );
    });
  });

  group('SellerMarketingCubit', () {
    test('load reads all three lists', () async {
      final cubit = SellerMarketingCubit(
        repository: _FakeMarketingRepository(
          discounts: const [_discount],
          joinable: const [
            SellerJoinableDiscount(id: 14, name: 'Marketplace Autumn Sale'),
          ],
          deals: const [_deal],
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerMarketingStatus.loaded);
      expect(cubit.state.discounts, hasLength(1));
      expect(cubit.state.joinable, hasLength(1));
      expect(cubit.state.deals, hasLength(1));
    });

    test('creating a discount sends the rule and rereads the lists', () async {
      final repository = _FakeMarketingRepository();
      final cubit = SellerMarketingCubit(repository: repository);

      final ok = await cubit.createDiscount(_discount);

      expect(ok, isTrue);
      expect(repository.lastDiscountInput?['name'], 'Monsoon 10% off');
      expect(repository.lastDiscountInput?['actionType'], 'by_percent');
      expect(cubit.state.discounts, hasLength(1));
      expect(cubit.state.successMessage, 'Discount created');
    });

    test('joining and leaving a campaign send the ids', () async {
      final repository = _FakeMarketingRepository(
        joinable: const [SellerJoinableDiscount(id: 14, name: 'Autumn')],
      );
      final cubit = SellerMarketingCubit(repository: repository);

      await cubit.joinDiscounts([14]);
      expect(repository.lastEnrolled, [14]);

      await cubit.leaveDiscounts([14]);
      expect(repository.lastWithdrawn, [14]);
    });

    test('copying a deal makes an inactive copy', () async {
      final repository = _FakeMarketingRepository(deals: const [_deal]);
      final cubit = SellerMarketingCubit(repository: repository);

      await cubit.load();
      final ok = await cubit.copyDeal(23);

      expect(ok, isTrue);
      expect(repository.copiedDealId, 23);
      expect(cubit.state.deals.last.name, 'Copy of Festive 200 off');
      expect(cubit.state.deals.last.status, isFalse);
    });

    test('deleting a discount drops it', () async {
      final repository = _FakeMarketingRepository(discounts: const [_discount]);
      final cubit = SellerMarketingCubit(repository: repository);

      await cubit.load();
      await cubit.deleteDiscount(28);

      expect(cubit.state.discounts, isEmpty);
    });

    test('a rejected write surfaces the server message', () async {
      final cubit = SellerMarketingCubit(
        repository: _FakeMarketingRepository(
          failWith: const SellerApiException(
            'The name field is required.',
            SellerApiFailure.validation,
          ),
        ),
      );

      final ok = await cubit.createDiscount(_discount);

      expect(ok, isFalse);
      expect(cubit.state.errorMessage, 'The name field is required.');
      expect(cubit.state.isWorking, isFalse);
    });
  });

  group('SellerCouponsCubit', () {
    test('generate asks for the batch and rereads the codes', () async {
      final repository = _FakeMarketingRepository();
      final cubit = SellerCouponsCubit(repository: repository, dealId: 23);

      final ok = await cubit.generate(
        quantity: 3,
        codeLength: 12,
        prefix: 'FEST-',
      );

      expect(ok, isTrue);
      expect(repository.lastCouponInput?['couponQty'], 3);
      expect(repository.lastCouponInput?['codeLength'], 12);
      expect(repository.lastCouponInput?['codePrefix'], 'FEST-');
      expect(cubit.state.coupons, hasLength(3));
    });

    test('a short code length is raised to the server minimum', () async {
      final repository = _FakeMarketingRepository();
      final cubit = SellerCouponsCubit(repository: repository, dealId: 23);

      await cubit.generate(quantity: 1, codeLength: 4);

      expect(repository.lastCouponInput?['codeLength'], 10);
    });

    test('deleting takes the coupon id, not the deal id', () async {
      final repository = _FakeMarketingRepository(
        storedCoupons: const [
          SellerCoupon(id: 101, code: 'FEST-AAAA', dealId: 23),
          SellerCoupon(id: 102, code: 'FEST-BBBB', dealId: 23),
        ],
      );
      final cubit = SellerCouponsCubit(repository: repository, dealId: 23);

      await cubit.load();
      await cubit.delete(101);

      expect(repository.deletedCouponId, 101);
      expect(cubit.state.coupons.single.id, 102);
      expect(cubit.state.totalCount, 1);
    });

    test('SellerJoinableDiscount parses _id or String IRI and computes isEnrolled', () {
      final notEnrolled = SellerJoinableDiscount.fromJson({
        'id': '/api/seller/marketing/product-discounts/join/2',
        '_id': 2,
        'name': 'Testing Rule',
        'participation': null,
        'enrolled': false,
      });
      expect(notEnrolled.id, 2);
      expect(notEnrolled.isEnrolled, isFalse);

      final pending = SellerJoinableDiscount.fromJson({
        'id': '/api/seller/marketing/product-discounts/join/3',
        '_id': 3,
        'name': 'Pending Rule',
        'participation': 'pending',
        'enrolled': false,
      });
      expect(pending.id, 3);
      expect(pending.isEnrolled, isTrue);

      final approved = SellerJoinableDiscount.fromJson({
        'id': 4,
        'name': 'Approved Rule',
        'participation': 'approved',
        'enrolled': true,
      });
      expect(approved.id, 4);
      expect(approved.isEnrolled, isTrue);
    });
  });
}
