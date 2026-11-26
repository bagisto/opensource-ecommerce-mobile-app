import 'dart:convert';

import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'create return uses the server input type and submits the form values',
    () async {
      Map<String, dynamic>? sentBody;
      final repository = _repository(
        'createCustomerReturn',
        (body) => sentBody = body,
      );

      final created = await repository.createReturn(
        orderId: 42,
        orderItemId: 81,
        rmaQty: 1,
        resolutionType: 'return',
        rmaReasonId: 3,
        information: 'Item arrived damaged',
        packageCondition: 'opened',
      );

      expect(
        sentBody!['query'],
        matches(RegExp(r'\$input\s*:\s*createCustomerReturnInput!')),
      );
      expect(sentBody!['variables'], {
        'input': {
          'orderId': 42,
          'orderItemId': 81,
          'rmaQty': 1,
          'resolutionType': 'return',
          'rmaReasonId': 3,
          'agreement': true,
          'information': 'Item arrived damaged',
          'packageCondition': 'opened',
        },
      });
      expect(created.id, 15);
      expect(created.orderId, 42);
      expect(created.statusTitle, 'Pending');
    },
  );

  test(
    'cancel return wraps the return IRI in the required input object',
    () async {
      Map<String, dynamic>? sentBody;
      final repository = _repository(
        'cancelCustomerReturn',
        (body) => sentBody = body,
      );

      final canceled = await repository.cancelReturn(15);

      expect(
        sentBody!['query'],
        matches(
          RegExp(
            r'cancelCustomerReturn\s*\(\s*input\s*:\s*\{\s*id\s*:\s*\$id\s*\}\s*\)',
          ),
        ),
      );
      expect(sentBody!['variables'], {'id': '/api/shop/returns/15'});
      expect(canceled.id, 15);
      expect(canceled.statusTitle, 'Canceled');
    },
  );
}

AccountRepository _repository(
  String mutation,
  void Function(Map<String, dynamic>) capture,
) {
  final httpClient = MockClient((request) async {
    capture(jsonDecode(request.body) as Map<String, dynamic>);
    return http.Response(
      jsonEncode({
        'data': {
          '__typename': 'Mutation',
          mutation: {
            '__typename': '${mutation}Payload',
            'customerReturn': {
              '__typename': 'CustomerReturn',
              '_id': 15,
              'orderId': 42,
              'orderIncrementId': '100000042',
              'statusId': mutation == 'cancelCustomerReturn' ? 9 : 1,
              'statusTitle': mutation == 'cancelCustomerReturn'
                  ? 'Canceled'
                  : 'Pending',
              'statusColor': '#FFA500',
              'packageCondition': 'opened',
              'information': 'Item arrived damaged',
              'canClose': false,
              'canReopen': false,
              'isExpired': false,
              'item': {
                'id': 7,
                'order_item_id': 81,
                'sku': 'shirt-blue',
                'name': 'Blue shirt',
                'quantity': 1,
                'resolution': 'return',
                'reason_id': 3,
                'reason': 'Damaged product',
                'variant_id': null,
              },
              'images': [],
              'messagesCount': 0,
              'createdAt': '2026-09-07T12:00:00Z',
              'updatedAt': '2026-09-07T12:00:00Z',
            },
          },
        },
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  });
  addTearDown(httpClient.close);
  return AccountRepository(
    client: GraphQLClient(
      link: HttpLink('https://example.com/graphql', httpClient: httpClient),
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}
