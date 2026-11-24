import 'dart:convert';

import 'package:bagisto_flutter/core/graphql/account_queries.dart';
import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/order_detail_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/shipment_detail_bottom_sheet.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  test('shipment query documents request additional for items', () {
    expect(AccountQueries.getCustomerOrderShipment, contains('additional'));
    expect(AccountQueries.getCustomerOrderShipments, contains('additional'));
  });

  testWidgets(
      'shipment bottom sheet renders Sold By from additional attributes', (
    tester,
  ) async {
    final shipment = OrderShipment.fromJson({
      'id': '/api/shop/customer-order-shipments/6',
      '_id': 6,
      'shippingNumber': '6',
      'items': {
        'edges': [
          {
            'node': {
              'id': '6',
              'name': 'simple seller product',
              'sku': '001',
              'qty': 1,
              'additional': {
                'attributes': [
                  {
                    'attribute_name': 'Sold By',
                    'option_label': 'seller1-business',
                  },
                ],
              },
            },
          },
        ],
      },
    });

    final bloc = OrderDetailBloc(
      repository: AccountRepository(
        client: GraphQLClient(
          link: HttpLink(
            'https://example.com/graphql',
            httpClient: MockClient((_) async => http.Response('{}', 200)),
          ),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: bloc,
            child: ShipmentDetailBottomSheet(
              shipment: shipment,
              bloc: bloc,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('simple seller product'), findsOneWidget);
    expect(
      find.textContaining('Sold By : seller1-business', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('001'), findsOneWidget);
  });
}
