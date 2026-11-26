import 'dart:async';

import 'package:bagisto_flutter/features/account/data/models/returns_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/returns_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  test(
    'pagination can recover after a refresh fails with existing returns',
    () async {
      final repository = _DeferredReturnsRepository();
      final bloc = ReturnsBloc(repository: repository);
      addTearDown(bloc.close);

      bloc.add(const LoadReturns());
      await pumpEventQueue();
      repository.responses[0].complete(_page([1], 'cursor-1'));
      await pumpEventQueue();
      bloc.add(const LoadReturns());
      await pumpEventQueue();
      repository.responses[1].completeError(
        const AccountException('Refresh failed'),
      );
      await pumpEventQueue();

      bloc.add(const LoadMoreReturns());
      await pumpEventQueue();
      expect(bloc.state.isLoadingMore, isTrue);
      expect(repository.afterCalls, [null, null, 'cursor-1']);
      repository.responses[2].complete(_page([2], 'cursor-2'));
      await pumpEventQueue();
      expect(bloc.state.status, ReturnsStatus.loaded);
      expect(bloc.state.returns.map((item) => item.id), [1, 2]);
      expect(bloc.state.errorMessage, isNull);
    },
  );

  for (final fails in [false, true]) {
    test(
      'refresh ignores a stale pagination ${fails ? 'error' : 'page'}',
      () async {
        final repository = _DeferredReturnsRepository();
        final bloc = ReturnsBloc(repository: repository);
        addTearDown(bloc.close);

        bloc.add(const LoadReturns());
        await pumpEventQueue();
        repository.responses[0].complete(_page([1, 2], 'cursor-2'));
        await pumpEventQueue();

        bloc.add(const LoadMoreReturns());
        await pumpEventQueue();
        expect(bloc.state.isLoadingMore, isTrue);

        bloc.add(const LoadReturns());
        await pumpEventQueue();
        bloc.add(const LoadMoreReturns());
        await pumpEventQueue();
        expect(repository.afterCalls, [null, 'cursor-2', null]);

        repository.responses[2].complete(_page([1], 'cursor-1'));
        await pumpEventQueue();
        if (fails) {
          repository.responses[1].completeError(
            const AccountException('Old page failed'),
          );
        } else {
          repository.responses[1].complete(_page([3], 'cursor-3'));
        }
        await pumpEventQueue();

        expect(bloc.state.returns.map((item) => item.id), [1]);
        expect(bloc.state.endCursor, 'cursor-1');
        expect(bloc.state.isLoadingMore, isFalse);
        expect(bloc.state.errorMessage, isNull);

        bloc.add(const LoadMoreReturns());
        await pumpEventQueue();
        expect(repository.afterCalls, [null, 'cursor-2', null, 'cursor-1']);
        repository.responses[3].complete(_page([2], 'cursor-2'));
        await pumpEventQueue();
        expect(bloc.state.returns.map((item) => item.id), [1, 2]);
        expect(bloc.state.endCursor, 'cursor-2');
      },
    );

    test(
      'latest refresh ignores an older refresh ${fails ? 'error' : 'response'}',
      () async {
        final repository = _DeferredReturnsRepository();
        final bloc = ReturnsBloc(repository: repository);
        addTearDown(bloc.close);

        bloc.add(const LoadReturns());
        await pumpEventQueue();
        bloc.add(const LoadReturns());
        await pumpEventQueue();
        repository.responses[1].complete(_page([2], 'latest-cursor'));
        await pumpEventQueue();
        if (fails) {
          repository.responses[0].completeError(
            const AccountException('Old refresh failed'),
          );
        } else {
          repository.responses[0].complete(_page([1], 'old-cursor'));
        }
        await pumpEventQueue();

        expect(bloc.state.status, ReturnsStatus.loaded);
        expect(bloc.state.returns.map((item) => item.id), [2]);
        expect(bloc.state.endCursor, 'latest-cursor');
        expect(bloc.state.errorMessage, isNull);
      },
    );
  }
}

typedef _ReturnPage = ({
  List<CustomerReturn> returns,
  int totalCount,
  bool hasNextPage,
  String? endCursor,
});

_ReturnPage _page(List<int> ids, String cursor) => (
  returns: [for (final id in ids) CustomerReturn(id: id)],
  totalCount: 3,
  hasNextPage: true,
  endCursor: cursor,
);

class _DeferredReturnsRepository extends AccountRepository {
  final afterCalls = <String?>[];
  final responses = <Completer<_ReturnPage>>[];

  _DeferredReturnsRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<_ReturnPage> getCustomerReturns({
    int first = 20,
    String? after,
    int? status,
  }) {
    afterCalls.add(after);
    final response = Completer<_ReturnPage>();
    responses.add(response);
    return response.future;
  }
}
