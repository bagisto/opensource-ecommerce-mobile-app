import 'dart:async';

import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/account_dashboard_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAccountRepository extends AccountRepository {
  _FakeAccountRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  int profileCalls = 0;

  @override
  Future<CustomerProfile> getCustomerProfile() async {
    profileCalls++;
    throw Exception('offline');
  }

  @override
  Future<List<CustomerAddress>> getCustomerAddresses({int first = 10}) async =>
      const [];

  @override
  Future<List<RecentOrder>> getRecentOrders({int first = 5}) async => const [];
}

void main() {
  test('RefreshAccountDashboard completes its completer when done', () async {
    final repository = _FakeAccountRepository();
    final bloc = AccountDashboardBloc(repository: repository);
    addTearDown(bloc.close);

    final completer = Completer<void>();
    bloc.add(RefreshAccountDashboard(completer: completer));

    await completer.future.timeout(const Duration(seconds: 5));
    expect(repository.profileCalls, 1);
  });
}
