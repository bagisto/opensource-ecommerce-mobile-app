import 'dart:convert';

import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// `createShopProductFlagInput.listingId` is a String on the server, not an
/// Int. Sending the number is refused before the mutation even runs, with
/// `String cannot represent a non string value: 333`, and the shopper sees
/// that raw GraphQL text in a SnackBar.
void main() {
  test('a reported listing id is sent as a string', () async {
    late Map<String, dynamic> sentVariables;

    final repository = ShopMarketplaceRepository(
      client: GraphQLClient(
        link: HttpLink(
          'https://example.com/graphql',
          httpClient: MockClient((request) async {
            sentVariables =
                (jsonDecode(request.body) as Map<String, dynamic>)['variables']
                    as Map<String, dynamic>;
            return http.Response(
              jsonEncode({
                'data': {
                  'createShopProductFlag': {'clientMutationId': null},
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

    await repository.flagProduct(
      listingId: 333,
      reason: 'Duplicate product',
      otherReason: 'looks the same as another listing',
    );

    final input = sentVariables['input'] as Map<String, dynamic>;
    expect(input['listingId'], isA<String>());
    expect(input['listingId'], '333');
    expect(input['reason'], 'Duplicate product');
    expect(input['otherReason'], 'looks the same as another listing');
  });

  test('an empty other reason is left out entirely', () async {
    late Map<String, dynamic> sentVariables;

    final repository = ShopMarketplaceRepository(
      client: GraphQLClient(
        link: HttpLink(
          'https://example.com/graphql',
          httpClient: MockClient((request) async {
            sentVariables =
                (jsonDecode(request.body) as Map<String, dynamic>)['variables']
                    as Map<String, dynamic>;
            return http.Response(
              jsonEncode({
                'data': {
                  'createShopProductFlag': {'clientMutationId': null},
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

    await repository.flagProduct(listingId: 7, reason: 'Other Reason');

    final input = sentVariables['input'] as Map<String, dynamic>;
    expect(input['listingId'], '7');
    expect(input.containsKey('otherReason'), isFalse);
  });
}
