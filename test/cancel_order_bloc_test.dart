import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/order_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  euWithdrawalTests();
  bookingCancellationTests();
  returnEligibilityTests();
  group('OrderDetail.canCancel', () {
    OrderDetail order(String status) =>
        OrderDetail(status: status, grandTotal: 0);

    test('is true for pending/processing, false otherwise', () {
      expect(order('pending').canCancel, true);
      expect(order('pending_payment').canCancel, true);
      expect(order('processing').canCancel, true);
      expect(order('completed').canCancel, false);
      expect(order('canceled').canCancel, false);
      expect(order('closed').canCancel, false);
    });
  });

  test('CancelOrder success emits cancelSuccess with refreshed order', () async {
    final repository = _FakeCancelRepository(
      result: (
        success: true,
        message: 'Order has been canceled successfully',
        orderId: 5,
        status: 'canceled',
      ),
      refreshed: OrderDetail(status: 'canceled', grandTotal: 0, numericId: 5),
    );
    final bloc = OrderDetailBloc(repository: repository);

    bloc.add(const CancelOrder(5));

    final state = await bloc.stream.firstWhere(
      (s) => s.status == OrderDetailStatus.cancelSuccess,
    );

    expect(state.successMessage, 'Order has been canceled successfully');
    expect(state.order?.status, 'canceled');
    expect(repository.canceledOrderIds, [5]);
    await bloc.close();
  });

  test('CancelOrder failure keeps the order visible and reports the message', () async {
    final repository = _FakeCancelRepository(
      result: (
        success: false,
        message: 'Order cannot be canceled',
        orderId: 5,
        status: 'processing',
      ),
      refreshed: OrderDetail(status: 'processing', grandTotal: 0),
    );
    final bloc = OrderDetailBloc(repository: repository);

    bloc.add(const LoadOrderDetail(5));
    await bloc.stream.firstWhere((s) => s.status == OrderDetailStatus.loaded);
    bloc.add(const CancelOrder(5));

    final state = await bloc.stream.firstWhere(
      (s) => s.errorMessage != null,
    );

    // A failed action must not replace the order view with the error page.
    expect(state.status, OrderDetailStatus.loaded);
    expect(state.errorMessage, 'Order cannot be canceled');
    await bloc.close();
  });
}

class _FakeCancelRepository extends AccountRepository {
  final ({bool success, String message, int orderId, String status}) result;
  final OrderDetail refreshed;
  final List<int> canceledOrderIds = [];

  _FakeCancelRepository({required this.result, required this.refreshed})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<({bool success, String message, int orderId, String status})>
  cancelOrder({required int orderId}) async {
    canceledOrderIds.add(orderId);
    return result;
  }

  @override
  Future<OrderDetail> getCustomerOrder(int orderId) async => refreshed;
}

class _ReturnableRepository extends _FakeCancelRepository {
  _ReturnableRepository({required this.returnable})
    : super(
        result: (success: true, message: '', orderId: 7, status: 'completed'),
        refreshed: OrderDetail(
          status: 'completed',
          grandTotal: 0,
          numericId: 7,
          incrementId: '10007',
        ),
      );

  final List<CustomerOrder> returnable;
  final List<String?> requestedIncrementIds = [];

  @override
  Future<List<CustomerOrder>> getReturnableOrders({String? incrementId}) async {
    requestedIncrementIds.add(incrementId);
    return returnable;
  }
}

void returnEligibilityTests() {
  test('loaded order exposes its returnable entry when eligible', () async {
    final repository = _ReturnableRepository(
      returnable: const [
        CustomerOrder(numericId: 7, incrementId: '10007', status: 'completed', grandTotal: 0),
      ],
    );
    final bloc = OrderDetailBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const LoadOrderDetail(7));
    final state = await bloc.stream.firstWhere((s) => s.returnableOrder != null);

    expect(state.returnableOrder?.numericId, 7);
    expect(repository.requestedIncrementIds, ['10007']);
  });

  test('order without returnable quantity offers no return', () async {
    final bloc = OrderDetailBloc(
      repository: _ReturnableRepository(returnable: const []),
    );
    addTearDown(bloc.close);

    bloc.add(const LoadOrderDetail(7));
    await bloc.stream.firstWhere((s) => s.status == OrderDetailStatus.loaded);
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.returnableOrder, isNull);
  });
}

