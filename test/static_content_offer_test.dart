import 'package:bagisto_flutter/features/home/presentation/widgets/static_content_widget.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exact "Offer Information" static_content from the test server.
const _offerHtml =
    '<div class="home-offer"><h1>Get UPTO 40% OFF on your 1st order SHOP NOW</h1></div>';
const _offerCss =
    '.home-offer h1 {display: block;font-weight: 500;text-align: center;'
    'font-size: 22px;font-family: DM Serif Display;background-color: #E8EDFE;'
    'padding-top: 20px;padding-bottom: 20px;}';

Widget _wrap(String html, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: StaticContentWidget(
          html: html,
          css: _offerCss,
          baseUrl: 'https://example.com',
        ),
      ),
    );

void main() {
  linkTests();
  testWidgets('renders the home offer text like the storefront', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_offerHtml));

    final textFinder = find.text('Get UPTO 40% OFF on your 1st order SHOP NOW');
    expect(textFinder, findsOneWidget);

    final text = tester.widget<Text>(textFinder);
    expect(text.textAlign, TextAlign.center);
    expect(text.style?.fontWeight, FontWeight.w500);

    final bar = tester.widget<Container>(
      find.byKey(const ValueKey('home_offer_bar')),
    );
    expect(
      (bar.decoration as BoxDecoration?)?.color ?? bar.color,
      const Color(0xFFE8EDFE),
    );
    expect(tester.getSize(find.byKey(const ValueKey('home_offer_bar'))).width,
        800);
  });

  testWidgets('decodes entities and strips inner tags', (tester) async {
    await tester.pumpWidget(
      _wrap(
        '<div class="home-offer"><h1>Save <b>40%</b> &amp; more</h1></div>',
      ),
    );

    expect(find.text('Save 40% & more'), findsOneWidget);
  });

  testWidgets('empty offer renders nothing', (tester) async {
    await tester.pumpWidget(_wrap('<div class="home-offer"><h1> </h1></div>'));

    expect(find.byKey(const ValueKey('home_offer_bar')), findsNothing);
  });
}

Widget _wrapWithLinks(String html, ValueChanged<String> onLinkTap) =>
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: StaticContentWidget(
            html: html,
            baseUrl: 'https://example.com',
            onLinkTap: onLinkTap,
          ),
        ),
      ),
    );

void linkTests() {
  testWidgets('bold collections button follows the configured link', (
    tester,
  ) async {
    String? tapped;
    await tester.pumpWidget(
      _wrapWithLinks(
        '<div class="inline-col-wrapper"><img data-src="a.webp">'
        '<h2>Bold</h2><a href="https://shop.test/winter-wear">'
        '<button class="primary-button">View All</button></a></div>',
        (link) => tapped = link,
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    expect(tapped, 'https://shop.test/winter-wear');
  });

  testWidgets('collection cards wrapped in links are tappable', (
    tester,
  ) async {
    String? tapped;
    await tester.pumpWidget(
      _wrapWithLinks(
        '<div class="collection-card-wrapper">'
        '<a href="/games"><div class="single-collection-card">'
        '<img data-src="storage/theme/8/1.webp"><h3>Games</h3></div></a>'
        '</div>',
        (link) => tapped = link,
      ),
    );

    await tester.tap(find.byKey(const ValueKey('static_link_0')));
    expect(tapped, '/games');
  });

  test('imageLinks maps images inside anchors to their href', () {
    expect(
      StaticContentWidget.imageLinks(
        '<a href="/men"><img data-src="1.webp"></a><img src="2.webp">',
      ),
      {'1.webp': '/men'},
    );
    expect(StaticContentWidget.firstHref('<a href="#">x</a>'), isNull);
  });
}
