import 'dart:convert';

import 'package:bagisto_flutter/core/channel/channel_bootstrap_service.dart';
import 'package:bagisto_flutter/core/widgets/channel_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

GraphQLClient _client(String? logoUrl) => GraphQLClient(
  link: HttpLink(
    'https://example.com/graphql',
    httpClient: MockClient(
      (_) async => http.Response(
        jsonEncode({
          'data': {
            '__typename': 'Query',
            'channel': {
              '__typename': 'Channel',
              'id': '/api/shop/channels/1',
              '_id': 1,
              'code': 'default',
              'hostname': null,
              'theme': 'default',
              'timezone': null,
              'homeSeo': null,
              'logoUrl': logoUrl,
              'faviconUrl': null,
              'locales': {'__typename': 'LocaleCursorConnection', 'edges': []},
              'currencies': {
                '__typename': 'CurrencyCursorConnection',
                'edges': [],
              },
              'defaultLocale': null,
              'baseCurrency': null,
            },
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      ),
    ),
  ),
  cache: GraphQLCache(store: InMemoryStore()),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bootstrap caches the channel logo and clears it when removed',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await ChannelBootstrapService(
      client: _client('https://shop.test/storage/logo.png'),
      prefs: prefs,
    ).bootstrap();
    expect(
      prefs.getString(ChannelBootstrapService.logoUrlCacheKey),
      'https://shop.test/storage/logo.png',
    );

    await ChannelBootstrapService(client: _client(null), prefs: prefs)
        .bootstrap();
    expect(prefs.getString(ChannelBootstrapService.logoUrlCacheKey), isNull);
  });

  testWidgets('logo falls back to the bundled one without a channel logo', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const MaterialApp(
        home: ChannelLogo(height: 20, fallback: Text('fallback')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('fallback'), findsOneWidget);
  });

  testWidgets('channel logo image is used when configured', (tester) async {
    SharedPreferences.setMockInitialValues({
      ChannelBootstrapService.logoUrlCacheKey: 'https://shop.test/logo.png',
    });
    await tester.pumpWidget(
      const MaterialApp(
        home: ChannelLogo(height: 20, fallback: Text('fallback')),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const ValueKey('channel_logo_image')), findsOneWidget);
  });
}
