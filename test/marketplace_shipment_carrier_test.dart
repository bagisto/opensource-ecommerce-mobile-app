import 'package:bagisto_flutter/marketplace/features/orders/data/models/seller_order.dart';
import 'package:flutter_test/flutter_test.dart';

/// A shipment is only accepted if it carries what the chosen carrier asked
/// for, and the carrier registry is the only thing that knows what that is.
/// Reading the declaration wrongly means a shipment the courier rejects.
void main() {
  group('SellerFulfilmentCarrier', () {
    test('the manual carrier declares its two typed-in fields', () {
      // Exactly what the live registry answers for `manual`.
      final carrier = SellerFulfilmentCarrier.fromJson(const {
        'code': 'manual',
        'title': 'Manual (Own Arrangement)',
        'capabilities': [],
        'needsParcelDetails': false,
        'pickupMode': 'none',
        'isDefault': true,
        'shipmentFields': [
          {
            'name': 'carrierTitle',
            'key': 'carrier_title',
            'label': 'Carrier Title',
            'type': 'text',
            'required': false,
          },
          {
            'name': 'trackNumber',
            'key': 'track_number',
            'label': 'Tracking ID',
            'type': 'text',
            'required': false,
          },
        ],
      });

      expect(carrier.shipmentFields, hasLength(2));
      expect(carrier.shipmentFields.first.label, 'Carrier Title');
      // `name` is what the mutation takes; `key` is the registry's own
      // snake_case, which the input would reject.
      expect(carrier.shipmentFields.first.name, 'carrierTitle');
      expect(carrier.shipmentFields.last.name, 'trackNumber');
    });

    test('a carrier that books nothing asks for no collection', () {
      const carrier = SellerFulfilmentCarrier(
        code: 'manual',
        title: 'Manual',
        pickupMode: 'none',
      );

      expect(carrier.booksPickup, isFalse);
      expect(carrier.wantsParcel, isFalse);
    });

    test('a courier that books a window does ask for one', () {
      const carrier = SellerFulfilmentCarrier(
        code: 'dhl',
        title: 'DHL Express',
        capabilities: ['label', 'pickup'],
        needsParcelDetails: true,
        pickupMode: 'slots',
      );

      expect(carrier.booksPickup, isTrue);
      expect(carrier.wantsParcel, isTrue);
    });

    test('a carrier with no declared fields still parses', () {
      final carrier = SellerFulfilmentCarrier.fromJson(const {
        'code': 'x',
        'title': 'X',
      });

      expect(carrier.shipmentFields, isEmpty);
      expect(carrier.booksPickup, isFalse);
    });

    test('a required field is marked as one', () {
      const field = SellerCarrierField(
        name: 'trackNumber',
        label: 'Tracking ID',
        isRequired: true,
      );

      expect(field.isRequired, isTrue);
    });
  });

  group('SellerParcel', () {
    test('an untouched parcel is not sent', () {
      const parcel = SellerParcel();

      expect(parcel.isEmpty, isTrue);
      expect(parcel.toInput(), isEmpty);
    });

    test('only the measures the seller filled in travel', () {
      const parcel = SellerParcel(weight: 1.4, length: 30);

      expect(parcel.isEmpty, isFalse);
      expect(parcel.toInput(), {'weight': 1.4, 'length': 30.0});
    });

    test('a full parcel carries all four measures', () {
      const parcel = SellerParcel(
        weight: 2.5,
        length: 40,
        width: 30,
        height: 20,
      );

      expect(parcel.toInput(), {
        'weight': 2.5,
        'length': 40.0,
        'width': 30.0,
        'height': 20.0,
      });
    });
  });
}
