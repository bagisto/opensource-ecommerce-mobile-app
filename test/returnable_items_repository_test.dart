import 'dart:convert';

import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'returnable items request uses only orderId and reads a plain list',
    () async {
      Map<String, dynamic>? sentBody;
      final httpClient = MockClient((request) async {
        sentBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'data': {
              '__typename': 'Query',
              'returnableItems': [
                {
                  '__typename': 'ReturnableItem',
                  'orderItemId': 81,
                  'productId': 12,
                  'sku': 'shirt-blue',
                  'name': 'Blue shirt',
                  'type': 'simple',
                  'urlKey': 'blue-shirt',
                  'price': 25.0,
                  'baseImageUrl': null,
                  'qtyOrdered': 3,
                  'currentQuantity': 2,
                  'forReturnQuantity': 2,
                  'forCancelQuantity': 0,
                  'rmaQuantity': 1,
                  'rmaReturnPeriod': 7,
                },
              ],
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

      final items = await repository.getReturnableItems(42);

      expect(sentBody?['variables'], {'orderId': 42});
      final query = sentBody!['query'] as String;
      // The API returns every eligible item without pagination. Inspect the
      // transmitted query: omitting variable values still sends field arguments.
      final fieldArguments = RegExp(
        r'\breturnableItems\s*\(\s*orderId\s*:([^)]*)\)',
      ).firstMatch(query)?.group(1)?.replaceAll(RegExp(r'\s+'), '');
      expect(fieldArguments, r'$orderId');
      expect(query, isNot(matches(RegExp(r'\$(first|after)\b'))));
      expect(items, hasLength(1));
      expect(items.single.orderItemId, 81);
      expect(items.single.name, 'Blue shirt');
      expect(items.single.maxQuantityFor('return'), 2);
      expect(items.single.maxQuantityFor('cancel_items'), 0);
    },
  );
}
