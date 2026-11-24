import 'package:bagisto_flutter/features/category/presentation/widgets/category_banner.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  group('CategoryBanner aspect ratio', () {
    testWidgets('locks the banner to the 1920x700 storefront ratio', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const CategoryBanner()));

      final aspectRatio = tester.widget<AspectRatio>(
        find.descendant(
          of: find.byType(CategoryBanner),
          matching: find.byType(AspectRatio),
        ),
      );

      expect(aspectRatio.aspectRatio, 1920 / 700);
    });

    testWidgets('no longer pins the banner to a fixed 200px height', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const SizedBox(width: 390, child: CategoryBanner())),
      );

      final size = tester.getSize(find.byType(AspectRatio).first);

      // 390 width minus the 16px horizontal padding on each side.
      expect(size.width, closeTo(358, 0.5));
      expect(size.height, closeTo(358 * 700 / 1920, 0.5));
      expect(size.height, isNot(closeTo(200, 0.5)));
    });
  });

  group('CategoryBanner overlay text', () {
    testWidgets('renders no hardcoded English promo text', (tester) async {
      await tester.pumpWidget(_wrap(const CategoryBanner()));

      expect(find.text('Shop the Collection'), findsNothing);
      expect(find.text('Up to 50% off on selected items'), findsNothing);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders only the title the API supplied', (tester) async {
      await tester.pumpWidget(_wrap(const CategoryBanner(title: 'Footwear')));

      expect(find.text('Footwear'), findsOneWidget);
      // No invented subtitle alongside it.
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders an API title and subtitle together', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CategoryBanner(title: 'Footwear', subtitle: 'New arrivals'),
        ),
      );

      expect(find.text('Footwear'), findsOneWidget);
      expect(find.text('New arrivals'), findsOneWidget);
    });

    testWidgets('empty API strings produce no overlay', (tester) async {
      await tester.pumpWidget(_wrap(const CategoryBanner(title: '')));

      expect(find.byType(Text), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
