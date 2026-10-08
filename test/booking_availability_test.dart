import 'package:bagisto_flutter/core/graphql/queries.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

BookingProductData _booking(Map<String, dynamic> json) =>
    BookingProductData.fromJson({'id': '1', ...json});

void main() {
  perDayListTest();
  test('default "one" booking is bookable on the from_day..to_day ranges', () {
    // Live product 2507: Mon, Tue, Wed (0 = Sunday).
    final booking = _booking({
      'type': 'default',
      'defaultSlot': {
        'bookingType': 'one',
        'slots':
            '[{"id":"1","to":"18:00","from":"12:00","to_day":"1","from_day":"1"},'
            '{"id":"2","to":"18:00","from":"12:00","to_day":"2","from_day":"2"},'
            '{"id":"1","to":"18:00","from":"12:00","to_day":"3","from_day":"3"}]',
      },
    });

    expect(booking.bookableWeekdays, {1, 2, 3});
    expect(booking.isBookableOn(DateTime(2026, 10, 5)), isTrue); // Monday
    expect(booking.isBookableOn(DateTime(2026, 10, 4)), isFalse); // Sunday
  });

  test('per-day slots allow only days that have slots', () {
    final booking = _booking({
      'type': 'appointment',
      'appointmentSlot': {
        'sameSlotAllDays': '0',
        'slots': {
          '0': <Object>[],
          '5': [
            {'from': '10:00', 'to': '11:00'},
          ],
        },
      },
    });

    expect(booking.bookableWeekdays, {5});
  });

  test('same slots every day leave every day bookable', () {
    final booking = _booking({
      'type': 'appointment',
      'appointmentSlot': {
        'sameSlotAllDays': '1',
        'slots': '[{"to":"10:45","from":"10:00"}]',
      },
    });

    expect(booking.bookableWeekdays, isNull);
    expect(booking.isBookableOn(DateTime(2026, 10, 4)), isTrue);
  });

  test('allowCancellation is read from the API', () {
    expect(_booking({'allowCancellation': '0'}).allowCancellation, isFalse);
    expect(_booking({'allowCancellation': '1'}).allowCancellation, isTrue);
    expect(_booking({}).allowCancellation, isNull);
    expect(ProductQueries.getProductById, contains('allowCancellation'));
  });
}

void perDayListTest() {
  test('per-day slots as a weekday-indexed list', () {
    final booking = _booking({
      'type': 'default',
      'defaultSlot': {
        'bookingType': 'many',
        'slots': [
          <Object>[],
          [
            {'from': '09:00', 'to': '10:00'},
          ],
          <Object>[],
        ],
      },
    });

    expect(booking.bookableWeekdays, {1});
  });
}
