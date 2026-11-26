import 'package:bagisto_flutter/features/account/data/models/returns_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/returns_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  test(
    'LoadMoreReturns uses the current end cursor and appends the next page',
    () async {
      const firstReturn = CustomerReturn(
        id: 1,
        orderId: 10,
        orderIncrementId: '1001',
        statusTitle: 'Pending',
      );
      const secondReturn = CustomerReturn(
        id: 2,
        orderId: 11,
        orderIncrementId: '1002',
        statusTitle: 'Solved',
      );

      final repository = _FakeAccountRepository(
        responsesByCursor: const {
          'cursor-1': (
            returns: [secondReturn],
            totalCount: 7,
            hasNextPage: false,
            endCursor: 'cursor-2',
          ),
        },
      );
      final bloc = _SeededReturnsBloc(repository: repository)
        ..seedState(
          const ReturnsState(
            status: ReturnsStatus.loaded,
            returns: [firstReturn],
            totalCount: 7,
            hasNextPage: true,
            endCursor: 'cursor-1',
          ),
        );

      bloc.add(const LoadMoreReturns());

      final finalState = await bloc.stream.firstWhere(
        (state) => !state.isLoadingMore,
      );

      expect(finalState.returns.map((r) => r.id).toList(), [1, 2]);
      expect(finalState.endCursor, 'cursor-2');
      expect(repository.afterCalls, ['cursor-1']);
      await bloc.close();
    },
  );

  test('LoadReturns surfaces repository errors as error status', () async {
    final repository = _ThrowingAccountRepository();
    final bloc = ReturnsBloc(repository: repository);

    bloc.add(const LoadReturns());

    final finalState = await bloc.stream.firstWhere(
      (state) => state.status == ReturnsStatus.error,
    );

    expect(finalState.errorMessage, isNotNull);
    await bloc.close();
  });
}

class _SeededReturnsBloc extends ReturnsBloc {
  _SeededReturnsBloc({required super.repository});

  void seedState(ReturnsState state) {
    emit(state);
  }
}

GraphQLClient _fakeClient() => GraphQLClient(
  link: HttpLink('https://example.com/graphql'),
  cache: GraphQLCache(store: InMemoryStore()),
);

class _FakeAccountRepository extends AccountRepository {
  final Map<
    String?,
    ({
      List<CustomerReturn> returns,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  responsesByCursor;
  final List<String?> afterCalls = [];

  _FakeAccountRepository({required this.responsesByCursor})
    : super(client: _fakeClient());

  @override
  Future<
    ({
      List<CustomerReturn> returns,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerReturns({int first = 20, String? after, int? status}) async {
    afterCalls.add(after);
    final response = responsesByCursor[after];
    if (response == null) {
      return (
        returns: const <CustomerReturn>[],
        totalCount: 0,
        hasNextPage: false,
        endCursor: null,
      );
    }
    return response;
  }
}

class _ThrowingAccountRepository extends AccountRepository {
  _ThrowingAccountRepository() : super(client: _fakeClient());

  @override
  Future<
    ({
      List<CustomerReturn> returns,
      int totalCount,
      bool hasNextPage,
      String? endCursor,
    })
  >
  getCustomerReturns({int first = 20, String? after, int? status}) async {
    throw const AccountException('boom');
  }
}
