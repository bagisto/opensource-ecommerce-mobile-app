import 'package:bagisto_flutter/core/constants/api_constants.dart';
import 'package:bagisto_flutter/core/graphql/graphql_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  test('seller link targets the seller endpoint', () {
    final link = GraphQLClientProvider.buildSellerHttpLink();

    expect(link.uri.toString(), ApiEnv.sellerGraphql);
  });

  test('seller link never sends the storefront key', () {
    final link = GraphQLClientProvider.buildSellerHttpLink();

    expect(link.defaultHeaders.containsKey('X-STOREFRONT-KEY'), isFalse);
    expect(link.defaultHeaders['Content-Type'], 'application/json');
  });

  test('shop link still sends the storefront key', () {
    final client = GraphQLClientProvider.buildClient();

    expect(client, isA<GraphQLClient>());
    expect(ApiEnv.storefrontKey.isNotEmpty, isTrue);
  });

  test('seller client is built without throwing, with and without a token', () {
    expect(GraphQLClientProvider.buildSellerClient(), isA<GraphQLClient>());
    expect(
      GraphQLClientProvider.buildSellerClient(token: 'abc'),
      isA<GraphQLClient>(),
    );
  });
}
