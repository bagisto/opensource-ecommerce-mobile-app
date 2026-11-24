import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_type_sections.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// The booking section's dates and times.
///
/// They were plain text fields: a seller had to know that the server wants
/// "2026-09-01 00:00:00" and type it by hand, and a mistyped one is refused
/// with nothing said about which field was wrong.
Future<SellerBookingConfig?> _pump(
  WidgetTester tester, {
  SellerBookingConfig config = const SellerBookingConfig(type: 'default'),
  bool isEditing = false,
}) async {
  SellerBookingConfig? saved;

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => SellerBookingSection(
              title: 'Booking',
              notice: 'Saving replaces the whole set.',
              config: saved ?? config,
              onChanged: (value) => setState(() => saved = value),
              isEditing: isEditing,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return saved;
}

/// Reads what the section last handed back.
SellerBookingConfig _current(WidgetTester tester) {
  final section = tester.widget<SellerBookingSection>(
    find.byType(SellerBookingSection),
  );
  return section.config!;
}

/// The top offset of a keyed field, for asserting one field sits above
/// another in the scrolled column — a Column lays its children out
/// top-to-bottom in the order given, so this is a direct check of that
/// order, not just of which fields exist.
double _top(WidgetTester tester, String key) =>
    tester.getTopLeft(find.byKey(Key(key))).dy;

void main() {
  testWidgets('a date is picked from a calendar, not typed', (tester) async {
    await _pump(tester, config: const SellerBookingConfig(type: 'event'));

    await tester.tap(find.byKey(const Key('bookingAvailableFrom')));
    await tester.pumpAndSettle();

    // The calendar is open; take whatever day it offers.
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Then the clock, since the server wants a time as well as a date.
    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final from = _current(tester).availableFrom;
    expect(from, isNotNull);
    // The server's own format, so the seller never has to know it.
    expect(
      RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(from!),
      isTrue,
      reason: from,
    );
  });

  testWidgets('the day a slot falls on is named, not numbered', (tester) async {
    await _pump(
      tester,
      config: const SellerBookingConfig(
        type: 'default',
        slots: [SellerBookingSlot(day: 1, from: '09:00', to: '17:00')],
      ),
    );

    // 1 is Monday. A seller reading "1" cannot tell whether weeks start on
    // Sunday here.
    expect(find.text('Monday'), findsOneWidget);
  });

  testWidgets('a slot time is picked from a clock', (tester) async {
    await _pump(
      tester,
      config: const SellerBookingConfig(
        type: 'default',
        slots: [SellerBookingSlot(day: 1, from: '09:00', to: '17:00')],
      ),
    );

    await tester.tap(find.byKey(const Key('slotFrom_0')));
    await tester.pumpAndSettle();

    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(_current(tester).slots.single.from, matches(r'^\d{2}:\d{2}$'));
  });

  testWidgets('a rental slot carries a weekday too', (tester) async {
    // The panel shows no weekday for a rental or a table, but the server
    // refuses a slot without one — an unexplained 500. Verified live.
    //
    // Slots (and so this day picker) only appear once a rental can be
    // booked by the hour — a daily-only rental shows no slots at all, per
    // the web panel.
    await _pump(
      tester,
      config: const SellerBookingConfig(
        type: 'rental',
        rentingType: 'hourly',
        slots: [SellerBookingSlot(from: '09:00', to: '17:00')],
      ),
    );

    expect(find.byKey(const Key('slotDay_0')), findsOneWidget);
  });

  testWidgets('appointment rejects a second slot that overlaps the first', (
    tester,
  ) async {
    await _pump(
      tester,
      config: const SellerBookingConfig(
        type: 'appointment',
        sameSlotAllDays: false,
        slots: [SellerBookingSlot(day: 1, from: '09:00', to: '17:00')],
      ),
    );

    await tester.ensureVisible(find.byKey(const Key('bookingAddSlot_1')));
    await tester.tap(find.byKey(const Key('bookingAddSlot_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('Time slots on the same day cannot overlap.'),
      findsOneWidget,
    );
    expect(_current(tester).slots, hasLength(1));
  });

  testWidgets('a daily-only rental asks for no slots at all', (tester) async {
    // Matches the web panel: "Daily Basis" renting shows Location, Qty,
    // Available Every Week, Available From/To, Renting Type and Daily
    // Price — nothing time-of-day.
    await _pump(tester, config: const SellerBookingConfig(type: 'rental'));

    expect(find.byKey(const Key('bookingAddSlot')), findsNothing);
    expect(find.byKey(const Key('bookingSameSlotAllDays')), findsNothing);
  });

  testWidgets('rental marks the visible price and quantity required', (
    tester,
  ) async {
    await _pump(
      tester,
      config: const SellerBookingConfig(type: 'rental', rentingType: 'hourly'),
    );

    final qty = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('bookingQty')),
        matching: find.byType(TextField),
      ),
    );
    final price = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('bookingHourlyPrice')),
        matching: find.byType(TextField),
      ),
    );
    final rentingType = tester.widget<DropdownButtonFormField<String>>(
      find.byKey(const Key('bookingRentingType')),
    );
    expect(qty.decoration!.labelText, 'Qty *');
    expect(price.decoration!.labelText, 'Hourly Price *');
    expect(rentingType.decoration.labelText, 'Renting Type *');
    expect(find.text('Available every week *'), findsOneWidget);
    expect(find.text('Same slot for all days *'), findsOneWidget);
  });

  testWidgets('table selection shows table limit and guest capacity fields', (
    tester,
  ) async {
    await _pump(
      tester,
      config: const SellerBookingConfig(
        type: 'table',
        qty: 58,
        priceType: 'per_table',
        guestLimit: 6,
      ),
    );

    final chargedPer = tester.widget<DropdownButtonFormField<String>>(
      find.byKey(const Key('bookingPriceType')),
    );
    final guestLimitPerTable = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('bookingGuestLimitPerTable')),
        matching: find.byType(TextField),
      ),
    );
    final guestCapacity = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('bookingGuestCapacity')),
        matching: find.byType(TextField),
      ),
    );
    final duration = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('bookingTableDuration')),
        matching: find.byType(TextField),
      ),
    );
    final breakTime = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('bookingTableBreak')),
        matching: find.byType(TextField),
      ),
    );
    final preventBefore = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('bookingPreventBefore')),
        matching: find.byType(TextField),
      ),
    );
    expect(chargedPer.decoration.labelText, 'Charged Per *');
    expect(guestLimitPerTable.decoration!.labelText, 'Guest Limit Per Table *');
    expect(guestCapacity.decoration!.labelText, 'Guest Capacity *');
    expect(guestLimitPerTable.controller!.text, '6');
    expect(guestCapacity.controller!.text, '58');
    expect(duration.decoration!.labelText, 'Slot Duration (Mins) *');
    expect(breakTime.decoration!.labelText, 'Break Time b/w Slots (Mins) *');
    expect(preventBefore.decoration!.labelText, 'Prevent Scheduling Before');
  });

  testWidgets('guest charging shows capacity without a per-table limit', (
    tester,
  ) async {
    await _pump(
      tester,
      config: const SellerBookingConfig(type: 'table', qty: 58),
    );

    expect(find.byKey(const Key('bookingGuestCapacity')), findsOneWidget);
    expect(find.byKey(const Key('bookingGuestLimitPerTable')), findsNothing);
  });

  test('a slot always sends the day the server demands', () {
    expect(const SellerBookingSlot(from: '09:00', to: '17:00').toInput(), {
      'day': 0,
      'from': '09:00',
      'to': '17:00',
    });
    expect(
      const SellerBookingSlot(day: 3, from: '09:00', to: '17:00').toInput(),
      {'day': 3, 'from': '09:00', 'to': '17:00'},
    );
  });

  testWidgets('each kind of booking asks for what it needs', (tester) async {
    // The panel asks these and the app did not, so a seller could not set
    // them and the server kept its own defaults.
    Future<void> check(
      String type,
      List<Key> expected,
      List<Key> absent,
    ) async {
      await _pump(tester, config: SellerBookingConfig(type: type));
      for (final key in expected) {
        expect(find.byKey(key), findsOneWidget, reason: '$type wants $key');
      }
      for (final key in absent) {
        expect(find.byKey(key), findsNothing, reason: '$type has no $key');
      }
    }

    await check(
      'default',
      [const Key('bookingHowManyTimes')],
      [
        const Key('bookingDuration'),
        const Key('bookingEveryWeek'),
        const Key('bookingRentingType'),
        const Key('bookingPriceType'),
      ],
    );
    await check(
      'appointment',
      [const Key('bookingDuration'), const Key('bookingSameSlotAllDays')],
      [const Key('bookingHowManyTimes')],
    );
    await check(
      'rental',
      [const Key('bookingRentingType'), const Key('bookingEveryWeek')],
      [const Key('bookingDuration'), const Key('bookingSameSlotAllDays')],
    );
    await check(
      'table',
      [const Key('bookingPriceType'), const Key('bookingPreventBefore')],
      [const Key('bookingRentingType'), const Key('bookingQty')],
    );
    await check('event', [], [
      const Key('bookingEveryWeek'),
      const Key('bookingSameSlotAllDays'),
      const Key('bookingQty'),
    ]);
  });

  testWidgets('no booking type offers a location-visibility toggle', (
    tester,
  ) async {
    // Web has no such control on this tab for any type — showing one was
    // exactly the "irrelevant toggle" this panel used to add on its own.
    for (final type in ['default', 'appointment', 'event', 'rental', 'table']) {
      await _pump(tester, config: SellerBookingConfig(type: type));
      expect(
        find.byKey(const Key('bookingShowLocation')),
        findsNothing,
        reason: '$type must not show a location-visibility toggle',
      );
    }
  });

  testWidgets('"Available every week" hides the window dates once it is on', (
    tester,
  ) async {
    // Matches web: a weekly repeat has no fixed window to bound, so
    // Available From/To disappear the moment the toggle is switched on.
    await _pump(
      tester,
      config: const SellerBookingConfig(
        type: 'appointment',
        availableEveryWeek: false,
      ),
    );
    expect(find.byKey(const Key('bookingAvailableFrom')), findsOneWidget);
    expect(find.byKey(const Key('bookingAvailableTo')), findsOneWidget);

    await tester.tap(find.byKey(const Key('bookingEveryWeek')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bookingAvailableFrom')), findsNothing);
    expect(find.byKey(const Key('bookingAvailableTo')), findsNothing);
  });

  testWidgets('default and event show required window dates', (
    tester,
  ) async {
    await _pump(tester, config: const SellerBookingConfig(type: 'default'));
    for (final key in ['bookingAvailableFrom', 'bookingAvailableTo']) {
      final field = find.byKey(Key(key));
      expect(field, findsOneWidget);
      final decoration = tester.widget<InputDecorator>(
        find.descendant(of: field, matching: find.byType(InputDecorator)),
      ).decoration;
      expect(decoration.labelText, endsWith(' *'));
    }
    expect(
      _top(tester, 'bookingAvailableFrom'),
      lessThan(_top(tester, 'bookingHowManyTimes')),
    );

    await _pump(tester, config: const SellerBookingConfig(type: 'event'));
    expect(find.byKey(const Key('bookingAvailableFrom')), findsOneWidget);
    expect(find.byKey(const Key('bookingAvailableTo')), findsOneWidget);
  });

  testWidgets('a rental shows only the price its renting type charges', (
    tester,
  ) async {
    // Matches web: Daily Basis asks Daily Price alone, Hourly Basis asks
    // Hourly Price alone, and Both asks for both.
    await _pump(
      tester,
      config: const SellerBookingConfig(type: 'rental', rentingType: 'daily'),
    );
    expect(find.byKey(const Key('bookingDailyPrice')), findsOneWidget);
    expect(find.byKey(const Key('bookingHourlyPrice')), findsNothing);

    await _pump(
      tester,
      config: const SellerBookingConfig(type: 'rental', rentingType: 'hourly'),
    );
    expect(find.byKey(const Key('bookingDailyPrice')), findsNothing);
    expect(find.byKey(const Key('bookingHourlyPrice')), findsOneWidget);

    await _pump(
      tester,
      config: const SellerBookingConfig(
        type: 'rental',
        rentingType: 'daily_and_hourly',
      ),
    );
    expect(find.byKey(const Key('bookingDailyPrice')), findsOneWidget);
    expect(find.byKey(const Key('bookingHourlyPrice')), findsOneWidget);
  });

  testWidgets(
    "table asks its own settings before the seller adds slots — web's own "
    'order, not just its fields',
    (tester) async {
      await _pump(
        tester,
        config: const SellerBookingConfig(
          type: 'table',
          availableEveryWeek: false,
        ),
      );

      final chargedPer = _top(tester, 'bookingPriceType');
      final guestCapacity = _top(tester, 'bookingGuestCapacity');
      final duration = _top(tester, 'bookingTableDuration');
      final preventBefore = _top(tester, 'bookingPreventBefore');
      final sameSlot = _top(tester, 'bookingSameSlotAllDays');
      final addSlot = _top(tester, 'bookingAddSlot');

      expect(chargedPer, lessThan(guestCapacity));
      expect(guestCapacity, lessThan(duration));
      expect(duration, lessThan(preventBefore));
      expect(preventBefore, lessThan(sameSlot));
      expect(sameSlot, lessThan(addSlot));
    },
  );

  testWidgets(
    "an hourly rental asks its renting type before the seller adds slots",
    (tester) async {
      await _pump(
        tester,
        config: const SellerBookingConfig(
          type: 'rental',
          rentingType: 'hourly',
          availableEveryWeek: false,
        ),
      );

      expect(
        _top(tester, 'bookingRentingType'),
        lessThan(_top(tester, 'bookingAddSlot')),
      );
    },
  );

  testWidgets(
    'default booking with many bookings renders duration, break and schedule grid',
    (tester) async {
      await _pump(
        tester,
        config: const SellerBookingConfig(
          type: 'default',
          bookingType: 'many',
          duration: 45,
          breakTime: 15,
          slots: [
            SellerBookingSlot(
              day: 1,
              fromDay: 1,
              toDay: 1,
              from: '10:00',
              to: '14:00',
              status: 1,
            ),
          ],
        ),
      );

      // Duration and Break time fields are present
      expect(find.byKey(const Key('bookingDuration')), findsOneWidget);
      expect(find.byKey(const Key('bookingBreak')), findsOneWidget);

      // Schedule grid renders weekdays
      expect(find.text('Sunday'), findsOneWidget);
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('10:00 - 14:00'), findsOneWidget);
    },
  );

  testWidgets(
    'default booking with one booking renders day range from/to dropdowns',
    (tester) async {
      await _pump(
        tester,
        config: const SellerBookingConfig(
          type: 'default',
          bookingType: 'one',
          slots: [
            SellerBookingSlot(
              day: 0,
              fromDay: 0,
              toDay: 2,
              from: '09:00',
              to: '18:00',
            ),
          ],
        ),
      );

      // Slots Time Duration header is visible
      expect(find.byKey(const Key('bookingAddSlot')), findsOneWidget);
      expect(find.byKey(const Key('slotDay_0')), findsOneWidget);
      expect(find.byKey(const Key('slotToDay_0')), findsOneWidget);
      expect(find.byKey(const Key('slotFrom_0')), findsOneWidget);
      expect(find.byKey(const Key('slotTo_0')), findsOneWidget);

      // Duration and break are absent in 'one' mode
      expect(find.byKey(const Key('bookingDuration')), findsNothing);
      expect(find.byKey(const Key('bookingBreak')), findsNothing);
    },
  );

  testWidgets(
    'booking type is selectable when product is new, and locked when editing saved product',
    (tester) async {
      // 1. When creating a new product (isEditing: false), dropdown is enabled
      await _pump(tester, isEditing: false);

      final dropdownFinder = find.byWidgetPredicate(
        (w) =>
            w is DropdownButtonFormField<String> &&
            w.key.toString().contains('bookingType'),
      );
      expect(dropdownFinder, findsOneWidget);
      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        dropdownFinder,
      );
      expect(
        dropdown.onChanged,
        isNotNull,
        reason: 'Dropdown must be enabled on new products',
      );

      // Change type to event
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Event Booking').last);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('bookingAddTicket')), findsOneWidget);

      // 2. When opening an already saved product (isEditing: true), dropdown is disabled
      await _pump(tester, isEditing: true);
      final lockedFinder = find.byWidgetPredicate(
        (w) =>
            w is DropdownButtonFormField<String> &&
            w.key.toString().contains('bookingType'),
      );
      final lockedDropdown = tester.widget<DropdownButtonFormField<String>>(
        lockedFinder,
      );
      expect(
        lockedDropdown.onChanged,
        isNull,
        reason: 'Dropdown must be disabled when editing saved product',
      );
    },
  );
}
