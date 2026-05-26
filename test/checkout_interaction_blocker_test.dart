import 'package:bagisto_flutter/features/checkout/presentation/widgets/checkout_interaction_blocker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('allows taps when not blocking', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: CheckoutInteractionBlocker(
          isBlocking: false,
          child: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => tapCount++,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap me'), warnIfMissed: false);
    await tester.pump();

    expect(tapCount, 1);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('blocks taps and shows progress while blocking', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: CheckoutInteractionBlocker(
          isBlocking: true,
          child: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => tapCount++,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap me'), warnIfMissed: false);
    await tester.pump();

    expect(tapCount, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
