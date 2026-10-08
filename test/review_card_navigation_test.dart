import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/presentation/widgets/product_reviews_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tapping a review card reports the reviewed product', (
    tester,
  ) async {
    ProductReview? tapped;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProductReviewsSection(
              reviews: const [
                ProductReview(
                  productId: 22,
                  productName: 'Blue Shirt',
                  name: 'Jo',
                  title: 'Great',
                  rating: 5,
                  comment: 'Nice fit',
                ),
              ],
              totalCount: 1,
              onReviewTap: (review) => tapped = review,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Nice fit'));
    expect(tapped?.productId, 22);
  });
}
