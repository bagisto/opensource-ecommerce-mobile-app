import 'dart:convert';

import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

AccountRepository _repository(
  Map<String, dynamic> Function(Map<String, dynamic> body) respond,
) {
  final httpClient = MockClient((request) async {
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    return http.Response(
      jsonEncode(respond(body)),
      200,
      headers: {'content-type': 'application/json'},
    );
  });
  return AccountRepository(
    client: GraphQLClient(
      link: HttpLink('https://example.com/graphql', httpClient: httpClient),
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}

Map<String, dynamic> _withdrawal(int orderId, String status) => {
  '__typename': 'EuWithdrawal',
  'id': '/api/shop/eu-withdrawals/$orderId',
  '_id': orderId,
  'orderId': orderId,
  'orderIncrementId': '$orderId',
  'status': status,
  'receivedAt': '2026-09-20',
  'declinedReason': null,
};

void main() {
  test('reads whether EU withdrawal is enabled', () async {
    final repository = _repository(
      (_) => {
        'data': {
          '__typename': 'Query',
          'euWithdrawalStatus': {
            '__typename': 'EuWithdrawalStatus',
            'id': '/api/shop/eu-withdrawal-status/default',
            'enabled': true,
            'channel': 'default',
          },
        },
      },
    );

    expect(await repository.isEuWithdrawalEnabled(), isTrue);
  });

  test('finds the withdrawal request for an order', () async {
    final repository = _repository(
      (_) => {
        'data': {
          '__typename': 'Query',
          'euWithdrawals': {
            '__typename': 'EuWithdrawalCursorConnection',
            'edges': [
              {'__typename': 'EuWithdrawalEdge', 'node': _withdrawal(5, 'received')},
              {'__typename': 'EuWithdrawalEdge', 'node': _withdrawal(7, 'declined')},
            ],
            'pageInfo': {
              '__typename': 'EuWithdrawalPageInfo',
              'hasNextPage': false,
              'endCursor': null,
            },
          },
        },
      },
    );

    expect((await repository.getEuWithdrawalForOrder(7))?.status, 'declined');
    expect(await repository.getEuWithdrawalForOrder(9), isNull);
  });

  test('guest withdrawal sends order number, email and reason', () async {
    Map<String, dynamic>? sent;
    final repository = _repository((body) {
      sent = body;
      return {
        'data': {
          'createGuestEuWithdrawal': {
            '__typename': 'createGuestEuWithdrawalPayload',
            'guestEuWithdrawal': {
              '__typename': 'GuestEuWithdrawal',
              'id': '/api/shop/guest-eu-withdrawals/1',
              'uuid': 'abc',
              'orderIncrementId': '1001',
              'status': 'received',
              'receivedAt': '2026-09-30',
            },
          },
        },
      };
    });

    final result = await repository.createGuestEuWithdrawal(
      orderIncrementId: '1001',
      email: 'guest@example.com',
      reasonText: 'Changed my mind',
    );

    expect(result.status, 'received');
    expect(sent?['variables'], {
      'input': {
        'orderIncrementId': '1001',
        'email': 'guest@example.com',
        'reasonText': 'Changed my mind',
      },
    });
  });
}
