import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/models/seller_aftersales.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/models/seller_return_filters.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/data/repository/seller_aftersales_repository.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/bloc/seller_aftersales_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/bloc/seller_returns_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/widgets/seller_aftersales_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAfterSalesRepository implements SellerAfterSalesRepository {
  _FakeAfterSalesRepository({
    this.returnPages = const {},
    this.statuses = const [],
    this.detail,
    this.bookingPages = const {},
    this.customerPages = const {},
    this.productReviewPages = const {},
    this.shopReviewPages = const {},
    this.failWith,
  });

  final Map<int, PaginatedResult<SellerReturnSummary>> returnPages;
  final List<SellerReturnStatus> statuses;
  SellerReturnDetail? detail;
  final Map<int, PaginatedResult<SellerBooking>> bookingPages;
  final Map<int, PaginatedResult<SellerCustomer>> customerPages;
  final Map<int, PaginatedResult<SellerReview>> productReviewPages;
  final Map<int, PaginatedResult<SellerReview>> shopReviewPages;
  final SellerApiException? failWith;

  int? lastStatusFilter;
  int? lastId;
  int? lastIsGuest;
  String? lastOrderStatus;
  int? lastOrderId;
  String? lastFrom;
  String? lastTo;
  String? lastSearch;
  int? appliedStatusId;
  String? lastReply;
  bool didReopen = false;

  @override
  GraphQLClient get client => throw UnimplementedError();

  static PaginatedResult<T> _empty<T>() => PaginatedResult<T>(
    items: const [],
    totalCount: 0,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<PaginatedResult<SellerReturnSummary>> returns({
    int page = 1,
    String? search,
    int? id,
    int? isGuest,
    String? orderStatus,
    int? statusId,
    int? orderId,
    String? resolution,
    String? from,
    String? to,
  }) async {
    if (failWith != null) throw failWith!;
    lastSearch = search;
    lastStatusFilter = statusId;
    lastId = id;
    lastIsGuest = isGuest;
    lastOrderStatus = orderStatus;
    lastOrderId = orderId;
    lastFrom = from;
    lastTo = to;
    return returnPages[page] ?? _empty();
  }

  @override
  Future<SellerReturnDetail> returnDetail(int id) async {
    if (failWith != null) throw failWith!;
    return detail!;
  }

  @override
  Future<List<SellerReturnStatus>> returnStatuses() async {
    if (failWith != null) throw failWith!;
    return statuses;
  }

  @override
  Future<List<SellerReturnMessage>> replyToReturn(
    int id, {
    String? message,
    String? attachment,
    String? attachmentName,
  }) async {
    if (failWith != null) throw failWith!;
    lastReply = message;
    return const [];
  }

  @override
  Future<SellerReturnDetail> changeReturnStatus(
    int id, {
    required int statusId,
    String? information,
    String? packageCondition,
    double? shipping,
  }) async {
    if (failWith != null) throw failWith!;
    appliedStatusId = statusId;
    return detail!;
  }

  @override
  Future<SellerReturnDetail> reopenReturn(int id, {String? information}) async {
    if (failWith != null) throw failWith!;
    didReopen = true;
    return detail!;
  }

  @override
  Future<PaginatedResult<SellerBooking>> bookings({
    int page = 1,
    String? from,
    String? to,
    int? orderId,
    int? productId,
    int? id,
    int? qty,
  }) async {
    if (failWith != null) throw failWith!;
    return bookingPages[page] ?? _empty();
  }

  @override
  Future<SellerBooking> bookingDetail(int id) async =>
      throw UnimplementedError();

  @override
  Future<({double? total, String? currency})> bookingOrderTotal(
    int orderId,
  ) async => (total: null, currency: null);

  @override
  Future<SellerReturnOrderInfo?> returnOrderInfo(
    int orderId,
    int? orderItemId,
  ) async => null;

  @override
  Future<PaginatedResult<SellerCustomer>> customers({
    int page = 1,
    String? search,
    int? status,
  }) async {
    if (failWith != null) throw failWith!;
    lastSearch = search;
    return customerPages[page] ?? _empty();
  }

  @override
  Future<PaginatedResult<SellerReview>> productReviews({int page = 1}) async {
    if (failWith != null) throw failWith!;
    return productReviewPages[page] ?? _empty();
  }

  @override
  Future<PaginatedResult<SellerReview>> shopReviews({int page = 1}) async {
    if (failWith != null) throw failWith!;
    return shopReviewPages[page] ?? _empty();
  }
}

const _statuses = [
  SellerReturnStatus(id: 1, title: 'Pending Review', color: '#efb308'),
  SellerReturnStatus(id: 5, title: 'Refunded', color: '#10b981'),
  SellerReturnStatus(id: 7, title: 'Request Declined', color: '#e11d48'),
];

const _summary = SellerReturnSummary(
  id: 1,
  orderId: 4,
  orderIncrementId: '4',
  customerName: 'Aarav Sharma',
  rmaStatusId: 1,
  rmaStatus: 'Pending Review',
  rmaStatusColor: '#efb308',
  resolution: 'refund',
  reason: 'Damaged During Shipping',
  quantity: 1,
  productName: 'Stoneware Mug',
  productSku: 'demo-mug',
  isInvoiced: true,
);

void main() {
  group('models', () {
    test('the refund and cancel statuses are flagged as irreversible', () {
      const refund = SellerReturnStatus(id: 5, title: 'Refunded');
      const cancel = SellerReturnStatus(id: 8, title: 'Item Canceled');
      const approve = SellerReturnStatus(id: 2, title: 'Approved');

      expect(refund.refunds, isTrue);
      expect(refund.hasSideEffect, isTrue);
      expect(cancel.cancels, isTrue);
      expect(cancel.hasSideEffect, isTrue);
      expect(approve.hasSideEffect, isFalse);
    });

    test('the detail reads the allowed statuses the server decided', () {
      final detail = SellerReturnDetail.fromJson(const {
        'id': 1,
        'orderIncrementId': '4',
        'rmaStatusId': 7,
        'rmaStatus': 'Request Declined',
        'canChangeStatus': true,
        'canReopen': true,
        'allowedStatuses': [
          {'id': 1, 'title': 'Pending Review', 'color': '#efb308'},
        ],
        'images': [
          {'id': 1, 'url': 'http://example.test/photo.jpg'},
        ],
        'additionalFields': [
          {'code': 'invoice_no', 'label': 'Invoice number', 'value': 'INV-2'},
        ],
        'messages': [
          {'id': 1, 'senderType': 'customer', 'text': 'It arrived chipped.'},
          {'id': 2, 'senderType': 'seller', 'text': 'Sorry — send it back.'},
        ],
      });

      expect(detail.allowedStatuses.single.id, 1);
      expect(detail.canReopen, isTrue);
      expect(detail.images, ['http://example.test/photo.jpg']);
      expect(detail.additionalFields.single.value, 'INV-2');
      expect(detail.messages.first.isFromSeller, isFalse);
      expect(detail.messages.last.isFromSeller, isTrue);
    });

    test('a booking reports the day its slot falls on', () {
      const booking = SellerBooking(id: 1, from: '2026-08-20 10:00:00');
      expect(booking.day, '2026-08-20');

      const iso = SellerBooking(id: 2, from: '2026-08-21T14:30:00+05:30');
      expect(iso.day, '2026-08-21');
    });

    test('a customer carries this seller\'s figures, not marketplace-wide '
        'ones', () {
      final customer = SellerCustomer.fromJson(const {
        'id': 2,
        'fullName': 'Demo Buyer',
        'email': 'buyer@example.com',
        'status': 1,
        'revenue': 39.98,
        'orderCount': 1,
      });

      expect(customer.revenue, 39.98);
      expect(customer.orderCount, 1);
      expect(customer.isActive, isTrue);
    });

    test('a shop review has no product attached', () {
      final review = SellerReview.fromJson(const {
        'id': 1,
        'rating': 5,
        'title': 'Fast dispatch',
        'status': 'approved',
        'customerName': 'Aarav Sharma',
      });

      expect(review.productId, isNull);
      expect(review.isApproved, isTrue);
    });

    test('status colours parse, and a bad one falls back rather than '
        'throwing', () {
      expect(
        SellerStatusPill.parseHexColor('#efb308'),
        const Color(0xFFEFB308),
      );
      expect(
        SellerStatusPill.parseHexColor('#80efb308'),
        const Color(0x80EFB308),
      );
      expect(SellerStatusPill.parseHexColor('nonsense'), isNull);
      expect(SellerStatusPill.parseHexColor(null), isNull);
    });
  });

  group('SellerReturnsCubit', () {
    test(
      'load reads the statuses once and the first page of requests',
      () async {
        final repository = _FakeAfterSalesRepository(
          statuses: _statuses,
          returnPages: {
            1: const PaginatedResult(
              items: [_summary],
              totalCount: 1,
              lastPage: 1,
              currentPage: 1,
            ),
          },
        );
        final cubit = SellerReturnsCubit(repository: repository);

        await cubit.load();

        expect(cubit.state.status, SellerReturnsStatus.loaded);
        expect(cubit.state.statuses, hasLength(3));
        expect(cubit.state.returns.single.productSku, 'demo-mug');
      },
    );

    test('the status filter reaches the server', () async {
      final repository = _FakeAfterSalesRepository(statuses: _statuses);
      final cubit = SellerReturnsCubit(repository: repository);

      await cubit.load();
      await cubit.filterByStatus(5);
      expect(repository.lastStatusFilter, 5);

      await cubit.filterByStatus(null);
      expect(repository.lastStatusFilter, isNull);
      expect(cubit.state.statusFilter, isNull);
    });

    test('the filter sheet\'s filters reach the server', () async {
      final repository = _FakeAfterSalesRepository(statuses: _statuses);
      final cubit = SellerReturnsCubit(repository: repository);

      await cubit.applyFilters(
        const SellerReturnFilters(
          id: 4,
          orderId: 10,
          customerName: 'Playwright',
          statusId: 2,
          isGuest: 0,
          delivery: SellerReturnDelivery.delivered,
          from: '2026-08-20',
          to: '2026-08-20',
        ),
      );

      expect(repository.lastId, 4);
      expect(repository.lastOrderId, 10);
      expect(repository.lastSearch, 'Playwright');
      expect(repository.lastStatusFilter, 2);
      expect(repository.lastIsGuest, 0);
      expect(repository.lastOrderStatus, 'completed');
      expect(repository.lastFrom, '2026-08-20');
      expect(repository.lastTo, '2026-08-20');
      expect(cubit.state.filters.activeCount, 7);
    });

    test('Undelivered drops completed orders and asks for no status', () async {
      const open = SellerReturnSummary(id: 5, orderStatus: 'processing');
      const done = SellerReturnSummary(id: 4, orderStatus: 'completed');
      final repository = _FakeAfterSalesRepository(
        statuses: _statuses,
        returnPages: {
          1: const PaginatedResult(
            items: [done],
            totalCount: 3,
            lastPage: 2,
            currentPage: 1,
          ),
          2: const PaginatedResult(
            items: [open, done],
            totalCount: 3,
            lastPage: 2,
            currentPage: 2,
          ),
        },
      );
      final cubit = SellerReturnsCubit(repository: repository);

      await cubit.applyFilters(
        const SellerReturnFilters(delivery: SellerReturnDelivery.undelivered),
      );

      // Page 1 held only a completed order, so the list read on to page 2.
      expect(repository.lastOrderStatus, isNull);
      expect(cubit.state.returns.map((r) => r.id), [5]);
      expect(cubit.state.currentPage, 2);
    });

    test('a status chip keeps the sheet\'s other filters', () async {
      final cubit = SellerReturnsCubit(
        repository: _FakeAfterSalesRepository(statuses: _statuses),
      );

      await cubit.applyFilters(const SellerReturnFilters(orderId: 10));
      await cubit.filterByStatus(3);

      expect(cubit.state.filters.orderId, 10);
      expect(cubit.state.filters.statusId, 3);
    });

    test('an empty list is a loaded screen, not a failure', () async {
      final cubit = SellerReturnsCubit(
        repository: _FakeAfterSalesRepository(statuses: _statuses),
      );

      await cubit.load();

      expect(cubit.state.status, SellerReturnsStatus.loaded);
      expect(cubit.state.returns, isEmpty);
    });

    test('a rejected read surfaces the server message', () async {
      final cubit = SellerReturnsCubit(
        repository: _FakeAfterSalesRepository(
          failWith: const SellerApiException(
            'Forbidden',
            SellerApiFailure.forbidden,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerReturnsStatus.failed);
      expect(cubit.state.errorMessage, 'Forbidden');
    });
  });

  group('SellerReturnDetailCubit', () {
    SellerReturnDetail detailWith({
      bool canChangeStatus = true,
      bool canReopen = false,
    }) {
      return SellerReturnDetail(
        summary: _summary,
        allowedStatuses: _statuses,
        canChangeStatus: canChangeStatus,
        canReopen: canReopen,
        messages: const [
          SellerReturnMessage(
            id: 1,
            senderType: 'customer',
            text: 'It arrived chipped.',
          ),
        ],
      );
    }

    test('load reads the request', () async {
      final cubit = SellerReturnDetailCubit(
        repository: _FakeAfterSalesRepository(detail: detailWith()),
        returnId: 1,
      );

      await cubit.load();

      expect(cubit.state.status, SellerReturnDetailStatus.loaded);
      expect(cubit.state.request?.allowedStatuses, hasLength(3));
    });

    test('an empty reply is not worth a request', () async {
      final repository = _FakeAfterSalesRepository(detail: detailWith());
      final cubit = SellerReturnDetailCubit(
        repository: repository,
        returnId: 1,
      );

      final sent = await cubit.reply(message: '   ');

      expect(sent, isFalse);
      expect(repository.lastReply, isNull);
    });

    test('a reply is sent and the request reread', () async {
      final repository = _FakeAfterSalesRepository(detail: detailWith());
      final cubit = SellerReturnDetailCubit(
        repository: repository,
        returnId: 1,
      );

      await cubit.load();
      final sent = await cubit.reply(message: '  Send it back, please.  ');

      expect(sent, isTrue);
      expect(repository.lastReply, 'Send it back, please.');
      expect(cubit.state.successMessage, 'Reply sent');
    });

    test('changing status sends the chosen id', () async {
      final repository = _FakeAfterSalesRepository(detail: detailWith());
      final cubit = SellerReturnDetailCubit(
        repository: repository,
        returnId: 1,
      );

      await cubit.load();
      final ok = await cubit.changeStatus(5);

      expect(ok, isTrue);
      expect(repository.appliedStatusId, 5);
    });

    test('reopening reports back', () async {
      final repository = _FakeAfterSalesRepository(
        detail: detailWith(canReopen: true),
      );
      final cubit = SellerReturnDetailCubit(
        repository: repository,
        returnId: 1,
      );

      await cubit.load();
      final ok = await cubit.reopen();

      expect(ok, isTrue);
      expect(repository.didReopen, isTrue);
      expect(cubit.state.successMessage, 'Request reopened');
    });

    test('a rejected status change leaves the screen usable', () async {
      final cubit = SellerReturnDetailCubit(
        repository: _FakeAfterSalesRepository(
          failWith: const SellerApiException(
            'Invalid status.',
            SellerApiFailure.validation,
          ),
        ),
        returnId: 1,
      );

      final ok = await cubit.changeStatus(5);

      expect(ok, isFalse);
      expect(cubit.state.status, SellerReturnDetailStatus.loaded);
      expect(cubit.state.errorMessage, 'Invalid status.');
    });
  });

  group('list cubits', () {
    test('customers page and append', () async {
      final cubit = SellerCustomersCubit(
        repository: _FakeAfterSalesRepository(
          customerPages: {
            1: const PaginatedResult(
              items: [SellerCustomer(id: 2, fullName: 'Demo Buyer')],
              totalCount: 2,
              lastPage: 2,
              currentPage: 1,
            ),
            2: const PaginatedResult(
              items: [SellerCustomer(id: 3, fullName: 'Aarav Sharma')],
              totalCount: 2,
              lastPage: 2,
              currentPage: 2,
            ),
          },
        ),
      );

      await cubit.load();
      expect(cubit.state.hasNextPage, isTrue);

      await cubit.loadMore();
      expect(cubit.state.items.map((c) => c.id), [2, 3]);
      expect(cubit.state.hasNextPage, isFalse);
    });

    test('a customer search reaches the server', () async {
      final repository = _FakeAfterSalesRepository();
      final cubit = SellerCustomersCubit(repository: repository);

      await cubit.search('aarav');

      expect(repository.lastSearch, 'aarav');
    });

    test('bookings load', () async {
      final cubit = SellerBookingsCubit(
        repository: _FakeAfterSalesRepository(
          bookingPages: {
            1: const PaginatedResult(
              items: [
                SellerBooking(
                  id: 1,
                  from: '2026-08-20 10:00:00',
                  to: '2026-08-20 11:00:00',
                  qty: 2,
                  productName: 'Studio session',
                ),
              ],
              totalCount: 1,
              lastPage: 1,
              currentPage: 1,
            ),
          },
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerListStatus.loaded);
      expect(cubit.state.items.single.qty, 2);
    });

    test('the two review tabs read different endpoints', () async {
      final repository = _FakeAfterSalesRepository(
        productReviewPages: {
          1: const PaginatedResult(
            items: [SellerReview(id: 1, rating: 5, productId: 56)],
            totalCount: 1,
            lastPage: 1,
            currentPage: 1,
          ),
        },
        shopReviewPages: {
          1: const PaginatedResult(
            items: [SellerReview(id: 9, rating: 4)],
            totalCount: 1,
            lastPage: 1,
            currentPage: 1,
          ),
        },
      );

      final onProducts = SellerReviewsCubit(repository: repository);
      final onShop = SellerReviewsCubit(
        repository: repository,
        onProducts: false,
      );

      await onProducts.load();
      await onShop.load();

      expect(onProducts.state.items.single.productId, 56);
      expect(onShop.state.items.single.id, 9);
    });

    test('loadMore stops at the last page', () async {
      final cubit = SellerCustomersCubit(
        repository: _FakeAfterSalesRepository(),
      );

      await cubit.load();
      await cubit.loadMore();

      expect(cubit.state.items, isEmpty);
      expect(cubit.state.isLoadingMore, isFalse);
    });
  });
}
