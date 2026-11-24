import 'package:bagisto_flutter/marketplace/features/reporting/presentation/widgets/seller_report_chart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a year-only label is shown as-is', () {
    expect(formatAxisLabel('2026'), '2026');
  });

  test('a year-month label is reformatted to its last calendar day', () {
    expect(formatAxisLabel('2026-09'), '30 Sep');
    expect(formatAxisLabel('2026-01'), '31 Jan');
    expect(formatAxisLabel('2026-02'), '28 Feb');
  });

  test('a full date label is reformatted', () {
    expect(formatAxisLabel('2026-09-14'), '14 Sep');
  });

  test('an unrecognised shape falls back to the raw label', () {
    expect(formatAxisLabel('week-37'), 'week-37');
    expect(formatAxisLabel(''), '');
  });
}
