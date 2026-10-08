import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _banners = [
  BannerImage(imageUrl: 'https://example.com/storage/theme/1/a.webp'),
  BannerImage(imageUrl: 'https://example.com/storage/theme/1/b.webp'),
];

void main() {
  // Storefront banners are 1920x700 (2.74:1). The app keeps that exact ratio
  // for the image area on every screen width, with 20px side padding.
  for (final width in [320.0, 390.0, 414.0, 768.0]) {
    testWidgets('banner is 1920:700 at width $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ImageCarousel(
                images: _banners,
                baseUrl: 'https://example.com',
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final size = tester.getSize(
        find.byKey(const ValueKey('home_banner_image_area')).first,
      );
      expect(size.width, closeTo(width - 40, 0.01));
      expect(size.height, closeTo((width - 40) * 700 / 1920, 0.01));

      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('tapping a linked banner reports it', (tester) async {
    BannerImage? tapped;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ImageCarousel(
              images: const [
                BannerImage(
                  imageUrl: 'https://example.com/a.webp',
                  link: 'fashion',
                ),
              ],
              onBannerTap: (banner) => tapped = banner,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('home_banner_0')));
    expect(tapped?.linkSlug, 'fashion');
    await tester.pumpWidget(const SizedBox());
  });
}
