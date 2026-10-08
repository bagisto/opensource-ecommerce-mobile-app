import 'dart:convert';

import 'package:bagisto_flutter/core/graphql/account_queries.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('shipment detail query takes an ID! and sends the shipment IRI',
      () async {
    Map<String, dynamic>? sent;
    final httpClient = MockClient((request) async {
      sent = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({
          'data': {
            '__typename': 'Query',
            'customerOrderShipment': {
              '__typename': 'CustomerOrderShipment',
              'id': '/api/shop/customer-order-shipments/7',
              '_id': 7,
              'status': null,
              'trackNumber': 'TRK1',
              'carrierTitle': 'Flat Rate',
              'totalQty': 1,
              'createdAt': '2026-09-18',
              'items': {
                '__typename': 'CustomerOrderShipmentItemCursorConnection',
                'edges': <Object>[],
              },
              'shippingNumber': '7',
            },
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

    final shipment = await repository.getCustomerOrderShipment(7);

    expect(AccountQueries.getCustomerOrderShipment, contains(r'$id: ID!'));
    expect(sent?['variables'], {'id': '/api/shop/customer-order-shipments/7'});
    expect(shipment.trackNumber, 'TRK1');
  });
}
