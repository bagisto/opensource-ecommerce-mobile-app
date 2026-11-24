import 'package:flutter_test/flutter_test.dart';
import 'package:bagisto_flutter/core/store_config/store_config.dart';

void main() {
  group('StoreConfig social sharing', () {
    test('maps providers and trims configured share message', () {
      final config = StoreConfig.fromJson({
        'socialShareEnabled': true,
        'socialShareProviders': ['Facebook', ' whatsapp ', ''],
        'socialShareMessage': '  Check this out!  ',
      });

      expect(config.socialShareProviders, ['facebook', 'whatsapp']);
      expect(config.socialShareMessage, 'Check this out!');
      expect(config.showSocialShare, isTrue);
    });

    test('hides sharing when admin enables no providers', () {
      final config = StoreConfig.fromJson({
        'socialShareEnabled': true,
        'socialShareProviders': <String>[],
      });

      expect(config.showSocialShare, isFalse);
    });

    test('keeps legacy system sharing when providers are not returned', () {
      final config = StoreConfig.fromJson({'socialShareEnabled': true});

      expect(config.socialShareProviders, isNull);
      expect(config.showSocialShare, isTrue);
    });
  });
}
