import 'package:bagisto_flutter/features/product/presentation/utils/product_share_links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const message = 'Check this out!';
  const productName = 'Nike Shoes';
  const productUrl = 'https://shop.example/nike-shoes';
  const fullText = '$message\n\n$productName\n\n$productUrl';

  test('WhatsApp web share link carries full share text', () {
    final uri = ProductShareLinks.uriForProvider(
      provider: 'whatsapp',
      message: message,
      productName: productName,
      productUrl: productUrl,
    )!;

    expect(uri.queryParameters['text'], fullText);
    expect(uri.host, 'wa.me');
    expect(
      ProductShareLinks.whatsappWebUri(fullText).queryParameters['text'],
      fullText,
    );
  });

  test('social share URLs carry message, product name, and product URL', () {
    final facebook = ProductShareLinks.uriForProvider(
      provider: 'facebook',
      message: message,
      productName: productName,
      productUrl: productUrl,
    )!;
    expect(facebook.queryParameters['quote'], '$message\n\n$productName');
    expect(facebook.queryParameters['u'], productUrl);

    final twitter = ProductShareLinks.uriForProvider(
      provider: 'twitter',
      message: message,
      productName: productName,
      productUrl: productUrl,
    )!;
    expect(twitter.queryParameters['text'], '$message\n\n$productName');
    expect(twitter.queryParameters['url'], productUrl);

    final pinterest = ProductShareLinks.uriForProvider(
      provider: 'pinterest',
      message: message,
      productName: productName,
      productUrl: productUrl,
    )!;
    expect(
      pinterest.queryParameters['description'],
      '$message\n\n$productName',
    );
    expect(pinterest.queryParameters['url'], productUrl);

    final email = ProductShareLinks.uriForProvider(
      provider: 'email',
      message: message,
      productName: productName,
      productUrl: productUrl,
    )!;
    expect(email.queryParameters['subject'], productName);
    expect(email.queryParameters['body'], fullText);
  });

  test('LinkedIn web share URL carries the product link', () {
    expect(
      ProductShareLinks.productText(
        message: message,
        productName: productName,
        productUrl: productUrl,
      ),
      fullText,
    );

    final linkedIn = ProductShareLinks.uriForProvider(
      provider: 'linkedin',
      message: message,
      productName: productName,
      productUrl: productUrl,
    )!;
    expect(linkedIn.host, 'www.linkedin.com');
    expect(linkedIn.path, '/sharing/share-offsite/');
    expect(linkedIn.queryParameters['url'], productUrl);
  });
}
