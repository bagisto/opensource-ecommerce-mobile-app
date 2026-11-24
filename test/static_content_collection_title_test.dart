import 'package:bagisto_flutter/features/home/presentation/widgets/static_content_widget.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A collection card whose heading holds a link, or markup stored escaped, is
/// shown as its words, not as the raw tag.
Widget _wrap(String html) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SingleChildScrollView(
      child: StaticContentWidget(
        html: html,
        css: '',
        baseUrl: 'https://example.com',
      ),
    ),
  ),
);

String _grid(String title) =>
    '<div class="top-collection-container"><h2>New</h2>'
    '<div class="top-collection-grid">'
    '<div class="top-collection-card"><img src="/a.png"><h3>$title</h3></div>'
    '</div></div>';

void main() {
  testWidgets('a link inside a card heading shows only its text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(_grid('<a href="#active-wear">Our Collections</a>')),
    );
    expect(find.text('Our Collections'), findsOneWidget);
    expect(find.textContaining('<a'), findsNothing);
  });

  testWidgets('escaped markup in a card heading shows only its text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(_grid('&lt;a href="#active-wear"&gt;Our Collections&lt;/a&gt;')),
    );
    expect(find.text('Our Collections'), findsOneWidget);
    expect(find.textContaining('href'), findsNothing);
  });
}
