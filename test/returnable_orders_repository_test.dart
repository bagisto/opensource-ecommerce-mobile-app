import 'dart:convert';

import 'package:bagisto_flutter/core/graphql/returns_queries.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> _order(int id, int returnableQty) => {
  '__typename': 'ReturnableOrder',
  'id': '/api/shop/returnable-orders/$id',
  '_id': id,
  'incrementId': '$id',
  'status': 'completed',
  'statusLabel': 'Completed',
  'grandTotal': 25.0,
  'formattedGrandTotal': '\$25.00',
  'orderCurrencyCode': 'USD',
  'totalQtyOrdered': 2,
  'totalReturnedQty': 0,
  'returnableQty': returnableQty,
  'createdAt': '2026-09-18',
};

void main() {
  test('returnable orders keep only orders with returnable quantity',
      () async {
    Map<String, dynamic>? sent;
    final httpClient = MockClient((request) async {
      sent = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({
          'data': {
            '__typename': 'Query',
            'returnableOrders': [_order(41, 2), _order(42, 0)],
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    addTearDown(httpClient.close);
    final repository = AccountRepository(
      client: GraphQLClient(
        link: HttpLink('https://example.com/graphql', httpClient: httpClient),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final orders = await repository.getReturnableOrders(incrementId: '41');

    expect(orders.map((o) => o.numericId), [41]);
    expect(orders.single.status, 'completed');
    expect(orders.single.grandTotal, 25.0);
    expect(sent?['variables'], {'incrementId': '41'});
    expect(ReturnsQueries.getReturnableOrders, contains('returnableQty'));
  });
}
