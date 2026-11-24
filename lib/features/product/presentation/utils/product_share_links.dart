/// Builds WhatsApp share content and links.
class ProductShareLinks {
  static String productText({
    required String message,
    required String productName,
    required String productUrl,
  }) => [
    message,
    productName,
    productUrl,
  ].map((part) => part.trim()).where((part) => part.isNotEmpty).join('\n\n');

  static Uri whatsappWebUri(String text) =>
      Uri.https('wa.me', '/', {'text': text});

  static Uri? uriForProvider({
    required String provider,
    required String message,
    required String productName,
    required String productUrl,
  }) {
    final text = [
      message,
      productName,
    ].map((part) => part.trim()).where((part) => part.isNotEmpty).join('\n\n');
    final fullText = productText(
      message: message,
      productName: productName,
      productUrl: productUrl,
    );

    return switch (provider) {
      'facebook' => Uri.https('www.facebook.com', '/sharer/sharer.php', {
        'u': productUrl,
        'quote': text,
      }),
      'twitter' => Uri.https('twitter.com', '/intent/tweet', {
        'text': text,
        'url': productUrl,
      }),
      'pinterest' => Uri.https('www.pinterest.com', '/pin/create/button/', {
        'url': productUrl,
        'description': text,
      }),
      'whatsapp' => whatsappWebUri(fullText),
      'email' => Uri(
        scheme: 'mailto',
        queryParameters: {'subject': productName, 'body': fullText},
      ),
      // LinkedIn's web share endpoint accepts a URL and reads page metadata.
      'linkedin' => Uri.https('www.linkedin.com', '/sharing/share-offsite/', {
        'url': productUrl,
      }),
      _ => null,
    };
  }
}
