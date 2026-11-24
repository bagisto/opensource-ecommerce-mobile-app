// Short-description HTML rendering (ProductInfoSection).
// NOTE: the `review_media_` filename prefix was forced by this change's file-
// ownership constraints; rename to product_short_description_test.dart.
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_info_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  testWidgets('short description renders through flutter_html', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ProductInfoSection(
          product: const ProductModel(
            id: 'p1',
            name: 'Tee',
            shortDescription: '<p>Soft <b>cotton</b> tee</p>',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Html), findsOneWidget);
    expect(
      find.byKey(const ValueKey('product_short_description')),
      findsOneWidget,
    );
    expect(find.textContaining('cotton', findRichText: true), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('markup-only short description is suppressed', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ProductInfoSection(
          product: const ProductModel(
            id: 'p2',
            name: 'Tee',
            shortDescription: '<p>&nbsp;</p>',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Html), findsNothing);
    expect(
      find.byKey(const ValueKey('product_short_description')),
      findsNothing,
    );
  });
}
