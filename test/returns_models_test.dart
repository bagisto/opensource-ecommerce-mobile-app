import 'package:bagisto_flutter/features/account/data/models/returns_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomerReturn.fromJson', () {
    test('parses a full node with decoded item and images', () {
      final json = {
        '_id': 12,
        'orderId': 5,
        'orderIncrementId': '100000005',
        'statusId': 1,
        'statusTitle': 'Pending',
        'statusColor': '#FFA500',
        'packageCondition': 'opened',
        'information': 'Item arrived damaged',
        'canClose': true,
        'canReopen': false,
        'isExpired': false,
        'item': {
          'id': 1,
          'order_item_id': 10,
          'sku': 'PROD-001',
          'name': 'Sample Product',
          'quantity': 2,
          'resolution': 'return',
          'reason_id': 2,
          'reason': 'Defective',
          'variant_id': null,
        },
        'images': [
          {'id': 1, 'path': '/returns/image1.jpg', 'url': 'https://x/i.jpg'},
        ],
        'messagesCount': 3,
        'createdAt': '2024-01-15T10:30:00Z',
      };

      final result = CustomerReturn.fromJson(json);

      expect(result.id, 12);
      expect(result.orderNumber, '#100000005');
      expect(result.returnNumber, '#12');
      expect(result.statusTitle, 'Pending');
      expect(result.canClose, true);
      expect(result.item?.name, 'Sample Product');
      expect(result.item?.quantity, 2);
      expect(result.item?.reason, 'Defective');
      expect(result.images.single.url, 'https://x/i.jpg');
      expect(result.formattedDate, '15 Jan 2024');
      expect(result.isTerminal, false);
      expect(result.canCancel, true);
    });

    test('parses item/images sent as JSON-encoded strings', () {
      final json = {
        '_id': 3,
        'statusTitle': 'Pending',
        'item': '{"name":"Encoded Product","quantity":1}',
        'images': '[{"id":1,"url":"https://x/a.jpg"}]',
      };

      final result = CustomerReturn.fromJson(json);

      expect(result.item?.name, 'Encoded Product');
      expect(result.images.single.url, 'https://x/a.jpg');
    });

    test('recognizes completed and rejected display statuses', () {
      for (final status in ['Canceled', 'Declined', 'Solved', 'Closed']) {
        final result = CustomerReturn.fromJson({
          '_id': 1,
          'statusTitle': status,
        });
        expect(result.isTerminal, true, reason: status);
      }
    });

    test('solved and declined returns can still be canceled', () {
      for (final status in [
        (id: 6, title: 'Solved'),
        (id: 7, title: 'Request Declined'),
      ]) {
        final result = CustomerReturn.fromJson({
          '_id': 1,
          'statusId': status.id,
          'statusTitle': status.title,
          'canReopen': status.id == 7,
        });
        expect(result.canCancel, true, reason: status.title);
      }
    });

    test('canceled status ID disables cancel even with a custom label', () {
      final result = CustomerReturn.fromJson({
        '_id': 1,
        'statusId': 9,
        'statusTitle': 'Custom canceled label',
      });
      expect(result.canCancel, false);
    });

    test('canceled labels disable cancel when the status ID is absent', () {
      for (final title in ['Canceled', 'Cancelled', 'Request Canceled']) {
        final result = CustomerReturn.fromJson({
          '_id': 1,
          'statusTitle': title,
        });
        expect(result.canCancel, false, reason: title);
      }
    });
  });

  group('ReturnableItem', () {
    test('maxQuantityFor picks the right cap per resolution', () {
      const item = ReturnableItem(
        name: 'P',
        forReturnQuantity: 3,
        forCancelQuantity: 1,
      );
      expect(item.maxQuantityFor('return'), 3);
      expect(item.maxQuantityFor('cancel_items'), 1);
    });
  });

  group('ReturnReason.fromJson', () {
    test('parses _id and title', () {
      final reason = ReturnReason.fromJson({
        '_id': 4,
        'title': 'Damaged product',
        'position': 2,
      });
      expect(reason.id, 4);
      expect(reason.title, 'Damaged product');
      expect(reason.position, 2);
    });
  });

  group('ReturnMessage.fromJson', () {
    test('parses admin flag and attachment url', () {
      final message = ReturnMessage.fromJson({
        '_id': 1,
        'rmaId': 12,
        'message': 'Hello',
        'isAdmin': true,
        'attachmentUrl': 'https://x/f.jpg',
        'createdAt': '2024-01-15T10:30:00Z',
      });
      expect(message.isAdmin, true);
      expect(message.attachmentUrl, 'https://x/f.jpg');
      expect(message.formattedDate, '15 Jan 2024');
    });
  });
}