class _BookingRepository extends _FakeCancelRepository {
  _BookingRepository({required this.allowsCancellation})
    : super(
        result: (success: true, message: '', orderId: 9, status: 'pending'),
        refreshed: const OrderDetail(
          status: 'pending',
          grandTotal: 0,
          numericId: 9,
          items: [
            OrderItem(name: 'Photo session', type: 'booking', productId: 2507),
            OrderItem(name: 'Shirt', type: 'simple', productId: 3),
          ],
        ),
      );

  final bool? allowsCancellation;
  final List<int> checkedProductIds = [];

  @override
  Future<bool?> getBookingAllowsCancellation(int productId) async {
    checkedProductIds.add(productId);
    return allowsCancellation;
  }
}

void bookingCancellationTests() {
  test('order with a non-cancelable booking item is flagged', () async {
    final repository = _BookingRepository(allowsCancellation: false);
    final bloc = OrderDetailBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const LoadOrderDetail(9));
    final state = await bloc.stream.firstWhere(
      (s) => s.hasNonCancelableBooking,
    );

    expect(state.hasNonCancelableBooking, isTrue);
    expect(repository.checkedProductIds, [2507]);
  });

  test('cancelable bookings are not flagged', () async {
    final bloc = OrderDetailBloc(
      repository: _BookingRepository(allowsCancellation: true),
    );
    addTearDown(bloc.close);

    bloc.add(const LoadOrderDetail(9));
    await bloc.stream.firstWhere((s) => s.status == OrderDetailStatus.loaded);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(bloc.state.hasNonCancelableBooking, isFalse);
  });
}

class _EuRepository extends _FakeCancelRepository {
  _EuRepository({required this.enabled, this.existing})
    : super(
        result: (success: true, message: '', orderId: 11, status: 'completed'),
        refreshed: const OrderDetail(
          status: 'completed',
          grandTotal: 0,
          numericId: 11,
        ),
      );

  final bool enabled;
  final EuWithdrawal? existing;
  final List<(int, String?)> created = [];

  @override
  Future<bool> isEuWithdrawalEnabled() async => enabled;

  @override
  Future<EuWithdrawal?> getEuWithdrawalForOrder(int orderId) async => existing;

  @override
  Future<EuWithdrawal> createEuWithdrawal({
    required int orderId,
    String? reasonText,
  }) async {
    created.add((orderId, reasonText));
    return EuWithdrawal(orderId: orderId, status: 'received');
  }
}

void euWithdrawalTests() {
  test('enabled EU withdrawal is offered for an order without a request',
      () async {
    final repository = _EuRepository(enabled: true);
    final bloc = OrderDetailBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const LoadOrderDetail(11));
    await bloc.stream.firstWhere((s) => s.euWithdrawalEnabled);
    expect(bloc.state.euWithdrawal, isNull);

    bloc.add(const WithdrawFromContract(orderId: 11, reasonText: 'No longer needed'));
    final state = await bloc.stream.firstWhere((s) => s.euWithdrawal != null);

    expect(state.euWithdrawal?.status, 'received');
    expect(repository.created, [(11, 'No longer needed')]);
  });

  test('disabled EU withdrawal is not offered', () async {
    final bloc = OrderDetailBloc(repository: _EuRepository(enabled: false));
    addTearDown(bloc.close);

    bloc.add(const LoadOrderDetail(11));
    await bloc.stream.firstWhere((s) => s.status == OrderDetailStatus.loaded);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(bloc.state.euWithdrawalEnabled, isFalse);
  });

  test('existing request is shown instead of a new one', () async {
    final bloc = OrderDetailBloc(
      repository: _EuRepository(
        enabled: true,
        existing: const EuWithdrawal(orderId: 11, status: 'confirmed'),
      ),
    );
    addTearDown(bloc.close);

    bloc.add(const LoadOrderDetail(11));
    final state = await bloc.stream.firstWhere((s) => s.euWithdrawal != null);
    expect(state.euWithdrawal?.status, 'confirmed');
  });
}
