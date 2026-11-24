import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order_filters.dart';
import 'package:bagisto_flutter/marketplace/features/orders/data/repository/seller_order_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _RecordingLink {
  _RecordingLink({this.data});

  final Map<String, dynamic>? data;
  Map<String, dynamic>? lastVariables;

  GraphQLClient get client {
    final link = Link.function((request, [forward]) async* {
      lastVariables = request.variables;
      yield Response(data: data, response: const {}, context: const Context());
    });

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }
}

const _orderSummary = {
  'id': 12,
  'incrementId': '1000012',
  'status': 'processing',
  'customerName': 'Demo Buyer',
  'customerEmail': 'buyer@example.com',
  'commission': 10.0,
  'sellerTotal': 90.0,
  'grandTotal': 100.0,
  'totalItemCount': 2,
  'totalQtyOrdered': 3,
  'sellerPayoutStatus': 'pending',
  'isWithdrawalRequested': false,
  'createdAt': '2026-08-14T10:00:00+05:30',
};

void main() {
  group('list', () {
    test('maps rows and pagination', () async {
      final link = _RecordingLink(
        data: {
          'sellerOrders': {
            'collection': [_orderSummary],
            'paginationInfo': {'totalCount': 1, 'lastPage': 1},
          },
        },
      );

      final page = await SellerOrderRepository(client: link.client).list();
      final order = page.items.single;

      expect(order.id, 12);
      expect(order.incrementId, '1000012');
      expect(order.sellerTotal, 90.0);
      expect(order.payoutStatus, SellerPayoutStatus.pending);
      expect(order.canRequestPayment, isTrue);
    });

    test('sends search and payout filters only when set', () async {
      final link = _RecordingLink(
        data: {
          'sellerOrders': {
            'collection': const <dynamic>[],
            'paginationInfo': {'totalCount': 0, 'lastPage': 1},
          },
        },
      );
      final repository = SellerOrderRepository(client: link.client);

      await repository.list(
        page: 2,
        filters: const SellerOrderFilters(
          search: 'john',
          payoutStatus: 'pending',
        ),
      );
      expect(link.lastVariables, {
        'page': 2,
        'search': 'john',
        'payout_status': 'pending',
      });

      await repository.list();
      expect(link.lastVariables, {'page': 1});
    });

    test('a paid order cannot be requested again', () async {
      final link = _RecordingLink(
        data: {
          'sellerOrders': {
            'collection': [
              {..._orderSummary, 'sellerPayoutStatus': 'paid'},
            ],
            'paginationInfo': {'totalCount': 1, 'lastPage': 1},
          },
        },
      );

      final page = await SellerOrderRepository(client: link.client).list();

      expect(page.items.single.payoutStatus, SellerPayoutStatus.paid);
      expect(page.items.single.canRequestPayment, isFalse);
    });
  });

  group('detail', () {
    test('maps items, invoices, shipments and refunds', () async {
      final link = _RecordingLink(
        data: {
          'sellerOrder': {
            ..._orderSummary,
            'items': [
              {
                'id': 5,
                'orderItemId': 5,
                'name': 'Runner Sneakers',
                'sku': 'demo-sneaker',
                'qtyOrdered': 3,
                'qtyInvoiced': 1,
                'qtyShipped': 0,
                'qtyRefunded': 0,
                'qtyCanceled': 0,
                'price': 74.0,
                'total': 222.0,
                'productId': 65,
              },
            ],
            'invoices': [
              {
                'id': 3,
                'incrementId': 'INV-1',
                'state': 'paid',
                'totalQty': 1,
                'grandTotal': 74.0,
                'downloadUrl': 'http://example.com/invoice.pdf',
              },
            ],
            'shipments': [
              {
                'id': 4,
                'totalQty': 1,
                'carrierCode': 'manual',
                'carrierTitle': 'DHL',
                'trackNumber': 'TRK-1',
                'inventorySourceName': 'Default',
              },
            ],
            'refunds': const <dynamic>[],
          },
        },
      );

      final detail = await SellerOrderRepository(
        client: link.client,
      ).detail(12);

      expect(link.lastVariables, {'id': '/api/seller/orders/12'});
      expect(detail.summary.incrementId, '1000012');
      expect(detail.items.single.orderItemId, 5);
      expect(
        detail.invoices.single.downloadUrl,
        'http://example.com/invoice.pdf',
      );
      expect(detail.shipments.single.trackNumber, 'TRK-1');
      expect(detail.refunds, isEmpty);
    });

    test('remaining quantities drive what the seller may still do', () async {
      const line = SellerOrderLine(
        id: 5,
        orderItemId: 5,
        name: 'Runner Sneakers',
        sku: 'demo-sneaker',
        qtyOrdered: 3,
        qtyInvoiced: 2,
        qtyShipped: 1,
        qtyCanceled: 1,
      );

      // Ordered 3, invoiced 2, cancelled 1 leaves nothing to invoice.
      expect(line.qtyToInvoice, 0);
      // Invoiced 2, shipped 1 leaves one to dispatch.
      expect(line.qtyToShip, 1);

      const detail = SellerOrderDetail(
        summary: SellerOrderSummary(
          id: 12,
          incrementId: '1000012',
          status: 'processing',
        ),
        items: [line],
      );

      expect(detail.canInvoice, isFalse);
      expect(detail.canShip, isTrue);
      expect(detail.canCancel, isFalse);
    });

    test('a booking-only order offers no shipment and no Shipments tab', () {
      // Server says canShip false for booking lines even though qty is unshipped.
      final booking = SellerOrderDetail.fromJson({
        'id': 23,
        'incrementId': '44',
        'status': 'completed',
        'canShip': false,
        'shippingMethod': null,
        'shippingAddress': null,
        'items': [
          {
            'id': 1,
            'orderItemId': 1,
            'name': 'Booking — Default',
            'sku': 'booking-default',
            'qtyOrdered': 1,
            'qtyInvoiced': 1,
            'qtyShipped': 0,
          },
        ],
      });

      expect(booking.items.single.qtyToShip, 1);
      expect(booking.canShip, isFalse);
      expect(booking.showShipments, isFalse);

      // A simple pending order still ships and keeps the tab.
      final simple = SellerOrderDetail.fromJson({
        'id': 18,
        'incrementId': '39',
        'status': 'pending',
        'canShip': true,
        'shippingMethod': 'free_free',
        'items': [
          {
            'id': 2,
            'orderItemId': 2,
            'name': 'Simple Test',
            'sku': 'dssdsfd',
            'qtyOrdered': 16,
            'qtyShipped': 0,
          },
        ],
      });

      expect(simple.canShip, isTrue);
      expect(simple.showShipments, isTrue);

      // A shipped simple order keeps the tab because a shipment exists.
      final shipped = SellerOrderDetail.fromJson({
        'id': 3,
        'incrementId': '3',
        'status': 'completed',
        'canShip': false,
        'shipments': [
          {'id': 1, 'totalQty': 1},
        ],
        'items': const <dynamic>[],
      });

      expect(shipped.canShip, isFalse);
      expect(shipped.showShipments, isTrue);
    });
  });

  group('actions', () {
    test('invoice sends the order id and the chosen lines', () async {
      final link = _RecordingLink(
        data: {
          'createSellerInvoice': {
            'sellerInvoice': {
              'id': 3,
              'incrementId': 'INV-1',
              'state': 'paid',
              'totalQty': 2,
            },
          },
        },
      );

      final invoice = await SellerOrderRepository(
        client: link.client,
      ).createInvoice(orderId: 12, items: [(orderItemId: 5, qty: 2)]);

      expect(link.lastVariables?['input'], {
        'orderId': 12,
        'items': [
          {'orderItemId': 5, 'qty': 2},
        ],
      });
      expect(invoice.incrementId, 'INV-1');
    });

    test('shipment carries the source, carrier and tracking number', () async {
      final link = _RecordingLink(
        data: {
          'createSellerShipment': {
            'sellerShipment': {
              'id': 4,
              'totalQty': 1,
              'carrierCode': 'manual',
              'carrierTitle': 'DHL Express',
              'trackNumber': 'TRK-123',
            },
          },
        },
      );

      final shipment = await SellerOrderRepository(client: link.client)
          .createShipment(
            orderId: 12,
            items: [(orderItemId: 5, qty: 1)],
            inventorySourceId: 5,
            carrierTitle: 'DHL Express',
            trackNumber: 'TRK-123',
          );

      expect(link.lastVariables?['input'], {
        'orderId': 12,
        'carrierCode': 'manual',
        'items': [
          {'orderItemId': 5, 'qty': 1},
        ],
        'source': 5,
        'carrierTitle': 'DHL Express',
        'trackNumber': 'TRK-123',
      });
      expect(shipment.trackNumber, 'TRK-123');
    });

    test('a carrier that books nothing still records the shipment', () async {
      final link = _RecordingLink(
        data: {
          'createSellerShipment': {
            'sellerShipment': {
              'id': 4,
              'totalQty': 1,
              'carrierCode': 'manual',
              'bookingFailed': false,
            },
          },
        },
      );

      final shipment = await SellerOrderRepository(
        client: link.client,
      ).createShipment(orderId: 12, items: [(orderItemId: 5, qty: 1)]);

      expect(shipment.bookingFailed, isFalse);
      expect(link.lastVariables?['input'], isNot(contains('source')));
    });

    test('cancel returns the server message', () async {
      final link = _RecordingLink(
        data: {
          'createSellerOrderCancel': {
            'sellerOrderCancel': {
              'id': 12,
              'success': true,
              'message': 'Order cancelled successfully.',
            },
          },
        },
      );

      final message = await SellerOrderRepository(
        client: link.client,
      ).cancel(12);

      expect(link.lastVariables?['input'], {'orderId': '12'});
      expect(message, 'Order cancelled successfully.');
    });

    test('a refused cancellation raises the server message', () async {
      final link = _RecordingLink(
        data: {
          'createSellerOrderCancel': {
            'sellerOrderCancel': {
              'id': 12,
              'success': false,
              'message': 'Order cannot be cancelled.',
            },
          },
        },
      );

      await expectLater(
        SellerOrderRepository(client: link.client).cancel(12),
        throwsA(
          isA<SellerApiException>().having(
            (e) => e.message,
            'message',
            'Order cannot be cancelled.',
          ),
        ),
      );
    });

    test('payment request returns the new payout status', () async {
      final link = _RecordingLink(
        data: {
          'createSellerPaymentRequest': {
            'sellerPaymentRequest': {
              'id': 12,
              'success': true,
              'sellerPayoutStatus': 'requested',
              'message': 'Requested',
            },
          },
        },
      );

      final status = await SellerOrderRepository(
        client: link.client,
      ).requestPayment(12);

      expect(link.lastVariables?['input'], {
        'orderId': '/api/seller/orders/12',
      });
      expect(status, 'requested');
    });
  });

  group('carriers', () {
    test('maps the shipment fields the carrier declares', () async {
      final link = _RecordingLink(
        data: {
          'sellerFulfilmentCarriers': [
            {
              'id': '/api/seller/fulfilment/carriers/manual',
              'code': 'manual',
              'title': 'Manual (Own Arrangement)',
              'capabilities': const <dynamic>[],
              'needsParcelDetails': false,
              'pickupMode': 'none',
              'shipmentFields': [
                {'name': 'carrierTitle', 'label': 'Carrier Title'},
                {'name': 'trackNumber', 'label': 'Tracking Number'},
              ],
              'isDefault': true,
            },
          ],
        },
      );

      final carriers = await SellerOrderRepository(
        client: link.client,
      ).carriers();
      final manual = carriers.single;

      expect(manual.code, 'manual');
      expect(manual.booksNothing, isTrue);
      // The whole declaration, not just the names: the form needs the label
      // to show and the mutation needs the name to send.
      expect(manual.shipmentFields.map((field) => field.name), [
        'carrierTitle',
        'trackNumber',
      ]);
      expect(manual.shipmentFields.first.label, 'Carrier Title');
      expect(manual.booksPickup, isFalse);
      expect(manual.wantsParcel, isFalse);
      expect(manual.isDefault, isTrue);
    });
  });
}
