import 'package:bagisto_flutter/marketplace/features/earnings/data/models/seller_earnings.dart';
import 'package:bagisto_flutter/marketplace/features/reporting/presentation/widgets/seller_report_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The web chart answers a hover with the date and value; on a phone that is a
/// touch. These pin the touch → bar mapping and the selection it drives.
void main() {
  group('reportChartIndexAt', () {
    // 400 wide, 38 of it Y-axis labels, four points: slots of 90.5.
    test('maps a touch to the slot under it', () {
      expect(reportChartIndexAt(39, 400, 4), 0);
      expect(reportChartIndexAt(38 + 90.5 * 2 + 1, 400, 4), 2);
      expect(reportChartIndexAt(399, 400, 4), 3);
    });

    test('ignores the Y-axis labels and an empty series', () {
      expect(reportChartIndexAt(10, 400, 4), isNull);
      expect(reportChartIndexAt(100, 400, 0), isNull);
    });
  });

  group('reportChartIsPreviousAt', () {
    // Slots of 90.5 from x=38. The previous bar is the left half of a slot.
    test('left half of a slot is the previous period, right the current', () {
      expect(reportChartIsPreviousAt(40, 400, 4, paired: true), isTrue);
      expect(reportChartIsPreviousAt(38 + 80, 400, 4, paired: true), isFalse);
      // Second slot, left half.
      expect(
        reportChartIsPreviousAt(38 + 90.5 + 10, 400, 4, paired: true),
        isTrue,
      );
    });

    test('is never the previous period when only one series is drawn', () {
      expect(reportChartIsPreviousAt(40, 400, 4, paired: false), isFalse);
    });
  });

  group('SellerReportChart touch', () {
    const points = [
      SellerReportPoint(
        label: '2026-09-18',
        total: 10,
        formattedTotal: r'$10.00',
      ),
      SellerReportPoint(
        label: '2026-09-19',
        total: 728.19,
        formattedTotal: r'$728.19',
      ),
      SellerReportPoint(label: '2026-09-20', total: 0),
    ];

    Future<void> pump(WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SellerReportChart(
              points: points,
              previousPoints: [
                SellerReportPoint(label: '2026-08-18', total: 5),
                SellerReportPoint(label: '2026-08-19', total: 6),
                SellerReportPoint(label: '2026-08-20', total: 7),
              ],
            ),
          ),
        ),
      );
    }

    int? selected(WidgetTester tester) {
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byKey(const Key('sellerReportChartTouch')),
          matching: find.byType(CustomPaint),
        ),
      );
      return (paint.painter! as dynamic).selectedIndex as int?;
    }

    testWidgets('tapping a bar picks it and tapping it again clears', (
      tester,
    ) async {
      await pump(tester);
      expect(selected(tester), isNull);

      final box = tester.getRect(
        find.byKey(const Key('sellerReportChartTouch')),
      );
      // Canvas is the available width; the middle third is the second slot.
      final plotLeft = box.left + 38;
      final slot = (box.width - 38) / 3;
      final middle = Offset(plotLeft + slot * 1.5, box.center.dy);

      await tester.tapAt(middle);
      await tester.pump();
      expect(selected(tester), 1);

      await tester.tapAt(middle);
      await tester.pump();
      expect(selected(tester), isNull);
    });

    testWidgets('the touched half decides which series is shown', (
      tester,
    ) async {
      await pump(tester);
      final box = tester.getRect(
        find.byKey(const Key('sellerReportChartTouch')),
      );
      final plotLeft = box.left + 38;
      final slot = (box.width - 38) / 3;

      bool previous() {
        final paint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byKey(const Key('sellerReportChartTouch')),
            matching: find.byType(CustomPaint),
          ),
        );
        return (paint.painter! as dynamic).selectedPrevious as bool;
      }

      // Left quarter of the second slot: the previous period's bar.
      await tester.tapAt(Offset(plotLeft + slot * 1.25, box.center.dy));
      await tester.pump();
      expect(selected(tester), 1);
      expect(previous(), isTrue);

      // Right quarter of the same slot: the current period's bar. Same slot,
      // other series, so it moves the pick rather than clearing it.
      await tester.tapAt(Offset(plotLeft + slot * 1.75, box.center.dy));
      await tester.pump();
      expect(selected(tester), 1);
      expect(previous(), isFalse);
    });

    testWidgets('a touch on the axis labels picks nothing', (tester) async {
      await pump(tester);
      final box = tester.getRect(
        find.byKey(const Key('sellerReportChartTouch')),
      );

      await tester.tapAt(Offset(box.left + 10, box.center.dy));
      await tester.pump();
      expect(selected(tester), isNull);
    });

    testWidgets('each bar is readable to a screen reader', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester);
      await tester.pump();

      // The labels live on the painter's semantic nodes, not on widgets, so
      // they are read from the semantics tree itself.
      final tree = tester
          .getSemantics(find.byKey(const Key('sellerReportChartTouch')))
          .toStringDeep();

      expect(tree, contains('18 Sep: \$10.00'));
      expect(tree, contains('19 Sep: \$728.19'));
      expect(tree, contains('20 Sep: 0.00'));
      handle.dispose();
    });
  });
}
