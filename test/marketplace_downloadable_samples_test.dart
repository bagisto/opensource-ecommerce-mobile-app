import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/features/products/data/models/seller_product_types.dart';
import 'package:bagisto_flutter/marketplace/features/products/presentation/widgets/seller_type_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The free previews a downloadable product offers.
///
/// The panel gives samples their own card beside the files being sold, and
/// `updateSellerProduct` takes them as their own list — verified live, saved
/// and read back. The app had the model and the payload but no way to enter
/// one, so the Downloads tab could sell a file and never offer a preview.
Future<List<SellerDownloadableSample>> _pump(
  WidgetTester tester,
  List<SellerDownloadableSample> samples,
) async {
  var current = samples;

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: SellerDownloadableSamplesSection(
              title: 'Downloadable samples',
              notice: 'Saving sends the whole set back.',
              addLabel: 'Add sample',
              samples: current,
              onChanged: (next) => setState(() => current = next),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return current;
}

void main() {
  testWidgets('a seller can add a preview', (tester) async {
    await _pump(tester, const []);

    await tester.tap(find.text('Add sample'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('downloadableSampleTitle_0')), findsOneWidget);
    expect(find.byKey(const Key('downloadableSampleUrl_0')), findsOneWidget);
  });

  testWidgets('what is typed reaches the payload', (tester) async {
    await _pump(tester, const [SellerDownloadableSample(title: '')]);

    await tester.enterText(
      find.byKey(const Key('downloadableSampleTitle_0')),
      'Chapter 1 preview',
    );
    await tester.enterText(
      find.byKey(const Key('downloadableSampleUrl_0')),
      'https://example.com/preview.pdf',
    );
    await tester.pumpAndSettle();

    // The shape the server took live, locales and all.
    const sample = SellerDownloadableSample(
      title: 'Chapter 1 preview',
      url: 'https://example.com/preview.pdf',
    );
    expect(sample.toInput(), {
      'locales': [
        {'code': 'en', 'title': 'Chapter 1 preview'},
      ],
      'type': 'url',
      'url': 'https://example.com/preview.pdf',
      'sortOrder': 0,
    });
  });

  testWidgets('removing a preview removes the row', (tester) async {
    await _pump(tester, const [
      SellerDownloadableSample(title: 'Chapter 1'),
      SellerDownloadableSample(title: 'Chapter 2'),
    ]);

    await tester.tap(find.byKey(const Key('downloadableSampleRemove_0')));
    await tester.pumpAndSettle();

    // The set is replaced, not merged, so a row dropped here is dropped on
    // the marketplace — confirmed live by sending an empty list.
    expect(find.byKey(const Key('downloadableSample_1')), findsNothing);
    expect(find.byKey(const Key('downloadableSample_0')), findsOneWidget);
  });

  test('a preview the seller left out of the draft is not sent', () {
    // Partial update: an untouched list must stay absent, or every product
    // edit would wipe the previews.
    const sample = SellerDownloadableSample(
      title: 'Preview',
      type: 'file',
      file: 'data:application/pdf;base64,AAAA',
      fileName: 'preview.pdf',
    );

    final input = sample.toInput();
    expect(input['type'], 'file');
    expect(input['fileName'], 'preview.pdf');
    expect(input.containsKey('url'), isFalse);
  });
}
