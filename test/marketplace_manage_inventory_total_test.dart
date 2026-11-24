import 'dart:convert';

import 'package:bagisto_flutter/marketplace/features/manage_inventory/data/repository/seller_manage_inventory_repository.dart';
import 'package:bagisto_flutter/marketplace/graphql/seller_manage_inventory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// The panel prints how many products match the filters — 36 on the test
/// seller — while a page holds only 10. Counting the loaded rows instead
/// made the screen read "10 Results" however many there really were.
SellerManageInventoryRepository _repository({
  required int rows,
  Object? totalCount,
  void Function(String body)? onRequest,
}) => SellerManageInventoryRepository(
  client: GraphQLClient(
    link: HttpLink(
      'https://example.com/graphql',
      httpClient: MockClient((request) async {
        onRequest?.call(request.body);
        return http.Response(
          jsonEncode({
            'data': {
              'sellerManageInventories': {
                '__typename': 'SellerManageInventoryCursorConnection',
                'totalCount': totalCount,
                'edges': [
                  for (var i = 0; i < rows; i++)
                    {
                      '__typename': 'SellerManageInventoryEdge',
                      'node': {
                        '__typename': 'SellerManageInventory',
                        'id':
                            '/api/seller/seller_manage_inventories/${722 - i}',
                        'productId': 752 - i,
                        'name': 'Product $i',
                        'sku': 'sku-$i',
                        'type': 'simple',
                        'status': 1,
                        'isOwner': true,
                        'isApproved': true,
                        'baseImage': null,
                        'price': 10,
                        'quantity': 0,
                        'manageStock': true,
                        'soldUnits': 0,
                        'pendingUnits': 0,
                        'canceledUnits': 0,
                        'updatedAt': '2026-10-15T09:00:00+00:00',
                      },
                    },
                ],
                'pageInfo': {
                  '__typename': 'SellerManageInventoryPageInfo',
                  'hasNextPage': true,
                  'endCursor': 'Mjk=',
                },
              },
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    ),
    cache: GraphQLCache(store: InMemoryStore()),
  ),
);

void main() {
  test('the query asks the server for the total', () {
    expect(SellerManageInventoryDocuments.list, contains('totalCount'));
  });

  test('a page of 10 out of 36 still reports 36', () async {
    final page = await _repository(rows: 10, totalCount: 36).list(first: 10);

    expect(page.items.length, 10);
    expect(page.totalCount, 36);
    expect(page.hasNextPage, isTrue);
  });

  test('the total is sent on the wire, not guessed', () async {
    late String body;
    await _repository(
      rows: 10,
      totalCount: 36,
      onRequest: (value) => body = value,
    ).list(first: 10);

    expect(body, contains('totalCount'));
  });

  test('a server that omits the total falls back to the rows in hand', () async {
    final page = await _repository(rows: 4, totalCount: null).list(first: 10);

    expect(page.totalCount, 4);
  });
}
