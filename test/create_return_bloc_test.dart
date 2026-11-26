import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/models/returns_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/create_return_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const _returnable = CustomerOrder(
  numericId: 42,
  incrementId: '10042',
  status: 'completed',
  grandTotal: 20,
);

class _FakeRepository extends AccountRepository {
  _FakeRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  int allOrdersCalls = 0;

  @override
  Future<List<CustomerOrder>> getReturnableOrders({String? incrementId}) async =>
      const [_returnable];

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
    allOrdersCalls++;
    return (
      orders: const <CustomerOrder>[],
      totalCount: 0,
      hasNextPage: false,
      endCursor: null,
    );
  }

  @override
  Future<List<ReturnableItem>> getReturnableItems(int orderId) async => const [
    ReturnableItem(orderItemId: 1, name: 'Shirt', forReturnQuantity: 1),
    ReturnableItem(orderItemId: 2, name: 'Already returned'),
  ];

  @override
  Future<List<ReturnReason>> getReturnReasons(String resolutionType) async =>
      const [ReturnReason(id: 3, title: 'Damaged')];
}

void main() {
  test('order picker lists only orders eligible for a return', () async {
    final repository = _FakeRepository();
    final bloc = CreateReturnBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const LoadCreateReturn());
    final state = await bloc.stream.firstWhere(
      (s) => s.status == CreateReturnStatus.loaded,
    );

    expect(state.orders.map((o) => o.numericId), [42]);
    expect(state.hasNextPage, isFalse);
    expect(repository.allOrdersCalls, 0);
  });

  test('items with nothing left to return are not offered', () async {
    final bloc = CreateReturnBloc(repository: _FakeRepository());
    addTearDown(bloc.close);

    bloc.add(const SelectOrderForReturn(_returnable));
    final state = await bloc.stream.firstWhere(
      (s) => s.phase == CreateReturnPhase.fillForm,
    );

    expect(state.items.map((i) => i.orderItemId), [1]);
  });
}
