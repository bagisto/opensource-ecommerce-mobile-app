import 'package:bagisto_flutter/features/checkout/presentation/helpers/payment_method_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentMethodLogo.defaultLogoAsset', () {
    test('maps all standard web payment method codes correctly', () {
      expect(
        PaymentMethodLogo.defaultLogoAsset('stripe'),
        'assets/images/stripe.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset('razorpay'),
        'assets/images/razorpay.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset('payu'),
        'assets/images/payu.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset('phonepe'),
        'assets/images/phonepe.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset('paypal_smart_button'),
        'assets/images/paypal.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset('paypal_standard'),
        'assets/images/paypal.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset('cashondelivery'),
        'assets/images/cash-on-delivery.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset('moneytransfer'),
        'assets/images/money-transfer.png',
      );
    });

    test('matches marketplace vendor-specific titles as seen on web', () {
      expect(
        PaymentMethodLogo.defaultLogoAsset(
          'marketplace_cod',
          'Cash On Delivery with roy',
        ),
        'assets/images/cash-on-delivery.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset(
          'marketplace_transfer',
          'Money Transfer with roy',
        ),
        'assets/images/money-transfer.png',
      );
      expect(
        PaymentMethodLogo.defaultLogoAsset(
          'cod',
        ),
        'assets/images/cash-on-delivery.png',
      );
    });

    test('returns null for unrecognised payment methods', () {
      expect(PaymentMethodLogo.defaultLogoAsset('custom_unknown_gateway'), isNull);
    });
  });

  group('PaymentMethodLogo widget', () {
    testWidgets('renders default logo Image.asset for known code', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaymentMethodLogo(
              code: 'stripe',
              title: 'Stripe',
            ),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/stripe.png');
    });

    testWidgets('renders default logo Image.asset for PayPal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaymentMethodLogo(
              code: 'paypal_smart_button',
              title: 'PayPal Smart Button',
            ),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/paypal.png');
    });

    testWidgets('renders fallback icon when code is unknown', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaymentMethodLogo(
              code: 'unknown_method_xyz',
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.payment);
    });
  });
}
