import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_draft.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:flutter_test/flutter_test.dart';

const _detail = SellerProductDetail(
  iri: SellerIri('/theme/api-4.9/public/api/seller/products/55'),
  productId: 70,
  sku: 'cfg-shirt',
  name: 'Configurable Shirt',
  type: 'configurable',
  status: 1,
);

SellerProductDraft get _draft => SellerProductDraft.fromDetail(_detail);

void main() {
  test('untouched type structures stay out of the payload', () {
    final input = _draft.toInput();

    for (final key in const [
      'variants',
      'links',
      'bundleOptions',
      'downloadableLinks',
      'downloadableSamples',
      'booking',
    ]) {
      expect(input.containsKey(key), isFalse, reason: key);
    }
  });

  test('variants carry the core product id, not the catalogue id', () {
    final input = _draft
        .copyWith(
          variants: const [
            SellerVariantEdit(
              variantId: 71,
              sku: 'cfg-shirt-red-s',
              name: 'Red / S',
              price: 1200,
              status: true,
              stocks: [(inventorySourceId: 5, qty: 4)],
            ),
          ],
        )
        .toInput();

    expect(input['variants'], [
      {
        'variantId': 71,
        'sku': 'cfg-shirt-red-s',
        'name': 'Red / S',
        'price': 1200,
        'status': 1,
        'inventories': [
          {'inventorySourceId': 5, 'qty': 4},
        ],
      },
    ]);
  });

  test('grouped links emit the associated product, qty and order', () {
    final input = _draft
        .copyWith(
          links: const [
            SellerGroupedLink(associatedProductId: 2, qty: 1, sortOrder: 1),
            SellerGroupedLink(associatedProductId: 3, qty: 2, sortOrder: 2),
          ],
        )
        .toInput();

    expect(input['links'], [
      {'associatedProductId': 2, 'qty': 1, 'sortOrder': 1},
      {'associatedProductId': 3, 'qty': 2, 'sortOrder': 2},
    ]);
  });

  test('a bundle option emits its locale label and its products', () {
    final input = _draft
        .copyWith(
          bundleOptions: const [
            SellerBundleOption(
              label: 'Choose a bag',
              type: 'checkbox',
              isRequired: true,
              sortOrder: 1,
              products: [
                SellerBundleOptionProduct(
                  productId: 2,
                  qty: 1,
                  isDefault: true,
                ),
              ],
            ),
          ],
        )
        .toInput();

    expect(input['bundleOptions'], [
      {
        'locales': [
          {'code': 'en', 'label': 'Choose a bag'},
        ],
        'type': 'checkbox',
        'isRequired': true,
        'sortOrder': 1,
        'products': [
          {'productId': 2, 'qty': 1, 'isDefault': true, 'sortOrder': 0},
        ],
      },
    ]);
  });

  test('a downloadable file sends the data URI and its name', () {
    final input = _draft
        .copyWith(
          downloadableLinks: const [
            SellerDownloadableLink(
              title: 'Starter kit',
              type: 'file',
              file: 'data:application/zip;base64,AAA',
              fileName: 'kit.zip',
              price: 100,
              downloads: 3,
            ),
          ],
        )
        .toInput();

    final link = (input['downloadableLinks'] as List).single as Map;
    expect(link['type'], 'file');
    expect(link['file'], 'data:application/zip;base64,AAA');
    expect(link['fileName'], 'kit.zip');
    expect(link.containsKey('url'), isFalse);
  });

  test('a downloadable url sends no file fields', () {
    final input = _draft
        .copyWith(
          downloadableSamples: const [
            SellerDownloadableSample(
              title: 'Preview',
              url: 'https://example.com/preview.mp3',
            ),
          ],
        )
        .toInput();

    final sample = (input['downloadableSamples'] as List).single as Map;
    expect(sample['type'], 'url');
    expect(sample['url'], 'https://example.com/preview.mp3');
    expect(sample.containsKey('file'), isFalse);
  });

  group('booking', () {
    test('default with many bookings sends per-day slots', () {
      final input = _draft
          .copyWith(
            booking: const SellerBookingConfig(
              type: 'default',
              qty: 5,
              bookingType: 'many',
              duration: 30,
              breakTime: 10,
              slots: [SellerBookingSlot(day: 1, from: '09:00', to: '12:00')],
            ),
          )
          .toInput();

      final booking = input['booking'] as Map;
      expect(booking['type'], 'default');
      expect(booking['bookingType'], 'many');
      expect(booking['slots'], [
        {'day': 1, 'from': '09:00', 'to': '12:00'},
      ]);
    });

    test('default with a single booking sends day-range slots', () {
      final input = _draft
          .copyWith(
            booking: const SellerBookingConfig(
              type: 'default',
              bookingType: 'one',
              slots: [
                SellerBookingSlot(
                  fromDay: 0,
                  toDay: 1,
                  from: '09:00',
                  to: '18:00',
                ),
              ],
            ),
          )
          .toInput();

      final booking = input['booking'] as Map;
      expect(booking['type'], 'default');
      expect(booking['bookingType'], 'one');
      expect(booking['slots'], [
        {'day': 0, 'from': '09:00', 'to': '18:00', 'from_day': 0, 'to_day': 1},
      ]);
    });

    test('an event sends tickets instead of slots', () {
      final input = _draft
          .copyWith(
            booking: const SellerBookingConfig(
              type: 'event',
              tickets: [
                SellerBookingTicket(
                  name: 'Gold',
                  description: 'Front row',
                  qty: 50,
                  price: 1000,
                ),
              ],
            ),
          )
          .toInput();

      final booking = input['booking'] as Map;
      expect(booking.containsKey('slots'), isFalse);
      expect(booking['tickets'], [
        {
          'locales': [
            {'code': 'en', 'name': 'Gold', 'description': 'Front row'},
          ],
          'qty': 50,
          'price': 1000,
        },
      ]);
    });

    test('a rental sends its renting type and prices', () {
      final input = _draft
          .copyWith(
            booking: const SellerBookingConfig(
              type: 'rental',
              rentingType: 'daily',
              dailyPrice: 500,
              hourlyPrice: 80,
              sameSlotAllDays: true,
              slots: [SellerBookingSlot(from: '08:00', to: '20:00')],
            ),
          )
          .toInput();

      final booking = input['booking'] as Map;
      expect(booking['rentalSlot'], {
        'rentingType': 'daily',
        'dailyPrice': 500,
        'hourlyPrice': 80,
        'sameSlotAllDays': 1,
      });
      expect(booking.containsKey('tableSlot'), isFalse);
    });

    test('rental both option maps to and from the API value', () {
      final input = _draft
          .copyWith(
            booking: const SellerBookingConfig(
              type: 'rental',
              rentingType: 'daily_and_hourly',
              dailyPrice: 500,
              hourlyPrice: 80,
            ),
          )
          .toInput();

      expect(
        (input['booking'] as Map)['rentalSlot']['rentingType'],
        'daily_hourly',
      );

      final loaded = SellerBookingConfig.fromJson({
        'type': 'rental',
        'slotSettings': {'renting_type': 'daily_hourly'},
      });

      expect(loaded.rentingType, 'daily_and_hourly');
    });

    test('a table sends its guest limit and slot length', () {
      final input = _draft
          .copyWith(
            booking: const SellerBookingConfig(
              type: 'table',
              qty: 58,
              priceType: 'per_guest',
              guestLimit: 6,
              duration: 90,
              breakTime: 15,
              preventSchedulingBefore: 2,
              sameSlotAllDays: true,
              slots: [SellerBookingSlot(from: '12:00', to: '15:00')],
            ),
          )
          .toInput();

      final booking = input['booking'] as Map;
      expect(booking['qty'], 58);
      expect(booking['tableSlot'], {
        'priceType': 'guest',
        'guestLimit': 6,
        'duration': 90,
        'breakTime': 15,
        'preventSchedulingBefore': 2,
        'sameSlotAllDays': 1,
      });
      expect(booking.containsKey('rentalSlot'), isFalse);
    });

    test('table pricing values from the web map to app dropdown values', () {
      final guest = SellerBookingConfig.fromJson({
        'type': 'table',
        'qty': 58,
        'slotSettings': {'price_type': 'guest', 'guest_limit': 6},
      });
      final table = SellerBookingConfig.fromJson({
        'type': 'table',
        'qty': 58,
        'slotSettings': {'price_type': 'table', 'guest_limit': 6},
      });

      expect(guest.priceType, 'per_guest');
      expect(table.priceType, 'per_table');
      expect(guest.qty, 58);
      expect(table.guestLimit, 6);

      expect(
        guest.copyWith(type: 'table').toInput()['tableSlot']['priceType'],
        'guest',
      );
      expect(
        table.copyWith(type: 'table').toInput()['tableSlot']['priceType'],
        'table',
      );
    });

    test('an appointment sends per-day slots and its duration', () {
      final input = _draft
          .copyWith(
            booking: const SellerBookingConfig(
              type: 'appointment',
              duration: 45,
              breakTime: 15,
              slots: [SellerBookingSlot(day: 2, from: '10:00', to: '14:00')],
            ),
          )
          .toInput();

      final booking = input['booking'] as Map;
      expect(booking['duration'], 45);
      expect(booking['slots'], [
        {'day': 2, 'from': '10:00', 'to': '14:00'},
      ]);
      expect(booking.containsKey('tickets'), isFalse);
    });

    test('an appointment keeps separate nonoverlapping slots on one day', () {
      final booking =
          _draft
                  .copyWith(
                    booking: const SellerBookingConfig(
                      type: 'appointment',
                      sameSlotAllDays: false,
                      slots: [
                        SellerBookingSlot(day: 1, from: '09:00', to: '12:00'),
                        SellerBookingSlot(day: 1, from: '14:00', to: '18:00'),
                      ],
                    ),
                  )
                  .toInput()['booking']
              as Map<String, dynamic>;

      expect(booking['sameSlotAllDays'], 0);
      expect(booking['slots'], [
        {'day': 1, 'from': '09:00', 'to': '12:00'},
        {'day': 1, 'from': '14:00', 'to': '18:00'},
      ]);
      expect(
        const SellerBookingSlot(
          day: 1,
          from: '09:00',
          to: '17:00',
        ).overlaps(const SellerBookingSlot(day: 1, from: '07:00', to: '19:00')),
        isTrue,
      );
    });
  });
}
