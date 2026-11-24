import 'package:bagisto_flutter/core/constants/asset_constants.dart';
import 'package:bagisto_flutter/core/widgets/category_circular_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryCircularImage', () {
    testWidgets('renders placeholder asset when imageUrl is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryCircularImage(imageUrl: null, size: 64),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.image, isA<AssetImage>());
      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, AppAssets.categoryPlaceholder);
    });

    testWidgets('renders placeholder asset when imageUrl is empty or blank', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryCircularImage(imageUrl: '   ', size: 64),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.image, isA<AssetImage>());
      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, AppAssets.categoryPlaceholder);
    });

    testWidgets('renders CachedNetworkImage when imageUrl is valid', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryCircularImage(
              imageUrl: 'https://example.com/category.png',
              size: 64,
            ),
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
      final networkImage = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(networkImage.imageUrl, 'https://example.com/category.png');
    });

    testWidgets('applies specified size to container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryCircularImage(imageUrl: null, size: 51),
          ),
        ),
      );

      final containerFinder = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(containerFinder);
      final constraints = containerWidget.constraints;
      expect(constraints?.minWidth, 51);
      expect(constraints?.minHeight, 51);
    });
  });
}
