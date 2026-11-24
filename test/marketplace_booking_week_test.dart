import 'package:bagisto_flutter/marketplace/features/aftersales/data/models/seller_aftersales.dart';
import 'package:bagisto_flutter/marketplace/features/aftersales/presentation/widgets/seller_booking_week.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// The week grid draws each slot where it falls, so a booking landing in the
/// wrong column or at the wrong height is a seller turning up on the wrong day.
void main() {
  SellerBooking booking({
    required String from,
    required String to,
    String? orderStatus,
  }) {
    return SellerBooking.fromJson({
      'id': 1,
      'from': from,
      'to': to,
      'qty': 1,
      'productName': 'Studio Session',
      'customerName': 'Aarav Sharma',
      'orderStatus': orderStatus,
    });
  }

  Future<void> pump(
    WidgetTester tester, {
    required DateTime weekStart,
    required List<SellerBooking> bookings,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SellerBookingWeek(
            bookings: bookings,
            weekStart: weekStart,
            onWeekChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('the week bar names the week it is showing', (tester) async {
    await pump(
      tester,
      // Monday of ISO week 34, 2026 -- the week the panel labels the same way.
      weekStart: DateTime(2026, 8, 17),
      bookings: const [],
    );

    expect(find.textContaining('Week 34'), findsOneWidget);
    expect(find.textContaining('August 2026'), findsOneWidget);
  });

  testWidgets('every day of the week gets a column', (tester) async {
    await pump(tester, weekStart: DateTime(2026, 8, 17), bookings: const []);

    for (final day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']) {
      expect(find.text(day), findsOneWidget, reason: '$day is missing');
    }
    // Monday the 17th through Sunday the 23rd.
    expect(find.text('17'), findsOneWidget);
    expect(find.text('23'), findsOneWidget);
  });

  testWidgets('a booking inside the week is drawn with time and status color', (
    tester,
  ) async {
    await pump(
      tester,
      weekStart: DateTime(2026, 8, 17),
      bookings: [
        booking(
          from: '2026-08-19 10:00:00',
          to: '2026-08-19 11:00:00',
          orderStatus: 'pending',
        ),
      ],
    );

    expect(find.textContaining('10:00'), findsOneWidget);
    expect(find.text('Aarav Sharma'), findsNothing);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(InkWell),
        matching: find.byType(Container),
      ).first,
    );
    final decoration = container.decoration as BoxDecoration;
    final border = decoration.border as Border;
    expect(border.left.color, const Color(0xFFEAB308));
  });

  testWidgets('a booking in another week is left out', (tester) async {
    await pump(
      tester,
      weekStart: DateTime(2026, 8, 17),
      bookings: [
        // The following Monday: right product, wrong week.
        booking(from: '2026-08-24 10:00:00', to: '2026-08-24 11:00:00'),
      ],
    );

    expect(find.text('Studio Session'), findsNothing);
  });

  testWidgets('a booking with an unreadable date does not throw', (
    tester,
  ) async {
    await pump(
      tester,
      weekStart: DateTime(2026, 8, 17),
      bookings: [booking(from: 'not a date', to: 'nor this')],
    );

    expect(tester.takeException(), isNull);
  });

  /// The horizontal offsets of the two views that scroll sideways: the day
  /// strip, and the grid under it.
  List<double> offsets(WidgetTester tester) {
    return tester
        .widgetList<Scrollable>(find.byType(Scrollable))
        .toList()
        .asMap()
        .entries
        .where((entry) => entry.value.axisDirection == AxisDirection.right)
        .map(
          (entry) =>
              (tester.state(find.byType(Scrollable).at(entry.key))
                      as ScrollableState)
                  .position
                  .pixels,
        )
        .toList();
  }

  testWidgets('the week can be scrolled sideways from the day strip', (
    tester,
  ) async {
    // Two and a half days fit on screen, so the rest of the week is only
    // reachable by dragging — and the strip is where a finger lands first.
    await pump(tester, weekStart: DateTime(2026, 8, 10), bookings: const []);

    await tester.dragFrom(const Offset(400, 120), const Offset(-200, 0));
    await tester.pumpAndSettle();

    expect(offsets(tester), everyElement(greaterThan(0)));
  });

  testWidgets('the dates stay over their own columns', (tester) async {
    // The strip and the grid shared one controller, which syncs on jumpTo and
    // never on a drag: the columns slid out from under their own dates.
    await pump(tester, weekStart: DateTime(2026, 8, 10), bookings: const []);

    await tester.dragFrom(const Offset(400, 400), const Offset(-240, 0));
    await tester.pumpAndSettle();

    final scrolled = offsets(tester);
    expect(scrolled.first, greaterThan(0));
    expect((scrolled.first - scrolled.last).abs(), lessThan(1));
  });

  testWidgets('the far end of the week is reachable', (tester) async {
    await pump(tester, weekStart: DateTime(2026, 8, 10), bookings: const []);

    // Sunday is built but sits off the right edge until the week is dragged.
    final width = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getTopLeft(find.text('Sun')).dx, greaterThan(width));

    for (var drag = 0; drag < 6; drag++) {
      await tester.dragFrom(const Offset(400, 400), const Offset(-300, 0));
      await tester.pumpAndSettle();
    }

    expect(tester.getTopLeft(find.text('Sun')).dx, lessThan(width));
  });
  testWidgets('a booking slot shows only time without customer name or email', (
    tester,
  ) async {
    await pump(
      tester,
      weekStart: DateTime(2026, 8, 24),
      bookings: [
        SellerBooking.fromJson({
          'id': 1,
          'from': '2026-08-24T10:00:00+05:30',
          'to': '2026-08-24T11:00:00+05:30',
          'qty': 2,
          'productName': 'Studio Session — 1 Hour',
          'customerName': 'Zed Booker',
          'customerEmail': 'zed@example.com',
        }),
      ],
    );

    expect(find.textContaining('10:00'), findsOneWidget);
    expect(find.text('Zed Booker'), findsNothing);
    expect(find.text('zed@example.com'), findsNothing);
  });

  testWidgets('a 30-minute slot fits its text instead of overflowing', (
    tester,
  ) async {
    final from = DateTime(2026, 8, 17, 9).toUtc().toIso8601String();
    final to = DateTime(2026, 8, 17, 9, 30).toUtc().toIso8601String();

    await pump(
      tester,
      weekStart: DateTime(2026, 8, 17),
      bookings: [booking(from: from, to: to)],
    );

    // A RenderFlex overflow is reported as an exception.
    expect(tester.takeException(), isNull);
    expect(find.textContaining('9:00'), findsOneWidget);
  });
}
