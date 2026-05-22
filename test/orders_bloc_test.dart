import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/orders_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  test(
    'LoadMoreOrders uses the current end cursor and appends the next page',
    () async {
      const firstOrder = CustomerOrder(
        numericId: 1,
        incrementId: '1001',
        status: 'pending',
        grandTotal: 100,
      );
      const secondOrder = CustomerOrder(
        numericId: 2,
        incrementId: '1002',
        status: 'processing',
        grandTotal: 200,
      );

      final repository = _FakeAccountRepository(
        responsesByCursor: const {
          'cursor-1': (
            orders: [secondOrder],
            totalCount: 42,
            hasNextPage: false,
            endCursor: 'cursor-2',
          ),
        },
      );
      final bloc = _SeededOrdersBloc(repository: repository)
        ..seedState(
          const OrdersState(
            status: OrdersStatus.loaded,
            orders: [firstOrder],
            totalCount: 42,
            hasNextPage: true,
            endCursor: 'cursor-1',
          ),
        );

      bloc.add(const LoadMoreOrders());

      final finalState = await bloc.stream.firstWhere(
        (state) => !state.isLoadingMore,
      );

      expect(finalState.orders.map((order) => order.incrementId).toList(), [
        '1001',
        '1002',
      ]);
      expect(finalState.endCursor, 'cursor-2');
      expect(repository.afterCalls, ['cursor-1']);
      await bloc.close();
    },
  );
}

class _SeededOrdersBloc extends OrdersBloc {
  _SeededOrdersBloc({required super.repository});

  void seedState(OrdersState state) {
    emit(state);
  }
}

class _FakeAccountRepository extends AccountRepository {
  final Map<
    String?,
    ({
      List<CustomerOrder> orders,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  responsesByCursor;
  final List<String?> afterCalls = [];

  _FakeAccountRepository({required this.responsesByCursor})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<
    ({
      List<CustomerOrder> orders,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerOrders({int first = 20, String? after, String? status}) async {
    afterCalls.add(after);
    final response = responsesByCursor[after];
    if (response == null) {
      return (
        orders: const <CustomerOrder>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }
    return response;
  }
}
