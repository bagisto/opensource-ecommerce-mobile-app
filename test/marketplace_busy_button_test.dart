import 'package:bagisto_flutter/marketplace/core/ui/seller_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A button that goes grey while a request runs looks exactly like a button
/// that refuses to work, so the panel's actions say which one they are.
class _Host extends StatefulWidget {
  const _Host({this.buttons = 1});

  final int buttons;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            for (var index = 0; index < widget.buttons; index++)
              SellerBusyButton(
                key: Key('action$index'),
                label: 'Action $index',
                busy: _busy,
                onPressed: () => setState(() => _busy = true),
              ),
            TextButton(
              key: const Key('finish'),
              onPressed: () => setState(() => _busy = false),
              child: const Text('finish'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('it spins while the request runs and stops when it ends', (
    tester,
  ) async {
    await tester.pumpWidget(const _Host());

    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key('action0')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // The label stays, so the button keeps its width and its meaning.
    expect(find.text('Action 0'), findsOneWidget);

    await tester.tap(find.byKey(const Key('finish')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('only the pressed button spins when several share the flag', (
    tester,
  ) async {
    await tester.pumpWidget(const _Host(buttons: 3));

    await tester.tap(find.byKey(const Key('action1')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('action1')),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a second press cannot fire while the first is running', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => SellerBusyButton(
              key: const Key('action'),
              label: 'Save',
              busy: presses > 0,
              onPressed: () => setState(() => presses++),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('action')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('action')), warnIfMissed: false);
    await tester.pump();

    expect(presses, 1);
  });

  testWidgets('a button disabled for its own reasons shows no spinner', (
    tester,
  ) async {
    // An empty form disables its save. Nothing is running, so nothing spins.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SellerBusyButton(label: 'Save', busy: true, onPressed: null),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Save'), findsOneWidget);
  });
}
