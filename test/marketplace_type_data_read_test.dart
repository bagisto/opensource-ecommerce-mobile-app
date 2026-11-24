import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product.dart';
import 'package:flutter_test/flutter_test.dart';

/// What `sellerProduct` returns for a product's own type.
///
/// It used to return none of it, so every one of these tabs opened blank and a
/// seller had to retype the whole set to change one entry. The payloads below
/// are the live 2.4.9 responses, verbatim.
void main() {
  test('a configurable reads its variations, already labelled', () {
    final product = SellerProductDetail.fromJson({
      'id': '/api/seller/products/246',
      'sku': 'hcchchjccj666',
      'type': 'configurable',
      'variants': [
        {
          'variantId': 268,
          'listingId': 247,
          'sku': 'hcchchjccj666-variant-1',
          'name': 'Variant 1',
          'price': 8685,
          'weight': 5656,
          'status': 1,
          'superAttributes': {
            'color': {'option_id': 1, 'label': 'Red'},
          },
          'inventories': [
            {'sourceId': 5, 'sourceCode': 'default', 'qty': 12},
          ],
          'images': [
            {'url': 'http://example.com/red.jpg', 'position': 1},
          ],
        },
      ],
    });

    final variant = product.variants.single;
    expect(variant.variantId, 268);
    expect(variant.listingId, 247);
    expect(variant.price, 8685);
    expect(variant.status, isTrue);
    // The label is what a row is recognised by; the option id is the server's
    // own business.
    expect(variant.options, {'color': 'Red'});
    expect(variant.stocks.single.qty, 12);
    expect(variant.images, ['http://example.com/red.jpg']);

    // And it turns straight back into the edit the update takes.
    expect(variant.toEdit().toInput(), {
      'variantId': 268,
      'sku': 'hcchchjccj666-variant-1',
      'name': 'Variant 1',
      'price': 8685.0,
      'weight': 5656.0,
      'status': 1,
      'inventories': [
        {'inventorySourceId': 5, 'qty': 12},
      ],
    });
  });

  test('a booking reads its window, its slots and its per-type settings', () {
    // `slotSettings` is Bagisto's own snake_case and carries whatever the type
    // keeps beside its slots.
    final product = SellerProductDetail.fromJson({
      'id': '/api/seller/products/121',
      'sku': 'demo-booking-studio',
      'type': 'booking',
      'booking': {
        'bookingId': 3,
        'type': 'default',
        'qty': 3,
        'location': 'Studio B, Sector 63',
        'showLocation': true,
        'availableEveryWeek': true,
        'availableFrom': '2026-08-15 00:00:00',
        'availableTo': '2026-12-31 23:59:59',
        'slots': [
          {'day': 1, 'from': '10:00', 'to': '13:00'},
          {'day': 3, 'from': '10:00', 'to': '17:00'},
        ],
        'slotSettings': {
          'booking_type': 'many',
          'duration': 60,
          'break_time': 15,
        },
        'tickets': <dynamic>[],
      },
    });

    final booking = product.booking!;
    expect(booking.type, 'default');
    expect(booking.location, 'Studio B, Sector 63');
    expect(booking.availableFrom, '2026-08-15 00:00:00');
    expect(booking.bookingType, 'many');
    expect(booking.duration, 60);
    expect(booking.breakTime, 15);
    expect(booking.slots.first.day, 1);
    expect(booking.slots.first.from, '10:00');
  });

  test('an event reads its tickets, prices and all', () {
    // Prices come back as strings and the name sits inside `locales`.
    final product = SellerProductDetail.fromJson({
      'id': '/api/seller/products/321',
      'sku': 'probe-r-ev',
      'type': 'booking',
      'booking': {
        'type': 'event',
        'qty': 100,
        'location': 'Arena',
        'slotSettings': <dynamic>[],
        'tickets': [
          {
            'id': 11,
            'price': '1000.0000',
            'qty': 50,
            'special_price': null,
            'locales': [
              {'code': 'en', 'name': 'Gold', 'description': 'Front row'},
            ],
          },
        ],
      },
    });

    final ticket = product.booking!.tickets.single;
    expect(ticket.name, 'Gold');
    expect(ticket.description, 'Front row');
    expect(ticket.qty, 50);
    expect(ticket.price, 1000);
    expect(ticket.specialPrice, isNull);
  });

  test('a grouped product reads the products it holds', () {
    final product = SellerProductDetail.fromJson({
      'id': '/api/seller/products/318',
      'sku': 'probe-r-gr',
      'type': 'grouped',
      'links': [
        {
          'linkId': 12,
          'associatedProductId': 272,
          'sku': 'shirt-red',
          'name': 'Red shirt',
          'qty': 2,
          'sortOrder': 1,
        },
      ],
    });

    final link = product.links.single;
    expect(link.associatedProductId, 272);
    expect(link.qty, 2);
    // Read-only, so the row can name what it points at rather than show an id.
    expect(link.name, 'Red shirt');
  });

  test('a bundle reads its options and what is inside each', () {
    final product = SellerProductDetail.fromJson({
      'id': '/api/seller/products/319',
      'sku': 'probe-r-bn',
      'type': 'bundle',
      'bundleOptions': [
        {
          'bundleOptionId': 11,
          'label': 'Choose a bag',
          'type': 'checkbox',
          'isRequired': true,
          'sortOrder': 1,
          'products': [
            {
              'bundleOptionProductId': 16,
              'productId': 272,
              'sku': 'shirt-red',
              'name': 'Red shirt',
              'qty': 1,
              'isDefault': true,
              'sortOrder': 1,
            },
          ],
        },
      ],
    });

    final option = product.bundleOptions.single;
    expect(option.label, 'Choose a bag');
    expect(option.isRequired, isTrue);
    expect(option.products.single.productId, 272);
    expect(option.products.single.isDefault, isTrue);
  });

  test('a downloadable reads its links and its samples', () {
    final product = SellerProductDetail.fromJson({
      'id': '/api/seller/products/320',
      'sku': 'probe-r-dl',
      'type': 'downloadable',
      'downloadableLinks': [
        {
          'linkId': 4,
          'title': 'Album',
          'type': 'url',
          'url': 'https://example.com/a.mp3',
          'file': null,
          'fileName': null,
          'downloads': 3,
          'price': 100,
          'sortOrder': 1,
        },
      ],
      'downloadableSamples': [
        {
          'sampleId': 3,
          'title': 'Sample',
          'type': 'url',
          'url': 'https://example.com/s.mp3',
          'sortOrder': 1,
        },
      ],
    });

    expect(product.downloadableLinks.single.title, 'Album');
    expect(product.downloadableLinks.single.price, 100);
    expect(product.downloadableLinks.single.downloads, 3);
    expect(product.downloadableSamples.single.title, 'Sample');
  });

  test('a type carrying nothing is empty, not a crash', () {
    // Every other type's field comes back empty, and booking null.
    final product = SellerProductDetail.fromJson({
      'id': '/api/seller/products/1',
      'sku': 'plain',
      'type': 'simple',
    });

    expect(product.variants, isEmpty);
    expect(product.links, isEmpty);
    expect(product.bundleOptions, isEmpty);
    expect(product.downloadableLinks, isEmpty);
    expect(product.downloadableSamples, isEmpty);
    expect(product.booking, isNull);
  });
}
