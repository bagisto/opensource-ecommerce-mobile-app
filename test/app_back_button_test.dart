import 'package:bagisto_flutter/core/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The shared back button is a bare icon, so the name screen readers and
/// long-press rely on has to come from the widget itself — no call site can
/// be trusted to remember it.
void main() {
  Future<void> pumpButton(WidgetTester tester, {VoidCallback? onTap}) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(child: AppBackButton(onTap: onTap))),
        ),
      );

  testWidgets('announces itself as a named button', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpButton(tester);

    expect(
      tester.getSemantics(find.byType(AppBackButton)),
      matchesSemantics(
        label: 'Back',
        isButton: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );

    handle.dispose();
  });

  testWidgets('long press shows the tooltip', (tester) async {
    await pumpButton(tester);

    await tester.longPress(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets('still runs its callback', (tester) async {
    var taps = 0;
    await pumpButton(tester, onTap: () => taps++);

    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    expect(taps, 1);
  });
}
