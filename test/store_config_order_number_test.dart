import 'package:flutter_test/flutter_test.dart';
import 'package:bagisto_flutter/core/store_config/store_config.dart';

void main() {
  group('StoreConfig order number configuration & formatting', () {
    test('parses order number prefix, length, and suffix from json', () {
      final config = StoreConfig.fromJson({
        'orderNumberPrefix': ' Prefix ',
        'orderNumberLength': 5,
        'orderNumberSuffix': ' Suffix ',
      });

      expect(config.orderNumberPrefix, 'Prefix');
      expect(config.orderNumberLength, 5);
      expect(config.orderNumberSuffix, 'Suffix');
    });

    test('parses string length and null fields gracefully', () {
      final config = StoreConfig.fromJson({
        'orderNumberPrefix': null,
        'orderNumberLength': '6',
        'orderNumberSuffix': null,
      });

      expect(config.orderNumberPrefix, isNull);
      expect(config.orderNumberLength, 6);
      expect(config.orderNumberSuffix, isNull);
    });

    test('formats order number using admin config with # by default', () {
      final config = StoreConfig.fromJson({
        'orderNumberPrefix': 'Prefix',
        'orderNumberLength': 5,
        'orderNumberSuffix': 'Suffix',
      });

      // Raw order ID "41"
      expect(config.formatOrderNumber('41'), '#Prefix00041Suffix');

      // Leading '#' in raw ID should not produce duplicate '#'
      expect(config.formatOrderNumber('#41'), '#Prefix00041Suffix');

      // If orderIncrementId already formatted is supplied, ensure single '#'
      expect(
        config.formatOrderNumber('41', orderIncrementId: 'Prefix00041Suffix'),
        '#Prefix00041Suffix',
      );
      expect(
        config.formatOrderNumber('41', orderIncrementId: '#Prefix00041Suffix'),
        '#Prefix00041Suffix',
      );

      // withHash: false should omit '#'
      expect(
        config.formatOrderNumber('41', withHash: false),
        'Prefix00041Suffix',
      );
    });

    test('formats order number when config is null with # in both cases', () {
      final config = StoreConfig.fromJson({
        'orderNumberPrefix': null,
        'orderNumberLength': null,
        'orderNumberSuffix': null,
      });

      expect(config.formatOrderNumber('41'), '#41');
      expect(config.formatOrderNumber('#41'), '#41');
      expect(config.formatOrderNumber('41', orderIncrementId: '41'), '#41');
      expect(config.formatOrderNumber('41', orderIncrementId: '#41'), '#41');

      // withHash: false should omit '#'
      expect(config.formatOrderNumber('41', withHash: false), '41');
    });

    test('handles partial configuration (prefix only, length only, suffix only)', () {
      final prefixOnly = StoreConfig.fromJson({'orderNumberPrefix': 'ORD-'});
      expect(prefixOnly.formatOrderNumber('123'), '#ORD-123');

      final lengthOnly = StoreConfig.fromJson({'orderNumberLength': 6});
      expect(lengthOnly.formatOrderNumber('123'), '#000123');

      final suffixOnly = StoreConfig.fromJson({'orderNumberSuffix': '-US'});
      expect(suffixOnly.formatOrderNumber('123'), '#123-US');
    });

    test('handles empty / null inputs cleanly', () {
      const config = StoreConfig();
      expect(config.formatOrderNumber(null), '');
      expect(config.formatOrderNumber(''), '');
      expect(config.formatOrderNumber('   '), '');
    });
  });
}
