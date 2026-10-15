import 'package:bagisto_flutter/features/home/presentation/widgets/static_content_widget.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// "The game with our new additions!" section (id 8) from the local server
/// after an admin edit: the card title holds a link inside the `<h3>`.
const _gameHtml = '''
<div class="section-game">
  <div class="section-title"><h2>The game with our new additions!</h2></div>
  <div class="section-gap container">
    <div class="collection-card-wrapper">
      <div class="single-collection-card">
        <a href="men">
          <img src="" data-src="__media__/themes/default/sections/8/a.webp" class="lazy" width="615" height="600" alt="x" />
        </a><h3 class="overlay-text"><a href="#active-wear">Our Collections</a></h3><a href="#active-wear">
        </a>
      </div>
      <div class="single-collection-card">
        <a href="#active-wear-female">
          <img src="" data-src="__media__/themes/default/sections/8/b.webp" class="lazy" width="615" height="600" alt="x" />
          <h3 class="overlay-text">Our &amp; Collections </h3>
        </a>
      </div>
    </div>
  </div>
</div>
''';

/// "Bold Collections" section (id 10) image markup from the local server.
const _boldHtml = '''
<div class="section-gap bold-collections container">
  <div class="inline-col-wrapper direction-rtl">
    <div class="inline-col-image-wrapper">
      <img src="" data-src="__media__/themes/default/sections/10/c.webp" class="lazy" width="632" height="510" alt="x">
    </div>
    <div class="inline-col-content-wrapper direction-ltr">
      <h2 class="inline-col-title">Unleash <b>Your</b> Boldness</h2>
      <p class="inline-col-description">Bold designs.</p>
      <a href="#electronics">
        <button class="primary-button max-md:rounded-lg">View Collections</button>
      </a>
    </div>
  </div>
</div>
''';

Widget _wrap(String html) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SingleChildScrollView(
      child: StaticContentWidget(
        html: html,
        baseUrl: 'http://shop.test/public/',
      ),
    ),
  ),
);

List<String> _imageUrls(WidgetTester tester) => tester
    .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
    .map((image) => image.imageUrl)
    .toList();

void main() {
  testWidgets('collection card titles show text, not HTML tags', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_gameHtml));

    expect(find.textContaining('<a'), findsNothing);
    expect(find.text('Our Collections'), findsOneWidget);
    expect(find.text('Our & Collections'), findsOneWidget);
  });

  testWidgets('__media__ image paths resolve to the storage folder', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_gameHtml));

    expect(_imageUrls(tester), [
      'http://shop.test/public/storage/themes/default/sections/8/a.webp',
      'http://shop.test/public/storage/themes/default/sections/8/b.webp',
    ]);
  });

  testWidgets('bold collections image and title resolve correctly', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_boldHtml));

    expect(_imageUrls(tester), [
      'http://shop.test/public/storage/themes/default/sections/10/c.webp',
    ]);
    expect(find.text('Unleash Your Boldness'), findsOneWidget);
  });

  testWidgets('bold collections button uses the text from the HTML', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(_boldHtml));

    expect(find.text('View Collections'), findsOneWidget);
    expect(find.text('View All'), findsNothing);
  });
}
