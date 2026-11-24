import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_info_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildWidget(ProductModel product) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ProductInfoSection(product: product),
      ),
    );
  }

  testWidgets(
    'does NOT display review stars or count when product has no reviews',
    (WidgetTester tester) async {
      const productNoReviews = ProductModel(
        id: '1',
        name: 'Simple',
        price: 1000.0,
        formattedPrice: '\$1,000.00',
        reviews: [],
      );

      await tester.pumpWidget(buildWidget(productNoReviews));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsNothing);
      expect(find.text('0.0'), findsNothing);
      expect(find.text('0'), findsNothing);
      expect(find.text('In Stock'), findsOneWidget);
    },
  );

  testWidgets(
    'displays review stars and count when product has reviews',
    (WidgetTester tester) async {
      const productWithReviews = ProductModel(
        id: '1',
        name: 'Simple',
        price: 1000.0,
        formattedPrice: '\$1,000.00',
        reviews: [
          ProductReview(
            id: '1',
            name: 'John',
            rating: 4.5,
            title: 'Great',
            comment: 'Loved it',
          ),
        ],
      );

      await tester.pumpWidget(buildWidget(productWithReviews));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('In Stock'), findsOneWidget);
    },
  );
}
