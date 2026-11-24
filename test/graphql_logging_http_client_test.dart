import 'dart:convert';

import 'package:bagisto_flutter/core/graphql/graphql_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('logs GraphQL query variables and response body', () async {
    SharedPreferences.setMockInitialValues({});
    final messages = <String>[];
    final previousDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) messages.add(message);
    };
    addTearDown(() => debugPrint = previousDebugPrint);

    final client = LoggingHttpClient(
      inner: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'data': {
              'shopProductSeller': {
                'sellerId': 38,
                'businessName': 'Atlas Outfitters',
              },
            },
          }),
          200,
        );
      }),
    );
    addTearDown(client.close);

    final request =
        http.Request(
            'POST',
            Uri.parse('https://demo-mp-api.bagisto.com/api/graphql'),
          )
          ..body = jsonEncode({
            'query':
                'query ShopProductSeller(\$id: ID!, \$urlKey: String!) { shopProductSeller(id: \$id, urlKey: \$urlKey) { sellerId businessName } }',
            'variables': {
              'id': '/api/shop/products/simple/seller',
              'urlKey': 'simple',
            },
          });

    await client.send(request);

    expect(messages, contains('📄 Query:'));
    expect(messages.join('\n'), contains('query ShopProductSeller'));
    expect(messages, contains('🔧 Variables:'));
    expect(messages.join('\n'), contains('/api/shop/products/simple/seller'));
    expect(messages.join('\n'), contains('"urlKey": "simple"'));
    expect(messages, contains('📥 Response Body:'));
    expect(messages.join('\n'), contains('"businessName": "Atlas Outfitters"'));
  });
}
