import 'package:bagisto_flutter/marketplace/marketplace_landing_content.dart';
import 'package:flutter_test/flutter_test.dart';

/// The admin's Featured Sellers settings decide whether the landing section
/// is drawn at all.
void main() {
  test('section shows only when featured sellers and Show Publicly are on', () {
    MarketplaceLandingContent of(bool featured, bool publicly) =>
        MarketplaceLandingContent.fromJson({
          'featuredSellersEnabled': featured,
          'sellersShownPublicly': publicly,
        });

    expect(of(true, true).showFeaturedSellers, isTrue);
    expect(of(true, false).showFeaturedSellers, isFalse);
    expect(of(false, true).showFeaturedSellers, isFalse);
    expect(of(false, false).showFeaturedSellers, isFalse);
  });

  test('limit and criteria are read and survive the cache round trip', () {
    final content = MarketplaceLandingContent.fromJson({
      'featuredSellersEnabled': true,
      'featuredSellersLimit': 12,
      'featuredSellersCriteria': 'rating',
      'sellersShownPublicly': true,
    });

    final again = MarketplaceLandingContent.fromJson(content.toJson());
    expect(again.featuredSellersLimit, 12);
    expect(again.featuredSellersCriteria, 'rating');
    expect(again.sellersShownPublicly, isTrue);
  });

  test('a server that does not send Show Publicly counts as on', () {
    final content = MarketplaceLandingContent.fromJson({
      'featuredSellersEnabled': true,
    });
    expect(content.sellersShownPublicly, isTrue);
    expect(content.showFeaturedSellers, isTrue);
  });
}
